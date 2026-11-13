{ pkgs, ... }:

let
  maintainers = import ../maintainers.nix;
in
{
  imports = builtins.attrValues (builtins.mapAttrs (key: value: value.extraConfig) maintainers);

  users.users = builtins.mapAttrs (key: value: {
    isNormalUser = true;
    shell = value.shell pkgs;
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = value.sshKeys;
    packages = value.pkgs pkgs;
  }) maintainers;
}
