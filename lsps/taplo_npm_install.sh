#!/bin/bash

# Set up directories
PREFIX="$HOME/.helix-starter"
LSP_DIR="$PREFIX/lsp"
TAPLO_DIR="$LSP_DIR/taplo"
INSTALL_DIR="$LSP_DIR/bin"
NODEJS_DIR="$PREFIX/nodejs"

# Check npm availability
if ! command -v npm &>/dev/null; then
	# Import Node.js to PATH
	if [ -d "$NODEJS_DIR" ]; then
		export PATH=$NODEJS_DIR/bin:$PATH
		echo "Use bundled Node.js at $NODEJS_DIR"
	else
		echo "Error: npm is not available. Please install Node.js first."
		exit 1
	fi
fi

# Install Taplo
install_taplo() {
	echo "Installing Taplo..."
	rm -rf "$TAPLO_DIR"
	mkdir -p "$TAPLO_DIR"
	npm install --prefix "$TAPLO_DIR" @taplo/cli
	echo "Taplo installed in $TAPLO_DIR"

	# Create a link to the Taplo executables
	ln -s "$TAPLO_DIR/node_modules/.bin/taplo" "$INSTALL_DIR/taplo"
	echo "Created link to taplo at $INSTALL_DIR/taplo"
}

mkdir -p "$PREFIX"
mkdir -p "$LSP_DIR"
mkdir -p "$INSTALL_DIR"
mkdir -p "$TAPLO_DIR"

install_taplo

echo "Taplo is ready to use. Add $INSTALL_DIR to your PATH to use it if you want to us it in the other editors."
