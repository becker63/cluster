{
  rootPath,
  secrets,
  modulesPath,
  lib,
  ...
}:
{

  imports = [
    "${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix"
    "${rootPath}/configurations/shared"
  ];
  nixpkgs.hostPlatform = "x86_64-linux";
  users.users.root.initialHashedPassword = lib.mkForce null; # override or unset what the minimal installer sets
}
