# 🐝 GSwarm One-Click Installer

This script installs the GSwarm CLI tool, sets up a Telegram bot for notifications, and starts monitoring Gensyn Swarm rewards automatically.

---

## 📦 Features

- ✅ Automatic installation of Go (version >= 1.24.5)
- ✅ jq installation for JSON parsing
- ✅ GSwarm CLI installed from GitHub
- ✅ Telegram bot token setup with automatic chat ID fetch
- ✅ Saves config in `telegram-config.json`
- ✅ Starts `gswarm` instantly

---
## Quick Start

```bash
bash <(curl -sL https://raw.githubusercontent.com/CodeDialect/gswarm-role/main/gswarm.sh)
```


Follow the Telegram bot setup prompts

- Create a new bot using [@BotFather](https://t.me/botfather)
- Paste your bot token when asked
- Send a message to your bot so the script can fetch your chat ID
- Get your EOA from [gensyn dashboard](https://dashboard.gensyn.ai)

---

## Config File

After setup, you'll get a `telegram-config.json` file like this:

```json
{
  "bot_token": "123456:ABC-DEF...",
  "chat_id": "987654321",
  "welcome_sent": true,
  "api_url": "https://gswarm.dev/api"
}
```

---

## Requirements

- Linux (Debian/Ubuntu)
- `curl`, `jq`, `sudo` access

---

💬 Questions?
Join [Telegram](https://t.me/nodehunterz)
