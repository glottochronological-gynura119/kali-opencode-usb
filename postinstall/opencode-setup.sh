#!/bin/bash
################################################################################
# Kali + OpenCode Pentest AI Suite Setup
# Runs after first boot into Kali Live
################################################################################

set -euo pipefail

KALI_USER="kali"
OPENCODE_HOME="/home/$KALI_USER/.opencode"
CLI_AGENT_HOME="/home/$KALI_USER/cli-agent"
KALI_MCP_HOME="/home/$KALI_USER/kali-mcp"
SHANNON_HOME="/home/$KALI_USER/opencode-shannon-plugin"

echo "🗡️  Setting up Pentest AI Suite..."
echo ""

# ============================================================================
# Install OpenCode
# ============================================================================
echo "[1/6] Installing OpenCode..."
if command -v opencode &> /dev/null; then
    echo "  OpenCode already installed"
else
    curl -fsSL https://opencode.ai/install.sh | bash
fi
echo ""

# ============================================================================
# Install CLI Agent
# ============================================================================
echo "[2/6] Installing CLI Agent..."
if [[ -d "$CLI_AGENT_HOME" ]]; then
    echo "  CLI Agent directory exists, updating..."
    cd "$CLI_AGENT_HOME"
    git pull origin main 2>/dev/null || true
else
    echo "  Cloning CLI Agent..."
    cd /home/$KALI_USER
    git clone https://github.com/amranu/cli-agent.git
    cd cli-agent
fi

python3 -m venv .venv
source .venv/bin/activate
pip install --upgrade pip
pip install -e .
echo ""

# ============================================================================
# Install Kali MCP Server
# ============================================================================
echo "[3/6] Installing Kali MCP Server..."
if [[ -d "$KALI_MCP_HOME" ]]; then
    echo "  Kali MCP directory exists, updating..."
    cd "$KALI_MCP_HOME"
    git pull origin main 2>/dev/null || true
else
    echo "  Cloning Kali MCP..."
    cd /home/$KALI_USER
    git clone https://github.com/k3nn3dy-ai/kali-mcp.git
    cd kali-mcp
fi

python3 -m venv .venv
source .venv/bin/activate
pip install --upgrade pip
pip install -e ".[dev]"
echo ""

# ============================================================================
# Install Shannon Plugin
# ============================================================================
echo "[4/6] Installing Shannon Plugin..."
if [[ -d "$SHANNON_HOME" ]]; then
    echo "  Shannon Plugin directory exists, updating..."
    cd "$SHANNON_HOME"
    git pull origin main 2>/dev/null || true
else
    echo "  Cloning Shannon Plugin..."
    cd /home/$KALI_USER
    git clone https://github.com/vichhka-git/opencode-shannon-plugin.git
    cd opencode-shannon-plugin
fi

# Install bun if not present
if ! command -v bun &> /dev/null; then
    echo "  Installing Bun..."
    curl -fsSL https://bun.sh/install.sh | bash
    export PATH="$HOME/.bun/bin:$PATH"
fi

# Build the plugin
cd "$SHANNON_HOME"
bun install
bun run build

# Build Docker image
echo "  Building Shannon Docker image (this may take a while)..."
docker build -t shannon-tools . 2>/dev/null || echo "  Docker build skipped (run 'docker build -t shannon-tools .' manually)"
echo ""

# ============================================================================
# Install Ollama (optional)
# ============================================================================
echo "[5/6] Setting up Ollama (optional)..."
if command -v ollama &> /dev/null; then
    echo "  Ollama already installed"
else
    read -p "  Install Ollama for offline AI models? (y/n): " install_ollama
    if [[ "$install_ollama" == "y" ]]; then
        curl -fsSL https://ollama.com/install.sh | bash
        
        echo "  Pulling default models..."
        ollama pull llama3
        ollama pull codellama
        echo "  Models ready for offline use"
    fi
fi
echo ""

# ============================================================================
# Configure OpenCode
# ============================================================================
echo "[6/6] Configuring OpenCode..."
mkdir -p "/home/$KALI_USER/.config/opencode"

cat > "/home/$KALI_USER/.config/opencode/opencode.jsonc" << 'EOF'
{
  "$schema": "https://opencode.ai/config.json",
  "mcp": {
    "cli-agent": {
      "type": "local",
      "command": ["/home/kali/cli-agent/.venv/bin/python", "/home/kali/cli-agent/mcp_server.py"],
      "enabled": true
    },
    "kali-mcp": {
      "type": "local",
      "command": ["/home/kali/kali-mcp/.venv/bin/python", "-m", "kali_mcp_server"],
      "enabled": true
    }
  },
  "plugin": [
    "/home/kali/opencode-shannon-plugin"
  ]
}
EOF

# Create Shannon config
cat > "/home/$KALI_USER/.config/opencode/shannon-plugin.json" << 'EOF'
{
  "shannon": {
    "require_authorization": true,
    "docker_image": "shannon-tools",
    "browser_testing": true,
    "idor_testing": true,
    "upload_testing": true
  }
}
EOF
echo ""

# ============================================================================
# Create workspace structure
# ============================================================================
echo "Creating workspace structure..."
mkdir -p "$OPENCODE_HOME/workspace/memory"
mkdir -p "$OPENCODE_HOME/workspace/templates"
mkdir -p "$OPENCODE_HOME/workspace/backups"
mkdir -p "$KALI_MCP_HOME/sessions"
echo ""

# ============================================================================
# Create bash aliases
# ============================================================================
echo "Creating bash aliases..."
cat >> "/home/$KALI_USER/.bashrc" << 'EOF'

# ═══════════════════════════════════════════════════════════
# Kali Pentest AI Suite
# ═══════════════════════════════════════════════════════════

# OpenCode
alias oc-start='opencode serve'
alias oc-web='opencode web'
alias oc-status='opencode --version'

# CLI Agent
alias agent-chat='source ~/cli-agent/.venv/bin/activate && agent chat'
alias agent-ask='source ~/cli-agent/.venv/bin/activate && agent ask'

# Kali MCP
alias kali-mcp-start='source ~/kali-mcp/.venv/bin/activate && python -m kali_mcp_server --transport stdio'

# Shannon Plugin
alias shannon-init='docker run -d --name shannon-tools shannon-tools'

# Quick pentest
alias nmap-quick='nmap -sV -sC -oN scan-$(date +%Y%m%d).txt'
alias nmap-full='nmap -p- -T4 -oN fullscan-$(date +%Y%m%d).txt'

echo "🗡️  Pentest AI Suite ready"
EOF

# ============================================================================
# Final instructions
# ============================================================================
echo ""
echo "═══════════════════════════════════════════════════════════"
echo "  ✅ Setup complete!"
echo "═══════════════════════════════════════════════════════════"
echo ""
echo "Available Tools:"
echo ""
echo "  OpenCode:"
echo "    oc-web       - Start OpenCode web interface"
echo "    opencode     - Start OpenCode TUI"
echo ""
echo "  CLI Agent:"
echo "    agent-chat   - Start CLI Agent"
echo "    agent-chat --model ollama:llama3  - Use offline AI"
echo ""
echo "  Kali MCP (35+ security tools):"
echo "    /port_scan target=IP scan_type=quick"
echo "    /dns_enum domain=example.com"
echo "    /hydra_attack target=IP service=ssh"
echo ""
echo "  Shannon Plugin (autonomous pentesting):"
echo "    /shannon-scan  - Full penetration test"
echo "    /shannon-recon - Reconnaissance only"
echo "    /shannon-report - Generate report"
echo "    shannon-init  - Start Docker container"
echo ""
echo "🗡️  Happy (legal) hacking!"
echo "═══════════════════════════════════════════════════════════"
