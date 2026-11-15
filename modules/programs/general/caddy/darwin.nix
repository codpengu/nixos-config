{ pkgs, ... }:
let
  caddyConfig = pkgs.writeText "Caddyfile-localhost-proxies" ''
        {
        	storage file_system /var/lib/caddy-localhost-proxies
        }

        full-text-rss.localhost {
    		bind 127.0.0.1
        	tls internal
        	reverse_proxy 127.0.0.1:9907
        }

        wallabag.localhost {
    		bind 127.0.0.1
        	tls internal
        	reverse_proxy 127.0.0.1:9908
        }

        syncthing.localhost {
    		bind 127.0.0.1
        	tls internal
        	reverse_proxy 127.0.0.1:8384
        }

        jellyfin.localhost {
    		bind 127.0.0.1
        	tls internal
        	reverse_proxy 127.0.0.1:8096
        }

        nzbget.localhost {
    		bind 127.0.0.1
        	tls internal
        	reverse_proxy 127.0.0.1:6789
        }

        freshrss.localhost {
    		bind 127.0.0.1
        	tls internal
        	reverse_proxy freshrss.local
        }
  '';
in
{
  environment.systemPackages = [ pkgs.caddy ];

  launchd.daemons.caddy-localhost-proxies = {
    environment = {
      HOME = "/var/lib/caddy-localhost-proxies";
      XDG_CONFIG_HOME = "/var/lib/caddy-localhost-proxies/config";
      XDG_DATA_HOME = "/var/lib/caddy-localhost-proxies/data";
    };

    script = ''
      mkdir -p /var/log/caddy-localhost-proxies /var/lib/caddy-localhost-proxies
      chmod 755 /var/log/caddy-localhost-proxies /var/lib/caddy-localhost-proxies
      touch /var/log/caddy-localhost-proxies/stdout.log /var/log/caddy-localhost-proxies/stderr.log
      chmod 644 /var/log/caddy-localhost-proxies/stdout.log /var/log/caddy-localhost-proxies/stderr.log
      exec ${pkgs.caddy}/bin/caddy run --config ${caddyConfig} --adapter caddyfile
    '';

    serviceConfig = {
      KeepAlive = true;
      RunAtLoad = true;
      StandardOutPath = "/var/log/caddy-localhost-proxies/stdout.log";
      StandardErrorPath = "/var/log/caddy-localhost-proxies/stderr.log";
    };
  };
}
