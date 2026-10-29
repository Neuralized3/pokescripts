#!/usr/bin/env bash
# pokescripts installer: clones the repo and adds the startup lines to your shell config.
# Usage: bash install.sh [-shd | -gen5]
set -e

REPO_URL="https://github.com/neuralized3/pokescripts.git"
DEST="$HOME/pokescripts"
STYLE="$1"

# 1. Choose the sprite style (argument, prompt, or default)
if [ -z "$STYLE" ]; then
  if { : > /dev/tty; } 2>/dev/null; then
    echo "Which sprite style do you want on startup?"
    echo "  1) -shd   Pokémon Showdown sprites (GIF)"
    echo "  2) -gen5  Generation V sprites (PNG)"
    printf "Choose [1/2] (default 1): " > /dev/tty
    read -r CHOICE < /dev/tty || CHOICE=""
    case "$CHOICE" in
      2|-gen5|gen5) STYLE="-gen5" ;;
      *)            STYLE="-shd" ;;
    esac
  else
    STYLE="-shd"
  fi
fi
case "$STYLE" in
  -shd|-gen5) ;;
  *) echo "Invalid style '$STYLE'. Use -shd or -gen5."; exit 1 ;;
esac

# 2. Clone (or update) the repo
if [ -d "$DEST/.git" ]; then
  git -C "$DEST" pull
else
  git clone "$REPO_URL" "$DEST"
fi

# 3. Pick the shell config file
case "$(basename "$SHELL")" in
  zsh)  RC="$HOME/.zshrc" ;;
  bash) RC="$HOME/.bashrc" ;;
  *)    echo "Unsupported shell: $SHELL. Add the lines from the README manually."; exit 1 ;;
esac
touch "$RC"

# 4. Remove any old pokescripts block, then add the new one
if grep -q "^# pokescripts$" "$RC"; then
  awk '/^# pokescripts$/{skip=3} skip>0{skip--; next} {print}' "$RC" \
    | awk 'NF{for(i=0;i<b;i++)print ""; b=0; print; next} {b++}' > "$RC.tmp" && mv "$RC.tmp" "$RC"
  echo "Updated existing pokescripts setup in $RC"
else
  echo "Added pokescripts to $RC"
fi

cat >> "$RC" << EOT

# pokescripts
alias pokemon='python3 ~/pokescripts/pokemon.py'
pokemon $STYLE
EOT

echo "Done ($STYLE). Open a new kitty window or run: source $RC"
