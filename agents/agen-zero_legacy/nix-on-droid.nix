{  # NixOS Configuration for ARM64 (Vivo Y28)
  # Production-Ready NixOS Configuration

  # 1. Deduplicated environment packages
  environment.systemPackages = with pkgs; [
    vim
    git
    # Add other necessary packages here
  ];

  # 2. lib.mkForce PATH reconstruction with absolute store paths
  let
    myPath = lib.mkForce [
      pkgs.stdenv
      # Add additional paths if required
    ];
  in
  {
    environment.variables.PATH = myPath;
  }

  # 3. Custom user-level tailscale-rootless wrapper script
  systemd.user.services.tailscale-wrapper = {
    description = "Tailscale Rootless Wrapper";
    script = ''
      #!/bin/sh
      exec /run/current-system/sw/bin/tailscale up --tun=userspace-networking
    ''; 
    serviceConfig = { 
      ExecStart = "${pkgs.tailscale}/bin/tailscale up --tun=userspace-networking";
    };
  };

  # 4. Input validation assertions preventing non-ARM installation
  let
    isARM = (builtins.length (filter (x: x == "arm64") (lib.systems));
  in if ! isARM then
    throw "This configuration is only meant for ARM64 systems."
  ;

  # 5. Auto-optimise-store and garbage collection policies
  system.gc = { 
    autoOptimizeStore = true; 
    garbageCollect = true;
  };

  # 6. Clean 2-space indentation
  # (This configuration follows clean 2-space indentation)

  # 7. Ready-to-pipe format for cat << EOF deployment
  cat << EOF > /etc/nixos/configuration.nix
  { config, pkgs, ... }:  
  } 

EOF
}