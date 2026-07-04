{ inputs, pkgs, ... }:
{
  # home.packages = with pkgs; [ rofi ];
  imports = [ inputs.vicinae.homeManagerModules.default ];

  programs.vicinae = {
    enable = true;

    settings = {
      close_on_focus_loss = true;
      theme = {
        light = {
          name = "vicinae-light";
          icon_theme = "default";
        };
        dark = {
          name = "vicinae-dark";
          icon_theme = "default";
        };
      };

      launcher_window = {
        opacity = 0.95;
      };

      providers = {
        # "@Gelei/bluetooth-0" = {
        #   preferences = {
        #     connectionToggleable = true;
        #   };
        # };
        # "applications" = {
        #   preferences = {
        #     launchPrefix = "uwsm app -- ";
        #   };
        # };
      };
    };

    extensions = with inputs.vicinae-extensions.packages.${pkgs.stdenv.hostPlatform.system}; [
      nix
      wifi-commander
      it-tools
    ];
  };
}
