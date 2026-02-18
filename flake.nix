{
  description = "CTF environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };

      python = pkgs.python311;

      # Define Python packages here
      pythonPackages =
        ps: with ps; [
          requests
        ];

    in
    {
      devShells.${system}.default = pkgs.mkShell {
        buildInputs = [
          (python.withPackages pythonPackages)
        ];

        shellHook = ''
          echo "Python dev environment ready 🚀"
          python --version
        '';
      };
    };
}
