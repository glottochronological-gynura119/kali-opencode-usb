#!/bin/bash
################################################################################
# Kali + OpenCode + CLI Agent + Kali MCP Setup Script
# Runs after first boot into Kali Live
################################################################################

set -euo pipefail

KALI_USER="kali"
OPENCODE_HOME="/home/$KALI_USER/.opencode"
CLI_AGENT_HOME="/home/$KALI_USER/cli-agent"
KALI_MCP_HOME="/home/$KALI_USER/kali-mcp"

echo "🗡️  Setting up Pentest AI Suite..."
echo ""

# ============================================================================
# Install OpenCode
# ============================================================================
echo "[1/5] Installing OpenCode..."
if command -v opencode &> /dev/null; then
    echo "  OpenCode already installed"
else
    curl -fsSL https://opencode.ai/install.sh | bash
fi
echo ""

# ============================================================================
# Install CLI Agent
# ============================================================================
echo "[2/5] Installing CLI Agent..."
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
echo "[3/5] Installing Kali MCP Server..."
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
# Install Ollama (optional - for offline AI)
# ============================================================================
echo "[4/5] Setting up Ollama (optional)..."
if command -v ollama &> /dev/null; then
    echo "  Ollama already installed"
else
    read -p "  Install Ollama for offline AI models? (y/n): " install_ollama
    if [[ "$install_ollama" == "y" ]]; then
        curl -fsSL https://ollama.com/install.sh | bash
        
        echo "  Pulling default models (this may take a while)..."
        ollama pull llama3
        ollama pull codellama
        echo "  Models ready for offline use"
    fi
fi
echo ""

# ============================================================================
# Configure MCP Servers
# ============================================================================
echo "[5/5] Configuring MCP servers..."
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
alias agent-shell='source ~/cli-agent/.venv/bin/activate && agent shell'

# Kali MCP
alias kali-mcp-start='source ~/kali-mcp/.venv/bin/activate && python -m kali_mcp_server --transport stdio'
alias mcp-test='source ~/kali-mcp/.venv/bin/activate && python -m kali_mcp_server --transport stdio --help'

# Ollama
alias ollama-list='ollama list'
alias ollama-models='ollama list'
alias ollama-run='agent chat --model ollama:llama3'

# Quick pentest
alias nmap-quick='nmap -sV -sC -oN scan-$(date +%Y%m%d).txt'
alias nmap-full='nmap -p- -T4 -oN fullscan-$(date +%Y%m%d).txt'

echo "🗡️  Pentest AI Suite ready"
echo "   oc-web        - OpenCode Web UI"
echo "   agent-chat    - CLI Agent"
echo "   kali-mcp-start - Kali MCP Server"
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
echo "    kali-mcp-start  - Start MCP server"
echo "    /port_scan target=IP scan_type=quick"
echo "    /dns_enum domain=example.com"
echo "    /hydra_attack target=IP service=ssh"
echo "    /recon_auto target=example.com depth=standard"
echo ""
echo "  Ollama Models:"
echo "    Cloud:  deepseek, anthropic, openai, gemini"
echo "    Local:  ollama:llama3, ollama:codellama"
echo ""
echo "🗡️  Happy (legal) hacking!"
echo "═══════════════════════════════════════════════════════════"
