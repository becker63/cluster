# run `nix develop` to get these scripts
{
  perSystem =
    {
      pkgs,
      config,
      system,
      ...
    }:
    let
      unfreePkgs = import pkgs.path {
        inherit system;
        config = {
          allowUnfree = true;
        };
      };
    in
    {
      mission-control.scripts = {
        # Utils
        hello = {
          category = "Dev Tools";
          description = "Hello :)";
          exec = pkgs.writeShellScriptBin "hello" "echo Hello!";
        };

        clean = {
          category = "Utils";
          description = "Cleans any result produced by Nix or associated tools";
          exec = pkgs.writeShellScriptBin "clean" "rm -rf result* *.qcow2";
        };

      };
      devShells.default = pkgs.mkShell {
        inputsFrom = [ config.mission-control.devShell ];
        buildinputs = with unfreePkgs; [
          terraform
        ];
        shellHook = ''
          # https://discourse.nixos.org/t/using-nix-develop-opens-bash-instead-of-zsh/25075/17 TLDR: Too much setup, idc bro just exit twice
          export ROOT="${./.}"
          zsh
        '';
      };
    };
}
