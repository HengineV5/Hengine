{
  description = "Hengine development shell (native graphics libraries for Silk.NET/GLFW/Vulkan)";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = {
    self,
    nixpkgs,
  }: {
    devShells = nixpkgs.lib.genAttrs ["x86_64-linux" "aarch64-linux"] (system: let
      pkgs = nixpkgs.legacyPackages.${system};

      runtimeLibs = with pkgs; [
        glfw
        wayland
        libxkbcommon
        libdecor
        libGL
        vulkan-loader
        libx11
        libxcursor
        libxrandr
        libxi
        libxinerama
        libxxf86vm
        alsa-lib
      ];
    in {
      default = pkgs.mkShell {
        packages = with pkgs; [vulkan-tools];

        LD_LIBRARY_PATH = "${nixpkgs.lib.makeLibraryPath runtimeLibs}:/run/opengl-driver/lib";
      };
    });
  };
}
