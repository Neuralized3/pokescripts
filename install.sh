#!/usr/bin/env bash
# pokescripts installer
# Clones the repo and adds the aliases you choose to your shell config
# (~/.zshrc or ~/.bashrc), plus an optional command that runs on terminal start.
#
# Usage: bash install.sh [what to install] [art style] [startup] 
#
#   What to install (default: ask)
#     -pokemon      the `pokemon` sprite command
#     -pokefetch    the `pokefetch` command (fastfetch + Gen V Pokémon logo)
#     -both         both commands
#
#   Art style for pokemon (default: ask)
#     -shd          Pokémon Showdown sprites (GIF)
#     -gen5         Generation V sprites (PNG)
#
#   What runs when a terminal opens (default: the one thing you installed;
#   with -both you are asked)
#     -startup=pokemon | -startup=pokefetch | -startup=none
#
#   Other
#     -uninstall    remove the pokescripts block from your shell config
#     -h            show this help
#
# Examples:
#   bash install.sh                      interactive
#   bash install.sh -pokemon -shd        pokemon, Showdown sprites on startup
#   bash install.sh -pokefetch           pokefetch on startup
#   bash install.sh -both -gen5 -startup=pokefetch
#   bash install.sh -shd                 same as -pokemon -shd
set -e

REPO_URL="https://github.com/Neuralized3/pokescripts.git"
DEST="$HOME/pokescripts"
BEGIN="# >>> pokescripts >>>"
END="# <<< pokescripts <<<"

TARGET=""     # pokemon | pokefetch | both
STYLE=""      # -shd | -gen5
STARTUP=""    # pokemon | pokefetch | none
UNINSTALL=0

usage() {
  sed -n '2,32p' "$0" | sed 's/^# \{0,1\}//'
}

# Set VAR ($1) to VALUE ($2), but complain if it was already set differently.
set_once() {
  local cur="${!1}"
  if [ -n "$cur" ] && [ "$cur" != "$2" ]; then
    echo "Conflicting options: '$cur' and '$2'."
    exit 1
  fi
  printf -v "$1" '%s' "$2"
}

# ---------------------------------------------------------------- 1. Arguments
for arg in "$@"; do
  case "$arg" in
    -pokemon|-pokefetch|-both) set_once TARGET "${arg#-}" ;;
    -shd|-gen5)                set_once STYLE "$arg" ;;
    -startup=pokemon|-startup=pokefetch|-startup=none)
                               set_once STARTUP "${arg#-startup=}" ;;
    -none)                     # legacy: aliases only
                               set_once TARGET "both"; set_once STARTUP "none" ;;
    -uninstall)                UNINSTALL=1 ;;
    -h|-help|--help)           usage; exit 0 ;;
    *)
      echo "Unknown option '$arg'."
      usage
      exit 1
      ;;
  esac
done

# ------------------------------------------------------- 2. Pick shell config
case "$(basename "${SHELL:-}")" in
  zsh)  RC="$HOME/.zshrc" ;;
  bash) RC="$HOME/.bashrc" ;;
  *)
    echo "Unsupported shell: ${SHELL:-unknown}. Use the manual steps in the README."
    exit 1
    ;;
esac

# Remove any previous pokescripts block (new format and the old 3-line format).
strip_block() {
  [ -f "$RC" ] || return 0
  awk -v b="$BEGIN" -v e="$END" '
    $0 == b { skip = 1; next }
    $0 == e { skip = 0; next }
    skip    { next }
    /^# pokescripts$/ { legacy = 3 }
    legacy > 0 { legacy--; next }
    { print }
  ' "$RC" \
    | awk 'NF { for (i = 0; i < n; i++) print ""; n = 0; print; next } { n++ }' \
    > "$RC.tmp"
  cat "$RC.tmp" > "$RC"   # cat (not mv) so a symlinked rc file stays a symlink
  rm -f "$RC.tmp"
}

has_block() {
  [ -f "$RC" ] && grep -qE "^(# >>> pokescripts >>>|# pokescripts)$" "$RC"
}

# ------------------------------------------------------------- 3. Uninstall
if [ "$UNINSTALL" -eq 1 ]; then
  if has_block; then
    cp "$RC" "$RC.pokescripts.bak"
    strip_block
    echo "Removed pokescripts from $RC (backup: $RC.pokescripts.bak)"
  else
    echo "No pokescripts setup found in $RC"
  fi
  echo "The repo in $DEST was left alone. Delete it with: rm -rf $DEST"
  exit 0
fi

# ------------------------------------------------------ 4. Ask what to install
HAVE_TTY=0
if { : > /dev/tty; } 2>/dev/null; then HAVE_TTY=1; fi

# A style on its own (the old `-shd` / `-gen5` usage) means "pokemon".
if [ -z "$TARGET" ] && [ -n "$STYLE" ]; then
  TARGET="pokemon"
fi

# 4a. What to install
if [ -z "$TARGET" ]; then
  if [ "$HAVE_TTY" -eq 1 ]; then
    cat > /dev/tty << 'EOT'
What do you want to install?
  1) pokemon     random Pokémon sprite in your terminal
  2) pokefetch   fastfetch with a random Gen V Pokémon as the logo
  3) both
EOT
    printf "Choose [1-3] (default 1): " > /dev/tty
    read -r CHOICE < /dev/tty || CHOICE=""
    case "$CHOICE" in
      2|pokefetch|-pokefetch) TARGET="pokefetch" ;;
      3|both|-both)           TARGET="both" ;;
      *)                      TARGET="pokemon" ;;
    esac
  else
    TARGET="pokemon"
  fi
fi

# 4b. Art style (only matters for pokemon)
if [ "$TARGET" = "pokefetch" ]; then
  if [ -n "$STYLE" ]; then
    echo "Note: ignoring $STYLE, pokefetch always uses Generation V sprites."
    STYLE=""
  fi
elif [ -z "$STYLE" ]; then
  if [ "$HAVE_TTY" -eq 1 ]; then
    cat > /dev/tty << 'EOT'

Which art style should pokemon use?
  1) -shd    Pokémon Showdown sprites (GIF, animated)
  2) -gen5   Generation V sprites (PNG)
EOT
    printf "Choose [1-2] (default 1): " > /dev/tty
    read -r CHOICE < /dev/tty || CHOICE=""
    case "$CHOICE" in
      2|-gen5|gen5) STYLE="-gen5" ;;
      *)            STYLE="-shd" ;;
    esac
  else
    STYLE="-shd"
  fi
fi

# 4c. What runs when a terminal opens
if [ -z "$STARTUP" ]; then
  case "$TARGET" in
    pokemon|pokefetch) STARTUP="$TARGET" ;;
    both)
      if [ "$HAVE_TTY" -eq 1 ]; then
        cat > /dev/tty << 'EOT'

Both will be installed. Which one should run when a terminal opens?
  1) pokemon
  2) pokefetch
  3) neither (I'll run them by hand)
EOT
        printf "Choose [1-3] (default 1): " > /dev/tty
        read -r CHOICE < /dev/tty || CHOICE=""
        case "$CHOICE" in
          2|pokefetch) STARTUP="pokefetch" ;;
          3|none|neither) STARTUP="none" ;;
          *)           STARTUP="pokemon" ;;
        esac
      else
        STARTUP="pokemon"
      fi
      ;;
  esac
fi

if [ "$STARTUP" = "pokemon" ] && [ "$TARGET" = "pokefetch" ]; then
  echo "Error: -startup=pokemon, but pokemon is not being installed."; exit 1
fi
if [ "$STARTUP" = "pokefetch" ] && [ "$TARGET" = "pokemon" ]; then
  echo "Error: -startup=pokefetch, but pokefetch is not being installed."; exit 1
fi

# ----------------------------------------------------- 5. Check prerequisites
missing=0
for tool in git python3; do
  if ! command -v "$tool" > /dev/null 2>&1; then
    echo "Error: '$tool' is required but not installed."
    missing=1
  fi
done
[ "$missing" -eq 0 ] || exit 1

if ! command -v kitty > /dev/null 2>&1; then
  echo "Warning: kitty not found. Sprites are drawn with kitty's image protocol."
fi

if [ "$TARGET" != "pokemon" ] && ! command -v fastfetch > /dev/null 2>&1; then
  echo "Warning: fastfetch not found, but pokefetch needs it. Install it:"
  echo "  Debian/Ubuntu: sudo apt install fastfetch"
  echo "  Arch:          sudo pacman -S fastfetch"
  echo "  Fedora:        sudo dnf install fastfetch"
  echo "  macOS:         brew install fastfetch"
fi

# ----------------------------------------------------- 6. Clone or update repo
if [ -d "$DEST/.git" ]; then
  git -C "$DEST" pull
else
  git clone "$REPO_URL" "$DEST"
fi

# ---------------------------------------------------- 7. Write the shell block
touch "$RC"
if has_block; then
  cp "$RC" "$RC.pokescripts.bak"
  strip_block
  echo "Updated existing pokescripts setup in $RC (backup: $RC.pokescripts.bak)"
else
  echo "Added pokescripts to $RC"
fi

{
  echo ""
  echo "$BEGIN"
  if [ "$TARGET" != "pokefetch" ]; then
    echo "alias pokemon='python3 ~/pokescripts/pokemon.py'"
  fi
  if [ "$TARGET" != "pokemon" ]; then
    echo "alias pokefetch='python3 ~/pokescripts/pokefetch.py'"
  fi
  case "$STARTUP" in
    pokemon)   echo "pokemon $STYLE" ;;
    pokefetch) echo "pokefetch" ;;
  esac
  echo "$END"
} >> "$RC"

# ------------------------------------------------------------------ 8. Done
echo ""
echo "Installed: $TARGET${STYLE:+ ($STYLE)}   |   runs on startup: $STARTUP"
echo "Open a new kitty window or run: source $RC"
if [ "$TARGET" != "pokemon" ]; then
  echo "Tip: change the pokefetch logo size/padding via SCALE, PAD_LEFT and PAD_RIGHT"
  echo "     at the top of $DEST/pokefetch.py"
fi