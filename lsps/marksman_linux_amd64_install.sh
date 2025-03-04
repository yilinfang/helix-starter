#!/bin/bash

# Set up directories

PREFIX="$HOME/.helix-starter"
LSP_DIR="$PREFIX/lsp"
MARKSMAN_DIR="$LSP_DIR/marksman"
INSTALL_DIR="$LSP_DIR/bin"
MARKSMAN_URL="https://github.com/artempyanykh/marksman/releases/download/2024-12-18/marksman-linux-x64"

install_marksman() {
  echo "Installing Marksman..."
  rm -rf "$MARKSMAN_DIR"
  mkdir -p "$MARKSMAN_DIR"
  curl -L "$MARKSMAN_URL" -o "$MARKSMAN_DIR/marksman"
  chmod +x "$MARKSMAN_DIR/marksman"
  echo "Marksman installed in $MARKSMAN_DIR"
  # Create a link to the Marksman executable
  ln -s "$MARKSMAN_DIR/marksman" "$INSTALL_DIR/marksman"
  echo "Created link to Marksman at $INSTALL_DIR/marksman"
}

mkdir -p "$PREFIX"
mkdir -p "$LSP_DIR"
mkdir -p "$INSTALL_DIR"
mkdir -p "$MARKSMAN_DIR"

install_marksman

echo "Marksman is ready to use. Add $INSTALL_DIR to your PATH to use it if you want to us it in the other editors."