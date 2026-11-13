{ pkgs, config, ... }:

{
  services.hydra = {
    enable = true;
    hydraURL = "https://asahi-hydra.polarizedions.net";
    notificationSender = "hydra@polarizedions.net";
    listenHost = "127.0.0.1";
    port = 3000;
    useSubstitutes = true;
    extraConfig = ''
      max_concurrent_evals = 1
      using_frontend_proxy = 1
    '';

    buildMachinesFiles = [
      "/etc/nix/machines"
    ];
  };

  nix.buildMachines = [
    {
      hostName = "localhost";
      protocol = null;
      system = "aarch64-linux";
      systems = [
        "aarch64-linux"
      ];
      maxJobs = 8;
      speedFactor = 1;
      supportedFeatures = [ "kvm" ];
      mandatoryFeatures = [ ];
    }
  ];
  nix.distributedBuilds = true;

  nix.settings = {
    max-jobs = 8;
    experimental-features = [
      "nix-command"
      "flakes"
    ];

    allowed-uris = [
      "github:"
      "https://github.com/"
    ];
  };

  systemd.services.attic-watch-store = {
    wantedBy = [ "multi-user.target" ];
    wants = [ "network-online.target" ];
    after = [ "network-online.target" ];
    path = [ pkgs.attic-client ];
    environment.HOME = "/var/lib/attic-watch-store";
    serviceConfig = {
      DynamicUser = true;
      StateDirectory = "attic-watch-store";
      LoadCredential = "attic-token:${config.age.secrets.hydra-attic-token.path}";
      MemoryHigh = "5%";
      MemoryMax = "10%";
      Restart = "always";
    };
    script = ''
      set -eu -o pipefail
      attic login local http://127.0.0.1:8080 "$$(< "$CREDENTIALS_DIRECTORY/attic-token")"
      exec attic watch-store local:asahi
    '';
  };

}
