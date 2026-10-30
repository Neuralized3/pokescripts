import random
from list import gen5List
import os
import subprocess
import sys
import fcntl
import struct
import termios
SCALE = 1.3
PAD_LEFT = 5
PAD_RIGHT = 8


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