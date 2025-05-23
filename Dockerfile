# Use the LinuxServer Obsidian image
FROM lscr.io/linuxserver/obsidian:latest

# Set environment variables for cloud deployment
ENV PUID=1000
ENV PGID=1000
ENV TZ=UTC
ENV TITLE=Obsidian

# Expose the ports
EXPOSE 3000 3001

# The image already has the correct entrypoint
