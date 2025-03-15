{
  description = "Watson shortcuts";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };
  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      packages.${system}.default = pkgs.writeShellApplication {
        name = "watson_shortcuts.sh";
        runtimeInputs = with pkgs; [ bash watson ];
        text = builtins.readFile ./watson_shortcuts.sh;
        bashOptions = [ ];
        checkPhase = "";
      };
    };
}
