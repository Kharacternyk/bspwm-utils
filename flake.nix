{
  inputs.utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, utils }: utils.lib.eachDefaultSystem (system:
    with import nixpkgs { inherit system; }; {
      defaultPackage = pkgs.writeShellScriptBin "ubspc" (builtins.readFile ./ubspc.sh);
      devShell = pkgs.mkShell {
        packages = [ self.defaultPackage.${system} ];
      };
    }
  );
}
