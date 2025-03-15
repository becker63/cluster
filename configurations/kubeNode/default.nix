{
  rootPath,
  withSystem,
  inputs,
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
        { config, inputs', ... }:
        inputs.nixpkgs.lib.nixosSystem {
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
