{
  rootPath,
  withSystem,
  secrets,
  ...
}:
{
  flake.nixosConfigurations.iso = withSystem "x86_64-linux" (
    {
      config,
      inputs',
      pkgs,
      ...
    }:
    pkgs.lib.nixosSystem {
      # If you need to pass arguments to modules in 'iso-builder',
      # you can do so here, e.g.:
      specialArgs = {
        inherit inputs';
        # secrets, etc. if needed
      };

      modules = [
        "${pkgs.modulesPath}/installer/cd-dvd/installation-cd-minimal.nix"
        "${rootPath}/configurations/shared"
      ];

      # Example override: remove the minimal installer's default root password
      # so you can set your own or leave it empty.
      users.users.root.initialHashedPassword = pkgs.lib.mkForce null;
    }
  );
}
