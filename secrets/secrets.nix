let
  system = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAc0jA2C50dJ9zZbyjXVmlD0x5TvnblKVm1PxRqnPFJ8";
in
{
  "github-token.age" = {
    publicKeys = [ system ];
    amror = true;
  };
}
