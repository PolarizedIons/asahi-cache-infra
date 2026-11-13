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

  services.openssh.enable = true;

  networking.firewall.enable = true;
  networking.firewall.allowedTCPPorts = [
    22
    80
    443
  ];

  system.stateVersion = "26.05"; # StateVersion, StateVersion never changes
}
