{ config, lib, ... }:
let
  home-manager = builtins.fetchTarball {
    url = "https://github.com/nix-community/home-manager/archive/release-26.05.tar.gz";
  };
  pkgs = import <nixos> {
    config = {
      allowUnfree = true;
      permittedInsecurePackages = [
        "python3.12-ecdsa-0.19.1"
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
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings.General = {
      experimental = true;
      Private = "device";
      JustWorksPairing = "always";
      Class = "0x000100";
      FastConnectable = true;
    };
  };

  services.blueman.enable = true;

  networking.firewall.allowedTCPPorts = [
    # Local development server
    5173
    # Sunshine
    47984
    47989
    47990
    48010
  ];
  networking.firewall.allowedUDPPortRanges = [
    { from = 47998; to = 48000; }
    { from = 8000; to = 8010; }
  ];
  networking.hosts = lib.mkForce {
    "127.0.0.1" = [ 
      "nixos" 
      # "imaaronnicetomeetyou.me" 
      # "api.imaaronnicetomeetyou.me" 
    ];
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
    programs.firefox = {
      enable = true;
      package = unstable.firefox;
    };

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
      GDK_BACKEND = "wayland";
      XDG_SESSION_TYPE = "wayland";
    };

    home.pointerCursor = {
      name = "catppuccin-mocha-dark-cursors";
      package = pkgs.catppuccin-cursors.mochaDark;
      size = 24;
      gtk.enable = true;
    };

    home.packages = [
      pkgs.antigravity                # AntiGravity ide
      pkgs.awscli2                    # awscli2
      pkgs.bruno                      # Bruno rest client
      pkgs.claude-code                # Claude AI client
      pkgs.curl                       # Curl
      pkgs.davinci-resolve
      pkgs.dig                        # dig
      pkgs.discord                    # Discord
      pkgs.ergogen                    # Ergogen
      pkgs.evtest                     # Evtest
      pkgs.fd                         # fd - find but better
      pkgs.feh                        # Image Viewer
      pkgs.ffmpeg                     # FFmpeg
      pkgs.gamescope                  # Gamescope for Wayland
      pkgs.ghostty                    # Ghostty terminal
      pkgs.gimp                       # Image editor
      pkgs.git                        # Git
      pkgs.godot_4                    # Godot game engine
      pkgs.jetbrains.idea-oss   # Intellij IDEA IDE
      pkgs.kicad                      # KiCad EDA suite
      pkgs.mpv                        # media player
      pkgs.nodejs                     # NodeJS
      pkgs.obsidian                   # Obsidian note-taking app
      pkgs.playerctl
      pkgs.postgresql_17              # Postgres
      pkgs.protonup-qt                # ProtonUp in QT
      pkgs.esptool                    # EspTool for flashing ESP devices
      pkgs.picocom                    # Serial terminal
      (pkgs.prismlauncher.override { jdks = [ pkgs.jdk17 pkgs.jdk21 pkgs.jdk25 ]; })              # Minecraft launcher
      pkgs.nixd
      pkgs.obs-studio
      pkgs.qdirstat                   # QDirStat disk usage analyzer
      pkgs.qpwgraph
      pkgs.ripgrep		      # Ripgrep - grep but faster
      pkgs.smartmontools              # Smartctl disk utility
      pkgs.solaar                     # Solaar Logitech Device Manager
      pkgs.spotify                    # Spotify
      pkgs.sunshine                   # Sunshine game streaming server
      pkgs.sysfsutils                 # Systool
      pkgs.pcmanfm		      # PCManFM file manager
      pkgs.usbutils                   # lsusb
      pkgs.wev                        # Wayland Events
      pkgs.wget                       # Wget
      pkgs.xfce.xfconf                # XFConf configuration system
      pkgs.xivlauncher                # XIVLauncher for FFXIV
      pkgs.wowup-cf
      pkgs.yt-dlp                      # YouTube downloader
      pkgs.zip                        # ZIP package

      # System packages
      pkgs.cliphist                   # Command line history manager
      pkgs.coreutils                  # Core utilities
      pkgs.egl-wayland                # Required for nvidia/wayland/compositor compatibility
      pkgs.font-manager               # Font manager GUI
      pkgs.hyprshot                   # Screenshot tool for Hyprland
      pkgs.kdePackages.ark            # Archive manager
      pkgs.mako                       # Notification daemon
      pkgs.myxer                      # Audio mixer GUI
      pkgs.pulseaudio
      pkgs.rofi                       # Rofi general purpose list tool
      pkgs.seahorse                   # Seahorse password manager
      pkgs.zenity                     # Zenity dialog tool

      unstable.hyprlock
      (unstable.neovim.overrideAttrs (oldAttrs: {
        postInstall = ''
	  wrapProgram $out/bin/nvim --prefix PATH : ${pkgs.lib.makeBinPath [ 
          pkgs.clang 
          pkgs.gnumake 
          pkgs.unzip 
          pkgs.cargo 
          pkgs.lua-language-server
          pkgs.nil
        ]}
	'';
      })) # Neovim text editor
      unstable.signal-desktop         # Signal encrypted messenger
      unstable.tree-sitter 	      # Tree Sitter parser generator and incremental parser
      unstable.vintagestory           # Vintage story game
      unstable.wpaperd                # Wallpaper configuration
      unstable.zed-editor             # Zed code editor
      (unstable.bolt-launcher.override { enableRS3 = false; })
      
    ];

    gtk.cursorTheme = {
      package = pkgs.catppuccin-cursors.mochaDark;
      name = "catppuccin-mocha-dark-cursors";
    };
  };
}
