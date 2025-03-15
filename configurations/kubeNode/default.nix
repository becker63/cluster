{
  rootPath,
  withSystem,
  ...
}:
let
  nodes = builtins.fromJSON (builtins.readFile (rootPath + "/provision/kubeNode/nixos-vars.json"));
in
{
  flake.nixosConfigurations = builtins.listToAttrs (
    map (node: {
      name = node.name;

      value = withSystem "x86_64-linux" (
        { pkgs, inputs', ... }:
        pkgs.lib.nixosSystem {
          networking.hostId = node.hostid;
          specialArgs = {
            inherit inputs';
          };

          modules = [

          ];
        }
      );
    }) nodes
  );
}
