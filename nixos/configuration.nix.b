# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    supportedFilesystems = [ "ntfs" ];
    kernelPackages = pkgs.linuxPackages_6_6_hardened;

  };

 # Enable virtualisation support
  virtualisation.libvirtd.enable = true;

  networking.hostName = "ubuntu"; # Define your hostname.
  networking.wireguard.enable = true;

  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable the PipeWire service
  services.pipewire = {
    enable = true;
    alsa.enable = true; # If you want to support ALSA clients
    pulse.enable = true; # If you want to support PulseAudio clients
    jack.enable = true;
  };

  # Optional: Enable support for JACK clients

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Anchorage";

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

  # Configure keymap in X11
services.xserver = {
  enable = true;  # Enable the X server

  displayManager = {
    lightdm.enable = true;  # Enable LightDM
    # Any additional LightDM configurations go here
  };

  # Include any additional X server configurations here
};

services.undervolt.enable = true;
services.undervolt.coreOffset = -100;
services.undervolt.gpuOffset = -60;


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
security.apparmor.enable = false; # ENABLE ASAP
#security end B(
services.gnome.gnome-settings-daemon.enable = true;
services.mullvad-vpn.enable = true;
services.mullvad-vpn.package = pkgs.mullvad-vpn;
environment.systemPackages = [
pkgs.alacritty pkgs.audit pkgs.auto-cpufreq pkgs.catppuccin-sddm-corners pkgs.clamav pkgs.cmake pkgs.dunst pkgs.fail2ban pkgs.git pkgs.gsettings-desktop-schemas pkgs.gtop pkgs.helvum pkgs.htop pkgs.hyprpaper pkgs.kitty pkgs.libglvnd pkgs.libnotify pkgs.mesa pkgs.mesa.drivers pkgs.mullvad-vpn pkgs.nordic pkgs.nordzy-cursor-theme pkgs.papirus-icon-theme pkgs.pavucontrol pkgs.pipewire pkgs.python3 pkgs.qemu pkgs.redshift pkgs.rsync pkgs.sddm pkgs.sddm-chili-theme pkgs.snort pkgs.swaylock pkgs.undervolt pkgs.unzip pkgs.waybar pkgs.wlsunset pkgs.wofi
];
xdg.portal.enable = true;
xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.gaymer = {
    isNormalUser = true;
    description = "alice";
    extraGroups = [ "networkmanager" "wheel" "audio" "libvert"];
    packages = with pkgs; [ armcord bottom brave chezmoi featherpad firefox git gimp hyprpicker inkscape libreoffice-still lolcat lxappearance lynx mpv neofetch pcmanfm signal-desktop sublime swaylock timeshift ungoogled-chromium virt-manager vlc vscode-extensions.arcticicestudio.nord-visual-studio-code wget wlsunset];
  };
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.steam = {
    isNormalUser = true;
    description = "gayming";
    extraGroups = [ "networkmanager" "wheel" "audio" ];
    packages = with pkgs; [ steam steam-run git libreoffice-still mpv neofetch pcmanfm sublime ungoogled-chromium wget steam];
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
  GTK_THEME = "Nordic"; # Replace with the correct GTK theme name
  XDG_ICON_THEME = "Papirus-Nord"; # Replace with the correct icon theme name
};


  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

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

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
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
