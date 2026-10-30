import random
from list import gen5List
import os
import subprocess
import sys
import fcntl
import struct
import termios

# Defaults. Override per run with flags, or set POKEFETCH_SCALE in your shell
# config (see: pokefetch -help).
try:
    SCALE = float(os.environ.get("POKEFETCH_SCALE", 1.3))
except ValueError:
    SCALE = 1.3
PAD_LEFT = 5
PAD_RIGHT = 8

HELP = f"""Usage: pokefetch [options] [name]
Runs fastfetch with a Generation V Pokémon as the logo.
Options:
  --scale N        logo size multiplier (default {SCALE}; 1 = native pixels)
  --pad-left N     blank columns left of the logo (default {PAD_LEFT})
  --pad-right N    blank columns between the logo and the info (default {PAD_RIGHT})
  -help            show this guide
Examples:
  pokefetch                              random Pokémon
  pokefetch charizard                    a specific Pokémon
  pokefetch --scale 2 pikachu            bigger
  pokefetch --scale 0.8                  smaller, random Pokémon
  pokefetch --pad-left 0 --pad-right 2   compact layout
  pokefetch nidoran-f                    names are lowercase and match the
                                         file names (nidoran-f, ho-oh)
Ideas:
  export POKEFETCH_SCALE=2               your default size, put it in ~/.zshrc
                                         or ~/.bashrc
  alias pf='pokefetch --scale 1.8'       a shortcut with your favourite settings
  pokefetch --scale 3 mewtwo             a big showpiece
  pokefetch --scale 1 --pad-left 0       tiny logo, hugging the left edge"""


def pop_option(flag, cast, current, minimum):
    """Remove `flag VALUE` from sys.argv and return VALUE (or `current`)."""
    if flag not in sys.argv:
        return current
    i = sys.argv.index(flag)
    try:
        value = cast(sys.argv[i + 1])
        if value < minimum or (flag == "--scale" and value == 0):
            raise ValueError
    except (IndexError, ValueError):
        sys.exit(f"Invalid value for {flag}, type pokefetch -help to see the guide.")
    del sys.argv[i:i + 2]
    return value


def logo_flags(name):
    with open(f"{name}.png", "rb") as f:
        w, h = struct.unpack(">II", f.read(24)[16:24])

    cw, ch = 10, 20
    try:
        rows, cols, xpix, ypix = struct.unpack(
            "HHHH", fcntl.ioctl(sys.stdout.fileno(), termios.TIOCGWINSZ, b"\0" * 8)
        )
        if rows and cols and xpix and ypix:
            cw, ch = xpix / cols, ypix / rows
    except OSError:
        pass

    width = max(1, round(w * SCALE / cw))
    height = max(1, round(h * SCALE / ch))

    return (
        f"--logo-type kitty-icat --logo {name}.png "
        f"--logo-width {width} --logo-height {height} "
        f"--logo-padding-left {PAD_LEFT} --logo-padding-right {PAD_RIGHT}"
    )

def find_pokescripts():
    home = os.path.expanduser("~")

    direct = os.path.join(home, "pokescripts")
    if os.path.isdir(direct):
        return direct

    for root, dirs, files in os.walk(home):
        if "pokescripts" in dirs:
            return os.path.join(root, "pokescripts")

        dirs[:] = [d for d in dirs if not d.startswith(".")]

    return None


# Help first, so it works even if the folder can't be found.
if any(a in sys.argv[1:] for a in ("-help", "--help", "-h")):
    print(HELP)
    sys.exit(0)

# Pull the option flags out of sys.argv so only the Pokémon name is left.
SCALE = pop_option("--scale", float, SCALE, 0)
PAD_LEFT = pop_option("--pad-left", int, PAD_LEFT, 0)
PAD_RIGHT = pop_option("--pad-right", int, PAD_RIGHT, 0)

path = find_pokescripts()
if path is None:
    sys.exit("pokescripts folder not found")
os.chdir(path)


if len(sys.argv) == 1:
    poke = random.randrange(1,644)
    os.chdir("gen5")
    subprocess.run(f"fastfetch {logo_flags(gen5List[poke])}",shell=True)
elif len(sys.argv) == 2:
    name = sys.argv[1]
    if name in gen5List.values():
        os.chdir("gen5")
        subprocess.run(f"fastfetch {logo_flags(name)}",shell=True)
    else:
        print("Pokemon not found, type in lowercase.")
else:
    print("Enter the correct number of arguments.")