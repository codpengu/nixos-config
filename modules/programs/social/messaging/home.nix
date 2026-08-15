{ pkgs, ... }:
let
  signal-desktop =
    if pkgs.stdenv.hostPlatform.isDarwin then
      pkgs.signal-desktop.override {
        withAppleEmojis = true;
      }
    else
      pkgs.signal-desktop;
in
{
  home.packages = [
    signal-desktop
    pkgs.telegram-desktop
    pkgs.discord
  ];
}
