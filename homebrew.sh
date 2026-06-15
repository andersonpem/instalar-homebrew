#!/usr/bin/env bash
set -euo pipefail

BREW_INSTALL_URL="https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh"
BREW_MARKER_START="# >>> homebrew setup >>>"
BREW_MARKER_END="# <<< homebrew setup <<<"

detect_language() {
  local locale_value="${LANG:-${LC_ALL:-${LC_MESSAGES:-}}}"

  case "$locale_value" in
    pt_*|pt-*)
      echo "pt"
      ;;
    *)
      echo "en"
      ;;
  esac
}

LANGUAGE="$(detect_language)"

msg() {
  local key="$1"

  case "$LANGUAGE:$key" in
    pt:detected_os)
      echo "Sistema operacional detectado:"
      ;;
    en:detected_os)
      echo "Detected operating system:"
      ;;

    pt:unsupported_os)
      echo "Sistema operacional não suportado:"
      ;;
    en:unsupported_os)
      echo "Unsupported operating system:"
      ;;

    pt:brew_already_installed)
      echo "O Homebrew já está instalado."
      ;;
    en:brew_already_installed)
      echo "Homebrew is already installed."
      ;;

    pt:curl_required)
      echo "O curl é necessário, mas não foi encontrado. Instale o curl e execute este script novamente."
      ;;
    en:curl_required)
      echo "curl is required but was not found. Install curl first, then run this script again."
      ;;

    pt:installing_brew)
      echo "Instalando o Homebrew."
      ;;
    en:installing_brew)
      echo "Installing Homebrew."
      ;;

    pt:brew_not_found_after_install)
      echo "A instalação do Homebrew terminou, mas o comando brew não foi encontrado."
      ;;
    en:brew_not_found_after_install)
      echo "Homebrew installation finished, but the brew command could not be found."
      ;;

    pt:using_brew_binary)
      echo "Usando o binário do Homebrew:"
      ;;
    en:using_brew_binary)
      echo "Using Homebrew binary:"
      ;;

    pt:created_file)
      echo "Arquivo criado:"
      ;;
    en:created_file)
      echo "Created file:"
      ;;

    pt:added_shell_config)
      echo "Configuração do Homebrew adicionada em:"
      ;;
    en:added_shell_config)
      echo "Added Homebrew setup to:"
      ;;

    pt:brew_ready)
      echo "Homebrew está pronto."
      ;;
    en:brew_ready)
      echo "Homebrew is ready."
      ;;

    pt:open_new_terminal)
      echo "Abra uma nova janela do terminal e execute:"
      ;;
    en:open_new_terminal)
      echo "Open a new terminal window, then run:"
      ;;

    *)
      echo "$key"
      ;;
  esac
}

info() {
  printf "\033[1;34m[info]\033[0m %s\n" "$1"
}

success() {
  printf "\033[1;32m[ok]\033[0m %s\n" "$1"
}

warn() {
  printf "\033[1;33m[warn]\033[0m %s\n" "$1"
}

fail() {
  printf "\033[1;31m[error]\033[0m %s\n" "$1" >&2
  exit 1
}

command_exists() {
  command -v "$1" >/dev/null 2>&1
}

detect_os() {
  case "$(uname -s)" in
    Darwin)
      echo "macos"
      ;;
    Linux)
      echo "linux"
      ;;
    *)
      fail "$(msg unsupported_os) $(uname -s)."
      ;;
  esac
}

detect_brew_binary() {
  if command_exists brew; then
    command -v brew
    return 0
  fi

  local candidates=(
    "/opt/homebrew/bin/brew"
    "/usr/local/bin/brew"
    "/home/linuxbrew/.linuxbrew/bin/brew"
    "$HOME/.linuxbrew/bin/brew"
  )

  for candidate in "${candidates[@]}"; do
    if [ -x "$candidate" ]; then
      echo "$candidate"
      return 0
    fi
  done

  return 1
}

ensure_file_exists() {
  local file="$1"

  if [ ! -f "$file" ]; then
    touch "$file"
    success "$(msg created_file) $file"
  fi
}

remove_old_homebrew_block() {
  local file="$1"

  if grep -qF "$BREW_MARKER_START" "$file"; then
    awk "
      BEGIN { skip = 0 }
      \$0 == \"$BREW_MARKER_START\" { skip = 1; next }
      \$0 == \"$BREW_MARKER_END\" { skip = 0; next }
      skip == 0 { print }
    " "$file" > "$file.tmp"

    mv "$file.tmp" "$file"
  fi
}

add_homebrew_to_shell_file() {
  local file="$1"
  local brew_binary="$2"

  ensure_file_exists "$file"
  remove_old_homebrew_block "$file"

  cat >> "$file" <<EOF

$BREW_MARKER_START
if [ -x "$brew_binary" ]; then
  eval "\$($brew_binary shellenv)"
fi
$BREW_MARKER_END
EOF

  success "$(msg added_shell_config) $file"
}

install_homebrew() {
  if detect_brew_binary >/dev/null 2>&1; then
    success "$(msg brew_already_installed)"
    return 0
  fi

  if ! command_exists curl; then
    fail "$(msg curl_required)"
  fi

  info "$(msg installing_brew)"
  /bin/bash -c "$(curl -fsSL "$BREW_INSTALL_URL")"
}

main() {
  local os
  local brew_binary

  os="$(detect_os)"
  info "$(msg detected_os) $os"

  install_homebrew

  if ! brew_binary="$(detect_brew_binary)"; then
    fail "$(msg brew_not_found_after_install)"
  fi

  info "$(msg using_brew_binary) $brew_binary"

  add_homebrew_to_shell_file "$HOME/.zshrc" "$brew_binary"
  add_homebrew_to_shell_file "$HOME/.bashrc" "$brew_binary"

  eval "$("$brew_binary" shellenv)"

  success "$(msg brew_ready)"

  if command_exists brew; then
    brew --version
  else
    warn "$(msg open_new_terminal) brew --version"
  fi
}

main "$@"