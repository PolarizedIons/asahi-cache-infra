{ ... }:

let
  secrets = import ./secret-defs.nix;
in
{
  age.secrets = builtins.listToAttrs (
    map (s: {
      name = s;
      value = {
        file = ./${s}.age;
      };
    }) secrets
  );
}
