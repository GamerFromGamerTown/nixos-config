{ config, pkgs, ... }:

{
  # ... other configurations ...

# todo, auditd.service, autovt@tty1.service, libvirtd.service, logrotate.service (or just replace it with a
# chron job), nix-daemon.service, opensnitchd, and wpa_supplicant.service




 systemd.services.systemd-rfkill = {
    serviceConfig = {
#      # Hardening options
       ProtectSystem = "strict";
       ProtectHome = true;
       ProtectKernelTunables = true;
       ProtectKernelModules = true;
      ProtectControlGroups = true;
     # ProtectHostname = true;
       ProtectClock = true;
       ProtectProc = "invisible"; 
       ProcSubset = "pid"; 
       PrivateTmp = true;
       MemoryDenyWriteExecute = true; #
       NoNewPrivileges = true;
       LockPersonality = true; #
       RestrictRealtime = true; #
#      RestrictSUIDSGID = true;
#      RestrictAddressFamilies = "AF_INET";
#      RestrictNamespaces = true;
       SystemCallFilter = [ "write" "read" "openat" "close" "brk" "fstat" "lseek" "mmap" "mprotect" "munmap" "rt_sigaction" "rt_sigprocmask" "ioctl" "nanosleep" "select" "access" "execve" "getuid" "arch_prctl" "set_tid_address" "set_robust_list" "prlimit64" "pread64" "getrandom" ];
       SystemCallArchitectures = "native";
       UMask = "0077";
       IPAddressDeny = "any";
    };
  };

systemd.services.syslog = {
serviceConfig = {
  PrivateNetwork= true;
  CapabilityBoundingSet= ["CAP_DAC_READ_SEARCH" "CAP_SYSLOG" "CAP_NET_BIND_SERVICE"];
  NoNewPrivileges= true;
  PrivateDevices= true;
  ProtectClock= true;
  ProtectKernelLogs= true;
  ProtectKernelModules= true;
  PrivateMounts= true;
  SystemCallArchitectures= "native";
  MemoryDenyWriteExecute= true;
  LockPersonality= true;
  ProtectKernelTunables= true;
  RestrictRealtime= true;
  PrivateUsers= true;
  PrivateTmp= true;
  UMask= "0077";
  #SystemCallFilter= ["@cpu-emulation" "~@clock" "~@debug" "~@file-system" "@module" "@mount" "~@network-io" "@obsolete" "@raw-io" "@reboot" "~@resources" "@swap"]; # removing: @clock :wasn't @debug, @resources
#  SystemCallFilter= ["@cpu-emulation" "@debug" "~@file-system" "@module" "@obsolete" "@raw-io" "@reboot" "@swap"]; # removing: @clock :wasn't @debug, @resources
  RestrictNamespace = true;
  ProtectProc= "invisible";
  ProtectHome= true;
  DeviceAllow= false;
  ProtectSystem = "full";
  };
};


#systemd.services.bluetooth = {
#  serviceConfig = {
  #RestrictRealtime= true;
#  NoNewPrivileges= true;
#  AmbientCapabilities= false;
#  PrivateDevices= false;
  #ProtectClock = true;
#  ProtectKernelLogs = true;
#  ProtectKernelModules = true;
#  SystemCallArchitectures = "native";
  #RestrictSUIDSGID= true;
  #ProtectHostname= true;
#  LockPersonality= true;
  #RestrictAddressFamilies= [ "AF_PACKET"]; #and this
#  DeviceAllow= false;
  #ProtectProc= false;
#  ProcSubset= true;
#  PrivateUsers= true;
#  SystemCallFilter= ["~@cpu-emulation" "~@debug" "~@module" "~@mount" "~@obsolete" "~@raw-io" "~@reboot" "~@resources" "~@swap" ];
  #IPAddressDeny= true;
  #UMask = "0077";  
#  };
#};

systemd.services.systemd-journald = {
  serviceConfig = {
  UMask = 0077;
  PrivateNetwork= true;
  ProtectHostname= true;
  ProtectKernelModules= true;

  };
};


  systemd.services.auto-cpufreq = {
    serviceConfig = {
      # Restrict capabilities of the service
      CapabilityBoundingSet = "";
      # Reduce filesystem access
      ProtectSystem = "full";
      ProtectHome = true;
      # No need for network, so isolate it
      PrivateNetwork = true;
      IPAddressDeny = "any";
      # Additional hardening measures
      NoNewPrivileges = true;
      ProtectKernelTunables = true;
      ProtectKernelModules = true;
      ProtectControlGroups = true;
      ProtectHostname = false;
      MemoryDenyWriteExecute = true;     
      ProtectClock = true;
      RestrictNamespaces = true ;
      # Restrict temporary file creation
      PrivateTmp = true;
      PrivateUsers = true;
      ProtectProc= true;
      # Make various paths read-only or inaccessible
      ReadOnlyPaths = [ "/" ];
      InaccessiblePaths = [ "/home" "/root" "/proc" ];
      # Restrict the execution of certain system calls
      SystemCallFilter = [ "@system-service" ];
      SystemCallArchitectures = "native";
      # Set the default permissions for newly created files
      UMask = "0077";
    };
  };

systemd.services.NetworkManager-dispatcher = {
  serviceConfig = {
    # Hardening options
    # ProtectSystem = "strict";
    ProtectHome = true;
    ProtectKernelTunables = true;
    ProtectKernelModules = true;
    ProtectControlGroups = true;
    ProtectKernelLogs = true;
    ProtectHostname = true;
    ProtectClock = true;
    ProtectProc = "invisible";
    ProcSubset = "pid";
  # PrivateTmp = true;
    PrivateUsers = true;
    PrivateDevices = true;
  # PrivateIPC = true;
    MemoryDenyWriteExecute = true;
    NoNewPrivileges = true;
    LockPersonality = true;
    RestrictRealtime = true;
    RestrictSUIDSGID = true;
    RestrictAddressFamilies = "AF_INET";
    RestrictNamespaces = true;
    SystemCallFilter = [ "write" "read" "openat" "close" "brk" "fstat" "lseek" "mmap" "mprotect" "munmap" "rt_sigaction" "rt_sigprocmask" "ioctl" "nanosleep" "select" "access" "execve" "getuid" "arch_prctl" "set_tid_address" "set_robust_list" "prlimit64" "pread64" "getrandom" ];
    SystemCallArchitectures = "native";
    UMask = "0077";
    IPAddressDeny = "any";
  };
};

# systemd.services.display-manager = {
#   serviceConfig = {
#   ProtectSystem = "strict";
#   ProtectHome = true;
#   ProtectKernelTunables = true;
#   ProtectKernelModules = true; 
#   #ProtectControlGroups = true; # let's make our login manager use wayland
#   ProtectKernelLogs = true; # so we won't need all of this
#   #ProtectHostname = true;
#   #ProtectClock = true;
#   PrivateTmp = true;
#   #PrivateIPC = true;
#   MemoryDenyWriteExecute = true;
#   NoNewPrivileges = true; # what i also disabled
#   #LockPersonality = true;
#   #RestrictRealtime = true;
#   #RestrictSUIDSGID = true;
#   RestrictAddressFamilies = "AF_INET";
#   RestrictNamespaces = true; 
#   SystemCallFilter = [ "write" "read" "openat" "close" "brk" "fstat" "lseek" "mmap" "mprotect" "munmap" "rt_sigaction" "rt_sigprocmask" "ioctl" "nanosleep" "select" "access" "execve" "getuid" "arch_prctl" "set_tid_address" "set_robust_list" "prlimit64" "pread64" "getrandom" ];
#   SystemCallArchitectures = "native";
#   UMask = "0077";
#   IPAddressDeny = "any";
#   };
# };

systemd.services.emergency = {
  serviceConfig = {
    ProtectSystem = "strict";
    ProtectHome = true;
    ProtectKernelTunables = true;
    ProtectKernelModules = true;
    ProtectControlGroups = true;
    ProtectKernelLogs = true;
  # ProtectHostname = true;
    ProtectClock = true;
    ProtectProc = "invisible";
    ProcSubset = "pid";
    PrivateTmp = true;
    PrivateUsers = true;
    PrivateDevices = true;  # Might need adjustment for emergency access
    PrivateIPC = true;
    MemoryDenyWriteExecute = true;
    NoNewPrivileges = true;
    LockPersonality = true;
    RestrictRealtime = true;
    RestrictSUIDSGID = true;
    RestrictAddressFamilies = "AF_INET";
    RestrictNamespaces = true;
    SystemCallFilter = [ "write" "read" "openat" "close" "brk" "fstat" "lseek" "mmap" "mprotect" "munmap" "rt_sigaction" "rt_sigprocmask" "ioctl" "nanosleep" "select" "access" "execve" "getuid" "arch_prctl" "set_tid_address" "set_robust_list" "prlimit64" "pread64" "getrandom" ];
    UMask = "0077";
    IPAddressDeny = "any";
  };
};


#systemd.services."autovt@tty1" = {
 # serviceConfig = {
 #   ProtectSystem = "strict";
 #   ProtectHome = true;
 #   ProtectKernelTunables = true;
 #   ProtectKernelModules = true;
 #   ProtectControlGroups = true;
 #   ProtectKernelLogs = true;
 #   ProtectHostname = true;
 #   ProtectClock = true;
 #   ProtectProc = "invisible";
 #   ProcSubset = "pid";
 #   PrivateTmp = true;
 #   PrivateUsers = true;
#   PrivateDevices = true;
#   PrivateIPC = true;
 #   MemoryDenyWriteExecute = true;
 #   NoNewPrivileges = true;
 #   LockPersonality = true;
 #   RestrictRealtime = true;
 #   RestrictSUIDSGID = true;
 #   RestrictAddressFamilies = "AF_INET";
 #   RestrictNamespaces = true;
#   SystemCallFilter = [ "write" "read" "openat" "close" "brk" "fstat" "lseek" "mmap" "mprotect" "munmap" "rt_sigaction" "rt_sigprocmask" "ioctl" "nanosleep" "select" "access" "execve" "getuid" "arch_prctl" "set_tid_address" "set_robust_list" "prlimit64" "pread64" "getrandom" ];
 #   SystemCallArchitectures = "native";
 #   UMask = "0077";
 #   IPAddressDeny = "any";
 # };
#};

systemd.services."getty@tty1" = {
  serviceConfig = {
    ProtectSystem = "strict";
    ProtectHome = true;
    ProtectKernelTunables = true;
    ProtectKernelModules = true;
    ProtectControlGroups = true;
    ProtectKernelLogs = true;
 #  ProtectHostname = true;
    ProtectClock = true;
    ProtectProc = "invisible";
    ProcSubset = "pid";
    PrivateTmp = true;
    PrivateUsers = true;
    PrivateDevices = true;
    PrivateIPC = true;
    MemoryDenyWriteExecute = true;
    NoNewPrivileges = true;
    LockPersonality = true;
    RestrictRealtime = true;
    RestrictSUIDSGID = true;
    RestrictAddressFamilies = "AF_INET";
    RestrictNamespaces = true;
    SystemCallFilter = [ "write" "read" "openat" "close" "brk" "fstat" "lseek" "mmap" "mprotect" "munmap" "rt_sigaction" "rt_sigprocmask" "ioctl" "nanosleep" "select" "access" "execve" "getuid" "arch_prctl" "set_tid_address" "set_robust_list" "prlimit64" "pread64" "getrandom" ];
    SystemCallArchitectures = "native";
    UMask = "0077";
    IPAddressDeny = "any";
  };
};

systemd.services."getty@tty7" = {
  serviceConfig = {
    ProtectSystem = "strict";
    ProtectHome = true;
    ProtectKernelTunables = true;
    ProtectKernelModules = true;
    ProtectControlGroups = true;
    ProtectKernelLogs = true;
 #  ProtectHostname = true;
    ProtectClock = true;
    ProtectProc = "invisible";
    ProcSubset = "pid";
    PrivateTmp = true;
    PrivateUsers = true;
    PrivateDevices = true;
    PrivateIPC = true;
    MemoryDenyWriteExecute = true;
    NoNewPrivileges = true;
    LockPersonality = true;
    RestrictRealtime = true;
    RestrictSUIDSGID = true;
    RestrictAddressFamilies = "AF_INET";
    RestrictNamespaces = true;
    SystemCallFilter = [ "write" "read" "openat" "close" "brk" "fstat" "lseek" "mmap" "mprotect" "munmap" "rt_sigaction" "rt_sigprocmask" "ioctl" "nanosleep" "select" "access" "execve" "getuid" "arch_prctl" "set_tid_address" "set_robust_list" "prlimit64" "pread64" "getrandom" ];
    SystemCallArchitectures = "native";
    UMask = "0077";
    IPAddressDeny = "any";
  };
};

systemd.services.NetworkManager = {
  serviceConfig = {
  NoNewPrivileges = true;
  ProtectClock = true;
  ProtectKernelLogs = true;
  ProtectControlGroups = true;
  ProtectKernelModules = true; 
  SystemCallArchitectures = "native";
  MemoryDenyWriteExecute= true;
  ProtectProc = "invisible";
  ProcSubset = "pid";  
# CapabilityBoundingSet = "";
  RestrictNamespaces = true;
# lockPersonality = true;
  ProtectKernelTunables= true;
  ProtectHome = true;
  PrivateTmp = true;
  # SystemCallFilter = [ "write" "read" "openat" "close" "brk" "fstat" "lseek" "mmap" "mprotect" "munmap" "rt_sigaction" "rt_sigprocmask" "ioctl" "nanosleep" "select" "access" "execve" "getuid" "arch_prctl" "set_tid_address" "set_robust_list" "prlimit64" "pread64" "getrandom" ];
  UMask = "0077";
##########
  };
};

  #systemd.services.wpa_supplicant = {
    #serviceConfig = {
      # Basic Service Configuration
      #UMask = "0077";
     #PrivateTmp = true;
     #ProtectHome = true;
     #ProtectProc = "invisible";
     #ProcSubset = "pid";
     #PrivateMounts = true;
      #MemoryDenyWriteExecute = true;
      #ProtectHostname = false;
     #LockPersonality = true;
      #ProtectKernelTunables = true;
      #ProtectControlGroups = true;
      #ProtectKernelModules = true;
      #RestrictSUIDSGID = true;
      #NoNewPrivileges = true;
     #KeyringMode = "private";
     #Delegate = "no";
     #NotifyAccess = "none";

      # Capability and System Call Restrictions
     #CapabilityBoundingSet = "~CAP_NET_BIND_SERVICE ~CAP_NET_BROADCAST ~CAP_AUDIT_* ~CAP_SYS_RAWIO ~CAP_SYS_PTRACE ~CAP_SYS_(NICE|RESOURCE) ~CAP_SYS_TIME ~CAP_SYS_PACCT ~CAP_KILL ~CAP_WAKE_ALARM ~CAP_(DAC_*|FOWNER|IPC_OWNER) ~CAP_BPF ~CAP_LINUX_IMMUTABLE ~CAP_IPC_LOCK ~CAP_SYS_TTY_CONFIG ~CAP_SYS_BOOT ~CAP_SYS_CHROOT ~CAP_BLOCK_SUSPEND ~CAP_LEASE ~CAP_MKNOD ~CAP_(CHOWN|FSETID|SETFCAP) ~CAP_SET(UID|GID|PCAP) ~CAP_MAC_* ~CAP_SYS_MODULE ~CAP_SYS_ADMIN ~CAP_SYSLOG";
     #SystemCallFilter = "~@clock ~@cpu-emulation ~@debug ~@module ~@mount ~@obsolete ~@privileged ~@raw-io ~@reboot ~@resources ~@swap";
     #SystemCallArchitectures = "native"; # Adjust as necessary

      # Network and Device Restrictions
     #PrivateNetwork = false; # WPA Supplicant requires network access
     #PrivateUsers = false;   # WPA Supplicant needs to interact with user information
     #RestrictAddressFamilies = "~AF_PACKET ~AF_NETLINK ~AF_UNIX ~AF_(INET|INET6)"; # Adjust based on requirements

      # Additional Restrictions
     #RestrictNamespaces = "~cgroup ~ipc ~user ~pid ~net ~uts ~mnt";
    #};
  #};



#  systemd.services."nixos-rebuild-switch-to-configuration" = {
#    serviceConfig = {
#   ProtectSystem = "strict";
#    ProtectHome = false;
#   ProtectKernelTunables = true;  # Prevent changes to kernel runtime parameters
#   ProtectKernelModules = true;  # Prevent loading/unloading of kernel modules
#   ProtectControlGroups = true;
#   ProtectKernelLogs = true;
#    ProtectHostname = false;
#   ProtectClock = true;
#   ProtectProc = "invisible";
#   ProcSubset = "pid";
#   PrivateTmp = true;
#   PrivateUsers = true;  # Isolates the service from user namespaces
#   PrivateDevices = true;  # Deny access to raw device nodes
#    PrivateIPC = true;  # Enable private IPC namespace
#   MemoryDenyWriteExecute = true;  # Deny the creation of writable and executable memory mappings
#    NoNewPrivileges = true;  # Prevent gaining new privileges
#   LockPersonality = true;  # Locks the process's personality to prevent changes
#   RestrictRealtime = true;  # Prevent enabling realtime scheduling
#   RestrictSUIDSGID = true;  # Restrict setuid/setgid binaries
#   RestrictAddressFamilies = "";  # Restrict address families used by the service
#   RestrictNamespaces = true;  # Restrict access to other namespaces
#   SystemCallFilter = [ "@system-service" ];  # Allow only system calls needed for managing system services
#   SystemCallArchitectures = "native";
#   UMask = "0077";
#   IPAddressDeny = "any";  # Deny all IP traffic
#   };
#  };

systemd.services."dbus" = {
    serviceConfig = {
      # Restrict the service to its own private /tmp and /var/tmp directories
      ##PrivateTmp = true;
      # Give the service its own private network namespace
      ##PrivateNetwork = true;
      # Set up a read-only file system, with specific exceptions
      #ProtectSystem = "full";
      # Make the home directories inaccessible to the service
      ProtectHome = true;
      # Restrict the set of system calls the service can use
      ##SystemCallFilter = "~@clock @cpu-emulation @module @mount @obsolete @raw-io @swap";
      # Drop unnecessary capabilities
      ##ProtectKernelTunables = true;
      # Disable the creation of new privileges
      ##NoNewPrivileges = true;
      #CapabilityBoundingSet=["~CAP_SYS_TIME" "~CAP_SYS_PACCT" "~CAP_KILL" "~CAP_WAKE_ALARM" "~CAP_SYS_BOOT" "~CAP_SYS_CHROOT" "~CAP_LEASE" "~CAP_MKNOD" "~CAP_NET_ADMIN" "~CAP_SYS_ADMIN" "~CAP_SYSLOG" "~CAP_NET_BIND_SERVICE" "~CAP_NET_BROADCAST" "~CAP_AUDIT_WRITE" "~CAP_AUDIT_CONTROL" "~CAP_SYS_RAWIO" "~CAP_SYS_NICE" "~CAP_SYS_RESOURCE" "~CAP_SYS_TTY_CONFIG" "~CAP_SYS_MODULE" "~CAP_IPC_LOCK" "~CAP_LINUX_IMMUTABLE" "~CAP_BLOCK_SUSPEND" "~CAP_MAC_*" "~CAP_DAC_*" "~CAP_FOWNER" "~CAP_IPC_OWNER" "~CAP_SYS_PTRACE" "~CAP_SETUID" "~CAP_SETGID" "~CAP_SETPCAP" "~CAP_FSETID" "~CAP_SETFCAP" "~CAP_CHOWN"];
      ##ProtectKernelModules= true;
      ##ProtectKernelLogs= true;
      ##ProtectClock= true;
      ##ProtectControlGroups= true;
      ##RestrictNamespaces= true;
      ##MemoryDenyWriteExecute= true;
      #RestrictAddressFamilies= ["~AF_PACKET" "~AF_NETLINK"];
      #ProtectHostname= true;
      ##LockPersonality= true;
      #RestrictRealtime= true;
      ##PrivateUsers= true;
    };
  };

#systemd.services.nix-daemon = {
#  serviceConfig = {
  # ProtectSystem = "strict";
#    ProtectHome = false;
#   ProtectKernelTunables = true;
#   ProtectKernelModules = true;
#  ProtectControlGroups = true;
#  ProtectKernelLogs = true;
#    ProtectHostname = false;
#    ProtectClock = true;
#    ProtectProc = "invisible";
#    ProcSubset = "pid";
#    PrivateTmp = false;
#    PrivateUsers = false;
#    PrivateDevices = false;
#    PrivateIPC = true;
#    MemoryDenyWriteExecute = true;
#   NoNewPrivileges = true;
#   LockPersonality = true;
#    RestrictRealtime = true;
#  RestrictSUIDSGID = true;
 #  RestrictAddressFamilies = "AF_INET AF_INET6";  # Adjust as necessary for network operations
 #  RestrictNamespaces = true;
    # SystemCallFilter = [ "write" "read" "openat" "close" "brk" "fstat" "lseek" "mmap" "mprotect" "munmap" "rt_sigaction" "rt_sigprocmask" "ioctl" "nanosleep" "select" "access" "execve" "getuid" "arch_prctl" "set_tid_address" "set_robust_list" "prlimit64" "pread64" "getrandom" ];
#   SystemCallArchitectures = "native";
#   UMask = "0077";
#  };
#};

systemd.services.reload-systemd-vconsole-setup = {
  serviceConfig = {
    ProtectSystem = "strict";
    ProtectHome = true;
    ProtectKernelTunables = true;
    ProtectKernelModules = true;
    ProtectControlGroups = true;
    ProtectKernelLogs = true;
  # ProtectHostname = true;
    ProtectClock = true;
   #ProtectProc = "invisible";
   #ProcSubset = "pid";
   #PrivateTmp = true;
    PrivateUsers = true;
    PrivateDevices = true;
   #PrivateIPC = true;
    MemoryDenyWriteExecute = true;
    NoNewPrivileges = true;
    LockPersonality = true;
    RestrictRealtime = true;
   #RestrictSUIDSGID = true;
   #RestrictAddressFamilies = "AF_INET AF_INET6";
    RestrictNamespaces = true;
#   SystemCallFilter = [ "write" "read" "openat" "close" "brk" "fstat" "lseek" "mmap" "mprotect" "munmap" "rt_sigaction" "rt_sigprocmask" "ioctl" "nanosleep" "select" "access" "execve" "getuid" "arch_prctl" "set_tid_address" "set_robust_list" "prlimit64" "pread64" "getrandom" ];
#   SystemCallArchitectures = "native";
    UMask = "0077";
    IPAddressDeny = "any";
  };
};

systemd.services.rescue = {
  serviceConfig = {
    ProtectSystem = "strict";
    ProtectHome = true;
    ProtectKernelTunables = true;
    ProtectKernelModules = true;
    ProtectControlGroups = true;
    ProtectKernelLogs = true;
 #  ProtectHostname = true;
    ProtectClock = true;
    ProtectProc = "invisible";
    ProcSubset = "pid";
    PrivateTmp = true;
    PrivateUsers = true;
    PrivateDevices = true;  # Might need adjustment for rescue operations
    PrivateIPC = true;
    MemoryDenyWriteExecute = true;
    NoNewPrivileges = true;
    LockPersonality = true;
    RestrictRealtime = true;
    RestrictSUIDSGID = true;
    RestrictAddressFamilies = "AF_INET AF_INET6";  # Networking might be necessary in rescue mode
    RestrictNamespaces = true;
    SystemCallFilter = [ "write" "read" "openat" "close" "brk" "fstat" "lseek" "mmap" "mprotect" "munmap" "rt_sigaction" "rt_sigprocmask" "ioctl" "nanosleep" "select" "access" "execve" "getuid" "arch_prctl" "set_tid_address" "set_robust_list" "prlimit64" "pread64" "getrandom" ];
    SystemCallArchitectures = "native";
    UMask = "0077";
    IPAddressDeny = "any";  # May need to be relaxed for network troubleshooting in rescue mode
  };
};

systemd.services."systemd-ask-password-console" = {
  serviceConfig = {
    ProtectSystem = "strict";
    ProtectHome = true;
    ProtectKernelTunables = true;
    ProtectKernelModules = true;
    ProtectControlGroups = true;
    ProtectKernelLogs = true;
  # ProtectHostname = true;
    ProtectClock = true;
    ProtectProc = "invisible";
    ProcSubset = "pid";
    PrivateTmp = true;
    PrivateUsers = true;
    PrivateDevices = true;  # May need adjustment for console access
    PrivateIPC = true;
    MemoryDenyWriteExecute = true;
    NoNewPrivileges = true;
    LockPersonality = true;
    RestrictRealtime = true;
    RestrictSUIDSGID = true;
    RestrictAddressFamilies = "AF_INET AF_INET6";
    RestrictNamespaces = true;
    SystemCallFilter = [ "@system-service" ];  # A more permissive filter
    SystemCallArchitectures = "native";
    UMask = "0077";
    IPAddressDeny = "any";
  };
};


systemd.services."systemd-ask-password-wall" = {
  serviceConfig = {
    ProtectSystem = "strict";
    ProtectHome = true;
    ProtectKernelTunables = true;
    ProtectKernelModules = true;
    ProtectControlGroups = true;
    ProtectKernelLogs = true;
  # ProtectHostname = true;
    ProtectClock = true;
    ProtectProc = "invisible";
    ProcSubset = "pid";
    PrivateTmp = true;
    PrivateUsers = true;
    PrivateDevices = true;
    PrivateIPC = true;
    MemoryDenyWriteExecute = true;
    NoNewPrivileges = true;
    LockPersonality = true;
    RestrictRealtime = true;
    RestrictSUIDSGID = true;
    RestrictAddressFamilies = "AF_INET AF_INET6";
    RestrictNamespaces = true;
    SystemCallFilter = [ "@system-service" ];  # A more permissive filter
    SystemCallArchitectures = "native";
    UMask = "0077";
    IPAddressDeny = "any";
  };
};

systemd.services.thermald = {
  serviceConfig = {
    ProtectSystem = "strict";
    ProtectHome = true;
    ProtectKernelTunables = true;  # Necessary for adjusting cooling policies
    ProtectKernelModules = true;  # May need adjustment for module control
    ProtectControlGroups = true;
    ProtectKernelLogs = true;
  # ProtectHostname = true;
    ProtectClock = true;
    ProtectProc = "invisible";
    ProcSubset = "pid";
    PrivateTmp = true;
    PrivateUsers = true;
    PrivateDevices = true;  # May require access to specific hardware devices
    PrivateIPC = true;
    MemoryDenyWriteExecute = true;
    NoNewPrivileges = true;
    LockPersonality = true;
    RestrictRealtime = true;
    RestrictSUIDSGID = true;
    CapabilityBoundingSet = "";    
    RestrictNamespaces = true;
    SystemCallFilter = [ "@system-service" ];
    SystemCallArchitectures = "native";
    UMask = "0077";
    IPAddressDeny = "any";
    DeviceAllow= [];
    RestrictAddressFamilies = [ ]; 
 };
};

systemd.services."user@1000" = {
  serviceConfig = {
#   ProtectSystem = "strict";
#   ProtectHome = true;
    ProtectKernelTunables = true;
    ProtectKernelModules = true;
    ProtectControlGroups = true;
    ProtectKernelLogs = true;
 #  ProtectHostname = true;
    ProtectClock = true;
    ProtectProc = "invisible";
    ProcSubset = "pid";
    PrivateTmp = true;
    PrivateUsers = true;  # Be cautious, as this may restrict user operations
    PrivateDevices = true;
    PrivateIPC = true;
    MemoryDenyWriteExecute = true;
    NoNewPrivileges = true;
    LockPersonality = true;
    RestrictRealtime = true;
    RestrictSUIDSGID = true;
    RestrictAddressFamilies = "AF_INET AF_INET6";
    RestrictNamespaces = true;
    SystemCallFilter = [ "@system-service" ];  # Adjust based on user needs
    SystemCallArchitectures = "native";
    UMask = "0077";
    IPAddressDeny = "any";
  };
};

systemd.services.virtlockd = {
  serviceConfig = {
    ProtectSystem = "strict";
    ProtectHome = true;
    ProtectKernelTunables = true;
    ProtectKernelModules = true;
    ProtectControlGroups = true;
    ProtectKernelLogs = true;
 #  ProtectHostname = true;
    ProtectClock = true;
    ProtectProc = "invisible";
    ProcSubset = "pid";
    PrivateTmp = true;
    PrivateUsers = true;
    PrivateDevices = true;  # May need adjustment for accessing VM resources
    PrivateIPC = true;
    MemoryDenyWriteExecute = true;
    NoNewPrivileges = true;
    LockPersonality = true;
    RestrictRealtime = true;
    RestrictSUIDSGID = true;
    RestrictAddressFamilies = "AF_INET AF_INET6";
    RestrictNamespaces = true;
    SystemCallFilter = [ "@system-service" ];  # Adjust as necessary
    SystemCallArchitectures = "native";
    UMask = "0077";
    IPAddressDeny = "any";  # May need adjustment for network operations
  };
};

systemd.services.virtlogd = {
  serviceConfig = {
    ProtectSystem = "strict";
    ProtectHome = true;
    ProtectKernelTunables = true;
    ProtectKernelModules = true;
    ProtectControlGroups = true;
    ProtectKernelLogs = true;
  # ProtectHostname = true;
    ProtectClock = true;
    ProtectProc = "invisible";
    ProcSubset = "pid";
    PrivateTmp = true;
    PrivateUsers = true;
    PrivateDevices = true;  # May need adjustment for accessing VM logs
    PrivateIPC = true;
    MemoryDenyWriteExecute = true;
    NoNewPrivileges = true;
    LockPersonality = true;
    RestrictRealtime = true;
    RestrictSUIDSGID = true;
    RestrictAddressFamilies = "AF_INET AF_INET6";
    RestrictNamespaces = true;
    SystemCallFilter = [ "@system-service" ];  # Adjust based on log management needs
    SystemCallArchitectures = "native";
    UMask = "0077";
    IPAddressDeny = "any";  # May need to be relaxed for network-based log collection
  };
};

systemd.services.virtlxcd = {
  serviceConfig = {
    ProtectSystem = "strict";
    ProtectHome = true;
    ProtectKernelTunables = true;  # Necessary for container management
    ProtectKernelModules = true;
    ProtectControlGroups = true;
    ProtectKernelLogs = true;
 #  ProtectHostname = true;  # Adjust if container hostname management is required
    ProtectClock = true;
    ProtectProc = "invisible";
    ProcSubset = "pid";
    PrivateTmp = true;
    PrivateUsers = true;  # Be cautious, might need adjustment for container user management
    PrivateDevices = true;  # Containers might require broader device access
    PrivateIPC = true;
    MemoryDenyWriteExecute = true;
    NoNewPrivileges = true;
    LockPersonality = true;
    RestrictRealtime = true;
    RestrictSUIDSGID = true;
    RestrictAddressFamilies = "AF_INET AF_INET6";  # Necessary for networked containers
    RestrictNamespaces = true;
    SystemCallFilter = [ "@system-service" ];  # Adjust based on container operations
    SystemCallArchitectures = "native";
    UMask = "0077";
    IPAddressDeny = "any";  # May need to be relaxed for network functionality
  };
};

systemd.services.libvirtd = {
  serviceConfig = {
    ProtectSystem = "strict";
    ProtectHome = true;
    ProtectKernelTunables = true;
    ProtectControlGroups = true;
    ProtectHostname = false;
    ProtectClock = true;
    ProtectProc = "invisible";
    ProcSubset = "pid";
    PrivateTmp = true;
    PrivateUsers = true;
    PrivateDevices = false;  # Libvirt needs access to device nodes for virtualization (keepsies)
    PrivateIPC = true;
    MemoryDenyWriteExecute = true;
    NoNewPrivileges = true;
    LockPersonality = true;
    RestrictRealtime = true;
    RestrictSUIDSGID = true;
    #RestrictAddressFamilies = "AF_INET";
    RestrictNamespaces = true;
    SystemCallFilter = [ "@system-service" ];  # Adjust based on container operations
    SystemCallArchitectures = "native";
    UMask = "0077";
    IPAddressDeny = "any";
  };
 };

#systemd.services.libvirtd = {
#  serviceConfig = {
#    ProtectSystem = "strict";
#    ProtectHome = true;
#    ProtectKernelTunables = true; 
#    ProtectControlGroups = true; 
#    ProtectHostname = false;
#    ##ProtectClock = true;
#    ProtectProc = "invisible";
#    ProcSubset = "pid";
#    PrivateTmp = true;
#    PrivateUsers = true;
#    PrivateDevices = false;  # Libvirt needs access to device nodes for virtualization (keepsies)
#    PrivateIPC = true;
#    MemoryDenyWriteExecute = true;
#    NoNewPrivileges = true;
#    LockPersonality = true;
#    RestrictRealtime = true;
#    RestrictSUIDSGID = true;
#    #RestrictAddressFamilies = "AF_INET";
#    RestrictNamespaces = true;
#    SystemCallFilter = [ "@system-service" ];  # Adjust based on container operations
#    ##SystemCallArchitectures = "native";
#    UMask = "0077";
#    IPAddressDeny = "any";
#  };
# };

systemd.services.virtqemud = {
  serviceConfig = {
    ProtectSystem = "strict";
    ProtectHome = true;
    ProtectKernelTunables = true;  # Necessary for VM management
    ProtectKernelModules = true;  # May need adjustment for VM hardware emulation
    ProtectControlGroups = true;
    ProtectKernelLogs = true;
  # ProtectHostname = true;  # Adjust if VM hostname management is required
    ProtectClock = true;
    ProtectProc = "invisible";
    ProcSubset = "pid";
    PrivateTmp = true;
    PrivateUsers = true;  # Be cautious, might need adjustment for VM user management
    PrivateDevices = true;  # VMs might require broader device access
    PrivateIPC = true;
    MemoryDenyWriteExecute = true;
    NoNewPrivileges = true;
    LockPersonality = true;
    RestrictRealtime = true;
    RestrictSUIDSGID = true;
    RestrictAddressFamilies = "AF_INET AF_INET6";  # Necessary for networked VMs
    RestrictNamespaces = true;
    SystemCallFilter = [ "@system-service" ];  # Adjust based on VM operations
    SystemCallArchitectures = "native";
    UMask = "0077";
    IPAddressDeny = "any";  # May need to be relaxed for network functionality
  };
};






systemd.services.virtvboxd = {
  serviceConfig = {
    ProtectSystem = "strict";
    ProtectHome = true;
    ProtectKernelTunables = true;  # Required for some VM management tasks
    ProtectKernelModules = true;  # May need adjustment for module handling
    ProtectControlGroups = true;
    ProtectKernelLogs = true;
 #  ProtectHostname = true;  # Adjust if hostname management is required
    ProtectClock = true;
    ProtectProc = "invisible";
    ProcSubset = "pid";
    PrivateTmp = true;
    PrivateUsers = true;  # Be cautious, might need adjustment for VM user management
    PrivateDevices = true;  # VMs may require access to certain devices
    PrivateIPC = true;
    MemoryDenyWriteExecute = true;
    NoNewPrivileges = true;
    LockPersonality = true;
    RestrictRealtime = true;
    RestrictSUIDSGID = true;
    RestrictAddressFamilies = "AF_INET AF_INET6";  # Necessary for networked VMs
    RestrictNamespaces = true;
    SystemCallFilter = [ "@system-service" ];  # Adjust based on VM operations
    SystemCallArchitectures = "native";
    UMask = "0077";
    IPAddressDeny = "any";  # May need to be relaxed for network functionality
  };
};

}
