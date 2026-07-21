{
  delib,
  host,
  pkgs,
  ...
}:
delib.module {
  name = "programs.zed-editor";

  options = delib.singleEnableOption host.guiFeatured;

  home.ifEnabled = {
    programs.zed-editor = {
      enable = true;

      mutableUserSettings = false;
      mutableUserKeymaps = false;

      extensions = [
        "0x96f"
        "astro"
        "biome"
        "git-firefly"
        "nix"
        "typst"
        "sql"
        "qml"
      ];
      extraPackages = with pkgs; [
        nixd
        nil
        clang-tools
        tinymist
        package-version-server
        biome
        qt6.qtdeclarative
        rust-analyzer
      ];
    };
  };

}
