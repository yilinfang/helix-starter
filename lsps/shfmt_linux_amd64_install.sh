#!/bin/bash

# Set up directories
PREFIX="$HOME/.helix-starter"
LSP_DIR="$PREFIX/lsp"
SHFMT_DIR="$LSP_DIR/shfmt"
INSTALL_DIR="$LSP_DIR/bin"
SHFMT_URL="https://github.com/mvdan/sh/releases/download/v3.10.0/shfmt_v3.10.0_linux_amd64"

install_shfmt() {
	echo "Installing shfmt..."
	rm -rf "$SHFMT_DIR"
	mkdir -p "$SHFMT_DIR"
	curl -L "$SHFMT_URL" -o "$SHFMT_DIR/shfmt"
	chmod +x "$SHFMT_DIR/shfmt"
	echo "shfmt installed in $SHFMT_DIR"
	# Create a link to the shfmt executable
	ln -s "$SHFMT_DIR/shfmt" "$INSTALL_DIR/shfmt"
	echo "Created link to shfmt at $INSTALL_DIR/shfmt"
}

mkdir -p "$PREFIX"
mkdir -p "$LSP_DIR"
mkdir -p "$INSTALL_DIR"
mkdir -p "$SHFMT_DIR"

install_shfmt

echo "shfmt is ready to use. Add $INSTALL_DIR to your PATH to use it if you want to us it in the other editors."
