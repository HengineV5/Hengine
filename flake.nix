{
  description = "Hengine development shell";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = {
    self,
    nixpkgs,
  }: {
    devShells = nixpkgs.lib.genAttrs ["x86_64-linux" "aarch64-linux"] (system: let
      pkgs = nixpkgs.legacyPackages.${system};

      dotnet = pkgs.dotnetCorePackages.sdk_11_0;

      runtimeLibs = with pkgs; [
        glfw
        wayland
        libxkbcommon
        libdecor
        libGL
        vulkan-loader
        vulkan-validation-layers
        libx11
        libxcursor
        libxrandr
        libxi
        libxinerama
        libxxf86vm
        alsa-lib
        icu
        openssl
        zlib
      ];
    in {
      default = pkgs.mkShell {
        packages = [
          dotnet
          pkgs.netcoredbg
          pkgs.shaderc
          pkgs.vulkan-tools
          pkgs.git
        ];

        env = {
          DOTNET_ROOT = "${dotnet}/share/dotnet";
          DOTNET_CLI_TELEMETRY_OPTOUT = "1";
          DOTNET_NOLOGO = "1";
          VK_LAYER_PATH = "${pkgs.vulkan-validation-layers}/share/vulkan/explicit_layer.d";
          LD_LIBRARY_PATH = "${nixpkgs.lib.makeLibraryPath runtimeLibs}:/run/opengl-driver/lib";
        };
      };
    });
  };
}
