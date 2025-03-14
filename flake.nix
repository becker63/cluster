{
  description = "packages and build scripts";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/24.11";
    disko.url = "github:nix-community/disko";
    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-root.url = "github:srid/flake-root";
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      flake-parts,
      ...
    }:
    flake-parts.lib.mkFlake
      {
        inherit inputs;
        inherit self;
      }
      {
        flake =
          let
            shared = [
              inputs.flake-root.flakeModule
            ];
            secrets = builtins.fromJSON (builtins.readFile "${self}/secrets/secrets.json");
          in
          {
            nixosConfigurations.home-pc = nixpkgs.lib.nixosSystem {
              modules = [
                ./hosts/home-pc/configuration.nix
              ] ++ shared;
              specialArgs = {
                inherit inputs;
                inherit secrets;
              };
            };
          };

        # Everything that is not a nixosConfiguration
        systems = [
          "x86_64-linux"
          "aarch64-darwin"
        ];

        perSystem =
          { pkgs, system, ... }:
          {
            # Apply overlay and allow unfree packages
            _module.args.pkgs = import nixpkgs {
              inherit system;
              config.allowUnfree = true;
            };

            packages.default = pkgs.mkShell {
              buildInputs = with pkgs; [
                terraform
                terraform-providers.libvirt
                libxslt
                qemu
              ];

              shellHook = ''
                zsh
              '';
            };
          };
      };
}
