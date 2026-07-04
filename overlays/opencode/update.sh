#!/usr/bin/env nix
#!nix shell --ignore-environment nixpkgs#bash nixpkgs#cacert nixpkgs#coreutils nixpkgs#curl nixpkgs#gawk nixpkgs#gitMinimal nixpkgs#gnugrep nixpkgs#gnused nixpkgs#nix --command bash

set -euo pipefail

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
FLAKE_NIX="$SCRIPT_DIR/../../flake.nix"
OVERLAYS_DEFAULT="$SCRIPT_DIR/../default.nix"
FLAKE_ROOT="$SCRIPT_DIR/../.."

latest=$(curl -s "https://api.github.com/repos/anomalyco/opencode/releases/latest" | grep '"tag_name"' | sed 's/.*"tag_name": *"\([^"]*\)".*/\1/')

if [ -z "$latest" ]; then
  echo "Failed to fetch latest opencode release" >&2
  exit 1
fi

echo "Latest opencode release: $latest"

current=$(grep 'url = "github:anomalyco/opencode' "$FLAKE_NIX" | sed 's|.*opencode/\([^"]*\)".*|\1|')

if [ "$current" = "$latest" ]; then
  echo "Already on $latest; refreshing node_modules hashes anyway."
else
  sed -i "s|url = \"github:anomalyco/opencode/[^\"]*\";|url = \"github:anomalyco/opencode/$latest\";|" "$FLAKE_NIX"
  echo "Updated flake.nix: $current -> $latest"

  (cd "$FLAKE_ROOT" && nix flake update opencode)
fi

get_darwin_hash() {
  awk '
    /^[[:space:]]*opencode =/ { inOpencode = 1; next }
    inOpencode && /if super\.stdenv\.hostPlatform\.isDarwin then/ { inDarwin = 1; next }
    inDarwin && match($0, /sha256-[^"]+/) {
      print substr($0, RSTART, RLENGTH)
      exit
    }
  ' "$OVERLAYS_DEFAULT"
}

get_linux_hash() {
  awk '
    /^[[:space:]]*opencode =/ { inOpencode = 1; next }
    inOpencode && /if super\.stdenv\.hostPlatform\.isDarwin then/ { seenDarwin = 1; next }
    seenDarwin && /^[[:space:]]*else[[:space:]]*$/ { inLinux = 1; next }
    inLinux && match($0, /sha256-[^"]+/) {
      print substr($0, RSTART, RLENGTH)
      exit
    }
  ' "$OVERLAYS_DEFAULT"
}

replace_hash() {
  old_hash="$1"
  new_hash="$2"

  if [ -z "$old_hash" ] || [ -z "$new_hash" ]; then
    echo "replace_hash called with an empty hash" >&2
    exit 1
  fi

  sed -i "s|$old_hash|$new_hash|" "$OVERLAYS_DEFAULT"
}

compute_linux_hash() {
  fake_hash="sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA="
  temp_nix=$(mktemp /tmp/opencode-linux-node-modules.XXXXXX.nix)

  sed "s|FAKE_HASH_HERE|$fake_hash|" > "$temp_nix" <<'NIXEOF'
let
  flake = builtins.getFlake (toString ./.);
  pkgs = flake.inputs.nixpkgs.legacyPackages.x86_64-linux;
  src = flake.inputs.opencode.sourceInfo;
  rev = src.shortRev or src.dirtyShortRev or "dirty";
  node_modules = pkgs.callPackage "${src}/nix/node_modules.nix" {
    inherit rev;
    hash = "FAKE_HASH_HERE";
  };
in
node_modules.overrideAttrs (oldAttrs: {
  buildPhase = builtins.replaceStrings [ "--frozen-lockfile" ] [ "" ] oldAttrs.buildPhase;
})
NIXEOF

  build_output=$(cd "$FLAKE_ROOT" && nix build --impure --no-link --expr "$(cat "$temp_nix")" 2>&1 || true)
  rm -f "$temp_nix"

  real_hash=$(echo "$build_output" | grep -oP 'got:\s*\K\S+' | head -1)
  if [ -z "$real_hash" ]; then
    echo "Failed to determine Linux node_modules hash via fake-hash build." >&2
    echo "This requires a Linux builder because opencode node_modules is a build output, not a downloadable tarball." >&2
    echo "$build_output" >&2
    exit 1
  fi

  echo "$real_hash"
}

echo "Refreshing opencode node_modules hashes..."

current_darwin_hash=$(get_darwin_hash)
current_linux_hash=$(get_linux_hash)

hashes_json=$(curl -sf "https://raw.githubusercontent.com/anomalyco/opencode/$latest/nix/hashes.json" || true)
darwin_hash=""
if [ -n "$hashes_json" ]; then
  darwin_hash=$(echo "$hashes_json" | grep -oP '"aarch64-darwin":\s*"\K[^"]+' || true)
fi

if [ -z "$darwin_hash" ]; then
  echo "Failed to get aarch64-darwin node_modules hash from upstream hashes.json" >&2
  exit 1
fi

linux_hash=$(compute_linux_hash)

replace_hash "$current_darwin_hash" "$darwin_hash"
replace_hash "$current_linux_hash" "$linux_hash"

echo "Updated Darwin node_modules hash: $current_darwin_hash -> $darwin_hash"
echo "Updated Linux node_modules hash:  $current_linux_hash -> $linux_hash"
