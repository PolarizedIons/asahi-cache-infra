{
  polarizedions = {
    sshKeys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPUUddPj733ra6JQUcARRTw9J33WT70iiTwjQlk+Q7vH polarizedions@aegis"
    ];
    shell = pkgs: pkgs.zsh;
    extraConfig = { ... }: {
      programs.zsh.enable = true;
    };
    pkgs =
      pkgs: with pkgs; [
        btop
      ];
  };
}
