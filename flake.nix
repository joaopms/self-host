{
  description = "Ansible Environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = {
    self,
    nixpkgs,
  }: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {inherit system;};
  in {
    devShells.${system}.default = pkgs.mkShell {
      packages = with pkgs; [
        (python312.withPackages (ps: [
          ps.ansible-core
          ps.proxmoxer
          ps.github3-py
        ]))
      ];
    };
  };
}
