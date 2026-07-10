{ username, ... }:

{
  nix-homebrew = {
    enable = true;
    user = username;
    autoMigrate = true;
    enableRosetta = true;
  };

  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = true;
      cleanup = "uninstall";
      upgrade = true;
    };

    brews = [
      "bat"
      "bear"
      "binutils"
      "cmake"
      "cppcheck"
      "curl"
      "dotnet"
      "eza"
      "fd"
      "fzf"
      "gcovr"
      "gh"
      "git"
      "herdr"
      "jq"
      "lazygit"
      "lcov"
      "llvm"
      "nasm"
      "neovim"
      "ninja"
      "node"
      "pipx"
      "python"
      "ripgrep"
      "rust"
      "shellcheck"
      "shfmt"
      "starship"
      "yazi"
      "zoxide"
      "zsh"
      "zsh-autosuggestions"
      "zsh-syntax-highlighting"
    ];

    casks = [
      "claude-code"
      "font-jetbrains-mono-nerd-font"
      "wezterm"
    ];
  };
}
