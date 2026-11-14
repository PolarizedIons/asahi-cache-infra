{
  description = "Infra flake for asahi-cache (phobos)";

  inputs = {
    # Recommended: nixpkgs zstd tarball using the lockable tarball protocol
    nixpkgs.url = "https://channels.nixos.org/nixos-unstable/nixexprs.tar.zst";

    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";

    attic.url = "github:zhaofengli/attic";
    attic.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      self,
      nixpkgs,
      agenix,
      attic,
      ...
    }@inputs:
    let
      system = "aarch64-linux";
    in
    {

      packages."${system}".oidc-ssh-ca =
        let
          pkgs = import nixpkgs { inherit system; };
        in
        pkgs.buildGoModule rec {
          pname = "oidc-ssh-ca";
          version = "0.4.0";
          src = pkgs.fetchFromGitHub {
            owner = "atsuoishimoto";
            repo = "oidc-ssh-ca";
            rev = "${version}";
            sha256 = "sha256-eM8x++mD3AbWYqR4X4xXIXNtcIP4lGKcilOL/lLbF+M=";
          };
          vendorHash = "sha256-vU6aB0FKGgGj0sbEzmhOPIztNwnxTaLBbi8O50N28rU=";
          meta.mainProgram = pname;
        };

      nixosConfigurations.phobos = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          agenix.nixosModules.default
          attic.nixosModules.atticd
          ./host
          ./secrets
          ./services
        ];
        specialArgs = {
          inherit inputs self system;
        };
      };
    };
}
