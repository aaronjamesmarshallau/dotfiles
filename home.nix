{ config, lib, ... }:
let
  home-manager = builtins.fetchTarball {
    url = "https://github.com/nix-community/home-manager/archive/release-25.05.tar.gz";
  };
  pkgs = import <nixos> {
    config = {
      allowUnfree = true;
      permittedInsecurePackages = [
        "dotnet-runtime-7.0.20"
      ];
    };
  };
  unstable = import <nixos-unstable> {
    config = {
      allowUnfree = true;
      permittedInsecurePackages = [
        "openssl-1.1.1w"
        "dotnet-runtime-7.0.20"
      ];
    };
  };
in
{
  imports = [
    (import "${home-manager}/nixos")
  ];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Docker
  virtualisation.docker.enable = true;
  users.users.amarshall.extraGroups = [ "docker" ];

  # Bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  # Development port
  networking.firewall.allowedTCPPorts = [ 5173 ];
  networking.hosts = lib.mkForce {
    "127.0.0.1" = [ "nixos" ];
  };

  home-manager.users.amarshall = {
    # This should be the same value as `system.stateVersion` in
    # your `configuration.nix` file.
    home.stateVersion = "24.11";

    programs.zoxide = {
      enable = true;
      enableBashIntegration = true;
      enableFishIntegration = false;
      enableNushellIntegration = false;
      enableZshIntegration = false;
    };

    programs.bash = {
      enable = true;
      bashrcExtra = ''
      case "$TERM" in
          xterm-color|*-256color|*ghostty) color_prompt=yes;;
      esac
      '';
    };

    programs.java = {
      enable = true;
      package = pkgs.temurin-bin;
    };

    # Install Firefox
    programs.firefox.enable = true;

    # Install Waybar
    programs.waybar.enable = true;

    home.file = {            
      # other configs
      ".config" = {
        source = ./src/configs;
        recursive = true;
      };
    };

    home.sessionVariables = {
      ELECTRON_OZONE_PLATFORM_HINT = "wayland";
    };

    home.pointerCursor = {
      name = "catppuccin-mocha-dark-cursors";
      package = pkgs.catppuccin-cursors.mochaDark;
      size = 24;
      gtk.enable = true;
    };

    home.packages = [
      pkgs.awscli2                    # awscli2
      pkgs.code-cursor                # Cursor code editor
      pkgs.curl                       # Curl
      pkgs.davinci-resolve            # Video editing
      pkgs.dig                        # dig
      pkgs.ergogen                    # Ergogen
      pkgs.evtest                     # Evtest
      pkgs.fd                         # fd - find but better
      pkgs.feh                        # Image Viewer
      pkgs.gamescope                  # Gamescope for Wayland
      pkgs.ghostty                    # Ghostty terminal
      pkgs.gimp                       # Image editor
      pkgs.git                        # Git
      pkgs.godot_4                    # Godot game engine
      pkgs.jetbrains.idea-community   # Intellij IDEA IDE
      pkgs.kicad                      # KiCad EDA suite
      pkgs.lutris                     # Lutris game manager
      pkgs.mpv                        # media player
      pkgs.nodejs                     # NodeJS
      pkgs.obsidian                   # Obsidian note-taking app
      pkgs.postgresql_17              # Postgres
      pkgs.esptool                    # EspTool for flashing ESP devices
      pkgs.picocom                    # Serial terminal
      pkgs.prismlauncher              # Minecraft launcher
      pkgs.rpi-imager                 # Minecraft launcher
      pkgs.solaar                     # Solaar Logitech Device Manager
      pkgs.spotify                    # Spotify
      pkgs.sysfsutils                 # Systool
      pkgs.usbutils                   # lsusb
      pkgs.vesktop                    # Custom discord client
      pkgs.vintagestory               # Vintage story game
      pkgs.vscode                     # Visual Studio Code
      pkgs.wev                        # Wayland Events
      pkgs.wget                       # Wget
      pkgs.xfce.xfconf                # XFConf configuration system
      pkgs.xivlauncher                # XIVLauncher for FFXIV
      pkgs.zip                        # ZIP package

      # Thunar file manager
      (pkgs.xfce.thunar.override {
        thunarPlugins = with pkgs.xfce; [
          thunar-archive-plugin
          thunar-volman
        ];
      })

      # Flameshot screenshot tool
      (pkgs.flameshot.override { enableWlrSupport = true; })

      # System packages
      pkgs.cliphist                   # Command line history manager
      pkgs.coreutils                  # Core utilities
      pkgs.egl-wayland                # Required for nvidia/wayland/compositor compatibility
      pkgs.font-manager               # Font manager GUI
      pkgs.kdePackages.ark            # Archive manager
      pkgs.mako                       # Notification daemon
      pkgs.myxer                      # Audio mixer GUI
      pkgs.rofi-wayland               # Rofi general purpose list tool
      pkgs.seahorse                   # Seahorse password manager
      pkgs.zenity                     # Zenity dialog tool

      unstable.bruno                  # Bruno rest client
      unstable.hyprlock
      unstable.signal-desktop         # Signal encrypted messenger
      unstable.wpaperd                # Wallpaper configuration
      (unstable.bolt-launcher.override { enableRS3 = true; })
    ];

    gtk.cursorTheme = {
      package = pkgs.catppuccin-cursors.mochaDark;
      name = "catppuccin-mocha-dark-cursors";
    };
  };
}
