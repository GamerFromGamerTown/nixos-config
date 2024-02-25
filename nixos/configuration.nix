# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
 # ADD PRELOAD PACKAGE AND PRELOAD FOOT
{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
	./hardware-configuration.nix
      # Use custom bootloader settings.
	./bootloader-settings.nix 
      # Hardening systemd services
# 	./systemd-hardening.nix 
      # Enable the home manager. 
	<home-manager/nixos>	
    ];

  # Bootloader.
 nixpkgs.config.allowUnfree = true;
 # Enable virtualisation support
  virtualisation.libvirtd.enable = true;

  networking.hostName = "nixy_wixy"; # Define your hostname.
  networking.wireguard.enable = true;
  systemd.services.NetworkManager-wait-online.enable = true;
  hardware.bluetooth.enable = true; # enables support for Bluetooth
  services.blueman.enable = true;

 #programs.home-manager.enable = true;
 # users.users.gaymer.home-manager.enable = true;
 # users.users.gaymer.home-manager.homeDirectory = "/home/gaymer";
 # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable the PipeWire service
# Enable sound with pipewire.
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
    wireplumber.enable = true;

  };  


  # Optional: Enable support for JACK clients

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Anchorage";


programs.zsh = {
 ohMyZsh = {
    enable = true;
    plugins = [ "git" ];
    theme = "kolo";
 #  themeRandomCandidates = [ "kolo" "daveverwer" "jreese" ];
  };
};

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

programs.zsh.enable = true;

  # Configure keymap in X11
services.xserver = {
  enable = true;  # Enable the X server

  displayManager = {
    lightdm.enable = true;  # Enable LightDM
    # Any additional LightDM configurations go here
  };

  # Include any additional X server configurations here
};
services.logrotate.checkConfig = false;


services.undervolt.enable = true;
services.undervolt.coreOffset = -90;
services.undervolt.gpuOffset = -60;

# swapDevices = [ {
#    device = "/dev/sda3";
#    randomEncryption.enable = true; 
#  } ];

programs.hyprland = {
enable = true;
xwayland.enable = true; 
};
 ###
networking.nameservers = [ "9.9.9.9#nine.nine.nine.nine" "1.0.0.1#one.one.one.one" ];

services.resolved = {
  enable = true;
  dnssec = "true";
  domains = [ "~." ];
  fallbackDns = [ "9.9.9.9#one.one.one.one" "1.0.0.1#one.one.one.one" ];
  extraConfig = ''
    DNSOverTLS=yes
  '';
};
##
services.auto-cpufreq.enable = true;
services.thermald.enable = true;
# ^ cpu tomfoolery ^



#security B)
security.apparmor.enable = true; # CONFIG LATER
nix.settings.allowed-users = [ "@wheel" ];
security.sudo.execWheelOnly = true;
systemd.coredump.enable = false;
security.chromiumSuidSandbox.enable = true;
services.clamav.daemon.enable = true;
services.clamav.updater.enable = true;
services.opensnitch.enable = true;
#security end B(

services.gnome.gnome-settings-daemon.enable = true;
environment.systemPackages = [
pkgs.alacritty pkgs.auto-cpufreq pkgs.brightnessctl pkgs.bubblewrap pkgs.catppuccin pkgs.catppuccin-cursors pkgs.catppuccin-gtk pkgs.catppuccin-papirus-folders pkgs.clamav pkgs.cmake pkgs.fail2ban pkgs.git pkgs.gnumake pkgs.gsettings-desktop-schemas pkgs.gtop pkgs.helvum pkgs.htop pkgs.hyprpaper pkgs.inconsolata  pkgs.libglvnd pkgs.libnotify pkgs.logrotate pkgs.mesa pkgs.mesa.drivers pkgs.neovim pkgs.nordzy-cursor-theme pkgs.macchanger pkgs.opensnitch pkgs.opensnitch-ui pkgs.pavucontrol pkgs.pipewire pkgs.python3 pkgs.qemu pkgs.rsync pkgs.sddm pkgs.sddm-chili-theme pkgs.snort pkgs.swaylock pkgs.undervolt pkgs.unzip pkgs.waybar pkgs.wget pkgs.wlsunset pkgs.wofi pkgs.zsh
];
xdg.portal.enable = true;
xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.gaymer = {
    isNormalUser = true;
    description = "alice";
    extraGroups = [ "networkmanager" "wheel" "audio" "libvert"];
    shell = pkgs.zsh;
    packages = with pkgs; [ armcord bleachbit bottom brave fastfetch featherpad firefox foot geany git gimp hyprpicker krita libreoffice-still lolcat lxappearance lynx mpv oh-my-zsh pcmanfm signal-desktop sl swaylock timeshift virt-manager vlc vscode-extensions.arcticicestudio.nord-visual-studio-code wlsunset];
  };

home-manager.users.gaymer = { pkgs, ... }: {
  home.packages = [  ];
  home.stateVersion = "23.11";    
};

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.steam = {
    isNormalUser = true;
    description = "gayming";
    extraGroups = [ "networkmanager" "wheel" "audio" ];
    packages = with pkgs; [ steam steam-run git libreoffice-still mpv fastfetch pcmanfm ungoogled-chromium wget steam];
  };

fonts.packages = with pkgs; [
  noto-fonts
  nerdfonts
  noto-fonts-cjk
  noto-fonts-emoji
  liberation_ttf
  fira-code
  fira-code-symbols
  mplus-outline-fonts.githubRelease
  dina-font
  proggyfonts
];


environment.variables = {
  GTK_THEME = "Catppuccin"; # Replace with the correct GTK theme name
  XDG_ICON_THEME = "Papirus-Catppuccin"; # Replace with the correct icon theme name
};



  environment.shellInit = ''
    umask 0077
  '';

  # List packages installed in system profile. To search, run:
  # $ nix search wget

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #  enableSSHSupport = false;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

systemd.services.macchanger = {
  description = "macchanger on eth0";
  wantedBy = [ "multi-user.target" ];
  wants = [ "network-pre.target" ];
  before = [ "network-pre.target" ];
  bindsTo = [ "sys-subsystem-net-devices-enp0s25.device" ];
  after = [ "sys-subsystem-net-devices-enp0s25.device" ];

  serviceConfig = {
    ExecStart = "${pkgs.macchanger}/bin/macchanger -e enp0s25";
    Type = "oneshot";
  };
};


  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = true;
# Enable the firewall ###FIREWALL
  # Specify any other rules or settings here as needed
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

}
