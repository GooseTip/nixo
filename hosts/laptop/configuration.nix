{ config, lib, pkgs, ... }:

{
  networking.hostName = "nixtop";

  # --- Bootloader ---
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # --- Networking ---
  networking.networkmanager.enable = true;

  time.timeZone = "America/Indiana/Indianapolis";
  i18n.defaultLocale = "en_US.UTF-8";

  # --- Shell ---
  programs.fish.enable = true; # registers fish in /etc/shells

  # --- User ---
  users.users.tard = {
    isNormalUser = true;
    description = "tard";
    extraGroups = [ "wheel" "networkmanager" "video" "input" ];
    shell = pkgs.fish;
  };

  # --- Wayland / River session ---
  programs.river.enable = true;

  security.polkit.enable = true;
  security.pam.services.greetd.enableGnomeKeyring = true;

  # Minimal login manager: greetd + tuigreet drops straight to a TUI login,
  # no graphical DE overhead, then execs river.
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd river";
        user = "greeter";
      };
    };
  };

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  # --- Audio ---
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  # --- Fonts ---
  fonts.packages = with pkgs; [
    libertinus
    noto-fonts-emoji
  ];

  # --- Core system packages ---
  environment.systemPackages = with pkgs; [
    git
    wget
  ];

  # --- Misc ---
  programs.dconf.enable = true; # needed by some GTK apps (thunar)
  services.gvfs.enable = true;  # trash/network mounts for thunar

  system.stateVersion = "26.05";
}
