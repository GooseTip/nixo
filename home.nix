{ config, pkgs, lib, zen-browser, ... }:

let
  system = pkgs.system;
in
{
  home.username = "goose";
  home.homeDirectory = "/home/goose";
  home.stateVersion = "26.05";

  # ---------------------------------------------------------------------
  # Shell — fish + starship
  # ---------------------------------------------------------------------
  programs.fish.enable = true;

  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      add_newline = false;
      format = "$username$hostname$directory$character";
      username = {
        style_user = "bold bright-white";
        style_root = "bold bright-white";
        format = "[$user]($style)@";
        show_always = true;
      };
      hostname = {
        style = "bold bright-white";
        format = "[$hostname]($style) ";
        ssh_only = false;
      };
      character = {
        success_symbol = "[❯](bold white)";
        error_symbol = "[❯](bold bright-black)";
      };
      directory = {
        style = "bold bright-white";
        truncation_length = 3;
      };
    };
  };

  # ---------------------------------------------------------------------
  # Terminal — foot, Libertinus Mono 11pt, full grayscale palette
  # ---------------------------------------------------------------------
  programs.foot = {
    enable = true;
    settings = {
      main = {
        font = "Libertinus Mono:size=11";
        dpi-aware = "yes";
        shell = "${pkgs.fish}/bin/fish";
      };
      colors = {
        background = "1a1a1a";
        foreground = "e0e0e0";

        regular0 = "000000"; # black
        regular1 = "4d4d4d"; # (was red)
        regular2 = "666666"; # (was green)
        regular3 = "808080"; # (was yellow)
        regular4 = "999999"; # (was blue)
        regular5 = "b3b3b3"; # (was magenta)
        regular6 = "cccccc"; # (was cyan)
        regular7 = "e6e6e6"; # white

        bright0 = "333333";
        bright1 = "595959";
        bright2 = "737373";
        bright3 = "8c8c8c";
        bright4 = "a6a6a6";
        bright5 = "bfbfbf";
        bright6 = "d9d9d9";
        bright7 = "ffffff";
      };
    };
  };

  # ---------------------------------------------------------------------
  # Launcher — fuzzel, matched to the grayscale theme
  # ---------------------------------------------------------------------
  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        font = "Libertinus Sans:size=11";
        terminal = "foot";
      };
      colors = {
        background = "1a1a1aee";
        text = "e0e0e0ff";
        match = "ffffffff";
        selection = "4d4d4dff";
        selection-text = "ffffffff";
        border = "666666ff";
      };
    };
  };

  # ---------------------------------------------------------------------
  # Notifications — mako, grayscale
  # ---------------------------------------------------------------------
  services.mako = {
    enable = true;
    settings = {
      font = "Libertinus Sans 10";
      background-color = "#1a1a1aee";
      text-color = "#e0e0e0ff";
      border-color = "#666666ff";
      border-size = 1;
      border-radius = 4;
      default-timeout = 5000;
    };
  };

  # ---------------------------------------------------------------------
  # Bar — waybar, minimal modules, grayscale styling
  # ---------------------------------------------------------------------
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 26;
        modules-left = [ "river/tags" ];
        modules-center = [ "clock" ];
        modules-right = [ "pulseaudio" "network" "battery" ];
        clock.format = "%Y-%m-%d  %H:%M";
        battery.format = "{capacity}%";
        network.format-wifi = "{essid}";
        pulseaudio.format = "vol {volume}%";
      };
    };
    style = ''
      * {
        font-family: "Libertinus Sans";
        font-size: 11px;
      }
      window#waybar {
        background: #1a1a1a;
        color: #e0e0e0;
      }
      #river-tags button {
        color: #808080;
      }
      #river-tags button.occupied {
        color: #e0e0e0;
      }
      #river-tags button.focused {
        color: #ffffff;
        border-bottom: 2px solid #ffffff;
      }
      #clock, #pulseaudio, #network, #battery {
        padding: 0 10px;
        color: #cccccc;
      }
    '';
  };

  # ---------------------------------------------------------------------
  # Packages
  # ---------------------------------------------------------------------
  home.packages = with pkgs; [
    thunar
    thunar-archive-plugin
    nano
    grim
    slurp
    wl-clipboard
    swaybg
    zen-browser.packages.${system}.default
  ];

  # ---------------------------------------------------------------------
  # River — init script (river is configured via riverctl calls, not a
  # native nix module, so we manage the init script directly)
  # ---------------------------------------------------------------------
  xdg.configFile."river/init" = {
    executable = true;
    text = ''
      #!${pkgs.dash}/bin/dash

      riverctl map normal Super Return spawn foot
      riverctl map normal Super D spawn fuzzel
      riverctl map normal Super Q close
      riverctl map normal Super+Shift E exit

      # Focus / layout
      riverctl map normal Super J focus-view next
      riverctl map normal Super K focus-view previous
      riverctl map normal Super+Shift J swap next
      riverctl map normal Super+Shift K swap previous

      # Tags (workspaces), 1-9
      for i in $(seq 1 9); do
        tagmask=$((1 << (i - 1)))
        riverctl map normal Super $i set-focused-tags $tagmask
        riverctl map normal Super+Shift $i set-view-tags $tagmask
      done

      riverctl background-color 0x1a1a1a
      riverctl border-color-focused 0xffffff
      riverctl border-color-unfocused 0x4d4d4d
      riverctl border-width 2

      swaybg -c "#1a1a1a" &
      mako &
      waybar &
    '';
  };
}
