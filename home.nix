{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "bgodley";
  home.homeDirectory = "/home/bgodley";

  programs.git = { 
    enable = true;
    userName = "Braden Godley";
    userEmail = "braden@bgodley.com";
  };

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  nixpkgs.config.allowUnfree = true;

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # Terminal commands
    vim
    htop
    neovim
    gcc
    gnumake
    ripgrep
    wget
    git
    docker-compose
    zip
    ansible
    ngrok
    flatpak

    # kubernetes
    minikube
    kubectl

    # Applications
    gnome.gnome-software
    vscode
    obsidian
    noisetorch
    firefox
    tor-browser
    libreoffice
    spotify
    discord
    signal-desktop
    polychromatic
    gimp
    jetbrains.datagrip

    # Languages
    nodejs_20
    corepack_20

    # fonts
    nerdfonts

    # steering wheel
    oversteer
  ];

  fonts.fontconfig.enable = true;

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
    
    ".vimrc".source = dotfiles/vimrc;
    ".config/noisetorch/config.toml".source = dotfiles/noisetorch/config.toml;
    ".config/openrazer/persistence.conf".source = dotfiles/openrazer/persistence.conf;
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. If you don't want to manage your shell through Home
  # Manager then you have to manually source 'hm-session-vars.sh' located at
  # either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/bgodley/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    EDITOR = "vim";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
