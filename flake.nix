{
  description = "Infra flake for asahi-cache (phobos)";

  inputs = {
    # Recommended: nixpkgs zstd tarball using the lockable tarball protocol
    nixpkgs.url = "https://channels.nixos.org/nixos-unstable/nixexprs.tar.zst";

    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    { nixpkgs, agenix, ... }@inputs:
    {
      nixosConfigurations.phobos = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        modules = [
          agenix.nixosModules.default
          ./host
          ./secrets
          ./services
        ];
        specialArgs = {
          inherit inputs;
        };
      };
    };
}
