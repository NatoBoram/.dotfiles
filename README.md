# Dotfiles

My personal dotfiles.

![Screenshot](https://github.com/NatoBoram/.dotfiles/assets/10495562/678b127f-5b95-49e3-82a0-6bd3fee885a6)

## Content

- <https://github.com/github/copilot-cli>
- <https://github.com/google-gemini/gemini-cli>
- <https://github.com/llvm/llvm-project>
- <https://github.com/microsoft/vscode-copilot-chat>
- <https://github.com/microsoft/vscode>
- <https://github.com/nektos/act>
- <https://github.com/nicolargo/glances>
- <https://github.com/nordtheme/gedit>
- <https://github.com/ohmyzsh/ohmyzsh>
- <https://github.com/pnpm/pnpm>
- <https://github.com/romkatv/powerlevel10k>
- <https://github.com/vinceliuice/Graphite-gtk-theme>

## Installation

```sh
git clone git@github.com:NatoBoram/.dotfiles.git ~/.dotfiles
cd ~/.dotfiles
stow .
```

## Usage

To adopt a file from `$HOME`:

```sh
touch $FILE
stow --adopt .
```

The new empty file will be overwritten by the one at `$HOME`.

## Acknowledgements

- [Stow has forever changed the way I manage my dotfiles](https://www.youtube.com/watch?v=y6XCebnB9gs)
