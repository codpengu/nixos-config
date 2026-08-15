{ lib, pkgs, ... }:
{
  services.spotifyd = lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
    enable = true;
    settings = {
      global = {
        device_name = "DesktopNix";
        username_cmd = "${pkgs.coreutils}/bin/head -1 /run/agenix/spotify-username";
        password_cmd = "${pkgs.coreutils}/bin/head -1 /run/agenix/spotify-password";
        bitrate = 320;
      };
    };
  };
}
