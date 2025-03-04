#!/bin/bash

# Set up directories
PREFIX="$HOME/.helix-starter"
LSP_DIR="$PREFIX/lsp"
RUFF_DIR="$LSP_DIR/ruff"
INSTALL_DIR="$LSP_DIR/bin"

# Check python3 availability
if ! command -v python3 &>/dev/null; then
	echo "Error: python3 is not available. Please install python3 first."
	exit 1
fi

# Install ruff
install_ruff() {
	echo "Installing Ruff..."
	rm -rf "$RUFF_DIR"
	mkdir -p "$RUFF_DIR"
	local venv_dir="$RUFF_DIR/venv"
	python3 -m venv "$venv_dir"
	source "$venv_dir/bin/activate"
	pip install ruff
	deactivate
	echo "Ruff installed in $RUFF_DIR"

	# Create a link to the Ruff executable
	ln -s "$RUFF_DIR/venv/bin/ruff" "$INSTALL_DIR/ruff"
	echo "Created link to Ruff at $INSTALL_DIR/ruff"
}

mkdir -p "$PREFIX"
mkdir -p "$LSP_DIR"
mkdir -p "$INSTALL_DIR"
mkdir -p "$RUFF_DIR"

install_ruff
echo "Ruff is ready to use. Add $INSTALL_DIR to your PATH to use it if you want to us it in the other editors."
