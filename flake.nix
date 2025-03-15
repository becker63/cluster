# https://git.rossabaker.com/actions-bot/clan-infra
{
  description = "packages and build scripts";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/24.11";
    disko.url = "github:nix-community/disko";
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixos-facter-modules.url = "github:numtide/nixos-facter-modules";
    # Needed for mission control
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
      {
        flake =
          let

            secrets = builtins.fromJSON (builtins.readFile ./secrets/secrets.json);
            rootPath = ./.;
          in
          {

            nixosConfigurations.iso = nixpkgs.lib.nixosSystem {
              system = "x86_64-linux";
              modules = [
                ./iso-builder
              ];
              specialArgs = {
                inherit secrets rootPath;
                lib = nixpkgs.lib;
              };
            };
          };

        # Everything that is not a nixosConfiguration
        systems = [
          "x86_64-linux"
          "aarch64-darwin"
        ];

        imports = [
          flake-root.flakeModule
          mission-control.flakeModule
          (
            {
              withSystem,
              ...
            }:
            import ./configurations/kubeNode {
              inherit withSystem inputs;
              rootPath = ./.;
            }
          )
        ];

      };
}
