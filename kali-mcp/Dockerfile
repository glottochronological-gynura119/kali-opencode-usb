FROM kalilinux/kali-rolling

# Set non-interactive mode for apt
ENV DEBIAN_FRONTEND=noninteractive

# Install system dependencies and security tools
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    python3-venv \
    git \
    nmap \
    metasploit-framework \
    netcat-openbsd \
    curl \
    wget \
    dnsutils \
    whois \
    hydra \
    gobuster \
    dirb \
    nikto \
    sqlmap \
    testssl.sh \
    amass \
    httpx-toolkit \
    subfinder \
    gospider \
    golang \
    smbclient \
    enum4linux \
    nfs-common \
    hashid \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install waybackurls using Go
RUN go install github.com/tomnomnom/waybackurls@latest && \
    cp /root/go/bin/waybackurls /usr/local/bin/

# Create app directory
WORKDIR /app
COPY . /app/

# Create and activate virtual environment
RUN python3 -m venv /app/venv
ENV PATH="/app/venv/bin:$PATH"

# Install uv package manager
RUN pip install --no-cache-dir -v uv

# Install Python dependencies
RUN pip install --no-cache-dir -v -r requirements.txt

# Install development tooling used by run_tests.sh
RUN pip install --no-cache-dir -v \
    pyright \
    ruff \
    pytest \
    pytest-asyncio \
    black

# Ensure appropriate output directory permissions
RUN touch /app/command_output.txt

# Expose port for SSE
EXPOSE 8000

# Run the server with SSE transport
CMD ["python", "-m", "kali_mcp_server.server", "--transport", "sse", "--port", "8000"]