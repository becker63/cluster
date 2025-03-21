{
  description = "packages and build scripts";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/24.11";
    disko.url = "github:nix-community/disko";
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixos-facter-modules.url = "github:numtide/nixos-facter-modules";
    flake-root.url = "github:srid/flake-root";
    mission-control.url = "github:Platonic-Systems/mission-control";
  };

  outputs =
    inputs@{
      nixpkgs,
      flake-parts,
      flake-root,
      mission-control,
      nixos-facter-modules,
      disko,
      ...
    }:
    flake-parts.lib.mkFlake
      {
        inherit inputs;
      }
      (
        let
          # 1) Define secrets in a single place
          secrets = builtins.fromJSON (builtins.readFile ./secrets/secrets.json);
          rootPath = ./.;
        in
        {
          # Systems you can provision with, I really would not recommend building on darwin though, you need a remote builder
          systems = [
            "x86_64-linux"
            "aarch64-darwin"
          ];

          imports = [
            # Needed for mission-control
            flake-root.flakeModule
            mission-control.flakeModule
            ./runners.nix

            # kubernetes nodes
            (import ./configurations/kubeNode {
              inherit
                inputs
                secrets
                rootPath
                ;
            })

            # iso bootstrap
            (import ./iso-builder {
              inherit
                inputs
                secrets
                rootPath
                ;
            })
          ];
        }
      );
}
