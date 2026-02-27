# 🗡️ Kali + OpenClaw Portable Pentest USB

> **Boot anywhere. Pentest everything. Leave no trace.**

A bootable USB drive combining **Kali Linux Live** with **OpenClaw automation** for portable, automated penetration testing.

![License](https://img.shields.io/badge/license-MIT-blue.svg)
![Kali](https://img.shields.io/badge/Kali-2025.1-blue)
![OpenClaw](https://img.shields.io/badge/OpenClaw-latest-green)

---

## 🔥 Why This Exists

Traditional pentesting workflow problems:

| Problem | This Solution |
|---------|---------------|
| Tools scattered across machines | Single USB, everything pre-configured |
| Manual, repetitive recon workflows | OpenClaw automates + orchestrates |
| Forgetting to document findings | Memory files auto-created |
| Leaving traces on client systems | Boot Live USB, nothing touches host disk |
| Different environments per engagement | Consistent rig every time |

---

## 📦 What You Get

- **Full Kali Linux** - Every pentest tool you know (nmap, metasploit, burp, hashcat, etc.)
- **OpenClaw Gateway** - Automation layer that orchestrates tools, manages sessions, documents findings
- **Persistence** - Your configs, workflows, and findings survive reboots
- **Pre-configured Templates** - Network recon, web app testing, wireless audits
- **Drop-Box Node Support** - Deploy remote nodes on target network, control from USB
- **Forensically Clean** - Remove USB, no trace on host (RAM only)

---

## 🚀 Quick Start

### Build the USB

```bash
# Clone this repo
git clone https://github.com/YOURUSERNAME/kali-openclaw-usb.git
cd kali-openclaw-usb

# Build the USB (REPLACE /dev/sdX with your USB device)
sudo ./build-usb.sh /dev/sdX

# Wait 10-20 minutes (downloads ~3GB Kali ISO)
```

### Boot

1. Plug USB into target machine
2. Boot from USB (F12/Del/Esc for boot menu)
3. **IMPORTANT:** Select **"Live USB Persistence"** at boot menu
4. Login: `kali` / `kali` (default Kali credentials)

### First Boot Setup

```bash
# Run the post-install script
sudo bash ~/openclaw-setup.sh

# Or manually install OpenClaw
curl -fsSL https://openclaw.ai/install.sh | bash
```

### Daily Use

```bash
# Start OpenClaw gateway
oc-start

# Check status
oc-status

# Open web dashboard
oc-dashboard  # Opens http://localhost:18789

# List connected nodes
oc-nodes

# Start a recon session
oc-recon
```

---

## 📁 Repository Structure

```
kali-openclaw-usb/
├── build-usb.sh              # Main build script
├── postinstall/
│   ├── openclaw-setup.sh     # First-boot setup
│   └── README-OPENCLAW.txt   # Quick reference
├── templates/
│   ├── recon-network.md      # Network reconnaissance
│   ├── recon-web.md          # Web app testing
│   └── recon-wifi.md         # Wireless audits
├── scripts/
│   ├── backup-config.sh      # Backup before removing USB
│   └── deploy-node.sh        # Deploy drop-box nodes
├── docs/
│   ├── USAGE.md              # Detailed usage guide
│   ├── SECURITY.md           # Security considerations
│   └── TROUBLESHOOTING.md    # Common issues
└── README.md                 # This file
```

---

## 🎯 Use Cases

### 1. On-Site Penetration Testing

```bash
# Boot USB on your laptop at client site
oc-start

# Run network recon
sessions_spawn --runtime subagent --task "Scan 192.168.1.0/24"

# Document findings in real-time
write path="memory/client-engagement.md" content="..."
```

### 2. Remote Node Orchestration

```bash
# Deploy node on target network machine
openclaw node run --host <your-kali-ip> --port 18789 --display-name "Target-Box"

# Approve on your USB gateway
openclaw nodes approve <requestId>

# Run scans remotely
openclaw nodes run --node "Target-Box" -- nmap -sV 192.168.1.0/24
```

### 3. Red Team Operations

```bash
# Multiple sub-agents for parallel attacks
sessions_spawn --runtime subagent --task "Phishing campaign recon"
sessions_spawn --runtime subagent --task "Infrastructure enumeration"
sessions_spawn --runtime subagent --task "Credential stuffing analysis"

# Coordinate via sessions_send
sessions_send --sessionKey <key> --message "Target acquired, proceeding"
```

### 4. Security Audits + Compliance

```bash
# Automated documentation
# All tool outputs captured in memory files
# Generate reports from workspace

# Backup findings
./backup-config.sh

# Sync to secure storage
rsync -avz ~/.openclaw/workspace/backups user@vps:/secure/
```

---

## 🛠️ Pre-Approved Tools

The build script pre-configures OpenClaw to allow these common pentest tools:

| Tool | Purpose |
|------|---------|
| `nmap` | Network discovery + port scanning |
| `sqlmap` | SQL injection testing |
| `burpsuite` | Web app proxy + scanner |
| `metasploit` | Exploitation framework |
| `hashcat` | Password cracking |
| `john` | John the Ripper |
| `gobuster` | Directory enumeration |
| `nikto` | Web server scanning |
| `wfuzz` | Web fuzzing |
| `dirb` | Directory brute-forcing |
| `hydra` | Online password cracking |
| `netcat` | Network utility |

Add your own in `openclaw-setup.sh`:
```bash
openclaw approvals allowlist add --node localhost "/usr/bin/your-tool"
```

---

## 🔐 Security Considerations

### Legal

> ⚠️ **Only test systems you have written authorization to test.**

- Document all authorization in memory files
- Keep engagement letters in `workspace/authorization/`
- This is a powerful tool — use responsibly

### Operational Security

- **Encrypt persistence partition** for sensitive engagements
- **Never leave USB unattended**
- **Use TLS** for gateway connections (`--tls` flag)
- **Consider panic-wipe script** for high-risk scenarios
- **Use a VPS gateway** instead of running on USB for remote operations

### Technical

- USB 3.0+ **strongly recommended** (2.0 is painfully slow)
- **32GB+ drive minimum** (Kali + tools + persistence)
- **SSD-based USB drives** (Samsung Fit, etc.) much faster than flash
- **Always safely shutdown** — don't just yank USB!

---

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────────────┐
│                    USB Drive                            │
├─────────────────────────────────────────────────────────┤
│  [EFI Boot]  - Kali bootloader                          │
│  [Live ISO]  - Read-only Kali base system               │
│  [Persist]   - /home/kali/.openclaw/                     │
│                - Your configs, workspace, keys           │
│                - Pre-approved tools                      │
│                - Workflow templates                      │
└─────────────────────────────────────────────────────────┘
                          │
                          │ Boot on any x64 machine
                          ▼
┌─────────────────────────────────────────────────────────┐
│              Your Portable Pentest Rig                  │
│  • Full Kali toolset                                    │
│  • OpenClaw gateway (automation + orchestration)        │
│  • Pre-configured workflows                             │
│  • Auto-documentation                                   │
│  • Nothing touches host disk                            │
└─────────────────────────────────────────────────────────┘
                          │
                          │ Optional: Deploy nodes
                          ▼
┌─────────────────────────────────────────────────────────┐
│              Target Network Nodes                       │
│  • Remote machines running node host                    │
│  • Controlled from your USB gateway                     │
│  • Run scans, capture screens, exfil (legally)          │
└─────────────────────────────────────────────────────────┘
```

---

## 📚 Documentation

- **[USAGE.md](docs/USAGE.md)** - Detailed usage guide
- **[SECURITY.md](docs/SECURITY.md)** - Security best practices
- **[TROUBLESHOOTING.md](docs/TROUBLESHOOTING.md)** - Common issues + fixes
- **[TEMPLATES.md](templates/README.md)** - Workflow templates guide

---

## 🤝 Contributing

This is a **starter template**. Make it yours:

1. **Add your workflow templates** - Every engagement is different
2. **Customize bash aliases** - Build your muscle memory
3. **Add pre-approved tools** - Your toolkit, your rules
4. **Build automation scripts** - Common engagements → one command
5. **Share back** - Submit PRs for useful additions

### Ideas for Extensions

- [ ] Encrypted persistence partition setup
- [ ] Auto-sync to secure cloud storage
- [ ] Pre-configured VPS gateway deployment
- [ ] Hardware token integration (YubiKey)
- [ ] Panic-wipe script for emergencies
- [ ] Custom Kali ISO with OpenClaw pre-installed
- [ ] Docker-based alternative build

---

## 🐛 Troubleshooting

### Persistence not working
```bash
# Verify you selected "Live USB Persistence" at boot
# Check persistence.conf exists
cat /persistence/persistence.conf  # Should contain: "/ union"
```

### OpenClaw won't start
```bash
# Check Node.js is installed
node -v

# Reinstall OpenClaw
curl -fsSL https://openclaw.ai/install.sh | bash
```

### Gateway won't bind to port
```bash
# Check if port is in use
netstat -tlnp | grep 18789

# Change port
openclaw config set gateway.port 18790
```

### USB not booting
- Try different USB port (USB 3.0 vs 2.0)
- Disable Secure Boot in BIOS
- Try Rufus (Windows) or Etcher (Mac/Linux) to write ISO

---

## 📜 License

**MIT License** — Do what you want, just don't be evil.

```
Copyright (c) 2026 [Your Name]

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

---

## 🙏 Credits

Built with:
- **[Kali Linux](https://kali.org)** - The penetration testing distribution
- **[OpenClaw](https://openclaw.ai)** - AI automation for security workflows

**Idea timestamped:** 2026-02-26 21:57 CST  
*Because good ideas get stolen. 🗡️*

---

## 📬 Contact

- **GitHub:** [@YOURUSERNAME](https://github.com/YOURUSERNAME)
- **Discord:** [OpenClaw Community](https://discord.gg/clawd)
- **Twitter:** [@YOURHANDLE]

---

> **Disclaimer:** This tool is for authorized security testing only. The authors are not responsible for misuse. Always obtain written permission before testing any system you don't own.
