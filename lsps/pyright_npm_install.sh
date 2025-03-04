#!/bin/bash

# Set up directories
PREFIX="$HOME/.helix-starter"
LSP_DIR="$PREFIX/lsp"
PYRIGHT_DIR="$LSP_DIR/pyright"
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

# Install Pyright
install_pyright() {
  echo "Installing Pyright..."
  rm -rf "$PYRIGHT_DIR"
  mkdir -p "$PYRIGHT_DIR"
  npm install --prefix "$PYRIGHT_DIR" pyright
  echo "Pyright installed in $PYRIGHT_DIR"

  # Create a link to the Pyright executables
  ln -s "$PYRIGHT_DIR/node_modules/.bin/pyright" "$INSTALL_DIR/pyright"
  echo "Created link to Pyright at $INSTALL_DIR/pyright"
  ln -s "$PYRIGHT_DIR/node_modules/.bin/pyright-langserver" "$INSTALL_DIR/pyright-langserver"
  echo "Created link to Pyright language server at $INSTALL_DIR/pyright-langserver"
}

mkdir -p "$PREFIX"
mkdir -p "$LSP_DIR"
mkdir -p "$INSTALL_DIR"
mkdir -p "$PYRIGHT_DIR"

install_pyright

echo "Pyright is ready to use. Add $INSTALL_DIR to your PATH to use it if you want to us it in the other editors."
