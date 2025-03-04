#!/bin/bash

# Set up directories
PREFIX="$HOME/.helix-starter"

# Create the prefix directory if it doesn't exist
mkdir -p "$PREFIX"

INSTALL_DIR="$PREFIX/bin"
TEMP_DIR="$PREFIX/tmp"
HELIX_DIR="$PREFIX/helix"
NODEJS_DIR="$PREFIX/nodejs"
ZELLIJ_DIR="$PREFIX/zellij"
FD_DIR="$PREFIX/fd"
RG_DIR="$PREFIX/rg"
BAT_DIR="$PREFIX/bat"
FZF_DIR="$PREFIX/fzf"
LAZYGIT_DIR="$PREFIX/lazygit"
ZOXIDE_DIR="$PREFIX/zoxide"
YAZI_DIR="$PREFIX/yazi"
HELIX_CONFIG_DIR="$HOME/.config/helix"
NVIM_CONFIG_DIR="$HOME/.config/nvim"
TMUX_CONFIG_DIR="$HOME/.config/tmux"
ZELLIJ_CONFIG_DIR="$HOME/.config/zellij"
LSP_DIR="$PREFIX/lsp"

# URLs for tools
HELIX_URL="https://github.com/helix-editor/helix/releases/download/25.01.1/helix-25.01.1-x86_64-linux.tar.xz"
NODEJS_URL="https://nodejs.org/dist/v22.14.0/node-v22.14.0-linux-x64.tar.xz"
ZELLIJ_URL="https://github.com/zellij-org/zellij/releases/download/v0.41.2/zellij-x86_64-unknown-linux-musl.tar.gz"
FD_URL="https://github.com/sharkdp/fd/releases/download/v10.2.0/fd-v10.2.0-x86_64-unknown-linux-musl.tar.gz"
RG_URL="https://github.com/BurntSushi/ripgrep/releases/download/14.1.1/ripgrep-14.1.1-x86_64-unknown-linux-musl.tar.gz"
BAT_URL="https://github.com/sharkdp/bat/releases/download/v0.25.0/bat-v0.25.0-x86_64-unknown-linux-musl.tar.gz"
FZF_URL="https://github.com/junegunn/fzf/releases/download/v0.60.3/fzf-0.60.3-linux_amd64.tar.gz"
LAZYGIT_URL="https://github.com/jesseduffield/lazygit/releases/download/v0.48.0/lazygit_0.48.0_Linux_x86_64.tar.gz"
ZOXIDE_URL="https://github.com/ajeetdsouza/zoxide/releases/download/v0.9.7/zoxide-0.9.7-x86_64-unknown-linux-musl.tar.gz"
YAZI_URL="https://github.com/sxyazi/yazi/releases/download/v25.3.2/yazi-x86_64-unknown-linux-musl.zip"

# Configuration repositories
NVIM_CONFIG_REPO="https://github.com/yilinfang/nvim.git"
HELIX_CONFIG_REPO="https://github.com/yilinfang/helix.git"
TMUX_CONFIG_REPO="https://github.com/yilinfang/tmux.git"
ZELLIJ_CONFIG_REPO="https://github.com/yilinfang/zellij.git"

# Installation tracking variables
UPDATE_SHELL_CONFIGURATION=0

# Function to display menu and get user selection
show_menu() {
  echo "Select tools to install (enter numbers separated by space, or use letter 't', 'z', 'a' for tool bundle):"
  echo "1. Helix"
  echo "2. Node.js"
  echo "3. Zellij"
  echo "4. fd"
  echo "5. ripgrep"
  echo "6. bat"
  echo "7. fzf"
  echo "8. lazygit"
  echo "9. zoxide"
  echo "10. Yazi"
  echo "11. Neovim config"
  echo "12. tmux config"
  echo "13. Zellij config"
  echo "t. Tool bundle with Oh my tmux!"
  echo "z. Tool bundle with Zellij"
  echo "a. Install all"
  echo "i. Initialize shell configuration"

  read -p "Your choice: " CHOICE
}

# Installation functions
install_helix() {
  echo "Installing Helix..."
    rm -rf "$HELIX_DIR"
    mkdir -p "$HELIX_DIR"
    curl -L "$HELIX_URL" -o "$TEMP_DIR/helix.tar.xz"
    tar -xf "$TEMP_DIR/helix.tar.xz" -C "$HELIX_DIR" --strip-components=1
    
    HX_BINARY=$(find "$HELIX_DIR" -type f -name "hx" | head -n 1)
    if [ -z "$HX_BINARY" ]; then
      echo "Error: Helix binary not found in the extracted files."
      return
    fi

    # Create a wrapper script to launch Helix with the isolated Node.js environment
    tee "$INSTALL_DIR/hx" <<EOF
#!/bin/bash

# Add Node.js to PATH if system Node.js is not available
if ! command -v node >/dev/null; then
export PATH=$NODEJS_DIR/bin:\$PATH
fi

# Import LSP servers to PATH
if [ -d "$LSP_DIR" ]; then
export PATH=$LSP_DIR/bin:\$PATH
fi

exec $HX_BINARY "\$@"
EOF

    chmod +x "$INSTALL_DIR/hx"
    echo "Created wrapper script for Helix at $INSTALL_DIR/hx"
    UPDATE_SHELL_CONFIGURATION=1
}

install_nodejs() {
  echo "Installing Node.js..."
  rm -rf "$NODEJS_DIR"
  mkdir -p "$NODEJS_DIR"
  curl -L "$NODEJS_URL" -o "$TEMP_DIR/node.tar.xz"
  tar -xf "$TEMP_DIR/node.tar.xz" -C "$NODEJS_DIR" --strip-components=1
  echo "Node.js installed in $NODEJS_DIR. It will not be added to the system PATH. You have to do it yourself, if needed."
  UPDATE_SHELL_CONFIGURATION=1
}

install_zellij() {
  echo "Installing Zellij..."
  rm -rf "$ZELLIJ_DIR"
  mkdir -p "$ZELLIJ_DIR"
  curl -L "$ZELLIJ_URL" -o "$TEMP_DIR/zellij.tar.gz"
  tar -xzf "$TEMP_DIR/zellij.tar.gz" -C "$ZELLIJ_DIR"
  ZELLIJ_BINARY=$(find "$ZELLIJ_DIR" -type f -name "zellij" | head -n 1) 
  if [ -n "$ZELLIJ_BINARY" ]; then
    # Create a symbolic link to the Zellij binary
    ln -s "$ZELLIJ_DIR/zellij" "$INSTALL_DIR/zellij"
    echo "Created link to Zellij at $INSTALL_DIR/zellij"
    UPDATE_SHELL_CONFIGURATION=1
  else
    echo "Error: Zellij binary not found in the extracted files."
    return
  fi
}

install_fd() {
  echo "Installing fd..."
  rm -rf "$FD_DIR"
  mkdir -p "$FD_DIR"
  curl -L "$FD_URL" -o "$TEMP_DIR/fd.tar.gz"
  tar -xzf "$TEMP_DIR/fd.tar.gz" -C "$FD_DIR"
  FD_BINARY=$(find "$FD_DIR" -type f -name "fd" | head -n 1)
  if [ -n "$FD_BINARY" ]; then
    # Create a symbolic link to the fd binary
    ln -s "$FD_BINARY" "$INSTALL_DIR/fd"
    echo "Created link to fd at $INSTALL_DIR/fd"
    UPDATE_SHELL_CONFIGURATION=1
  else
    echo "Error: fd binary not found in the extracted files."
  fi
}

install_ripgrep() {
  echo "Installing ripgrep..."
  rm -rf "$RG_DIR"
  mkdir -p "$RG_DIR"
  curl -L "$RG_URL" -o "$TEMP_DIR/rg.tar.gz"
  tar -xzf "$TEMP_DIR/rg.tar.gz" -C "$RG_DIR"
  RG_BINARY=$(find "$RG_DIR" -type f -name "rg" | head -n 1)
  if [ -n "$RG_BINARY" ]; then
    # Create a symbolic link to the ripgrep binary
    ln -s "$RG_BINARY" "$INSTALL_DIR/rg"
    echo "Created link to ripgrep at $INSTALL_DIR/rg"
    UPDATE_SHELL_CONFIGURATION=1
  else
    echo "Error: ripgrep binary not found in the extracted files."
  fi
}

install_bat() {
  echo "Installing bat..."
  rm -rf "$BAT_DIR"
  mkdir -p "$BAT_DIR"
  curl -L "$BAT_URL" -o "$TEMP_DIR/bat.tar.gz"
  tar -xzf "$TEMP_DIR/bat.tar.gz" -C "$BAT_DIR"
  BAT_BINARY=$(find "$BAT_DIR" -type f -name "bat" | head -n 1)
  if [ -n "$BAT_BINARY" ]; then
    # Create a symbolic link to the bat binary
    ln -s "$BAT_BINARY" "$INSTALL_DIR/bat"
    echo "Created link to bat at $INSTALL_DIR/bat"
    UPDATE_SHELL_CONFIGURATION=1
  else
    echo "Error: bat binary not found in the extracted files."
  fi
}

install_fzf() {
  echo "Installing fzf..."
  rm -rf "$FZF_DIR"
  mkdir -p "$FZF_DIR"
  curl -L "$FZF_URL" -o "$TEMP_DIR/fzf.tar.gz"
  tar -xzf "$TEMP_DIR/fzf.tar.gz" -C "$FZF_DIR"
  FZF_BINARY=$(find "$FZF_DIR" -type f -name "fzf" | head -n 1)
  if [ -n "$FZF_BINARY" ]; then
    # Create a symbolic link to the fzf binary
    ln -s "$FZF_DIR/fzf" "$INSTALL_DIR/fzf"
    echo "Created link to fzf at $INSTALL_DIR/fzf"
    UPDATE_SHELL_CONFIGURATION=1
  else
    echo "Error: fzf binary not found in the extracted files."
  fi
}

install_lazygit() {
  echo "Installing lazygit..."
  rm -rf "$LAZYGIT_DIR"
  mkdir -p "$LAZYGIT_DIR"
  curl -L "$LAZYGIT_URL" -o "$TEMP_DIR/lazygit.tar.gz"
  tar -xzf "$TEMP_DIR/lazygit.tar.gz" -C "$LAZYGIT_DIR"
  LAZYGIT_BINARY=$(find "$LAZYGIT_DIR" -type f -name "lazygit" | head -n 1)
  if [ -n "$LAZYGIT_BINARY" ]; then
    # Create a symbolic link to the lazygit binary
    ln -s "$LAZYGIT_BINARY" "$INSTALL_DIR/lazygit"
    echo "Created link to lazygit at $INSTALL_DIR/lazygit"
    UPDATE_SHELL_CONFIGURATION=1
  else
    echo "Error: lazygit binary not found in the extracted files."
  fi
}

install_zoxide() {
  echo "Installing zoxide..."
  rm -rf "$ZOXIDE_DIR"
  mkdir -p "$ZOXIDE_DIR"
  curl -L "$ZOXIDE_URL" -o "$TEMP_DIR/zoxide.tar.gz"
  tar -xzf "$TEMP_DIR/zoxide.tar.gz" -C "$ZOXIDE_DIR"
  ZOXIDE_BINARY=$(find "$ZOXIDE_DIR" -type f -name "zoxide" | head -n 1)
  if [ -n "$ZOXIDE_BINARY" ]; then
    # Create a symbolic link to the zoxide binary
    ln -s "$ZOXIDE_BINARY" "$INSTALL_DIR/zoxide"
    echo "Created link to zoxide at $INSTALL_DIR/zoxide"
    UPDATE_SHELL_CONFIGURATION=1
  else
    echo "Error: zoxide binary not found in the extracted files."
  fi
}

install_yazi() {
  echo "Installing Yazi..."
  rm -rf "$YAZI_DIR"
  mkdir -p "$YAZI_DIR"
  curl -L "$YAZI_URL" -o "$TEMP_DIR/yazi.zip"
  unzip "$TEMP_DIR/yazi.zip" -d "$YAZI_DIR"
  YAZI_BINARY=$(find "$YAZI_DIR" -type f -name "yazi" | head -n 1)
  if [ -n "$YAZI_BINARY" ]; then
    # Create a symbolic link to the Yazi binary
    ln -s "$YAZI_BINARY" "$INSTALL_DIR/yazi"
    echo "Created link to Yazi at $INSTALL_DIR/yazi"
    UPDATE_SHELL_CONFIGURATION=1
  else
    echo "Error: Yazi binary not found in the extracted files."
  fi
}

install_helix_config() {
  echo "Installing Helix configuration..."
  rm -rf "$HELIX_CONFIG_DIR"
  git clone "$HELIX_CONFIG_REPO" "$HELIX_CONFIG_DIR"
}

install_tmux_config() {
  echo "Installing tmux configuration..."
  rm -rf "$TMUX_CONFIG_DIR"
  git clone "$TMUX_CONFIG_REPO" "$TMUX_CONFIG_DIR"
  ln -s "$TMUX_CONFIG_DIR/.tmux.conf" "$TMUX_CONFIG_DIR/tmux.conf"
  ln -s "$TMUX_CONFIG_DIR/.tmux.conf.local" "$TMUX_CONFIG_DIR/tmux.conf.local"
}

install_zellij_config() {
  echo "Installing Zellij configuration..."
  rm -rf "$ZELLIJ_CONFIG_DIR"
  git clone "$ZELLIJ_CONFIG_REPO" "$ZELLIJ_CONFIG_DIR"
}

create_shell_init_script() {
  echo "Creating Bash shell initialization script..."

  rm -f "$PREFIX/init.sh"

  tee "$PREFIX/init.sh" <<EOF
# Helix-starter environment initialization
# This file is automatically generated - do not edit directly

# Add binaries to PATH
export PATH="$INSTALL_DIR:\$PATH"

# Initialize fzf if installed
if [ -f "$INSTALL_DIR/fzf" ]; then
  eval "\$(fzf --bash)"
fi

# Initialize zoxide if installed
if [ -f "$INSTALL_DIR/zoxide" ]; then
  eval "\$(zoxide init bash)"
fi
EOF

  echo "Bash shell initialization script created at $PREFIX/init.sh"
}

main() {
  # Clean up and create fresh directories
  rm -rf "$TEMP_DIR"
  mkdir -p "$INSTALL_DIR" "$TEMP_DIR"

  # Show menu and process selection
  show_menu

  # Process user selection
  if [[ "$CHOICE" == "a" ]]; then
    install_helix
    install_nodejs
    install_zellij
    install_fd
    install_ripgrep
    install_bat
    install_fzf
    install_lazygit
    install_zoxide
    install_yazi
    install_helix_config
    install_tmux_config
    install_zellij_config
  elif [[ "$CHOICE" == "t" ]]; then
    install_helix
    install_nodejs
    install_fd
    install_ripgrep
    install_bat
    install_fzf
    install_lazygit
    install_zoxide
    install_yazi
    install_helix_config
    install_tmux_config
  elif [[ "$CHOICE" == "z" ]]; then
    install_helix
    install_nodejs
    install_zellij
    install_fd
    install_ripgrep
    install_bat
    install_fzf
    install_lazygit
    install_zoxide
    install_yazi
    install_helix_config
    install_zellij_config
  elif [[ "$CHOICE" == "i" ]]; then
    UPDATE_SHELL_CONFIGURATION=1
  else
    for num in $CHOICE; do
      case $num in
      1) install_helix ;;
      2) install_nodejs ;;
      3) install_zellij ;;
      4) install_fd ;;
      5) install_ripgrep ;;
      6) install_bat ;;
      7) install_fzf ;;
      8) install_lazygit ;;
      9) install_zoxide ;;
      10) install_yazi ;;
      11) install_helix_config ;;
      12) install_tmux_config ;;
      13) install_zellij_config ;;
      *) echo "Invalid option: $num" ;;
      esac
    done
  fi

  # Update fish shell configuration
  if [ $UPDATE_SHELL_CONFIGURATION -eq 1 ]; then
    create_shell_init_script

    # Create .bashrc if it doesn't exist
    BASHRC_FILE="$HOME/.bashrc"
    touch "$BASHRC_FILE"

    # Add source line if not already present
    if ! grep -q "source $PREFIX/init.sh" "$BASHRC_FILE"; then
      echo "" >>"$BASHRC_FILE"
      echo "# helix-starter configuration" >>"$BASHRC_FILE"
      echo "if [ -f $PREFIX/init.sh ]; then" >>"$BASHRC_FILE"
      echo "    source $PREFIX/init.sh" >>"$BASHRC_FILE"
      echo "fi" >>"$BASHRC_FILE"
      echo "Added initialization script to $BASHRC_FILE"
    fi
  fi

  # Clean up
  rm -rf "$TEMP_DIR"

  if [ $UPDATE_SHELL_CONFIGURATION -eq 1 ]; then
    echo "Installation complete. Please restart your shell to apply the changes."
  else
    echo "Installation complete."
  fi
}

main "$@"
