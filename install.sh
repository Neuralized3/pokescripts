#!/usr/bin/env bash
# pokescripts installer: clones the repo and adds the startup lines to your shell config.
set -e

REPO_URL="https://github.com/<your-username>/pokescripts.git"
DEST="$HOME/pokescripts"

# 1. Clone (or update) the repo
if [ -d "$DEST/.git" ]; then
  git -C "$DEST" pull
else
  git clone "$REPO_URL" "$DEST"
fi

# 2. Pick the shell config file
case "$(basename "$SHELL")" in
  zsh)  RC="$HOME/.zshrc" ;;
  bash) RC="$HOME/.bashrc" ;;
  *)    echo "Unsupported shell: $SHELL. Add the lines from the README manually."; exit 1 ;;
esac

# 3. Add the alias and startup command (only once)
if grep -q "# pokescripts" "$RC" 2>/dev/null; then
  echo "Already installed in $RC"
else
  cat >> "$RC" << 'EOT'

# pokescripts
alias pokemon='python3 ~/pokescripts/pokemon.py'
pokemon -shd
EOT
  echo "Added pokescripts to $RC"
fi

echo "Done. Open a new kitty window or run: source $RC"
