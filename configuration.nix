# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
# ENABLE DEBUGFS AND THEN ENABLE POWERTOP
{ config, pkgs, lib, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
	./hardware-configuration.nix
      # Use custom bootloader settings.
	./bootloader-settings.nix 
      # General security improvements.
        ./security/security.nix
      # Hardening systemd services
# 	./security/systemd-hardening.nix 
      # Apparmor Profiles
#	./security/apparmor.nix
      # Enable the home manager. 
#	<home-manager/nixos>	
    ];


nix.settings = {
  experimental-features = ["nix-command" "flakes"];
  allowed-users = [ "@wheel" ]; # only let accounts that can use sudo use nix to avoid abuse 
};
 

#nixpkgs config
  nixpkgs.config.allowUnfree = false;
nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "steam"
    "steam-original"
    "steam-run"
  ];

# networking !

  networking = {
    hostName = "nixy_wixy";
    wireguard.enable = true;
    timeServers = [
      "pool.ntp.org"
      "0.nixos.pool.ntp.org"
      "1.nixos.pool.ntp.org"
      "2.nixos.pool.ntp.org"
      "3.nixos.pool.ntp.org"
   ];
  tcpcrypt.enable = true;
  stevenblack.enable = true;
  stevenblack.block = [ "fakenews" "gambling" ];
  enableIPv6 = false;
};
  
  systemd.services.NetworkManager-wait-online.enable = true;
  hardware.bluetooth.enable = true; #enables support for Bluetooth
  
  # optimisations
  services = {
    blueman.enable = true;
    fstrim.enable = true;
    tailscale.enable = true;
  };
  

  # Set your time zone.
time.timeZone = "US/Alaska";

programs.zsh = {
 enable = true;
  ohMyZsh = {
    enable = true;
    plugins = [ "git" ];
    theme = "kolo";
 
  };
};



  # Select internationalisation properties.
i18n = {
  defaultLocale = "en_US.UTF-8";

  extraLocaleSettings = {
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
};

# DM tomfoolery

services.xserver = {
  enable = true;  # Enable the X server
  desktopManager.gnome.enable = false;
  displayManager = {
    #lightdm.enable = true;  # Enable LightDM
    sddm = {
      enable = true;
      wayland.enable = false;
      theme = "chili";
    };
  };
};

# WM/DE tomfoolery

programs.hyprland = {
enable = true;
xwayland.enable = true; 
};
 ###
services.xserver.desktopManager.plasma5.enable = true; # so teachers don't think i'm hacking the mainframe or smth

# networking

networking = {
  networkmanager.enable = true;
  iproute2.enable = true;
  nameservers = [ "9.9.9.9#nine.nine.nine.nine" "1.0.0.1#one.one.one.one" ];
};

services = {
  mullvad-vpn.enable = true;
  resolved = {
    enable = true;
    dnssec = "true";
    domains = [ "~." ];
    fallbackDns = [ "9.9.9.9#one.one.one.one" "1.0.0.1#one.one.one.one" ];
    extraConfig = ''
      DNSOverTLS=yes
    '';
  
  };
};

# power management & cpu adjustments

services = {
  undervolt = {
    enable = true;
    coreOffset = -60; #formerly -80
    gpuOffset = -35; # formerly -50
  };
  auto-cpufreq.enable = true;
  thermald.enable = true;
};

hardware.cpu.intel.updateMicrocode = true;
#services.tlp = {
#      enable = true;
#      settings = {
#        CPU_SCALING_GOVERNOR_ON_AC = "performance";
#        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
#
#        CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
#        CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
#
#        CPU_MIN_PERF_ON_AC = 0;
#        CPU_MAX_PERF_ON_AC = 100;
#        CPU_MIN_PERF_ON_BAT = 0;
#        CPU_MAX_PERF_ON_BAT = 20;
#
#      };
#};

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

# system package management
environment.systemPackages = with pkgs; [
apparmor-profiles auto-cpufreq bc binutils bison brightnessctl btop bubblewrap busybox catppuccin catppuccin-cursors (catppuccin-gtk.override {
    accents = [ "pink" ]; # You can specify multiple accents here to output multiple themes
    size = "compact";
    tweaks = [ "rimless" "black" ]; # You can also specify multiple tweaks here
    variant = "macchiato";
  })  catppuccin-kde catppuccin-papirus-folders clamav cmake flex gcc git gnome.cheese gnome.file-roller gnumake gsettings-desktop-schemas home-manager htop hyprpaper inconsolata kitty plasma-desktop playonlinux libglvnd libnotify libressl logrotate lynis nordic mesa mesa.drivers macchanger opensnitch opensnitch-ui pavucontrol pipewire pkg-config polkit polkit_gnome python3 qemu rsync sddm sddm-chili-theme shattered-pixel-dungeon swaybg swaylock tcpcrypt tldr undervolt unzip wine wineWowPackages.full virt-manager waybar wget wofi zsh
];

# theming
nixpkgs.config.gtk = {
  enable = true;
  theme = "Nordic";
  iconTheme = "Nordic";
};

xdg.portal = {
   enable = true;
   extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
};
programs.dconf.enable = true;
# audio
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    pulse = {
      enable = true;
    };
    alsa = {
      enable = true;
      support32Bit = true;
  };
};


# users!
  # Define a user account. Don't forget to set a password with ‘passwd’.

  users = {
    users.tcpcryptd.group = "wheel";

    users.alice = {
    isNormalUser = true;
    description = "alice";
    extraGroups = [ "networkmanager" "wheel" "audio" "libvirtd"];
    shell = pkgs.zsh;
    packages = with pkgs; [ armcord bleachbit bottom bluez bluez-tools brave fastfetch featherpad firefox foot git gimp home-manager hyprpicker intelmetool inkscape krita libreoffice-still lynx mullvad mullvad-vpn mpv networkmanagerapplet neovim oh-my-zsh pcmanfm signal-desktop starship sl swaylock timeshift tor tor-browser vscodium virt-manager];
  };

    users.steam = {
    isNormalUser = true;
    description = "gayming";
    extraGroups = [ "networkmanager" "wheel" "audio" ];
    packages = with pkgs; [ brave driversi686Linux.mesa steam steam-run libreoffice-still mpv fastfetch pcmanfm wget];
  };

  users.school = {
    isNormalUser = true;
    description = "skool";
    extraGroups = [ "networkmanager" "audio" ];
    packages = with pkgs; [ brave krita libreoffice-still mpv fastfetch pcmanfm wget ];
  };

  };


#steam
programs.steam = {
  enable = true;
  remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
  dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
};


#fonts
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
# ensure compatability
hardware.opengl = {
  enable = true;
  setLdLibraryPath = true;
  extraPackages = with pkgs; [
    mesa
    # Add any other specific packages you need
  ];
};

services = {
  gnome.gnome-settings-daemon.enable = true;
  logrotate.checkConfig = false;
  tor.enable = true;
}; 

systemd = {
  user.services.polkit-gnome-authentication-agent-1 = {
    description = "polkit-gnome-authentication-agent-1";
    wantedBy = [ "graphical-session.target" ];
    wants = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
  };
};


  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

}
