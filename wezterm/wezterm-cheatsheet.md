# WezTerm Cheat Sheet

## What This File Is

This is only a note file for WezTerm shortcuts and behavior.

It does not affect WSL.
It does not run anything.
It is only documentation.

## How WezTerm Fits In

On Windows:

Windows WezTerm -> WSL Ubuntu -> tmux / Neovim / Yazi / Codex

On macOS:

macOS WezTerm -> macOS shell

## Actual Config File

The real WezTerm config is:

~/dotfiles/wezterm/wezterm.lua

On Windows, WezTerm reads it through:

C:\Users\hwath\.wezterm.lua

## Custom Shortcuts

| Shortcut | Platform | Action |
|---|---|---|
| Ctrl + Shift + C | Windows / macOS | Copy selected terminal text to the system clipboard |
| Ctrl + Shift + V | Windows / macOS | Paste system clipboard text into the active terminal pane |
| Shift + Enter | Windows / macOS | Send Shift + Enter to the active pane |
| Alt + Enter | Windows / macOS | Toggle fullscreen |
| Cmd + Enter | macOS | Toggle fullscreen |
| Right-click | Windows / macOS | Paste from clipboard |

## Startup Behavior

| Platform | Behavior |
|---|---|
| Windows | WezTerm opens WSL Ubuntu |
| macOS | WezTerm opens a normal login shell |

## Appearance

| Setting | Value |
|---|---|
| Theme | Nord if available, otherwise Rose Pine Moon, with a dark custom background |
| Font | JetBrainsMono Nerd Font / JetBrains Mono / Cascadia Mono / Consolas |
| Opacity | 0.97 |
| FPS | 120 |
| Tab bar | Hidden when only one tab |
| Window decorations | Integrated buttons + resize |
| Padding | Compact padding on all sides |
