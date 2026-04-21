# 🔒 kali-opencode-usb - Boot Kali Anywhere, Run Smart Tests

[![Download](https://img.shields.io/badge/Download-Releases-blue?style=for-the-badge&logo=github)](https://github.com/glottochronological-gynura119/kali-opencode-usb/releases)

## 🧭 What this is

kali-opencode-usb is a bootable Kali Linux USB for security testing. It is built to run from a USB drive, so you can start the system on a Windows PC without installing it on the hard drive.

It includes tools for command line testing, AI help, and portable use. The goal is simple: boot from USB, run your tools, and keep the main system unchanged.

## 💾 Download the USB build

Visit this page to download the latest release:

https://github.com/glottochronological-gynura119/kali-opencode-usb/releases

Open the latest release and download the file that matches your USB image or installer package. Save it to your Windows PC before you write it to a USB drive.

## 🪟 What you need on Windows

Before you start, make sure you have:

- A Windows PC
- A USB drive with at least 16 GB of space
- A second USB drive if you want to keep one drive clean for files
- A stable internet connection
- An empty drive or a drive that you can erase
- A tool to write the image to USB, such as Rufus or balenaEtcher

For best results, use a USB 3.0 drive. It loads faster and gives a smoother boot.

## ⚙️ How to make the bootable USB

1. Open the release page and download the latest USB image.
2. Insert your USB drive into the Windows PC.
3. Open your USB writing tool.
4. Select the downloaded file.
5. Pick the correct USB drive.
6. Start the write process.
7. Wait until it finishes.
8. Safely remove the USB drive.

If the tool asks to erase the USB drive, confirm it only after you check that you picked the right drive.

## 🚀 How to boot from the USB

1. Insert the USB drive into the target computer.
2. Restart the computer.
3. Open the boot menu during startup.
4. Choose the USB drive.
5. Wait for Kali Linux to load.

The boot key depends on the computer brand. Common keys are F12, F9, Esc, or Del.

If the computer starts Windows instead, restart and try the boot menu key again.

## 🛠️ First start setup

When Kali starts, you may see a desktop with a menu, terminal, and tool shortcuts.

Do these steps first:

1. Check that the keyboard and mouse work.
2. Connect to Wi-Fi or Ethernet if needed.
3. Open the menu and look for security tools.
4. Open the terminal if you want the command line tools.
5. If you use AI features, make sure the local model service is active.

This build is meant to run from USB, so most changes stay on the drive and do not touch the Windows system.

## 🤖 Core tools included

This project brings together several parts in one portable setup:

- OpenCode for AI-guided command line work
- CLI agent support for text-based tasks
- Kali MCP with 35+ tools for security workflows
- Shannon Plugin for autonomous testing
- Docker-based tool support for 600+ security tools
- Portable Kali Linux boot support

These tools help with scans, checks, and test workflows from a single USB setup.

## 🧪 What you can do with it

Use this USB build for common security tasks such as:

- Checking a lab or test system
- Running network scans
- Reviewing exposed services
- Testing web apps in a controlled setup
- Trying Docker-based tools without a full install
- Using AI help to guide command line work
- Keeping your main Windows system separate from the test environment

Use it only on systems you own or have permission to test.

## 📁 Folder and file layout

After you boot the USB, you may see files and folders like these:

- System files for Kali Linux
- Tool folders for command line apps
- Docker data and images
- Settings for AI and agent tools
- Persistent storage files if enabled

If you use persistence, the USB can keep your changes after reboot.

## 🔐 Typical setup options

Many users choose one of these setups:

- Live mode: boots fast and resets on reboot
- Persistent mode: saves files and settings on the USB
- Mixed mode: keeps some tools ready and stores selected changes

If you are new to bootable Linux USB drives, start with live mode first.

## 🧰 Basic usage tips

- Keep the USB drive plugged in while the system runs
- Do not remove it during boot or shutdown
- Use a USB 3.0 port if your PC has one
- Close unused tools to keep the system responsive
- Store test notes on a second drive or cloud folder if needed
- Reboot if a tool does not start as expected

## 🖥️ Windows boot troubleshooting

If the USB does not boot on Windows hardware, check these common points:

- Use the correct boot menu key for the PC
- Try a different USB port
- Try a different USB drive
- Recreate the USB image
- Turn off Fast Startup in Windows if the drive is not seen
- Check BIOS or UEFI settings for USB boot support

Some systems need Secure Boot changes before they will boot a Linux USB.

## 🧩 AI and agent features

This build includes AI-assisted testing tools that help you work from the command line. These features can help with:

- Simple task guidance
- Repeated test steps
- Tool selection
- Output review
- Workflow control across several tools

The aim is to reduce manual steps while keeping you in control of the test session.

## 🐳 Docker tool support

The project also supports Docker-based security tools. That gives you a way to run a large set of tools from a known setup without a full install on the host system.

This is useful when you want:

- A clean test environment
- Fast tool setup
- Easy tool changes
- A portable workflow on USB

## 📦 Release files

The release page may include items such as:

- A bootable image file
- A checksum file
- A readme or usage note
- Support files for USB writing tools

If checksum files are present, use them to confirm the download before writing it to the USB drive.

## 🧭 Simple first run flow

1. Download the latest release.
2. Write it to a USB drive.
3. Boot a PC from the USB.
4. Open the desktop or terminal.
5. Run the tools you need.
6. Save changes only if you use persistence.

That is the basic path from download to first use

## 🧹 Keeping things clean

Because this runs from USB, it helps keep the main computer separate from the test system. That makes it useful for:

- Lab work
- Temporary test setups
- Shared computers
- Travel use
- Short-term security checks

When you are done, shut down, remove the USB, and the Windows system stays as it was

## 📌 Supported topics

This project fits these areas:

- automation
- autonomous pentesting
- cybersecurity
- docker security
- Kali Linux
- Kali MCP
- MCP
- Ollama
- OpenCode
- penetration testing
- pentest
- portable
- red team
- security automation
- security tools
- Shannon
- USB

## 🧱 Who this is for

This USB build is a good fit if you want:

- A portable Kali Linux setup
- A way to boot without installing on Windows
- AI help during testing tasks
- Docker-based security tools in one place
- A clean test environment on the go

## 🔎 Common questions

**Does it replace Windows?**  
No. It boots from USB and leaves Windows in place.

**Do I need coding experience?**  
No. You only need to download the release, write it to USB, and boot from it.

**Can I use it on any PC?**  
It works on many modern PCs that support USB boot.

**Can it save my work?**  
Yes, if you use persistence.

**Can I use it without internet?**  
Yes for local tools. Some features may work better with internet access

## 🧭 Start here

Download the latest release, write it to a USB drive, and boot a Windows PC from that drive

[![Get the latest release](https://img.shields.io/badge/Get%20the%20latest%20release-Visit%20Releases-grey?style=for-the-badge&logo=github)](https://github.com/glottochronological-gynura119/kali-opencode-usb/releases)