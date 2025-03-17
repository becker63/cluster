{
  rootPath,
  secrets,
  inputs,
  ...
}:
let
  nixpkgs = inputs.nixpkgs;
in
{
  flake.nixosConfigurations.iso = nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";

    specialArgs = {
      secrets = secrets;
    };

    modules = [
      "${nixpkgs.modulesPath}/installer/cd-dvd/installation-cd-minimal.nix"
      "${rootPath}/configurations/shared"
    ];

    # Override the minimal installer's default root password
    users.users.root.initialHashedPassword = nixpkgs.lib.mkForce null;
  };
}
