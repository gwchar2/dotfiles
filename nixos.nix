{
  pkgs,
  username ? "gwchar2",
  ...
}:

{
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  nixpkgs.config.allowUnfree = true;

  users.users.${username} = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
  };

  programs.zsh.enable = true;

  environment.systemPackages = with pkgs; [
    curl
    git
    home-manager
    vim
  ];

  fonts.packages = [
    pkgs.nerd-fonts.jetbrains-mono
  ];
}
