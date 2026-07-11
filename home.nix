{
  config,
  lib,
  pkgs,
  username,
  ...
}:

let
  dotfiles = "${config.home.homeDirectory}/dotfiles";
  link = path: config.lib.file.mkOutOfStoreSymlink "${dotfiles}/${path}";
in
{
  home = {
    inherit username;
    homeDirectory = if pkgs.stdenv.isDarwin then "/Users/${username}" else "/home/${username}";
    stateVersion = "25.05";

    packages =
      with pkgs;
      [
        bat
        eza
        fd
        fzf
        gh
        git
        jq
        lazygit
        neovim
        ripgrep
        starship
        yazi
        zoxide
        zsh-autosuggestions
        zsh-syntax-highlighting
      ]
      ++ lib.optionals pkgs.stdenv.isLinux [
        wl-clipboard
        xclip
      ]
      ++ lib.optional (pkgs.stdenv.isLinux && pkgs ? herdr) pkgs.herdr;

    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
      DOTFILES_DIR = dotfiles;
      NVIM_THEME = "nord";
      STARSHIP_THEME = "nord";
      WEZTERM_THEME = "nord";
    };

    file = {
      ".zshenv".source = link "home/.config/zsh/.zshenv";
      ".zshrc".source = link "home/.config/zsh/.zshrc";
      ".gitconfig".source = link "home/.gitconfig";

      ".config/zsh".source = link "home/.config/zsh";
      ".config/nvim".source = link "home/.config/nvim";
      ".config/wezterm".source = link "home/.config/wezterm";
      ".config/herdr".source = link "home/.config/herdr";
      ".config/starship".source = link "home/.config/starship";
      ".config/yazi".source = link "home/.config/yazi";

      "AGENTS.md".source = link "home/AGENTS.md";
      ".codex/AGENTS.md".source = link "home/AGENTS.md";
      ".claude/CLAUDE.md".source = link "home/AGENTS.md";
      ".claude/settings.json".source = link "home/.claude/settings.json";
      ".cursor/cursor.md".source = link "home/AGENTS.md";
      ".gemini/GEMINI.md".source = link "home/AGENTS.md";

      ".agents/skills".source = link ".agents/skills";
      ".codex/skills".source = link ".agents/skills";
      ".claude/skills".source = link ".agents/skills";
      ".agents/rules".source = link ".agents/rules";
      ".codex/rules".source = link ".agents/rules";
    };
  };

  xdg.enable = true;
  programs.home-manager.enable = true;
}
