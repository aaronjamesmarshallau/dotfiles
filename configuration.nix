# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
let unstable = import <nixos-unstable> {
  config = {
    allowUnfree = true;
  };
};
in
{
  nixpkgs.config.permittedInsecurePackages = [
    "broadcom-sta-6.30.223.271-57-6.12.55"
  ];
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./home.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.timeout = 0;
  boot.kernelParams = [ "nvidia_drm.fbdev=1" "nvidia_drm.modeset=1"];

  boot.extraModprobeConfig = '' options bluetooth disable_ertm=1 '';

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Australia/Melbourne";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_AU.UTF-8";
    LC_IDENTIFICATION = "en_AU.UTF-8";
    LC_MEASUREMENT = "en_AU.UTF-8";
    LC_MONETARY = "en_AU.UTF-8";
    LC_NAME = "en_AU.UTF-8";
    LC_NUMERIC = "en_AU.UTF-8";
    LC_PAPER = "en_AU.UTF-8";
    LC_TELEPHONE = "en_AU.UTF-8";
    LC_TIME = "en_AU.UTF-8";
  };

  # Enable SDDM for login
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };

  # Auto Login because hyprlock is the way
  services.displayManager.autoLogin = {
    enable = true;
    user = "amarshall";
  };

  systemd.services."systemd-suspend" = {
    serviceConfig = {
      Environment=''"SYSTEMD_SLEEP_FREEZE_USER_SESSIONS=false"'';
    };
  };

  hardware.xpadneo.enable = true;

  # nvidia
  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {
    # Required
    modesetting.enable = true;

    # By default, only the bare essentials are written to disk from
    # VRAM. If you encounter video corruptions after waking from sleep
    # try enabling this option.
    powerManagement.enable = true;

    # Turns off GPU when not in use - only supported by Turing or newer
    # cards.
    powerManagement.finegrained = false;

    # Use the open source kernel for your GPU. Not to be confused with
    # nouveau drivers
    open = true;

    # nvidia settings UI enabled (`nvidia-settings`)
    nvidiaSettings = true;

    # Specify which drivers to use.
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  # Configure keymap in X11
  #services.xserver.xkb = {
  #  layout = "us";
  #  variant = "";
  #};

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enables stuff for the file manager
  services.gvfs.enable = true;
  services.tumbler.enable = true;

  # Keyring
  services.gnome.gnome-keyring.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };
  services.sunshine = {
    enable = true;
    autoStart = true;
    capSysAdmin = true;
  };
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    publish = {
      enable = true;
      userServices = true;
      addresses = true;
    };
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.amarshall = {
    isNormalUser = true;
    description = "Aaron Marshall";
    extraGroups = [ "networkmanager" "wheel" ];
  };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    gamescopeSession.enable = true;
  };
  
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  fonts.packages = with pkgs; [
    nerd-fonts.symbols-only
    nerd-fonts.fantasque-sans-mono
    cabin
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?

}
