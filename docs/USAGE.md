# Usage Guide

## Quick Reference

```bash
# Gateway management
oc-start         # Start OpenClaw gateway
oc-stop          # Stop gateway
oc-status        # Check gateway status
oc-dashboard     # Open web UI (localhost:18789)

# Node management
oc-nodes         # List connected nodes
oc-pending       # Show pending node approvals
oc-approve <id>  # Approve a node

# Sessions
oc-recon         # Spawn recon sub-agent
```

---

## First Boot

1. **Boot from USB** - Select "Live USB Persistence"
2. **Login** - `kali` / `kali`
3. **Run setup** - `bash ~/openclaw-setup.sh`
4. **Start gateway** - `oc-start`

---

## Common Workflows

### Network Reconnaissance

```bash
# Start gateway
oc-start

# Open dashboard for visual monitoring
oc-dashboard

# Spawn recon agent
sessions_spawn --runtime subagent --task "Scan 192.168.1.0/24, identify live hosts and services"

# Or run manually
nmap -sV -sC -oN scan.txt 192.168.1.0/24

# Document findings
write path="memory/network-recon-$(date +%Y-%m-%d).md" content="Findings..."
```

### Web Application Testing

```bash
# Browser automation
browser action=snapshot profile=openclaw
browser action=navigate targetUrl="https://target.com"

# Directory enumeration
gobuster dir -u https://target.com -w /usr/share/wordlists/dirb/common.txt -o gobuster.txt

# Vulnerability scan
nikto -h https://target.com -o nikto.txt

# Document
write path="memory/web-audit-$(date +%Y-%m-%d).md" content="..."
```

### Deploy Remote Node

```bash
# On target machine
bash run-node.sh  # From deployment package

# On your USB gateway
openclaw nodes pending
openclaw nodes approve <requestId>

# Verify
openclaw nodes status

# Run commands remotely
openclaw nodes run --node "Target-Box" -- nmap -sV 192.168.1.0/24
openclaw nodes camera snap --node "Target-Box"
openclaw nodes screen record --node "Target-Box" --duration 30s
```

### Multi-Agent Coordination

```bash
# Spawn multiple agents for parallel work
AGENT1=$(sessions_spawn --runtime subagent --task "Network scanning" --mode session)
AGENT2=$(sessions_spawn --runtime subagent --task "Web app testing" --mode session)
AGENT3=$(sessions_spawn --runtime subagent --task "Wireless analysis" --mode session)

# Send coordination messages
sessions_send --sessionKey "$AGENT1" --message "Focus on ports 80,443,8080"
sessions_send --sessionKey "$AGENT2" --message "Start with /admin and /api endpoints"

# Check progress
sessions_list

# Collect findings
sessions_history --sessionKey "$AGENT1"
```

---

## Templates

Located in `~/.openclaw/workspace/templates/`:

- **recon-network.md** - Network reconnaissance workflow
- **recon-web.md** - Web application testing
- **recon-wifi.md** - Wireless security audits

Copy and customize for each engagement:
```bash
cp templates/recon-network.md engagements/client-name-network.md
```

---

## Memory Management

Daily findings go in `memory/YYYY-MM-DD.md`:

```bash
# Create today's memory file
cat > memory/$(date +%Y-%m-%d).md << 'EOF'
# $(date +%Y-%m-%d)

## Engagement: Client Name

### Findings
- 

### Commands Run
- 

### Next Steps
- 
EOF
```

---

## Backup

**Always backup before removing USB:**

```bash
# Local backup
~/backup-config.sh

# Remote sync
~/backup-config.sh user@vps:/backups/

# Manual rsync
rsync -avz ~/.openclaw/workspace user@vps:/backups/openclaw-workspace/
```

---

## Security Best Practices

### Before Engagement
- [ ] Verify written authorization is in `workspace/authorization/`
- [ ] Encrypt persistence partition if not already done
- [ ] Test all tools work correctly
- [ ] Backup current configuration

### During Engagement
- [ ] Document all activities in memory files
- [ ] Keep authorization documents accessible
- [ ] Never leave USB unattended
- [ ] Use TLS for any remote connections

### After Engagement
- [ ] Complete all documentation
- [ ] Backup findings to secure storage
- [ ] Clear any sensitive data from workspace (if needed)
- [ ] Verify USB is encrypted before transport

---

## Troubleshooting

### Gateway won't start
```bash
# Check if already running
pgrep -f "openclaw"

# Check port availability
netstat -tlnp | grep 18789

# Check logs
tail -f ~/.openclaw/logs/*.log
```

### Persistence not saving
```bash
# Verify persistence partition is mounted
mount | grep persistence

# Check persistence.conf
cat /persistence/persistence.conf  # Should be: "/ union"
```

### Tools not in allowlist
```bash
# View current allowlist
openclaw approvals allowlist list

# Add missing tool
openclaw approvals allowlist add --node localhost "/usr/bin/tool-name"
```

### Node won't connect
```bash
# Check firewall on gateway
sudo ufw allow 18789/tcp

# Verify gateway is listening
netstat -tlnp | grep 18789

# Check node can reach gateway
ping <gateway-ip>
```

---

## Tips & Tricks

### Quick Status Check
```bash
# Add to .bashrc for auto-status
alias oc-check='openclaw status && openclaw nodes status'
```

### Auto-Document Commands
```bash
# Log all nmap commands
alias nmap='nmap -oN logs/nmap-$(date +%Y%m%d-%H%M%S).txt'
```

### Fast Engagement Setup
```bash
# Create engagement directory
mkdir -p engagements/client-$(date +%Y%m%d)
cd engagements/client-$(date +%Y%m%d)

# Copy templates
cp ~/templates/*.md .

# Start logging
script -a session.log
```

### Emergency Cleanup
```bash
# Quick clear of sensitive data
find ~/.openclaw/workspace -name "*.txt" -delete
find ~/.openclaw/workspace -name "*.log" -delete
shred -u memory/*.md  # Secure delete
```

---

## Keyboard Shortcuts (Dashboard)

When using the web dashboard at `localhost:18789`:

- `Ctrl+K` - Quick command palette
- `Ctrl+J` - Jump to sessions
- `Ctrl+N` - New session

---

## Getting Help

```bash
# OpenClaw help
openclaw --help
openclaw <command> --help

# Check documentation
openclaw docs

# Community support
# Discord: https://discord.gg/clawd
```
