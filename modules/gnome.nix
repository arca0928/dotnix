{
  flake.modules.nixos.gnome =
    { pkgs, lib, ... }:
    let
      # from https://codeberg.org/SeniorMatthew/nixos/src/branch/main/modules/sessions/gnome/blur-my-shell.nix
      mutterMajor = lib.versions.major pkgs.mutter.version;

      # GNOME 49 = libmutter-17, GNOME 50 = libmutter-18
      mutterApi =
        {
          "49" = "17";
          "50" = "18";
        }
        .${mutterMajor} or (throw "Unsupported Mutter major: ${mutterMajor}");

      gnomeRoundedBlur = pkgs.stdenv.mkDerivation {
        pname = "gnome-rounded-blur";
        version = "1.0.1";

        src = pkgs.fetchFromGitHub {
          owner = "kancko";
          repo = "gnome-rounded-blur";
          rev = "v1.0.1";

          # First rebuild will fail and print the real hash.
          # Replace this with the printed `got: sha256-...`
          hash = "sha256-hiWQaYydlyIMHKsx49f7sGOLM9ev1g1kdlloUszZU8I";
        };

        nativeBuildInputs = with pkgs; [
          meson
          ninja
          pkg-config
          gobject-introspection
          wayland-scanner
          desktop-file-utils
          gettext
        ];

        buildInputs = with pkgs; [
          # Direct gnome-rounded-blur deps
          glib
          mutter

          # Mutter/pkg-config deps
          cairo
          colord
          lcms2
          pango
          libstartup_notification
          libcanberra
          libadwaita
          libxcvt
          libGL
          mesa-gl-headers

          # X11 deps
          libx11
          libxcomposite
          libxcursor
          libxdamage
          libxext
          libxfixes
          libxi
          libxcb
          libxrandr
          libxinerama
          libxau
          libsm

          # Wayland / input / compositor deps
          wayland
          wayland-protocols
          libinput
          libdrm
          libgbm
          libei
          libepoxy
          libdisplay-info
          libxkbcommon
          xkeyboard_config
          xwayland

          # GNOME / GTK deps
          gsettings-desktop-schemas
          gdk-pixbuf
          gnome-desktop
          gnome-settings-daemon
          gtk4
          atk
          fribidi
          harfbuzz
          graphene

          # Other Mutter deps
          pipewire
          libgudev
          libwacom
          sysprof
          libsysprof-capture
          libglycin
        ];

        postPatch = ''
          substituteInPlace meson.build \
            --replace-fail "mutter_api_version = '18'" "mutter_api_version = '${mutterApi}'" \
            --replace-fail "mutter_req = '>= 50.0'" "mutter_req = '>= ${mutterMajor}.0'" \
            --replace-fail "dependency('libmutter-18')" "dependency('libmutter-${mutterApi}')"
        '';
      };
    in
    {
      services.desktopManager.gnome = {
        enable = true;
      };
      environment.sessionVariables = {
        GI_TYPELIB_PATH = "${gnomeRoundedBlur}/lib/girepository-1.0:${pkgs.mutter}/lib/girepository-1.0";
        LD_LIBRARY_PATH = "${gnomeRoundedBlur}/lib:${pkgs.mutter}/lib";
      };

      environment.systemPackages = with pkgs; [
        adwaita-icon-theme
        gnomeRoundedBlur
      ];

      services.udev.packages = with pkgs; [
        gnome-settings-daemon
      ];

      programs.dconf.profiles.user.databases = [
        {
          lockAll = true;
          settings = {
            "org/gnome/mutter" = {
              experimental-features = [
                "scale-monitor-framebuffer"
                "variable-refresh-rate"
                "xwayland-native-scaling"
              ];
            };
          };
        }
      ];
    };
  flake.modules.homeManager.dconf =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        gnomeExtensions.transparent-top-bar-adjustable-transparency
        gnomeExtensions.status-tray
        gnomeExtensions.kimpanel
        gnomeExtensions.dash-to-dock
        gnomeExtensions.blur-my-shell
      ];

      gtk = {
        enable = true;
        iconTheme = {
          package = pkgs.adwaita-icon-theme;
          name = "Adwaita";
        };
      };

      dconf = {
        enable = true;
        settings = {
          "org/gnome/shell" = {
            disable-user-extensions = false;
            enabled-extensions = with pkgs.gnomeExtensions; [
              transparent-top-bar-adjustable-transparency.extensionUuid
              status-tray.extensionUuid
              kimpanel.extensionUuid
              dash-to-dock.extensionUuid
              blur-my-shell.extensionUuid
            ];
          };
        };
      };
    };
}
