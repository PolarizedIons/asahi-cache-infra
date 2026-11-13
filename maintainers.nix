{
  polarizedions = {
    sshKeys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPUUddPj733ra6JQUcARRTw9J33WT70iiTwjQlk+Q7vH polarizedions@aegis"
    ];
    pkgs =
      pkgs: with pkgs; [
        btop
      ];
  };
}
