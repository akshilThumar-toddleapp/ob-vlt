# Obsidian in Codespaces - Quick Start Guide

## Getting Started

1. **Open a terminal** in your codespace (bottom panel)

2. **Make the helper script executable:**
   ```bash
   chmod +x obsidian.sh
   ```

3. **Start Obsidian container:**
   ```bash
   ./obsidian.sh start
   ```

4. **Access Obsidian:**
   - Look for the **PORTS** tab in the bottom panel
   - Find port **3000** in the list
   - Click the **globe icon** next to port 3000
   - Obsidian will open in a new browser tab

## Managing Your Obsidian

| Command | Description |
|---------|-------------|
| `./obsidian.sh start` | Start the container |
| `./obsidian.sh stop` | Stop the container |
| `./obsidian.sh logs` | View container logs |
| `./obsidian.sh status` | Check container status |
| `./obsidian.sh ports` | Show access information |

## Important Notes

- **Data Persistence:** Your notes are stored in a Docker volume called `obsidian_data`
- **Sleep Mode:** Your codespace will sleep after 30 minutes of inactivity
- **Usage Limits:** Free GitHub accounts get 60 hours of Codespaces usage per month

## Tips

- **First Load:** The first load of Obsidian may take 30-60 seconds
- **Create Vault:** You can create a vault anywhere in the container's file system
- **Backup:** For important notes, consider syncing to GitHub or another service
