{ pkgs, modulesPath, ... }:
{

  imports = [
    "${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix"
  ];

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "yes"; # Allow root login with a password
      PasswordAuthentication = true; # Allow password authentication
    };
  };

  users.users.root = {
    password = "jidw"; # Set an empty password for root
  };
}
