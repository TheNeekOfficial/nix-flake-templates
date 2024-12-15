{
  description = "A python template for pandas etc.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }: 
    let  
      forAllSystems = nixpkgs.lib.genAttrs ["x86_64-linux" "aarch64-darwin"];
      pkgs = forAllSystems (system: nixpkgs.legacyPackages.${system});
      pythonPackages = (ps: with ps; [
        ipython
        pandas
      ]);
    in
    {
      devShells = forAllSystems (system: {
        default = pkgs.${system}.mkShellNoCC {
          packages = with pkgs.${system}; [
            (python3.withPackages pythonPackages)
            bash
            unzip
            gnumake
            gnugrep
          ];
        };
      });
    };
}
