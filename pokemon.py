
import os
import random
import subprocess
import sys

from list import shdList,gen5List


# Find the pokescripts directory.
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


# Handle command-line arguments.
if len(sys.argv) == 1:
    print("Type pokemon -help to see the guide.")

elif len(sys.argv) == 2:
    if sys.argv[1] == "-gen5":
        os.chdir("gen5")
        poke = random.randrange(1, 644)

        subprocess.run(
            f"kitty +kitten icat --align left {gen5List[poke]}.png",
            shell=True,
        )

    elif sys.argv[1] == "-shd":
        os.chdir("showdown")
        poke = random.randrange(1, 983)

        subprocess.run(
            f"kitty +kitten icat --align left {shdList[poke]}.gif",
            shell=True,
        )

    elif sys.argv[1] == "-help":
        print(
            """Usage: pokemon <style> [name]
Styles:
  -gen5    Generation V sprites (PNG), Pokémon #1-643 only (Not according to pokedex.)
  -shd     Pokémon Showdown sprites (GIF), Pokémon #1-982 (Not according to pokedex.)
Examples:
  pokemon -gen5              random Gen V sprite (png)
  pokemon -shd               random Showdown sprite (gif)
  pokemon -shd pikachu       a specific Pokémon
  pokemon -gen5 articuno     names match the file names
                              (nidoran-f, articuno, ho-oh)"""
        )

    else:
        print(
            "Enter a valid artstyle, "
            "type pokemon -help to see possible artstyles."
        )

elif len(sys.argv) == 3:
    name = sys.argv[2]
    if sys.argv[1] =="-gen5":
        if name in gen5List.values():
            os.chdir("gen5")
            subprocess.run(f"kitty +kitten icat --align left {name}.png",shell=True,)
        else:
            print("Either pokemon doesn't exist or the name is incorrect, please type in lowercase.")
    elif sys.argv[1] == "-shd":
        if name in shdList.values():
            os.chdir("showdown")
            subprocess.run(f"kitty +kitten icat --align left {name}.gif",shell=True,)
        else:
            print("Either pokemon doesn't exist or the name is incorrect, please type in lowercase.")
    else:
        print("Enter the correct Artstyle.")
else:
    poke = shdList[random.randrange(1,983)]

    phrases = [
        f"Darn! The wild POKéMON {poke} broke free",
        f"Oh no! {poke} broke free!",
        f"Aww! {poke} appeared to be caught!",
        f"Aargh! Almost had the {poke}!",
        f"Gah! {poke} was so close to being caught!",
    ]

    print(f"Error lol anyways, {phrases[random.randrange(0, 5)]}")
