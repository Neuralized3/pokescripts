# pokescripts

A small script that shows a random Pokémon sprite in the [kitty](https://sw.kovidgoyal.net/kitty/) terminal every time it starts.

## Requirements

- Python 3
- kitty terminal

## Installation

Pick the sprite style you want shown on startup:

| Style | Sprites |
|-------|---------|
| `-shd` | Pokémon Showdown sprites (GIF), Pokémon #1-982 |
| `-gen5` | Generation V sprites (PNG), Pokémon #1-643 only |

### Automatic (recommended)

Run one of these. It clones the repo to `~/pokescripts` and adds the startup lines to your `~/.zshrc` or `~/.bashrc` automatically. It detects your shell and won't add the lines twice.

Showdown sprites:

```bash
curl -fsSL https://raw.githubusercontent.com/Neuralized3/pokescripts/main/install.sh | bash -s -- -shd
```

Generation V sprites:

```bash
curl -fsSL https://raw.githubusercontent.com/Neuralized3/pokescripts/main/install.sh | bash -s -- -gen5
```

If you leave off the style, the installer asks you to choose (and defaults to `-shd`).

Already cloned the repo? Run the installer from inside it:

```bash
bash ~/pokescripts/install.sh -shd     # or -gen5
```

To switch styles later, just run the installer again with the other style. It replaces the old setup instead of duplicating it.

### Manual

1. Clone the repo into your home directory under the name `pokescripts`:

   ```bash
   git clone https://github.com/Neuralized3/pokescripts.git ~/pokescripts
   ```

2. Add the alias and startup command to your shell config (`~/.zshrc` for zsh, `~/.bashrc` for bash). Choose **one** of the two `pokemon` lines.

   ```bash
   alias pokemon='python3 ~/pokescripts/pokemon.py'
   pokemon -shd      # Showdown sprites (GIF)
   # pokemon -gen5   # Generation V sprites (PNG)
   ```

   Or append it with one command (swap `-shd` for `-gen5` if you want Gen V). For zsh:

   ```bash
   printf "\n# pokescripts\nalias pokemon='python3 ~/pokescripts/pokemon.py'\npokemon -shd\n" >> ~/.zshrc
   ```

   For bash:

   ```bash
   printf "\n# pokescripts\nalias pokemon='python3 ~/pokescripts/pokemon.py'\npokemon -shd\n" >> ~/.bashrc
   ```

3. Reload your shell config (or just open a new kitty window):

   ```bash
   source ~/.zshrc   # or ~/.bashrc
   ```

A random sprite will now appear whenever kitty starts.

## Usage

```
Usage: pokemon <style> [name]
Styles:
  -gen5    Generation V sprites (PNG), Pokémon #1-649 only
  -shd     Pokémon Showdown sprites (GIF), Pokémon #1-1025
Examples:
  pokemon -gen5              random Gen V sprite (png)
  pokemon -shd               random Showdown sprite (gif)
  pokemon -shd pikachu       a specific Pokémon
  pokemon -gen5 articuno     names match the file names
                             (nidoran-f, articuno, ho-oh)
```

## License

The code in this repository is released under the [MIT License](LICENSE).

The MIT License covers the code only. It does **not** cover the sprite images.

## Disclaimer

This is an unofficial, non-commercial fan project. Pokémon and all related names, characters, and sprites are trademarks and copyrights of Nintendo, Game Freak, and Creatures Inc. This project is not affiliated with or endorsed by them.

Sprite sources and credits:

- [PokeAPI](https://github.com/PokeAPI/sprites) for the Generation V sprites
- [Pokémon Showdown](https://play.pokemonshowdown.com/) / Smogon and its sprite artists for the Showdown sprites
