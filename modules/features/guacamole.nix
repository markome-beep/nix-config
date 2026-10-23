{
  flake.nixosModules.guacamole =
    { pkgs, config, ... }:
    let
      version = config.services.guacamole-client.package.version;
      # Extensions have to match the guacamole-client version exactly
      fetchExtension =
        name: hash:
        pkgs.fetchzip {
          url = "https://archive.apache.org/dist/guacamole/${version}/binary/guacamole-${name}-${version}.tar.gz";
          inherit hash;
        };
      jdbc = fetchExtension "auth-jdbc" "sha256-C4CeUeMvCkOf0xxunvAoO0eg89jNXyjO9u8PlaMiDYM=";
      totp = fetchExtension "auth-totp" "sha256-FTuWN8hw6oUndZr/Wa9u/jNedgXKLFxtR1SLg1+dpgY=";

      psql = "${config.services.postgresql.package}/bin/psql";
      stateDir = "/var/lib/guacamole-db";
      adminUser = "markome";
    in
    {
      # Browser remote desktop: http://dev-one:8080/guacamole/ on the tailnet. Only runs while
      # the Funnel Toggle is on (see funnel-toggle.nix)
      # Browser -> Tomcat (guacamole-client) -> guacd -> wayvnc on 127.0.0.1:5900 -> Hyprland
      #
      # Logins live in Postgres (Guacamole's JDBC auth has no SQLite backend) so the TOTP
      # extension has somewhere to store each user's key. First login enrolls TOTP with a QR code.
      # The initial admin password is in /var/lib/guacamole-db/initial-admin-password
      services.guacamole-server.enable = true;
      services.guacamole-client = {
        enable = true;
        settings = {
          guacd-hostname = "localhost";
          guacd-port = 4822;

          postgresql-hostname = "127.0.0.1";
          postgresql-port = config.services.postgresql.settings.port;
          postgresql-database = "guacamole";
          postgresql-username = "guacamole";
          # postgresql-password comes from POSTGRESQL_PASSWORD in Tomcat's environment,
          # so it never lands in the store
          enable-environment-properties = true;

          totp-issuer = "dev-one Guacamole";
        };
      };

      environment.etc = {
        "guacamole/extensions/guacamole-auth-jdbc-postgresql.jar".source =
          "${jdbc}/postgresql/guacamole-auth-jdbc-postgresql-${version}.jar";
        "guacamole/extensions/guacamole-auth-totp.jar".source =
          "${totp}/guacamole-auth-totp-${version}.jar";
        "guacamole/lib/postgresql-jdbc.jar".source =
          "${pkgs.postgresql_jdbc}/share/java/postgresql-jdbc.jar";
      };

      services.postgresql = {
        enable = true;
        ensureDatabases = [ "guacamole" ];
        ensureUsers = [
          {
            name = "guacamole";
            ensureDBOwnership = true;
          }
        ];
      };

      # Gives the guacamole role a random password (Tomcat gets it as an env file), and on the
      # first run loads the schema plus an admin user and the dev-one VNC connection
      systemd.services.guacamole-db-init = {
        description = "Initialize the Guacamole database";
        requires = [ "postgresql-setup.service" ];
        after = [ "postgresql-setup.service" ];
        before = [ "tomcat.service" ];
        requiredBy = [ "tomcat.service" ];
        path = [ pkgs.openssl ];
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          User = "postgres";
          StateDirectory = "guacamole-db";
          StateDirectoryMode = "0700";
          UMask = "0077";
        };
        script = ''
          if [ ! -s ${stateDir}/env ]; then
            echo "POSTGRESQL_PASSWORD=$(openssl rand -hex 32)" > ${stateDir}/env
          fi
          . ${stateDir}/env
          ${psql} -v ON_ERROR_STOP=1 -q -v pw="$POSTGRESQL_PASSWORD" <<'SQL'
          ALTER ROLE guacamole WITH LOGIN PASSWORD :'pw';
          SQL

          if [ "$(${psql} -d guacamole -tAc "SELECT to_regclass('public.guacamole_user') IS NOT NULL")" = t ]; then
            exit 0
          fi

          admin_pw=$(openssl rand -base64 18)
          salt=$(openssl rand -hex 32 | tr a-f A-F)
          ${psql} -d guacamole -v ON_ERROR_STOP=1 -q -1 \
            -v admin='${adminUser}' -v pw="$admin_pw" -v salt="$salt" \
            -c 'SET ROLE guacamole' \
            -f ${jdbc}/postgresql/schema/001-create-schema.sql \
            -f ${pkgs.writeText "guacamole-seed.sql" ''
              -- Same as 002-create-admin-user.sql, but with a random password instead of
              -- guacadmin/guacadmin. Hash scheme: sha256(password || uppercase hex salt)
              INSERT INTO guacamole_entity (name, type) VALUES (:'admin', 'USER');
              INSERT INTO guacamole_user (entity_id, password_hash, password_salt, password_date)
              SELECT entity_id, sha256(convert_to(:'pw' || :'salt', 'UTF8')), decode(:'salt', 'hex'), now()
              FROM guacamole_entity WHERE name = :'admin' AND type = 'USER';

              INSERT INTO guacamole_system_permission (entity_id, permission)
              SELECT entity_id, p::guacamole_system_permission_type
              FROM guacamole_entity,
                unnest(ARRAY['CREATE_CONNECTION', 'CREATE_CONNECTION_GROUP', 'CREATE_SHARING_PROFILE',
                             'CREATE_USER', 'CREATE_USER_GROUP', 'ADMINISTER']) p
              WHERE name = :'admin' AND type = 'USER';

              INSERT INTO guacamole_user_permission (entity_id, affected_user_id, permission)
              SELECT e.entity_id, u.user_id, p::guacamole_object_permission_type
              FROM guacamole_entity e JOIN guacamole_user u USING (entity_id),
                unnest(ARRAY['READ', 'UPDATE', 'ADMINISTER']) p
              WHERE e.name = :'admin' AND e.type = 'USER';

              -- The Hyprland session via wayvnc
              INSERT INTO guacamole_connection (connection_name, protocol) VALUES ('dev-one', 'vnc');
              INSERT INTO guacamole_connection_parameter (connection_id, parameter_name, parameter_value)
              SELECT connection_id, k, v
              FROM guacamole_connection,
                (VALUES ('hostname', '127.0.0.1'), ('port', '5900')) params (k, v)
              WHERE connection_name = 'dev-one';

              INSERT INTO guacamole_connection_permission (entity_id, connection_id, permission)
              SELECT e.entity_id, c.connection_id, p::guacamole_object_permission_type
              FROM guacamole_entity e, guacamole_connection c,
                unnest(ARRAY['READ', 'UPDATE', 'DELETE', 'ADMINISTER']) p
              WHERE e.name = :'admin' AND e.type = 'USER' AND c.connection_name = 'dev-one';
            ''}

          printf '%s\n' "user: ${adminUser}" "password: $admin_pw" > ${stateDir}/initial-admin-password
        '';
      };

      systemd.services.tomcat.serviceConfig.EnvironmentFile = "${stateDir}/env";

      # Guacamole web UI, tailnet only (Funnel reaches it over localhost). guacd, wayvnc and
      # Postgres stay on localhost
      networking.firewall.interfaces.${config.services.tailscale.interfaceName}.allowedTCPPorts = [
        config.services.tomcat.port
      ];

      # Hyprland is Wayland, so the VNC server has to run inside the session.
      # No VNC auth: it only listens on localhost, Guacamole's login is the gate
      systemd.user.services.wayvnc = {
        description = "VNC server for the Hyprland session (used by Guacamole)";
        wantedBy = [ "graphical-session.target" ];
        partOf = [ "graphical-session.target" ];
        after = [ "graphical-session.target" ];
        serviceConfig = {
          ExecStart = "${pkgs.wayvnc}/bin/wayvnc 127.0.0.1 5900";
          Restart = "on-failure";
          RestartSec = "5s";
        };
      };
    };
}
