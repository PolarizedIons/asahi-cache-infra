{ pkgs, ... }:

let
  maintainers = import ../maintainers.nix;
in
{
  users.users = builtins.mapAttrs (key: value: {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = value.sshKeys;
    packages = value.pkgs pkgs;
  }) maintainers;
}
