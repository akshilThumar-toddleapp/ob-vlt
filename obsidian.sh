#!/bin/bash
# Helper script for managing Obsidian in Codespaces

# Color formatting
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Show the banner
echo -e "${BLUE}╔════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║${GREEN}             Obsidian in Codespaces               ${BLUE}║${NC}"
echo -e "${BLUE}║${GREEN}                                                  ${BLUE}║${NC}"
echo -e "${BLUE}║${YELLOW} Commands:                                       ${BLUE}║${NC}"
echo -e "${BLUE}║${NC}   1. ${GREEN}start${NC} - Start Obsidian container             ${BLUE}║${NC}"
echo -e "${BLUE}║${NC}   2. ${GREEN}stop${NC} - Stop Obsidian container              ${BLUE}║${NC}"
echo -e "${BLUE}║${NC}   3. ${GREEN}logs${NC} - Show Obsidian container logs         ${BLUE}║${NC}"
echo -e "${BLUE}║${NC}   4. ${GREEN}status${NC} - Check container status             ${BLUE}║${NC}"
echo -e "${BLUE}║${NC}   5. ${GREEN}ports${NC} - Show port forwarding info           ${BLUE}║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════╝${NC}"

# Process command
case "$1" in
  start)
    echo -e "${GREEN}Starting Obsidian container...${NC}"
    docker-compose up -d
    echo -e "${GREEN}Container started!${NC}"
    echo -e "${YELLOW}Access Obsidian at:${NC} http://localhost:3000"
    echo -e "${YELLOW}(Look for the PORTS tab at the bottom panel)${NC}"
    ;;
    
  stop)
    echo -e "${YELLOW}Stopping Obsidian container...${NC}"
    docker-compose down
    echo -e "${GREEN}Container stopped!${NC}"
    ;;
    
  logs)
    echo -e "${BLUE}Showing container logs (press Ctrl+C to exit):${NC}"
    docker-compose logs -f
    ;;
    
  status)
    echo -e "${BLUE}Container status:${NC}"
    docker-compose ps
    ;;
    
  ports)
    echo -e "${YELLOW}Port forwarding information:${NC}"
    echo -e "Obsidian is available at: ${GREEN}http://localhost:3000${NC} (HTTP)"
    echo -e "Obsidian is available at: ${GREEN}https://localhost:3001${NC} (HTTPS)"
    echo -e "${YELLOW}Look for these in the PORTS tab at the bottom panel${NC}"
    ;;
    
  *)
    echo -e "${YELLOW}Usage: ./obsidian.sh [command]${NC}"
    echo -e "Available commands: start, stop, logs, status, ports"
    ;;
esac
