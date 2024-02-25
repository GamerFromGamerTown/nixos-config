# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
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
#	<home-manager/nixos>	

#    "${builtins.getEnv "HOME"}/.nix-defexpr/channels/home-manager/nixos"

    ];
  nix.settings.experimental-features = ["nix-command" "flakes"];
  # Bootloader.
 nixpkgs.config.allowUnfree = true;
###
### HEJ !!!!!!!!!!!!!!!! ENABLE "Curve25519" in tor, openssl, etc (for a refresher, it's AES but better and more secure)
###
  networking.hostName = "nixy_wixy"; # Define your hostname.
  networking.wireguard.enable = true;
  systemd.services.NetworkManager-wait-online.enable = true;
  hardware.bluetooth.enable = true; # enables support for Bluetooth
  services.blueman.enable = true;
  services.fstrim.enable = true;
 # programs.home-manager.enable = true;
 # users.users.alice.home-manager.enable = true;
 # users.users.alice.home-manager.homeDirectory = "/home/alice";


  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  security.rtkit.enable = true;



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


services.undervolt.enable = false;
services.undervolt.coreOffset = -50; #-80
services.undervolt.gpuOffset = -30; #-50

# swapDevices = [ {
#    device = "/dev/sda3";
#    randomEncryption.enable = true; 
#  } ];

programs.hyprland = {
enable = true;
xwayland.enable = true; 
};
 ###
services.xserver.desktopManager.plasma5.enable = true; # so teachers don't think i'm hacking the mainframe or smth

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
  security.auditd.enable = true;
  services.syslogd.enable = true;
  services.syslogd.extraConfig = ''
    *.*  -/var/log/syslog
  '';
  services.journald.forwardToSyslog = true;
virtualisation.libvirtd.enable = true;
services.openssh.enable = false;
# add bubblewrap for firefox&tor, brave, mpv, signal, then libreoffice (if you have time) and follow suit with apparmor
#security end B(

services.gnome.gnome-settings-daemon.enable = true;
environment.systemPackages = [
pkgs.auto-cpufreq pkgs.bc pkgs.binutils pkgs.bison pkgs.brightnessctl pkgs.bubblewrap pkgs.catppuccin pkgs.catppuccin-cursors pkgs.catppuccin-gtk pkgs.catppuccin-kde pkgs.catppuccin-papirus-folders pkgs.clamav pkgs.cmake pkgs.flex pkgs.gcc pkgs.git pkgs.gnumake pkgs.gsettings-desktop-schemas pkgs.home-manager pkgs.htop pkgs.hyprpaper pkgs.inconsolata pkgs.plasma-desktop pkgs.libglvnd pkgs.libnotify pkgs.libressl pkgs.logrotate pkgs.nordic pkgs.mesa pkgs.mesa.drivers pkgs.macchanger pkgs.opensnitch pkgs.opensnitch-ui pkgs.pavucontrol pkgs.pipewire pkgs.pkg-config pkgs.python3 pkgs.qemu pkgs.rsync pkgs.sddm pkgs.swaylock pkgs.undervolt pkgs.unzip pkgs.virt-manager pkgs.waybar pkgs.wget pkgs.wofi pkgs.zsh
];

nixpkgs.config.gtk = {
  enable = true;
  theme = "Nordic";
  iconTheme = "Nordic";
};

xdg.portal.enable = true;
xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.alice = {
    isNormalUser = true;
    description = "alice";
    extraGroups = [ "networkmanager" "wheel" "audio" "libvirtd"];
    shell = pkgs.zsh;
    packages = with pkgs; [ armcord bleachbit bottom bluez bluez-tools brave fastfetch featherpad firefox foot git gimp home-manager hyprpicker intelmetool krita libreoffice-still lynx mullvad mullvad-vpn mpv networkmanagerapplet neovim oh-my-zsh pcmanfm signal-desktop sl swaylock timeshift tor tor-browser vscodium virt-manager];
  };

services.mullvad-vpn.enable = true;
networking.iproute2.enable = true;

  sound.enable = true;
  hardware.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # lowLatency.enable = true;
};


#home-manager.users.alice = { pkgs, ... }: {
#  home.packages = [  ];
#  home.stateVersion = "23.11";    
#};

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.steam = {
    isNormalUser = true;
    description = "gayming";
    extraGroups = [ "networkmanager" "wheel" "audio" ];
    packages = with pkgs; [ brave steam steam-run libreoffice-still mpv fastfetch pcmanfm wget];
  };


users.users.school = {
isNormalUser = true;
description = "skool";
    extraGroups = [ "networkmanager" "audio" ];
    packages = with pkgs; [ brave krita libreoffice-still mpv fastfetch pcmanfm wget ];

};


fonts.packages = with pkgs; [
  noto-fonts
  nerdfonts
  noto-fonts-cjk
  liberation_ttf
  fira-code
  fira-code-symbols
  mplus-outline-fonts.githubRelease
  dina-font
  proggyfonts
];

hardware.opengl = {
  enable = true;
  setLdLibraryPath = true;
  extraPackages = with pkgs; [
    mesa
    # Add any other specific packages you need
  ];
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
  # Enable the firewall ###FIREWALL
    networking.firewall = {
    enable = true; # Enable the firewall
    allowPing = true; # Allow ICMP ping requests (useful for diagnostics)
    allowedUDPPorts = [ 53 ]; # Allow DNS queries
    # For HTTP and HTTPS web traffic
    allowedTCPPorts = [ 80 443 ];
  };
  # Specify any other rules or settings here as needed
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

}
