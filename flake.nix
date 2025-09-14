{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixos-generators, ... }:
    let
      mkIso = system: nixos-generators.nixosGenerate {
        inherit system;
        format = "install-iso";
        # Drop your installer customizations here if you really need them:
        modules = [ ];
      };
    in {
      # Native build when run on x86_64
      packages.x86_64-linux.install-iso = mkIso "x86_64-linux";
      # Cross/emulated build of aarch64 from x86_64 runner
      packages.aarch64-linux.install-iso = mkIso "aarch64-linux";

      # Convenience aliases:
      packages.x86_64-linux.default = self.packages.x86_64-linux.install-iso;
      packages.aarch64-linux.default = self.packages.aarch64-linux.install-iso;
    };
}
