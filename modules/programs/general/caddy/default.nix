{ ... }:
{
  services.nginx = {
    enable = true;

    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;

    virtualHosts."full-text-rss.localhost" = {
      locations."/".proxyPass = "http://localhost:9907";
      listenAddresses = [ "127.0.0.1" ];
    };

    virtualHosts."wallabag.localhost" = {
      locations."/".proxyPass = "http://localhost:9908";
      listenAddresses = [ "127.0.0.1" ];
    };

    virtualHosts."syncthing.localhost" = {
      locations."/".proxyPass = "http://localhost:8384";
      listenAddresses = [ "127.0.0.1" ];
    };

    virtualHosts."nzbget.localhost" = {
      locations."/".proxyPass = "http://localhost:6789";
      listenAddresses = [ "127.0.0.1" ];
    };

    virtualHosts."jellyfin.localhost" = {
      locations."/".proxyPass = "http://localhost:8096";
      listenAddresses = [ "127.0.0.1" ];
    };

    virtualHosts."freshrss.localhost" = {
      locations."/".proxyPass = "http://freshrss.local";
      listenAddresses = [ "127.0.0.1" ];
    };
  };

  services.caddy = {
    enable = false;

    virtualHosts."full-text-rss.localhost" = {
      extraConfig = ''
        reverse_proxy localhost:9907
      '';
      listenAddresses = [ "127.0.0.1" ];
    };

    virtualHosts."wallabag.localhost" = {
      extraConfig = ''
        reverse_proxy localhost:9908
      '';
      listenAddresses = [ "127.0.0.1" ];
    };

    virtualHosts."syncthing.localhost" = {
      extraConfig = ''
        reverse_proxy localhost:8384
      '';
      listenAddresses = [ "127.0.0.1" ];
    };

    virtualHosts."jellyfin.localhost" = {
      extraConfig = ''
        reverse_proxy localhost:8096
      '';
      listenAddresses = [ "127.0.0.1" ];
    };

    virtualHosts."nzbget.localhost" = {
      extraConfig = ''
        reverse_proxy localhost:6789
      '';
      listenAddresses = [ "127.0.0.1" ];
    };

    virtualHosts."freshrss.localhost" = {
      # extraConfig = ''
      #   root * ${pkgs.freshrss}/p
      #   php_fastcgi unix/${config.services.phpfpm.pools.freshrss.socket} {
      #       env FRESHRSS_DATA_PATH ${config.services.freshrss.dataDir}
      #   }
      #   file_server
      # '';
      extraConfig = ''
        reverse_proxy freshrss.local
      '';
      listenAddresses = [ "127.0.0.1" ];
    };
  };
}
