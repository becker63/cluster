{
  secrets,
  ...
}:
{
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "yes"; # Allow root login with a password
      PasswordAuthentication = true; # Allow password authentication
    };
  };

  users.users.root = {
    password = "${secrets.nixos.root_password}"; # Set an empty password for root
  };
}
