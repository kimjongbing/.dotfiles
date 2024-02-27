{ config, lib, pkgs, inputs, ... }:

let
  # User and Network Settings
  user = "deishuu";
  networkingUsername = "kaiki";

in {
  # System Configuration
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  boot.loader.systemd-boot = {
    enable = true;
    configurationLimit = 5;
  };

  boot.loader.efi.canTouchEfiVariables = true;

  nixpkgs.config = {
    allowUnfree = true;
  };

  boot.kernelPackages = pkgs.linuxPackages_zen;


  # Garbage Collection
  nix = {
    settings.auto-optimise-store = true;
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  # Networking
  networking = {
    hostName = networkingUsername;
    networkManager = {
      enable = true;
    };
  };

  # Time
  time = {
    timeZone = "Australia/Sydney";
    hardwareClockInLocalTime = true;
  };


  # Internationalization
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_TIME = "en_AU.UTF-8";
    };
  };
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  # Packages
  environment.systemPackages = with pkgs; [
    vim  # Editor for configuration editing
    wget
    git
    mpd
  ];

  fonts.packages = with pkgs; [
    font-awesome
  ];

  users.users.${user} = {
    isNormalUser = true;
    extraGroups = [ "wheel" "video" "networkmanager" "lp" "scanner" ]; # Enable ‘sudo’
    packages = with pkgs; [
      firefox
      tree
    ];
  };

  # Services
  services = {
    # X Server and Desktop
    xserver = {
      enable = true;
      desktopManager.gnome = {
        enable = true;
      };
    },

    # Nvidia Specific
    nvidia = {
      package = config.boot.kernelPackages.nvidiaPackages.beta;
      nvidiaSettings = true;
      virtualisation.podman.enableNvidia = true;
      hardware.nvidia.modesetting.enable = true;
    },

    # Sound
    sound = {
      enable = true;
      mediaKeys.enable = true;
    },

    # Pipewire Audio System
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    },

    # Printing
    printing = {
      enable = true;
    },

    # Bluetooth
    blueman = {
      enable = true;
      hardware.bluetooth = {
        enable = true;
        powerOnBoot = true;
        settings = {
          General = {
            Enable = "Source,Sink,Media,Socket";
          };
        };
      };
    },

    # Desktop Portal
    xdg.portal = {
      enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    },
  };

  # Environment Variables
  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1";
    NIXOS_OZONE_WL = "1";
  };

  # Security
  security.rtkit.enable = true;

  # System state version
  system.stateVersion = "23.11"; # Did you read the comment?
}
