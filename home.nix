{ config, pkgs, ... }:

let 
  chatgpt-cli = pkgs.callPackage (pkgs.fetchFromGitHub {
    owner = "braden-godley";
    repo = "chatgpt-cli";
    rev = "master";
    sha256 = "sha256-WgGDU03pJG2XW6+N7//c/b38DzTE76hnXM/AxlRkFq8=";
  }) {};
in
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
    git-lfs
    docker-compose
    zip
    ansible
    ngrok
    flatpak
    chatgpt-cli
    openvpn
    tmux
    alacritty

    # kubernetes
    minikube
    kubectl

    # Applications
    gnome.gnome-software
    vscode
    obsidian
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
    rustup
    python3

    # fonts
    nerdfonts

    # steering wheel
    oversteer

    # voice cancellation
    noisetorch

    # clipboard
    xclip
  ];

  programs.zsh = {
    initExtra = ''
        # pnpm
        export PNPM_HOME="/home/bgodley/.local/share/pnpm"
        case ":$PATH:" in
          *":$PNPM_HOME:"*) ;;
          *) export PATH="$PNPM_HOME:$PATH" ;;
        esac
        # pnpm end

        # Correcting the XDG_DATA_DIRS
        # export XDG_DATA_DIRS="/var/lib/flatpak/exports/share:/home/bgodley/.local/share/flatpak/exports/share:$XDG_DATA_DIRS"

        export PATH="$PATH:/home/bgodley/.cargo/bin"
    '';  
    enable = true;
    enableCompletion = true;
    enableAutosuggestions = true;
    syntaxHighlighting.enable = true;
    history.size = 10000;
    oh-my-zsh = {
        enable = true;
        plugins = [ 
            "git" 
            "rust" 
            "sudo" 
            "tmux" 
            "colored-man-pages" 
            "docker" 
            "docker-compose" 
        ];
    };
    shellAliases = {
        hm = "cd ~/.config/home-manager";
        hms = "git add . && git commit -m $(date +%D%T) && git push && home-manager switch";
    };
  };

  fonts.fontconfig.enable = true;


  # Define the systemd service for noisetorch
  # systemd.user.services.noisetorch = {
  #   description = "NoiseTorch for Kingston HyperX Cloud Alpha S Headset";
  #   after = [ "pipewire.service" ]; 
  #   wantedBy = [ "default.target" ];
  #   path = with pkgs; [ noisetorch ];
  #   serviceConfig = {
  #     ExecStart = ''
  #       ${pkgs.noisetorch}/bin/noisetorch -i -s alsa_input.usb-Kingston_HyperX_Cloud_Alpha_S_000000000001-00.mono-fallback
  #     '';
  #     Restart = "on-failure";
  #   };
  # };

  systemd.user.services = {
    noisetorch = {
      Unit = {
        Description = "NoiseTorch";
        After = "pipewire.service";
        Documentation = "man:noisetorch(1)";
      };
      Service = {
        # DynamicUser = true;
        Environment = "DEVICE=alsa_input.usb-Kingston_HyperX_Cloud_Alpha_S_000000000001-00.mono-fallback";
        ExecStart = "${pkgs.noisetorch}/bin/noisetorch -i -s $DEVICE";
        Restart = "on-failure";
        RestartSec = 5;
        StartLimitBurst = 3;
      };
      Install = {
        WantedBy = [ "default.target" ];
      };
    };
  };

  # Enable the NoiseTorch systemd service
  systemd.user.startServices = true;

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
    ".config/alacritty/alacritty.toml".source = dotfiles/alacritty.toml;
    ".tmux.conf".source = dotfiles/tmux.conf;
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
