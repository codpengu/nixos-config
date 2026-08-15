{ lib, pkgs, ... }:
{
  fonts.fontconfig.enable = true;
  home.packages = [
    pkgs.nerd-fonts.jetbrains-mono
    pkgs.nerd-fonts.caskaydia-cove
    pkgs.nerd-fonts.symbols-only
    pkgs.cascadia-code

    pkgs.font-awesome
    pkgs.material-icons
    pkgs.fira-code
    pkgs.fira-code-symbols
  ]
  ++ lib.optionals pkgs.stdenv.hostPlatform.isLinux [
    pkgs.symbola
  ];
}
