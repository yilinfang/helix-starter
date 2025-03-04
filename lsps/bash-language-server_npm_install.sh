#!/bin/bash

# Set up directories
PREFIX="$HOME/.helix-starter"
LSP_DIR="$PREFIX/lsp"
BASH_LSP_DIR="$LSP_DIR/bash-language-server"
INSTALL_DIR="$LSP_DIR/bin"
NODEJS_DIR="$PREFIX/nodejs"

# Check npm availability
if ! command -v npm &> /dev/null; then
  # Import Node.js to PATH
  if [ -d "$NODEJS_DIR" ]; then
    export PATH=$NODEJS_DIR/bin:$PATH
    echo "Use bundled Node.js at $NODEJS_DIR"
  else
    echo "Error: npm is not available. Please install Node.js first."
    exit 1
  fi
fi

# Install bash-language-server
install_bash-language-server() {
  echo "Installing bash-language-server..."
  rm -rf "$BASH_LSP_DIR"
  mkdir -p "$BASH_LSP_DIR"
  npm install --prefix "$BASH_LSP_DIR" bash-language-server
  echo "bash-language-server installed in $BASH_LSP_DIR"

  # Create link to the bash-language-server executable
  ln -s "$BASH_LSP_DIR/node_modules/.bin/bash-language-server" "$INSTALL_DIR/bash-language-server"
  echo "Created link to bash-language-server at $INSTALL_DIR/bash-language-server"
}

mkdir -p "$PREFIX"
mkdir -p "$LSP_DIR"
mkdir -p "$INSTALL_DIR"
mkdir -p "$BASH_LSP_DIR"

install_bash-language-server

echo "bash-language-server is ready to use. Add $INSTALL_DIR to your PATH to use it if you want to us it in the other editors."
