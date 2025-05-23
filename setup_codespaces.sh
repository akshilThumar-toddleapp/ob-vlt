#!/bin/bash
# Script to help set up GitHub Codespaces for Obsidian

# Color formatting
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}╔════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║${GREEN}       Set Up Obsidian in GitHub Codespaces       ${BLUE}║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════╝${NC}"

# Check if git is installed
if ! command -v git &> /dev/null; then
    echo -e "${RED}Git is not installed. Please install Git first.${NC}"
    exit 1
fi

# Create GitHub Codespaces setup file if it doesn't exist
if [ ! -f ".devcontainer/devcontainer.json" ]; then
    echo -e "${YELLOW}Creating .devcontainer directory...${NC}"
    mkdir -p .devcontainer
    
    echo -e "${YELLOW}Creating devcontainer.json configuration...${NC}"
    cat > .devcontainer/devcontainer.json << EOF
{
    "name": "Obsidian Vault",
    "dockerComposeFile": "../docker-compose.yml",
    "service": "obsidian",
    "workspaceFolder": "/config",
    "forwardPorts": [3000, 3001],
    "portsAttributes": {
        "3000": {
            "label": "Obsidian HTTP",
            "onAutoForward": "openPreview"
        },
        "3001": {
            "label": "Obsidian HTTPS",
            "onAutoForward": "silent"
        }
    },
    "postStartCommand": "chmod +x ./obsidian.sh && ./obsidian.sh start",
    "customizations": {
        "vscode": {
            "extensions": [
                "vsls-contrib.codetour",
                "yzhang.markdown-all-in-one",
                "bierner.markdown-preview-github-styles"
            ]
        }
    }
}
EOF
    echo -e "${GREEN}.devcontainer/devcontainer.json created.${NC}"
fi

# Ask for docs directory
echo -e "${YELLOW}Enter the path to your local documents folder (relative or absolute):${NC}"
read -r DOCS_PATH

# Check if the docs path exists
if [ ! -d "$DOCS_PATH" ]; then
    echo -e "${RED}Directory not found: $DOCS_PATH${NC}"
    exit 1
fi

# Copy docs to the obsidian_config directory
if [ ! -d "obsidian_config" ]; then
    echo -e "${YELLOW}Creating obsidian_config directory...${NC}"
    mkdir -p obsidian_config
fi

echo -e "${YELLOW}Copying documents to obsidian_config directory...${NC}"
cp -r "$DOCS_PATH"/* obsidian_config/

echo -e "${GREEN}Documents copied successfully to obsidian_config directory!${NC}"

# Update .gitignore if it doesn't exist
if [ ! -f ".gitignore" ]; then
    echo -e "${YELLOW}Creating .gitignore file...${NC}"
    cat > .gitignore << EOF
# Obsidian workspace settings
.obsidian/workspace.json
.obsidian/workspace
.obsidian/workspace-mobile.json

# Cached plugins
.obsidian/plugins/*/data.json
.obsidian/plugins/recent-files-obsidian/data.json

# Hot reload
.obsidian/hotreload.json

# Local history for Visual Studio Code
.history/
.vscode/

# OS generated files
.DS_Store
.DS_Store?
._*
.Spotlight-V100
.Trashes
ehthumbs.db
Thumbs.db
EOF
    echo -e "${GREEN}.gitignore file created.${NC}"
fi

# Check if this is a git repository
if [ ! -d ".git" ]; then
    echo -e "${YELLOW}Do you want to initialize a Git repository? (y/n)${NC}"
    read -r INIT_GIT
    
    if [[ "$INIT_GIT" == "y" || "$INIT_GIT" == "Y" ]]; then
        echo -e "${YELLOW}Initializing Git repository...${NC}"
        git init
        git add .
        git commit -m "Initial setup for Obsidian in GitHub Codespaces"
        
        echo -e "${YELLOW}Do you want to push to GitHub now? (y/n)${NC}"
        read -r PUSH_GIT
        
        if [[ "$PUSH_GIT" == "y" || "$PUSH_GIT" == "Y" ]]; then
            echo -e "${YELLOW}Enter your GitHub repository URL (e.g., https://github.com/username/repo.git):${NC}"
            read -r REPO_URL
            git remote add origin "$REPO_URL"
            git push -u origin main
            
            if [ $? -eq 0 ]; then
                echo -e "${GREEN}Push successful!${NC}"
            else
                echo -e "${YELLOW}Trying to push to master branch instead...${NC}"
                git push -u origin master
            fi
        fi
    fi
fi

echo -e "${BLUE}╔════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║${GREEN}                  Next Steps                     ${BLUE}║${NC}"
echo -e "${BLUE}║${NC}                                                  ${BLUE}║${NC}"
echo -e "${BLUE}║${NC} 1. Create a GitHub Codespace from your repository ${BLUE}║${NC}"
echo -e "${BLUE}║${NC} 2. Obsidian should start automatically            ${BLUE}║${NC}"
echo -e "${BLUE}║${NC} 3. Access via the PORTS tab (port 3000)           ${BLUE}║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════╝${NC}"
