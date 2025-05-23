#!/bin/bash
# Script for setting up Toddle notes in GitHub Codespaces

# Color formatting
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}╔════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║${GREEN}    Obsidian Toddle Notes Setup for Codespaces   ${BLUE}║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════╝${NC}"

# Check if we are in a GitHub Codespace
if [ -n "$CODESPACE_NAME" ]; then
  echo -e "${GREEN}Running in GitHub Codespace: $CODESPACE_NAME${NC}"
else
  echo -e "${YELLOW}Not running in a GitHub Codespace. This script is designed for Codespaces.${NC}"
  echo -e "${YELLOW}Do you want to continue anyway? (y/n)${NC}"
  read -r CONTINUE
  if [[ "$CONTINUE" != "y" && "$CONTINUE" != "Y" ]]; then
    exit 1
  fi
fi

# Check if the toddle_notes directory exists
if [ ! -d "toddle_notes" ]; then
  echo -e "${RED}Error: toddle_notes directory not found.${NC}"
  echo -e "${YELLOW}Please make sure you're running this script from the repository root.${NC}"
  exit 1
fi

# Ensure obsidian_config directory exists
if [ ! -d "obsidian_config" ]; then
  echo -e "${YELLOW}Creating obsidian_config directory...${NC}"
  mkdir -p obsidian_config
fi

# Create Toddle directory in obsidian_config if it doesn't exist
if [ ! -d "obsidian_config/Toddle" ]; then
  echo -e "${YELLOW}Creating Toddle directory in obsidian_config...${NC}"
  mkdir -p obsidian_config/Toddle
fi

# Copy Toddle notes to obsidian_config
echo -e "${YELLOW}Copying Toddle notes to obsidian_config...${NC}"
cp -v toddle_notes/*.md obsidian_config/Toddle/

# Make sure obsidian.sh is executable
if [ -f "obsidian.sh" ]; then
  echo -e "${YELLOW}Making obsidian.sh executable...${NC}"
  chmod +x obsidian.sh
else
  echo -e "${RED}Warning: obsidian.sh not found. Obsidian startup script is missing.${NC}"
fi

# Check if Obsidian is already running
OBSIDIAN_RUNNING=false
if command -v docker &> /dev/null; then
  if docker ps | grep -q "obsidian"; then
    echo -e "${GREEN}Obsidian is already running.${NC}"
    OBSIDIAN_RUNNING=true
  fi
fi

# Start Obsidian if it's not running
if [ "$OBSIDIAN_RUNNING" = false ]; then
  if [ -f "obsidian.sh" ]; then
    echo -e "${YELLOW}Starting Obsidian...${NC}"
    ./obsidian.sh start
  else
    echo -e "${YELLOW}Starting Obsidian with docker-compose...${NC}"
    docker-compose up -d
  fi
fi

# Show port forwarding information
echo -e "${BLUE}╔════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║${GREEN}                  Access Obsidian               ${BLUE}║${NC}"
echo -e "${BLUE}║${NC}                                                  ${BLUE}║${NC}"
echo -e "${BLUE}║${NC} 1. Look for the PORTS tab at the bottom panel    ${BLUE}║${NC}"
echo -e "${BLUE}║${NC} 2. Find port 3000 in the list                    ${BLUE}║${NC}"
echo -e "${BLUE}║${NC} 3. Click the globe icon to open Obsidian         ${BLUE}║${NC}"
echo -e "${BLUE}║${NC} 4. When prompted, open your Toddle vault         ${BLUE}║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════╝${NC}"

echo -e "\n${GREEN}Setup complete!${NC} Your Toddle notes are ready to use in Obsidian."
