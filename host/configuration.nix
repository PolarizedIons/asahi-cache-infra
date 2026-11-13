{ pkgs, ... }:

{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "phobos";
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Vienna";

  environment.systemPackages = with pkgs; [
    curl
    wget
    git
    nano
  ];

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
    settings.KbdInteractiveAuthentication = false;
  };

  networking.firewall.enable = true;
  networking.firewall.allowedTCPPorts = [
    22
    80
    443
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nix.optimise.automatic = true;
  nix.optimise.dates = [ "03:45" ];
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  system.stateVersion = "26.05"; # StateVersion, StateVersion never changes
}
