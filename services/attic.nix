{ config, ... }:

{
  services.atticd = {
    enable = true;
    environmentFile = config.age.secrets.attic-env.path;
    settings = {
      listen = "127.0.0.1:8080";

      storage = {
        type = "s3";
        region = "auto"; # R2; use your region for Hetzner
        bucket = "asahi-cache";
        endpoint = "https://bdd2b66da2d11403b76534a553e1d8dc.r2.cloudflarestorage.com";
      };

      chunking = {
        nar-size-threshold = 64 * 1024;
        min-size = 16 * 1024;
        avg-size = 64 * 1024;
        max-size = 256 * 1024;
      };

      compression.type = "zstd";

      garbage-collection = {
        interval = "24 hours";
        default-retention-period = "6 months";
      };
    };
  };

  # prevent the nix-daemon from making atticd unavailable
  systemd.services.atticd.serviceConfig = {
    CPUWeight = 500;
    MemoryLow = "512M";
    OOMScoreAdjust = -500;
  };
  systemd.services.nix-daemon.serviceConfig.CPUWeight = 50;
}
