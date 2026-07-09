{ config, lib, pkgs, ... }:

{
  networking.hostName = "nixtop";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.networkmanager.enable = true;

  time.timeZone = "America/Indiana/Indianapolis";
  i18n.defaultLocale = "en_US.UTF-8";

  programs.fish.enable = true;

  users.users.goose = {
    isNormalUser = true;
    description = "goose";
    extraGroups = [ "wheel" "networkmanager" "video" "input" ];
    shell = pkgs.fish;
  };

  programs.river-classic.enable = true;

  security.polkit.enable = true;
  security.pam.services.greetd.enableGnomeKeyring = true;

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd river";
        user = "greeter";
      };
    };
  };

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  fonts.packages = with pkgs; [
    libertinus
    noto-fonts-color-emoji
  ];

  environment.systemPackages = with pkgs; [
    git
    wget
  ];

  programs.dconf.enable = true;
  services.gvfs.enable = true;

  system.stateVersion = "26.05";
}
