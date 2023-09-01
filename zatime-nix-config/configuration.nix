# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
       
    ];
  
   virtualisation = {
    waydroid.enable = true;
    lxd.enable = true;
  };
  hardware.bluetooth.enable = true;  
  nix.settings.auto-optimise-store = true;
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;
  
  #card-hp latpop stuff 
   boot.extraModulePackages = [ config.boot.kernelPackages.rtl8821ce ];
   boot.blacklistedKernelModules = ["rtw88-8821ce"];
  services.auto-cpufreq.enable = true;
  services.auto-cpufreq.settings = {
   battery = {
     governor = "powersave";
     turbo = "never";
   };
   charger = {
     governor = "performance";
     turbo = "auto";
   };
  };
  services.thermald.enable = true;
  #flatpak
  services.flatpak.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Dubai";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "ar_AE.UTF-8";
    LC_IDENTIFICATION = "ar_AE.UTF-8";
    LC_MEASUREMENT = "ar_AE.UTF-8";
    LC_MONETARY = "ar_AE.UTF-8";
    LC_NAME = "ar_AE.UTF-8";
    LC_NUMERIC = "ar_AE.UTF-8";
    LC_PAPER = "ar_AE.UTF-8";
    LC_TELEPHONE = "ar_AE.UTF-8";
    LC_TIME = "ar_AE.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  services.xserver.displayManager.defaultSession = "plasmawayland";
  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };



  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
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

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.zatime = {
    isNormalUser = true;
    description = "zatime";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      firefox
      kate
     ppsspp
     brave
     lutris
     #spotify     
    #  thunderbird
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
   (python311.withPackages(ps: with ps; [ pandas requests inquirerpy tqdm ]))
   
  
   #pkgs.anydesk
  #this one is for rtl drivers for hp4 dq2xxxwm
   pkgs.linuxKernel.packages.linux_zen.rtl8821ce
   pkgs.rustup
   # support both 32- and 64-bit applications
    wineWowPackages.stable

    # support 32-bit only
    wine-staging

    # support 64-bit only
    (wine.override { wineBuild = "wine64"; })

    # wine-staging (version with experimental features)
    wineWowPackages.staging

    # winetricks (all versions)
    winetricks

    # native wayland support (unstable)
    wineWowPackages.waylandFull
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #  wget
  lzip
  pkgs.gnome.gnome-tweaks
  pkgs.gnomeExtensions.appindicator
  pkgs.gnomeExtensions.dash-to-dock
  pkgs.gnomeExtensions.user-themes
  pkgs.gnomeExtensions.blur-my-shell
  pkgs.emacsPackages.forge
  pkgs.gnomeExtensions.pano
  pkgs.pulsar
  pkgs.nodejs_20
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };
 

    nixpkgs.config.packageOverrides = pkgs: {
    vaapiIntel = pkgs.vaapiIntel.override { enableHybridCodec = true; };
    };
    hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver # LIBVA_DRIVER_NAME=iHD
      vaapiIntel         # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
      vaapiVdpau
      libvdpau-va-gl
    ];
  };


  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;


  nix = {
  package = pkgs.nixFlakes;
  extraOptions = ''
    experimental-features = nix-command flakes
  ''; 
   };



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
  system.stateVersion = "23.05"; # Did you read the comment?

}
