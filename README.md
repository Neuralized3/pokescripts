# pokescripts

Two small scripts for the [kitty](https://sw.kovidgoyal.net/kitty/) terminal:

- **`pokemon`** shows a random Pokémon sprite every time the terminal starts.
- **`pokefetch`** runs [fastfetch](https://github.com/fastfetch-cli/fastfetch) with a random Generation V Pokémon as the logo.

## Requirements

| Tool | Needed for |
|------|-----------|
| Python 3 | everything |
| git | installation |
| [kitty](https://sw.kovidgoyal.net/kitty/) | everything (sprites are drawn with kitty's image protocol) |
| [fastfetch](https://github.com/fastfetch-cli/fastfetch) | `pokefetch` only |

Installing fastfetch:

```bash
sudo apt install fastfetch      # Debian / Ubuntu
sudo pacman -S fastfetch        # Arch
sudo dnf install fastfetch      # Fedora
brew install fastfetch          # macOS
```

## Installation

Choose what should run **every time a terminal starts**. The `pokemon` and `pokefetch` aliases are added in every case, so you can always run either one by hand.

| Option | Runs on startup | Sprites |
|--------|-----------------|---------|
| `-shd` | `pokemon -shd` | Pokémon Showdown (GIF), Pokémon #1-982 |
| `-gen5` | `pokemon -gen5` | Generation V (PNG), Pokémon #1-643 only |
| `-pokefetch` | `pokefetch` | fastfetch with a random Gen V Pokémon logo (needs fastfetch) |
| `-none` | nothing | aliases only |

### Automatic (recommended)

The installer clones the repo to `~/pokescripts` and adds the aliases (and your chosen startup command) to `~/.zshrc` or `~/.bashrc`. It detects your shell, backs up your config before editing it, and never adds the lines twice.

Pick one:

```bash
# Showdown sprites on startup
curl -fsSL https://raw.githubusercontent.com/Neuralized3/pokescripts/main/install.sh | bash -s -- -shd

# Generation V sprites on startup
curl -fsSL https://raw.githubusercontent.com/Neuralized3/pokescripts/main/install.sh | bash -s -- -gen5

# pokefetch (fastfetch + Pokémon) on startup
curl -fsSL https://raw.githubusercontent.com/Neuralized3/pokescripts/main/install.sh | bash -s -- -pokefetch

# Aliases only, nothing on startup
curl -fsSL https://raw.githubusercontent.com/Neuralized3/pokescripts/main/install.sh | bash -s -- -none
```

Leave off the option and the installer asks you to choose (default `-shd`):

```bash
curl -fsSL https://raw.githubusercontent.com/Neuralized3/pokescripts/main/install.sh | bash
```

Already cloned the repo? Run the installer from inside it:

```bash
bash ~/pokescripts/install.sh -shd     # or -gen5, -pokefetch, -none
```

To switch later, run the installer again with a different option. It replaces the old setup instead of duplicating it.

### Manual

1. Clone the repo into your home directory under the name `pokescripts`:

   ```bash
   git clone https://github.com/Neuralized3/pokescripts.git ~/pokescripts
   ```

2. Add the aliases to your shell config. Set `RC` to the file for your shell, then run **one** of the commands below.

   ```bash
   RC=~/.zshrc      # zsh
   RC=~/.bashrc     # bash
   ```

   **Showdown sprites on startup:**

   ```bash
   printf "\n# >>> pokescripts >>>\nalias pokemon='python3 ~/pokescripts/pokemon.py'\nalias pokefetch='python3 ~/pokescripts/pokefetch.py'\npokemon -shd\n# <<< pokescripts <<<\n" >> "$RC"
   ```

   **Generation V sprites on startup:**

   ```bash
   printf "\n# >>> pokescripts >>>\nalias pokemon='python3 ~/pokescripts/pokemon.py'\nalias pokefetch='python3 ~/pokescripts/pokefetch.py'\npokemon -gen5\n# <<< pokescripts <<<\n" >> "$RC"
   ```

   **pokefetch on startup:**

   ```bash
   printf "\n# >>> pokescripts >>>\nalias pokemon='python3 ~/pokescripts/pokemon.py'\nalias pokefetch='python3 ~/pokescripts/pokefetch.py'\npokefetch\n# <<< pokescripts <<<\n" >> "$RC"
   ```

   **Aliases only (nothing on startup):**

   ```bash
   printf "\n# >>> pokescripts >>>\nalias pokemon='python3 ~/pokescripts/pokemon.py'\nalias pokefetch='python3 ~/pokescripts/pokefetch.py'\n# <<< pokescripts <<<\n" >> "$RC"
   ```

   Prefer to edit the file yourself? Paste this into it and delete the startup line you don't want:

   ```bash
   alias pokemon='python3 ~/pokescripts/pokemon.py'
   alias pokefetch='python3 ~/pokescripts/pokefetch.py'
   pokemon -shd        # Showdown sprites (GIF)
   # pokemon -gen5     # Generation V sprites (PNG)
   # pokefetch         # fastfetch with a Pokémon logo
   ```

3. Reload your shell config (or just open a new kitty window):

   ```bash
   source "$RC"
   ```

### Uninstall

```bash
bash ~/pokescripts/install.sh -uninstall   # removes the block from your shell config
rm -rf ~/pokescripts                       # optional: delete the repo
```

## Usage

### pokemon

```
Usage: pokemon <style> [name]
Styles:
  -gen5    Generation V sprites (PNG), Pokémon #1-643 only
  -shd     Pokémon Showdown sprites (GIF), Pokémon #1-982
Examples:
  pokemon -gen5              random Gen V sprite (png)
  pokemon -shd               random Showdown sprite (gif)
  pokemon -shd pikachu       a specific Pokémon
  pokemon -gen5 articuno     names match the file names
                             (nidoran-f, articuno, ho-oh)
```

### pokefetch

Shows your system info with fastfetch, using a Generation V sprite as the logo.

```
Usage: pokefetch [name]
Examples:
  pokefetch                  random Gen V Pokémon as the logo
  pokefetch charizard        a specific Pokémon
  pokefetch nidoran-f        names are lowercase and match the file names
```

The logo is sized automatically: each sprite is scaled by the same factor from its real pixel size and your terminal's cell size, so small Pokémon stay small and large ones stay large, on any font or zoom level.

To adjust the look, edit the constants at the top of `~/pokescripts/pokefetch.py`:

```python
SCALE = 1.3      # logo size multiplier (raise for bigger, lower for smaller)
PAD_LEFT = 10    # blank columns left of the logo
PAD_RIGHT = 10   # blank columns between the logo and the system info
```

To preview a size without editing anything, run fastfetch directly from `~/pokescripts/gen5`:

```bash
fastfetch --logo-type kitty-icat --logo pikachu.png --logo-width 12 --logo-height 6 --logo-padding-left 10 --logo-padding-right 10
```

## License

The code in this repository is released under the [MIT License](LICENSE).

The MIT License covers the code only. It does **not** cover the sprite images.

## Disclaimer

This is an unofficial, non-commercial fan project. Pokémon and all related names, characters, and sprites are trademarks and copyrights of Nintendo, Game Freak, and Creatures Inc. This project is not affiliated with or endorsed by them.

Sprite sources and credits:

- [PokeAPI](https://github.com/PokeAPI/sprites) for the Generation V sprites
- [Pokémon Showdown](https://play.pokemonshowdown.com/) / Smogon and its sprite artists for the Showdown sprites
- [fastfetch](https://github.com/fastfetch-cli/fastfetch) for the system info display used by `pokefetch`