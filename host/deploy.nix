{
  self,
  lib,
  system,
  pkgs,
  config,
  ...
}:

let
  policy = ./deploy-policy.yaml;
  pubKey = pkgs.writeText "ca.pub" "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN3n4rmvQDbuOTOGhbx9AhM4k1n9VztkYikElr+YUn7/";
  principal = pkgs.writeTextFile {
    name = "principal";
    text = ''
      gha-prod-deploy
    '';
    destination = "/etc/ssh/auth_principals/deploy";
  };

  # "principal" ''
  #   gha-prod-deploy
  # '';
in
{
  users.users.deploy = {
    isNormalUser = true;
  };

  services.openssh.extraConfig = ''
    TrustedUserCAKeys ${pubKey}

    Match User deploy
        AuthorizedPrincipalsFile ${principal}
  '';

  systemd.services.oidc-ssh-ca = {
    description = "oidc-ssh-ca - short-lived SSH certificate issuer";
    wantedBy = [ "multi-user.target" ];
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];

    environment.OIDC_SSH_CA_KEY_FILE = "%d/ca_key";

    serviceConfig = {
      ExecStart = lib.concatStringsSep " " [
        "${lib.getExe self.packages.${system}.oidc-ssh-ca} serve"
        "--config ${policy}"
        "--listen :8010"
        "--skip-key-permission-check"
      ];
      ExecReload = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";
      Restart = "on-failure";

      DynamicUser = true;
      LoadCredential = "ca_key:${config.age.secrets.deploy-ca.path}";

      ProtectSystem = "strict";
      ProtectHome = true;
      PrivateTmp = true;
      NoNewPrivileges = true;
      CapabilityBoundingSet = "";
      RestrictAddressFamilies = [
        "AF_INET"
        "AF_INET6"
      ];
      LockPersonality = true;
      MemoryDenyWriteExecute = true;
      ProtectKernelTunables = true;
      ProtectKernelModules = true;
      ProtectControlGroups = true;
    };
  };
}
