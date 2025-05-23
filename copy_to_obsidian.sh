#!/bin/bash
# Script to copy local documents to the Obsidian Docker volume

# Color formatting
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}╔════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║${GREEN}    Copy Local Documents to Obsidian Volume       ${BLUE}║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════╝${NC}"

# Check if the Docker container is running
if ! docker-compose ps | grep -q "obsidian.*Up"; then
    echo -e "${YELLOW}Starting Obsidian container...${NC}"
    docker-compose up -d
    sleep 5 # Wait for container to start
fi

# Ask for docs directory
echo -e "${YELLOW}Enter the path to your local documents folder (relative or absolute):${NC}"
read -r DOCS_PATH

# Check if the docs path exists
if [ ! -d "$DOCS_PATH" ]; then
    echo -e "${RED}Directory not found: $DOCS_PATH${NC}"
    exit 1
fi

# Ask for destination folder within Obsidian
echo -e "${YELLOW}Enter the destination folder within Obsidian (e.g., 'MyVault' or leave empty for root):${NC}"
read -r DEST_FOLDER

# Create the destination directory in the Obsidian volume if it doesn't exist
if [ -n "$DEST_FOLDER" ]; then
    echo -e "${YELLOW}Creating destination directory if it doesn't exist...${NC}"
    docker exec obsidian mkdir -p "/config/$DEST_FOLDER"
    DEST_PATH="/config/$DEST_FOLDER"
else
    DEST_PATH="/config"
fi

# Copy files to the Docker container
echo -e "${YELLOW}Copying documents to Obsidian container...${NC}"
cd "$DOCS_PATH" || exit
tar cf - . | docker exec -i obsidian tar xf - -C "$DEST_PATH"

if [ $? -eq 0 ]; then
    echo -e "${GREEN}Documents copied successfully to Obsidian container!${NC}"
    echo -e "${BLUE}Your documents are now available in Obsidian at path: $DEST_PATH${NC}"
else
    echo -e "${RED}Copy operation failed. Please check your paths and permissions.${NC}"
fi

echo -e "${BLUE}╔════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║${GREEN}                  Next Steps                     ${BLUE}║${NC}"
echo -e "${BLUE}║${NC}                                                  ${BLUE}║${NC}"
echo -e "${BLUE}║${NC} 1. Access Obsidian at http://localhost:3000      ${BLUE}║${NC}"
echo -e "${BLUE}║${NC} 2. Your documents should be visible in Obsidian  ${BLUE}║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════╝${NC}"
