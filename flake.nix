{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    vicinae.url = "github:vicinaehq/vicinae";
    vicinae-extensions = {
      url = "github:vicinaehq/extensions";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    openspec = {
      url = "github:Fission-AI/OpenSpec";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ccusage = {
      url = "github:ryoppippi/ccusage";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ghostty = {
      url = "github:ghostty-org/ghostty";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    ghostty-hm = {
      url = "github:clo4/ghostty-hm-module";
      inputs.pkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-darwin = {
      url = "github:lnl7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # auto-cpufreq = {
    #   url = "github:AdnanHodzic/auto-cpufreq";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    hyprland-contrib = {
      url = "github:hyprwm/contrib?rev=33b38358559054d316eb605ccb733980dfa7dc63";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # sg-nvim = {
    #   url = "github:sourcegraph/sg.nvim";
    # };

    nixos-hardware.url = "github:NixOS/nixos-hardware";

    # nur.url = "github:nix-community/NUR";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      nix-darwin,
      # nur,
      ...
    }@inputs:
    let
      inherit (self) outputs;

      system = "x86_64-linux";
      darwinSystem = "aarch64-darwin";

      overlays = [
        # (import ./overlays/nvim/neotest-jdtls)
        (import ./overlays/nvim/neotest-vim-test)
        (import ./overlays {
          inherit inputs;
          inherit pkgs;
        })
        # inputs.nur.overlays.default
      ];

      pkgs = import nixpkgs {
        inherit system;
        inherit overlays;
        config.allowUnfree = true;
      };

      darwinPkgs = import nixpkgs {
        system = darwinSystem;
        inherit overlays;
        config.allowUnfree = true;
      };

      inherit (nixpkgs) lib;
    in
    {
      devShells.${system} = {
        #run by `nix devlop` or `nix-shell`(legacy)
        default = import ./shell.nix { inherit pkgs; };
      };

      homeConfigurations = {
        "qverkk@nixos" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${system};
          extraSpecialArgs = {
            inherit inputs outputs pkgs;
            hostName = "nixos";
          };
          modules = [
            inputs.stylix.homeModules.stylix
            ./home/nixos.nix

            { home.sessionVariables.NIX_PATH = "nixpkgs=flake:nixpkgs$\{NIX_PATH:+:$NIX_PATH}"; }
            { nix.registry.nixpkgs.flake = inputs.nixpkgs; }
          ];
        };

        "qverkk@hybrid" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${system};
          extraSpecialArgs = {
            inherit inputs outputs pkgs;
            hostName = "hybrid";
          };
          modules = [
            ./home/hybrid.nix

            { home.sessionVariables.NIX_PATH = "nixpkgs=flake:nixpkgs$\{NIX_PATH:+:$NIX_PATH}"; }
            { nix.registry.nixpkgs.flake = inputs.nixpkgs; }
          ];
        };

        "qverkk@yogi" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${system};
          extraSpecialArgs = {
            inherit inputs outputs pkgs;
            hostName = "yogi";
          };
          modules = [
            inputs.stylix.homeModules.stylix
            ./home/yogi.nix

            { home.sessionVariables.NIX_PATH = "nixpkgs=flake:nixpkgs$\{NIX_PATH:+:$NIX_PATH}"; }
            { nix.registry.nixpkgs.flake = inputs.nixpkgs; }
          ];
        };

        "qverkk@moonder" = home-manager.lib.homeManagerConfiguration {
          pkgs = darwinPkgs;
          extraSpecialArgs = {
            inherit inputs outputs;
            pkgs = darwinPkgs;
            hostName = "moonder";
          };
          modules = [
            ./home/moonder.nix

            { home.sessionVariables.NIX_PATH = "nixpkgs=flake:nixpkgs$\{NIX_PATH:+:$NIX_PATH}"; }
            { nix.registry.nixpkgs.flake = inputs.nixpkgs; }
          ];
        };
      };

      darwinConfigurations = {
        moonder = nix-darwin.lib.darwinSystem {
          system = darwinSystem;
          specialArgs = {
            inherit inputs outputs;
          };
          modules = [
            ./hosts/moonder
            home-manager.darwinModules.home-manager

            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = {
                inherit inputs outputs;
                pkgs = darwinPkgs;
                hostName = "moonder";
              };
              home-manager.users.qverkk = import ./home/moonder.nix;
            }

            { nix.nixPath = [ "nixpkgs=flake:nixpkgs" ]; }
            { nix.registry.nixpkgs.flake = inputs.nixpkgs; }
          ];
        };
      };

      nixosConfigurations = {
        nixos = lib.nixosSystem {
          specialArgs = {
            inherit inputs;
          };
          modules = [
            inputs.stylix.nixosModules.stylix
            ./hosts/nixos

            { nix.nixPath = [ "nixpkgs=flake:nixpkgs" ]; }
            { nix.registry.nixpkgs.flake = inputs.nixpkgs; }
          ];
        };

        hybrid = lib.nixosSystem {
          specialArgs = {
            inherit inputs;
          };
          modules = [
            inputs.stylix.nixosModules.stylix
            ./hosts/hybrid

            { nix.nixPath = [ "nixpkgs=flake:nixpkgs" ]; }
            { nix.registry.nixpkgs.flake = inputs.nixpkgs; }
          ];
        };

        yogi = lib.nixosSystem {
          specialArgs = {
            inherit inputs;
          };
          modules = [
            inputs.stylix.nixosModules.stylix
            ./hosts/yogi

            { nix.nixPath = [ "nixpkgs=flake:nixpkgs" ]; }
            { nix.registry.nixpkgs.flake = inputs.nixpkgs; }
          ];
        };
      };
    };
}
