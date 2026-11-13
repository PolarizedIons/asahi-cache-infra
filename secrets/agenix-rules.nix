let
  secrets = import ./secret-defs.nix;
  phobos = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGtsFh/eYXH6FQ9U9Jni24VHioBbuz0SlNKWcSo3l+18";

  flatten = x: if builtins.isList x then builtins.concatMap flatten x else [ x ];
  maintainers = import ../maintainers.nix;
  sshKeys = flatten (builtins.attrValues (builtins.mapAttrs (key: value: value.sshKeys) maintainers));

  final = builtins.listToAttrs (
    map (s: {
      name = "${s}.age";
      value = {
        publicKeys = sshKeys ++ [ phobos ];
      };
    }) secrets
  );
in
final
