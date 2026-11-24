#!/bin/sh
set -eu

source_dir=$(CDPATH= cd "$(dirname "$0")/../bin" && pwd)
install_dir="$HOME/.local/bin"

mkdir -p "$install_dir"
for command_file in "$source_dir"/enjamer-*; do
  install -m 755 "$command_file" "$install_dir/${command_file##*/}"
done

register_path() {
  profile=$1
  if [ -f "$profile" ] && grep -Fqx '# Enjamer CLI PATH' "$profile"; then
    return
  fi
  cat >> "$profile" <<'PROFILE'

# Enjamer CLI PATH
case ":${PATH:-}:" in
  *":$HOME/.local/bin:"*) ;;
  *) export PATH="$HOME/.local/bin${PATH:+:$PATH}" ;;
esac
PROFILE
}

# Bash reads the first available login profile and uses .bashrc for
# interactive non-login shells.
login_profile="$HOME/.profile"
for candidate in "$HOME/.bash_profile" "$HOME/.bash_login"; do
  if [ -r "$candidate" ]; then
    login_profile=$candidate
    break
  fi
done

register_path "$login_profile"
register_path "$HOME/.bashrc"

zsh_profile="${ZDOTDIR:-$HOME}/.zshrc"
case "${SHELL:-}" in
  */zsh) register_path "$zsh_profile" ;;
  *) if [ -f "$zsh_profile" ]; then register_path "$zsh_profile"; fi ;;
esac

printf 'Enjamer commands installed in %s. Open a new terminal to use them.\n' "$install_dir"
