{ ... }:

{
  imports = [
    ./configuration.nix
    ./deploy.nix
    ./hardware-configuration.nix
    ./user-autoconfig.nix
  ];
}
