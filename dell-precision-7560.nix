{ config, lib, pkgs, ... }:

let
  unstable = import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/nixpkgs-unstable.tar.gz") { };
in
{
  boot.initrd.luks.devices.cryptroot.device = "/dev/disk/by-uuid/925baef0-27b8-419b-bf55-9582cd51259e";
  boot.loader.grub.useOSProber = true;

  fileSystems = {
    "/".options = [ "compress=zstd" ];
    "/home".options = [ "compress=zstd" ];
    "/nix".options = [ "compress=zstd" "noatime" ];
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  programs.firefox.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Security
  hardware.cpu.intel.updateMicrocode = true;

  # Add the docker group to allow distrobox
  users.users.lyn.extraGroups = [ "docker" ];

  environment.systemPackages = with pkgs; [
    # GPU stuff
    cudatoolkit
    gpustat

    # AI stuff
    # unstable.codex
    # unstable.lsp-ai

    # distrobox
  ];

  # Enable OpenGL
  hardware.graphics= {
    enable = true;
    enable32Bit = true;
  };

  # Activate ollama
  # services.ollama = {
  #   enable = true;
  #   acceleration = "cuda";
  # };

  # Update the exec to effectively use nvidia-offload.
  # systemd.user.services.ollama = {
  #   # NOTE: If you see this failure:
  #   #
  #   #     cuda driver library init failure: 999.
  #   #
  #   # Run the following command:
  #   #
  #   #     sudo rmmod nvidia_uvm; sudo modprobe nvidia_uvm
  #   #
  #   # However, this assumes there is no other GPU usage, or if they are, they
  #   # could be safely killed with the above command.
  #   environment = {
  #     __NV_PRIME_RENDER_OFFLOAD = "1";
  #     __NV_PRIME_RENDER_OFFLOAD_PROVIDER = "NVIDIA-G0";
  #     __GLX_VENDOR_LIBRARY_NAME = "nvidia";
  #     __VK_LAYER_NV_optimus = "NVIDIA_only";
  #   };
  # };

  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = ["nvidia"];
  # services.xserver.videoDrivers = ["modesetting" "nvidia"];

  # Disable wayland
  # services.xserver.displayManager.gdm.wayland = false;
  # services.displayManager.sddm.wayland.enable = false;

  hardware.nvidia = {

    # Modesetting is required.
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    # Enable this if you have graphical corruption issues or application crashes after waking
    # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead 
    # of just the bare essentials.
    powerManagement.enable = true;

    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = true;

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of 
    # supported GPUs is at: 
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus 
    # Only available from driver 515.43.04+
    open = true;

    # Enable the Nvidia settings menu,
    # accessible via `nvidia-settings`.
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.stable;

    # In order to correctly finish configuring your Nvidia graphics driver, you must follow
    # the below steps, which differ depending on whether or not you are using a hybrid
    # graphics setup or not. A laptop with hybrid graphics possesses both an integrated GPU
    # (often from the central processor) and a discrete, more powerful Nvidia GPU, typically
    # for performance-intensive tasks. This dual-GPU setup allows for power-saving during
    # basic tasks and higher graphics performance when needed.
    # 
    # Offload mode puts your Nvidia GPU to sleep and lets the Intel GPU handle all tasks,
    # except if you call the Nvidia GPU specifically by "offloading" an application to it.
    # 
    # Enabling PRIME sync introduces better performance and greatly reduces screen tearing, at
    # the expense of higher power consumption since the Nvidia GPU will not go to sleep
    # completely unless called for, as is the case in Offload Mode. It may also cause its own
    # issues in rare cases.
    #
    # PRIME Sync and Offload Mode cannot be enabled at the same time.
    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
      # sync.enable = true;
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };
}
