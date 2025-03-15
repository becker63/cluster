# https://aldoborrero.com/posts/2023/01/15/setting-up-my-machines-nix-style/
# https://github.com/Platonic-Systems/mission-control/tree/a562943f45d9b8ae63dd62ec084202fdbdbeb83f
# run `nix develop` to get these scripts
{
  perSystem =
    {
      pkgs,
      config,
      system,
      ...
    }:
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
        buildinputs = with pkgs; [
          terraform
        ];
        shellHook = ''
            # https://discourse.nixos.org/t/using-nix-develop-opens-bash-instead-of-zsh/25075/17 TLDR: Too much setup, idc bro just exit twice
          zsh
        '';
      };
    };
}
