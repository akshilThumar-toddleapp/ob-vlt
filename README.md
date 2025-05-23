# Running Obsidian in Docker - Complete Setup Guide

This guide will help you run the full-featured Obsidian desktop app in your browser using Docker, with persistent storage for your vault and settings.

## Prerequisites

### 1. Install Docker and Docker Compose

**For macOS (using Homebrew):**

```bash
brew install --cask docker
```

**Alternative - Download Docker Desktop:**

- Visit [Docker Desktop for Mac](https://www.docker.com/products/docker-desktop/)
- Download and install the .dmg file
- Start Docker Desktop from Applications

**Verify installation:**

```bash
docker --version
docker-compose --version
```

### 2. Get Your User and Group IDs

Run these commands to get your PUID and PGID:

```bash
id -u  # This gives you PUID
id -g  # This gives you PGID
```

Note these values - you'll need them for the environment variables.

## Setup Instructions

### Step 1: Create the Project Directory

```bash
mkdir obsidian-docker
cd obsidian-docker
```

### Step 2: Create the Configuration Directory

```bash
mkdir obsidian_config
```

This directory will store:

- Obsidian application settings
- Your vault files
- Plugins and themes
- All persistent data

### Step 3: Set Proper Permissions

```bash
# Set ownership of the config directory
sudo chown -R $(id -u):$(id -g) obsidian_config

# Set appropriate permissions
chmod -R 755 obsidian_config
```

### Step 4: Configure Environment Variables

Edit the `docker-compose.yml` file to match your system:

1. **PUID**: Replace `1000` with your user ID (from `id -u`)
2. **PGID**: Replace `1000` with your group ID (from `id -g`)
3. **TZ**: Set your timezone (e.g., `America/New_York`, `Europe/London`, `Asia/Tokyo`)

Common timezone examples:

- `America/New_York` (Eastern US)
- `America/Los_Angeles` (Pacific US)
- `America/Chicago` (Central US)
- `Europe/London` (UK)
- `Europe/Paris` (Central Europe)
- `Asia/Tokyo` (Japan)
- `Australia/Sydney` (Australia)

### Step 5: Start the Container

```bash
# Start the container in detached mode
docker-compose up -d

# Check if the container is running
docker-compose ps

# View logs (optional, for troubleshooting)
docker-compose logs obsidian
```

### Step 6: Access Obsidian

1. **HTTP Access**: Open your browser and go to `http://localhost:3000`
2. **HTTPS Access**: Open your browser and go to `https://localhost:3001`

**First-time setup:**

- The interface will load the Obsidian desktop application
- You can create a new vault or open an existing one
- All data will be saved to the `obsidian_config` directory

## Managing Your Setup

### Stopping the Container

```bash
docker-compose down
```

### Restarting the Container

```bash
docker-compose restart
```

### Updating Obsidian

```bash
# Stop the container
docker-compose down

# Pull the latest image
docker-compose pull

# Start with the new image
docker-compose up -d
```

### Viewing Logs

```bash
# View all logs
docker-compose logs

# Follow logs in real-time
docker-compose logs -f

# View only Obsidian service logs
docker-compose logs obsidian
```

## File Structure

After running, your directory structure will look like:

```
obsidian-docker/
├── docker-compose.yml
└── obsidian_config/
    ├── data/              # Application data
    ├── logs/              # Application logs
    └── (vault folders)    # Your Obsidian vaults
```

## Remote Access and Security

### For Local Network Access

To access Obsidian from other devices on your network:

1. Find your host machine's IP address:

   ```bash
   ipconfig getifaddr en0  # For macOS
   ```

2. Access via: `http://YOUR_IP:3000` or `https://YOUR_IP:3001`

### Security Considerations for Remote Access

**⚠️ Important Security Notes:**

1. **Firewall Configuration**: Only expose ports 3000/3001 to trusted networks
2. **VPN Access**: For internet access, use a VPN tunnel instead of direct exposure
3. **Reverse Proxy**: Consider using nginx or Traefik with SSL certificates
4. **Authentication**: The LinuxServer image doesn't include built-in authentication

### Setting Up Reverse Proxy (Optional)

For production use with SSL:

```yaml
# Add to docker-compose.yml
nginx:
  image: nginx:alpine
  container_name: obsidian-proxy
  ports:
    - "80:80"
    - "443:443"
  volumes:
    - ./nginx.conf:/etc/nginx/nginx.conf
    - ./ssl:/etc/nginx/ssl
  depends_on:
    - obsidian
```

## Troubleshooting

### Common Issues

1. **Permission Denied Errors**:

   ```bash
   sudo chown -R $(id -u):$(id -g) obsidian_config
   ```

2. **Container Won't Start**:

   ```bash
   # Check logs
   docker-compose logs obsidian

   # Verify Docker is running
   docker info
   ```

3. **Port Already in Use**:

   ```bash
   # Check what's using the port
   lsof -i :3000

   # Kill the process if needed
   sudo kill -9 <PID>
   ```

4. **Display Issues**:
   - The `shm_size: "1gb"` and `seccomp:unconfined` settings help with display rendering
   - If you experience issues, try increasing `shm_size` to `2gb`

### Performance Optimization

1. **Increase Shared Memory** (if experiencing lag):

   ```yaml
   shm_size: "2gb" # Increase from 1gb
   ```

2. **Resource Limits** (optional):
   ```yaml
   deploy:
     resources:
       limits:
         memory: 4G
         cpus: "2.0"
   ```

### Backup Your Data

Your Obsidian data is stored in `./obsidian_config`. To backup:

```bash
# Create a backup
tar -czf obsidian-backup-$(date +%Y%m%d).tar.gz obsidian_config/

# Restore from backup
tar -xzf obsidian-backup-YYYYMMDD.tar.gz
```

## Additional Tips

1. **Multiple Vaults**: You can create multiple vaults within the same container
2. **Plugin Installation**: All community plugins work normally through the web interface
3. **File Sync**: You can sync the `obsidian_config` directory with cloud storage for backup
4. **Mobile Access**: Access your vault from mobile devices using the web interface
5. **Theme Support**: All Obsidian themes work through the web interface

## Getting Started with Obsidian

Once you've accessed Obsidian in your browser:

1. **Create or Open a Vault**:

   - Click "Create new vault" or "Open folder as vault"
   - Choose a location within the container (it will be saved to your host)

2. **Install Community Plugins**:

   - Go to Settings → Community Plugins
   - Browse and install plugins as needed

3. **Customize Your Workspace**:
   - Install themes from Settings → Appearance
   - Configure hotkeys and preferences

Your Obsidian experience will be identical to the desktop app, but accessible from any web browser!
