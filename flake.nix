{
  description = "GPU Tracing";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
  };

  outputs = inputs@{ self, nixpkgs, ... }:
    let
      systems = [ "x86_64-linux" ];
      forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f system);
    in
    {
      devShells = forAllSystems (system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          default = pkgs.mkShell {
            nativeBuildInputs = [ pkgs.bashInteractive ];
            buildInputs = with pkgs; [
            ];
            AMD_VULKAN_ICD = "RADV";
            LD_LIBRARY_PATH = "$LD_LIBRARY_PATH:${with pkgs; lib.makeLibraryPath [
              vulkan-loader
              libxkbcommon
              wayland
            ]}";
          };
        });
    };
}
