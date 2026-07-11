{
  config,
  inputs,
  username,
  ...
}:

{
  nix-homebrew = {
    enable = true;
    user = username;
    autoMigrate = true;
    enableRosetta = false;
    mutableTaps = false;

    taps = {
      "homebrew/homebrew-core" = inputs.homebrew-core;
      "homebrew/homebrew-cask" = inputs.homebrew-cask;
    };
  };

  homebrew = {
    enable = true;
    taps = builtins.attrNames config.nix-homebrew.taps;

    onActivation = {
      autoUpdate = false;
      cleanup = "uninstall";
      upgrade = true;
    };

    brews = [
      "bear"
      "binutils"
      "cmake"
      "cppcheck"
      "dotnet"
      "gcovr"
      "herdr"
      "lcov"
      "llvm"
      "nasm"
      "ninja"
      "node"
      "pipx"
      "python"
      "rust"
      "shellcheck"
      "shfmt"
    ];

    casks = [
      "claude-code"
      "codex"
      "font-jetbrains-mono-nerd-font"
      "wezterm"
    ];
  };
}
