#!/bin/bash

# Set up directories
PREFIX="$HOME/.helix-starter"
LSP_DIR="$PREFIX/lsp"
PRETTIER_DIR="$LSP_DIR/prettier"
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

# Install Prettier
install_prettier() {
  echo "Installing Prettier..."
  rm -rf "$PRETTIER_DIR"
  mkdir -p "$PRETTIER_DIR"
  npm install --prefix "$PRETTIER_DIR" prettier
  echo "Prettier installed in $PRETTIER_DIR"

  # Create a link to the Prettier executables
  ln -s "$PRETTIER_DIR/node_modules/.bin/prettier" "$INSTALL_DIR/prettier"
  echo "Created link to prettier at $INSTALL_DIR/prettier"
}

mkdir -p "$PREFIX"
mkdir -p "$LSP_DIR"
mkdir -p "$INSTALL_DIR"
mkdir -p "$PRETTIER_DIR"

install_prettier

echo "Prettier is ready to use. Add $INSTALL_DIR to your PATH to use it if you want to us it in the other editors."
