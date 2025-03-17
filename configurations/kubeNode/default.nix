{
  rootPath,
  inputs,
  ...
}:
let
  # Read the JSON file containing node data
  nodes = builtins.fromJSON (builtins.readFile (rootPath + "/provision/kubeNode/nixos-vars.json"));
  # Capture the nixpkgs input from the flake
  nixpkgs = inputs.nixpkgs;
in
{
  flake.nixosConfigurations = builtins.listToAttrs (
    map (node: {
      name = node.name;
      value = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          {
            # Here we inject per-node configuration from the JSON data
            networking.hostId = node.hostid;
          }
        ];
      };
    }) nodes
  );
}
