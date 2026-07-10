{
  pkgs,
  username,
  ...
}:

{
  imports = [ ./homebrew.nix ];

  nix.enable = false;

  nixpkgs = {
    hostPlatform = "aarch64-darwin";
    config.allowUnfree = true;
  };

  system = {
    primaryUser = username;
    stateVersion = 6;

    defaults = {
      NSGlobalDomain = {
        AppleInterfaceStyle = "Dark";
        AppleKeyboardUIMode = 3;
        ApplePressAndHoldEnabled = false;
        InitialKeyRepeat = 15;
        KeyRepeat = 2;
        _HIHideMenuBar = true;
      };

      dock = {
        autohide = true;
        show-recents = false;
        orientation = "bottom";
      };

      finder = {
        AppleShowAllExtensions = true;
        CreateDesktop = false;
        FXDefaultSearchScope = "SCcf";
        FXPreferredViewStyle = "Nlsv";
        ShowPathbar = true;
        ShowStatusBar = true;
      };

      trackpad.Clicking = true;
    };
  };

  users.users.${username}.home = "/Users/${username}";

  programs.zsh.enable = true;

  fonts.packages = [
    pkgs.nerd-fonts.jetbrains-mono
  ];
}
