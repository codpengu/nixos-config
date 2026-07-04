#!/usr/bin/env nix
#!nix shell --ignore-environment nixpkgs#bash nixpkgs#cacert nixpkgs#coreutils nixpkgs#curl nixpkgs#gnugrep nixpkgs#gnused nixpkgs#nodejs nixpkgs#nix --command bash

set -euo pipefail

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
DEFAULT_NIX="$SCRIPT_DIR/default.nix"

echo "Fetching latest opencode-ai from npm registry..."
LATEST_VERSION=$(npm view opencode-ai version)

CURRENT_VERSION=$(grep -E '^\s*version\s*=' "$DEFAULT_NIX" | sed -E 's/.*version\s*=\s*"([^"]+)".*/\1/')

echo "Current version: $CURRENT_VERSION"
echo "Latest version:  $LATEST_VERSION"

if [ "$CURRENT_VERSION" = "$LATEST_VERSION" ]; then
  echo "opencode is already up to date (version $CURRENT_VERSION)"
  exit 0
fi

echo "Updating default.nix: $CURRENT_VERSION -> $LATEST_VERSION"
sed -i "s/version = \"[^\"]*\";/version = \"$LATEST_VERSION\";/" "$DEFAULT_NIX"

packages=(
  "opencode-linux-x64"
  "opencode-linux-arm64"
  "opencode-darwin-x64"
  "opencode-darwin-arm64"
)

for package in "${packages[@]}"; do
  tarball="https://registry.npmjs.org/${package}/-/${package}-${LATEST_VERSION}.tgz"

  echo "Computing hash for $package ..."
  hash=$(nix-prefetch-url --type sha256 "$tarball" 2>/dev/null)
  sri_hash=$(nix hash convert --hash-algo sha256 "$hash")

  if [ -z "$sri_hash" ]; then
    echo "Error: Failed to compute hash for $package" >&2
    exit 1
  fi

  echo "  $package: $sri_hash"
  sed -i "/package = \"${package}\";/,/[}];/{s|hash = \"sha256-[^\"]*\";|hash = \"$sri_hash\";|}" "$DEFAULT_NIX"
done

echo "Successfully updated opencode to version $LATEST_VERSION"
