{
  inputs.flake-utils.url = "github:numtide/flake-utils";
  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = import nixpkgs { inherit system; }; in
      {
        defaultPackage = pkgs.writeShellScriptBin "ubspc" (builtins.readFile ./ubspc.sh);
        devShell = pkgs.mkShell {
          packages = [ self.defaultPackage.${system} ];
        };
      }
    );
}
