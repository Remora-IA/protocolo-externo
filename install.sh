#!/bin/bash
set -e

# Paladin QA — install script
#
# Installs both the browser extension and registers it as an MCP server
# for Claude Code. The skill (QA-UX methodology) is already live because
# this repo must be cloned to ~/.claude/qa-ux/ — that's the skill install.
#
# Usage: ./install.sh <extension-id> [extension-id-2] ...
#
# How to get the extension ID:
#   1. Open chrome://extensions (or brave://extensions)
#   2. Enable Developer Mode
#   3. Click "Load unpacked" → select the extension/ directory in this repo
#   4. Copy the extension ID shown under the extension name
#   5. Repeat for each browser, pass all IDs to this script

if [ -z "$1" ]; then
  echo "Usage: ./install.sh <extension-id> [extension-id-2] ..."
  echo ""
  echo "Steps:"
  echo "  1. Open chrome://extensions (or brave://extensions)"
  echo "  2. Enable Developer Mode"
  echo "  3. Click 'Load unpacked' → select the extension/ directory"
  echo "  4. Copy the extension ID shown under the extension name"
  echo "  5. Run: ./install.sh <id>"
  exit 1
fi

EXTENSION_IDS=("$@")
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
HOST_DIR="$SCRIPT_DIR/extension/host"
NATIVE_HOST_PATH="$HOST_DIR/native-host-wrapper.sh"
HOST_NAME="com.paladin_qa.bridge"

# Verify node
if ! command -v node &> /dev/null; then
  echo "Error: node is not installed. Install Node.js first."
  exit 1
fi

# Verify this repo is at ~/.claude/qa-ux (skill install requirement)
EXPECTED_SKILL_PATH="$HOME/.claude/qa-ux"
if [ "$SCRIPT_DIR" != "$EXPECTED_SKILL_PATH" ]; then
  echo "Warning: this repo is at $SCRIPT_DIR but the skill expects to run from $EXPECTED_SKILL_PATH"
  echo "The QA-UX skill will not work unless you clone or symlink this repo to ~/.claude/qa-ux/"
  echo ""
fi

# Install npm dependencies
if [ ! -d "$HOST_DIR/node_modules" ]; then
  echo "Installing npm dependencies..."
  cd "$HOST_DIR" && npm install
  cd "$SCRIPT_DIR"
fi

# Generate the native host wrapper (hardcodes paths — generated, not committed)
cat > "$NATIVE_HOST_PATH" << WRAPPER
#!/bin/sh
exec "$(which node)" "$HOST_DIR/native-host.js"
WRAPPER
chmod +x "$NATIVE_HOST_PATH"

echo "Created native host wrapper: $NATIVE_HOST_PATH"

# Build allowed_origins from all extension IDs
ORIGINS=""
for i in "${!EXTENSION_IDS[@]}"; do
  if [ $i -gt 0 ]; then ORIGINS="$ORIGINS,"; fi
  ORIGINS="$ORIGINS
    \"chrome-extension://${EXTENSION_IDS[$i]}/\""
done

generate_manifest() {
  cat << EOF
{
  "name": "$HOST_NAME",
  "description": "Paladin QA Native Messaging Host",
  "path": "$NATIVE_HOST_PATH",
  "type": "stdio",
  "allowed_origins": [$ORIGINS
  ]
}
EOF
}

install_host() {
  local browser_name="$1"
  local host_dir="$2"
  if [ ! -d "$(dirname "$host_dir")" ]; then
    echo "  Skipping $browser_name (not installed)"
    return
  fi
  mkdir -p "$host_dir"
  generate_manifest > "$host_dir/$HOST_NAME.json"
  echo "  Installed for $browser_name"
}

echo ""
echo "Registering native messaging host for: ${EXTENSION_IDS[*]}"
echo ""

case "$(uname)" in
  Darwin)
    install_host "Chrome" "$HOME/Library/Application Support/Google/Chrome/NativeMessagingHosts"
    install_host "Edge"   "$HOME/Library/Application Support/Microsoft Edge/NativeMessagingHosts"
    install_host "Brave"  "$HOME/Library/Application Support/BraveSoftware/Brave-Browser/NativeMessagingHosts"
    ;;
  Linux)
    install_host "Chrome" "$HOME/.config/google-chrome/NativeMessagingHosts"
    install_host "Edge"   "$HOME/.config/microsoft-edge/NativeMessagingHosts"
    install_host "Brave"  "$HOME/.config/BraveSoftware/Brave-Browser/NativeMessagingHosts"
    ;;
  *)
    echo "Error: unsupported platform $(uname). Supports macOS and Linux."
    exit 1
    ;;
esac

echo ""
echo "Done. Next steps:"
echo ""
echo "  1. Restart your browser"
echo "  2. Add the MCP server to Claude Code:"
echo ""
echo "     claude mcp add paladin-qa -- node $HOST_DIR/mcp-server.js"
echo ""
echo "  3. The QA-UX skill is active if this repo lives at ~/.claude/qa-ux/"
echo "     Run /qa-ux in any Claude Code session to start."
echo ""
