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
      pythonPackages = ps: with ps; [ requests ];

      # Define PHP with common extensions for CTFs
      phpEnv = pkgs.php.buildEnv {
        extensions = (
          { enabled, all }:
          enabled
          ++ (with all; [
            xdebug
            mysqli
            curl
          ])
        );
      };

    in
    {
      devShells.${system}.default = pkgs.mkShell {
        buildInputs = [
          (python.withPackages pythonPackages)
          phpEnv # Add PHP here
        ];

        shellHook = ''
          echo "CTF environment ready 🚀"
          python --version
          php --version
          echo "Hint: Use 'php -S localhost:8000' to start a quick test server."
        '';
      };
    };
}
