
{ config, pkgs, ... }:

{

security = {
  apparmor.enable = true;
  chromiumSuidSandbox.enable = true;
  auditd.enable = true;
  rtkit.enable = true;
  polkit = {
   enable = true;
  };
  protectKernelImage = true;
  lockKernelModules = true;
  allowUserNamespaces = true;
  forcePageTableIsolation = true;
  sudo.enable = false;
  doas.enable = true;
  doas.extraRules = [{
    users = [ "alice" ];
    keepEnv = true;
    persist = true;  
  }];
};


environment = {
memoryAllocator.provider = "scudo";
variables.SCUDO_OPTIONS = "ZeroContents=1";
};
  # This is required by podman to run containers in rootless mode.
#  security.unprivilegedUsernsClone = mkDefault config.virtualisation.containers.enable;

#  security.virtualisation.flushL1DataCache = mkDefault "always";


  networking.firewall = {
    enable = true; # Enable the firewall
    allowPing = true; # Allow ICMP ping requests (useful for diagnostics)
    allowedUDPPorts = [ 53 ]; # Allow DNS queries
    # For HTTP and HTTPS web traffic
    allowedTCPPorts = [ 80 443 ];
    };

systemd.coredump.enable = false;

services = {
  clamav.daemon.enable = true;
  clamav.updater.enable = true;
  opensnitch.enable = true;
    syslogd.enable = true;
    syslogd.extraConfig = ''
      *.*  -/var/log/syslog
    '';
  journald.forwardToSyslog = true;
  openssh.enable = true;
  dbus.apparmor = "enabled";
};

virtualisation.libvirtd.enable = true;
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


  environment.shellInit = ''
    umask 0077
  '';

}
