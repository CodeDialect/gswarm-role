#!/usr/bin/env bash

# Colors
CYAN='\033[0;36m'
GREEN='\033[1;32m'
RED='\033[1;31m'
BLUE='\033[1;34m'
PURPLE='\033[1;35m'
RESET='\033[0m'
BOLD='\033[1m'

# ===============================
# BANNER
# ===============================
echo -e "${PURPLE}${BOLD}"
echo -e "${CYAN}
 
 ______              _         _                                             
|  ___ \            | |       | |                   _                        
| |   | |  ___    _ | |  ____ | | _   _   _  ____  | |_   ____   ____  _____ 
| |   | | / _ \  / || | / _  )| || \ | | | ||  _ \ |  _) / _  ) / ___)(___  )
| |   | || |_| |( (_| |( (/ / | | | || |_| || | | || |__( (/ / | |     / __/ 
|_|   |_| \___/  \____| \____)|_| |_| \____||_| |_| \___)\____)|_|    (_____)                   
                                
                                                                                                                                
${YELLOW}                      :: Powered by Noderhunterz ::
${NC}"


# === CONFIG ===
GO_VERSION="1.24.5"
GO_TARBALL="go${GO_VERSION}.linux-amd64.tar.gz"
GO_URL="https://golang.org/dl/${GO_TARBALL}"
GO_INSTALL_DIR="/usr/local"
CONFIG_PATH="telegram-config.json"
API_URL="https://gswarm.dev/api"

set -e

echo "📦 GSwarm Full One-Click Installer"

# === Install jq ===
if ! command -v jq >/dev/null 2>&1; then
  echo "🔧 Installing jq..."
  sudo apt update -y
  sudo apt install -y jq
else
  echo "✅ jq is already installed"
fi

# === Go Version Check & Install ===
function install_go {
  echo "⬇️ Installing Go $GO_VERSION..."
  curl -LO "$GO_URL"
  sudo rm -rf ${GO_INSTALL_DIR}/go
  sudo tar -C ${GO_INSTALL_DIR} -xzf "$GO_TARBALL"
  rm "$GO_TARBALL"

  export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin
  echo 'export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin' >> "$HOME/.bashrc"
  echo 'export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin' >> "$HOME/.profile"

  echo "✅ Go installed: $(/usr/local/go/bin/go version)"
}

function version_lt() {
  [ "$(printf '%s\n' "$1" "$2" | sort -V | head -n1)" != "$2" ]
}

if command -v go >/dev/null 2>&1; then
  INSTALLED_GO_VERSION=$(go version | awk '{print $3}' | sed 's/go//')
  echo "🔍 Detected Go version: $INSTALLED_GO_VERSION"
  if version_lt "$INSTALLED_GO_VERSION" "$GO_VERSION"; then
    echo "⚠️ Go version is less than $GO_VERSION. Replacing..."
    sudo rm -rf "$GO_INSTALL_DIR/go"
    rm -rf "$HOME/go"
    install_go
  else
    echo "✅ Go version is sufficient."
  fi
else
  install_go
fi

# Source updated PATH
export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin

# === Install GSwarm ===
echo "⬇️ Installing GSwarm CLI..."
go install github.com/Deep-Commit/gswarm/cmd/gswarm@latest
echo "✅ GSwarm installed at: $(which gswarm)"

# === Telegram Bot Setup ===
echo
echo "🤖 Telegram Bot Setup:"
echo "1. Open Telegram and search @BotFather"
echo "2. Send /newbot and follow the steps"
echo "3. Copy the bot token (format: 123456:ABC-DEF...)"
echo
read -p "Paste your bot token here: " BOT_TOKEN

echo
echo "📨 Now send any message to your bot in Telegram."
read -p "Press Enter after sending the message..."

echo "📡 Fetching your chat ID..."
CHAT_ID=$(curl -s "https://api.telegram.org/bot${BOT_TOKEN}/getUpdates" \
  | jq -r '.result[-1].message.chat.id')

if [[ -z "$CHAT_ID" || "$CHAT_ID" == "null" ]]; then
  echo "❌ Failed to retrieve chat ID. Did you message the bot first?"
  exit 1
fi

mkdir -p "$(dirname "$CONFIG_PATH")"

cat > "$CONFIG_PATH" <<EOF
{
  "bot_token": "$BOT_TOKEN",
  "chat_id": "$CHAT_ID",
  "welcome_sent": true,
  "api_url": "$API_URL"
}
EOF

echo "✅ Configuration saved to $CONFIG_PATH"

# === Run GSwarm ===
echo
echo "🚀 Starting GSwarm monitor..."
gswarm
