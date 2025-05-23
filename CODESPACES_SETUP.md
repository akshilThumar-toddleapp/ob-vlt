# GitHub Codespaces Deployment for Obsidian

## Setup Steps

### 1. Create `.devcontainer/devcontainer.json`
```json
{
  "name": "Obsidian in Browser",
  "image": "lscr.io/linuxserver/obsidian:latest",
  "forwardPorts": [3000, 3001],
  "postCreateCommand": "echo 'Obsidian container ready!'",
  "customizations": {
    "vscode": {
      "extensions": []
    }
  },
  "containerEnv": {
    "PUID": "1000",
    "PGID": "1000",
    "TZ": "America/New_York",
    "TITLE": "Obsidian"
  },
  "mounts": [
    "source=obsidian-data,target=/config,type=volume"
  ]
}
```

### 2. Access Obsidian
- Start Codespace from your GitHub repo
- Wait for container to start (~2 minutes)
- Access via forwarded port 3000
- Full Obsidian desktop in browser!

## Advantages
- ✅ **120 hours/month free** (4 hours/day)
- ✅ **No credit card** required
- ✅ **Better performance** than Render
- ✅ **Persistent storage** during session
- ✅ **Auto-sleep** when inactive (saves hours)

## Limitations
- ⚠️ **Monthly limit** (120 hours)
- ⚠️ **Data lost** between Codespace deletions
- ⚠️ **Must use GitHub** account
