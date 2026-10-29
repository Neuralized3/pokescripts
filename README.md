# pokescripts

A small script that shows a random Pokémon sprite in the [kitty](https://sw.kovidgoyal.net/kitty/) terminal every time it starts.

## Requirements

- Python 3
- kitty terminal

## Installation

### Automatic (recommended)

Run this single command. It clones the repo to `~/pokescripts` and adds the startup lines to your `~/.zshrc` or `~/.bashrc` automatically (it detects your shell and won't add them twice):

```bash
curl -fsSL https://raw.githubusercontent.com/<your-username>/pokescripts/main/install.sh | bash
```

Already cloned the repo? Run the installer from inside it instead:

```bash
bash ~/pokescripts/install.sh
```

### Manual

1. Clone the repo into your home directory under the name `pokescripts`:

   ```bash
   git clone https://github.com/<your-username>/pokescripts.git ~/pokescripts
   ```

2. Append the startup lines to your shell config with one command.

   For zsh:

   ```bash
   printf "\n# pokescripts\nalias pokemon='python3 ~/pokescripts/pokemon.py'\npokemon -shd\n" >> ~/.zshrc
   ```

   For bash:

   ```bash
   printf "\n# pokescripts\nalias pokemon='python3 ~/pokescripts/pokemon.py'\npokemon -shd\n" >> ~/.bashrc
   ```

   Or edit the file yourself and add these lines at the end:

   ```bash
   alias pokemon='python3 ~/pokescripts/pokemon.py'
   pokemon -shd
   ```

3. Reload your shell config (or just open a new kitty window):

   ```bash
   source ~/.zshrc   # or ~/.bashrc
   ```

A random sprite will now appear whenever kitty starts. Change `-shd` to `-gen5` in your config if you prefer the Generation V style.

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
