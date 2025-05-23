#!/bin/bash
# Script to copy local files to Obsidian in GitHub Codespaces

# Color formatting
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}╔════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║${GREEN}    Copy Files to Obsidian in GitHub Codespaces    ${BLUE}║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════╝${NC}"

# Check if we are in a GitHub Codespace
if [ -z "$GITHUB_CODESPACES" ] && [ -z "$CODESPACES" ]; then
    echo -e "${RED}This script is designed to run within a GitHub Codespace.${NC}"
    echo -e "${YELLOW}If you're in a Codespace but seeing this message, continue anyway (y/n)?${NC}"
    read -r CONTINUE
    if [[ "$CONTINUE" != "y" && "$CONTINUE" != "Y" ]]; then
        exit 1
    fi
fi

# Detect Obsidian config location
if [ -d "/config" ]; then
    OBSIDIAN_ROOT="/config"
    echo -e "${GREEN}Found Obsidian configuration at /config${NC}"
elif [ -d "/workspaces/obsidian" ]; then
    OBSIDIAN_ROOT="/workspaces/obsidian"
    echo -e "${GREEN}Found Obsidian at /workspaces/obsidian${NC}"
elif [ -d "obsidian_config" ]; then
    OBSIDIAN_ROOT="obsidian_config"
    echo -e "${GREEN}Found Obsidian configuration at ./obsidian_config${NC}"
else
    echo -e "${YELLOW}Enter the path to your Obsidian vault in Codespaces:${NC}"
    read -r OBSIDIAN_ROOT
    if [ ! -d "$OBSIDIAN_ROOT" ]; then
        echo -e "${RED}Directory not found: $OBSIDIAN_ROOT${NC}"
        echo -e "${YELLOW}Create it? (y/n)${NC}"
        read -r CREATE_DIR
        if [[ "$CREATE_DIR" == "y" || "$CREATE_DIR" == "Y" ]]; then
            mkdir -p "$OBSIDIAN_ROOT"
        else
            exit 1
        fi
    fi
fi

# Ask if files are local or to be pulled from Git
echo -e "${YELLOW}Are the files already in this Codespace? (y/n)${NC}"
read -r FILES_LOCAL

if [[ "$FILES_LOCAL" == "y" || "$FILES_LOCAL" == "Y" ]]; then
    # Ask for path to files
    echo -e "${YELLOW}Enter the path to your files:${NC}"
    read -r FILES_PATH
    
    # Check if the path exists
    if [ ! -d "$FILES_PATH" ] && [ ! -f "$FILES_PATH" ]; then
        echo -e "${RED}Path not found: $FILES_PATH${NC}"
        exit 1
    fi
    
    # Ask for destination folder within Obsidian
    echo -e "${YELLOW}Enter the destination folder within Obsidian (e.g., 'MyVault' or leave empty for root):${NC}"
    read -r DEST_FOLDER
    
    # Create the destination directory if it doesn't exist
    if [ -n "$DEST_FOLDER" ]; then
        DEST_PATH="$OBSIDIAN_ROOT/$DEST_FOLDER"
        mkdir -p "$DEST_PATH"
    else
        DEST_PATH="$OBSIDIAN_ROOT"
    fi
    
    # Copy files to Obsidian
    echo -e "${YELLOW}Copying files to Obsidian...${NC}"
    if [ -d "$FILES_PATH" ]; then
        cp -r "$FILES_PATH"/* "$DEST_PATH"
    else
        cp "$FILES_PATH" "$DEST_PATH"
    fi
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}Files copied successfully to Obsidian!${NC}"
        echo -e "${BLUE}Your files are now available in Obsidian at path: $DEST_PATH${NC}"
    else
        echo -e "${RED}Copy operation failed. Please check your paths and permissions.${NC}"
    fi
else
    # Files need to be pulled from Git
    echo -e "${YELLOW}Enter the URL of the Git repository containing your files:${NC}"
    read -r GIT_URL
    
    # Create a temporary directory
    TEMP_DIR=$(mktemp -d)
    echo -e "${YELLOW}Cloning repository...${NC}"
    git clone "$GIT_URL" "$TEMP_DIR"
    
    if [ $? -ne 0 ]; then
        echo -e "${RED}Failed to clone repository.${NC}"
        exit 1
    fi
    
    # Ask for source path within the cloned repo
    echo -e "${YELLOW}Enter the path to your files within the repo (or leave empty for root):${NC}"
    read -r REPO_PATH
    
    SOURCE_PATH="$TEMP_DIR"
    if [ -n "$REPO_PATH" ]; then
        SOURCE_PATH="$TEMP_DIR/$REPO_PATH"
    fi
    
    # Ask for destination folder within Obsidian
    echo -e "${YELLOW}Enter the destination folder within Obsidian (e.g., 'MyVault' or leave empty for root):${NC}"
    read -r DEST_FOLDER
    
    # Create the destination directory if it doesn't exist
    if [ -n "$DEST_FOLDER" ]; then
        DEST_PATH="$OBSIDIAN_ROOT/$DEST_FOLDER"
        mkdir -p "$DEST_PATH"
    else
        DEST_PATH="$OBSIDIAN_ROOT"
    fi
    
    # Copy files to Obsidian
    echo -e "${YELLOW}Copying files to Obsidian...${NC}"
    cp -r "$SOURCE_PATH"/* "$DEST_PATH"
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}Files copied successfully to Obsidian!${NC}"
        echo -e "${BLUE}Your files are now available in Obsidian at path: $DEST_PATH${NC}"
    else
        echo -e "${RED}Copy operation failed. Please check your paths and permissions.${NC}"
    fi
    
    # Clean up
    rm -rf "$TEMP_DIR"
fi

echo -e "${BLUE}╔════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║${GREEN}                  Next Steps                     ${BLUE}║${NC}"
echo -e "${BLUE}║${NC}                                                  ${BLUE}║${NC}"
echo -e "${BLUE}║${NC} 1. Access Obsidian in your Codespace             ${BLUE}║${NC}"
echo -e "${BLUE}║${NC} 2. Open the vault containing your files          ${BLUE}║${NC}"
echo -e "${BLUE}║${NC} 3. Enjoy using Obsidian in GitHub Codespaces!    ${BLUE}║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════╝${NC}"
