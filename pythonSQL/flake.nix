{
  description = "A python devshell that also has a background mysql service";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    process-compose-flake.url = "github:Platonic-Systems/process-compose-flake";
    services-flake.url = "github:juspay/services-flake";
  };

  outputs = {
    self, # Necessary for direnv
    nixpkgs,
    process-compose-flake,
    services-flake,
  }: let
    pythonPackages = ps:
      with ps; [
        ipython
        pandas
        tkinter
      ];
    forAllSystems = f:
      nixpkgs.lib.genAttrs ["x86_64-linux" "aarch64-darwin"] (system:
        f rec {
          pkgs = nixpkgs.legacyPackages.${system};
          servicesMod = (import process-compose-flake.lib {inherit pkgs;}).evalModules {
            modules = [
              services-flake.processComposeModules.default
              {
                services.mysql."sql1".enable = true;
              }
            ];
          };
        });
  in {
    devShells = forAllSystems ({
      pkgs,
      servicesMod,
    }: {
      default = pkgs.mkShell {
        inputsFrom = [
          servicesMod.config.services.outputs.devShell
        ];
        packages = [
          (pkgs.python3.withPackages pythonPackages)
          pkgs.sqlite
        ];
      };
    });
  };
}
