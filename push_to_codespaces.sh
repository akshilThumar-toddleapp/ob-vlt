#!/bin/bash
# Script to help push local documents to GitHub Codespaces

# Color formatting
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}╔════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║${GREEN}      Push Local Documents to Codespaces          ${BLUE}║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════╝${NC}"

# Check if git is installed
if ! command -v git &> /dev/null; then
    echo -e "${RED}Git is not installed. Please install Git first.${NC}"
    exit 1
fi

# Check if the directory is a git repository
if [ ! -d ".git" ]; then
    echo -e "${YELLOW}Initializing Git repository...${NC}"
    git init
    echo -e "${GREEN}Git repository initialized.${NC}"
else
    echo -e "${BLUE}Git repository already exists.${NC}"
fi

# Ask for GitHub repository URL if not already set
REMOTE_URL=$(git config --get remote.origin.url)
if [ -z "$REMOTE_URL" ]; then
    echo -e "${YELLOW}Enter your GitHub repository URL (e.g., https://github.com/username/repo.git):${NC}"
    read -r REPO_URL
    git remote add origin "$REPO_URL"
    echo -e "${GREEN}Remote origin added: $REPO_URL${NC}"
else
    echo -e "${BLUE}Remote origin already set to: $REMOTE_URL${NC}"
fi

# Create .gitignore if it doesn't exist
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

# Ask for docs directory
echo -e "${YELLOW}Enter the path to your local documents folder (relative or absolute):${NC}"
read -r DOCS_PATH

# Check if the docs path exists
if [ ! -d "$DOCS_PATH" ]; then
    echo -e "${RED}Directory not found: $DOCS_PATH${NC}"
    exit 1
fi

# Copy docs to the obsidian_config directory (if it exists) or current directory
if [ -d "obsidian_config" ]; then
    echo -e "${YELLOW}Copying documents to obsidian_config directory...${NC}"
    cp -r "$DOCS_PATH"/* obsidian_config/
    DOCS_DESTINATION="obsidian_config"
else
    echo -e "${YELLOW}Copying documents to current directory...${NC}"
    cp -r "$DOCS_PATH"/* .
    DOCS_DESTINATION="."
fi

echo -e "${GREEN}Documents copied successfully to $DOCS_DESTINATION${NC}"

# Stage all files
echo -e "${YELLOW}Staging files for commit...${NC}"
git add .

# Commit the changes
echo -e "${YELLOW}Enter a commit message:${NC}"
read -r COMMIT_MESSAGE
git commit -m "$COMMIT_MESSAGE"

# Push to GitHub
echo -e "${YELLOW}Pushing to GitHub...${NC}"
git push -u origin main

if [ $? -eq 0 ]; then
    echo -e "${GREEN}Push successful! Your documents are now in the GitHub repository.${NC}"
    echo -e "${BLUE}You can now access them in your GitHub Codespace.${NC}"
else
    echo -e "${RED}Push failed. Please check your GitHub credentials and repository access.${NC}"
    echo -e "${YELLOW}You may need to run: git push -u origin master${NC}"
fi

echo -e "${BLUE}╔════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║${GREEN}                  Next Steps                     ${BLUE}║${NC}"
echo -e "${BLUE}║${NC}                                                  ${BLUE}║${NC}"
echo -e "${BLUE}║${NC} 1. Open your GitHub Codespace                    ${BLUE}║${NC}"
echo -e "${BLUE}║${NC} 2. Run: ./obsidian.sh start                      ${BLUE}║${NC}"
echo -e "${BLUE}║${NC} 3. Open Obsidian via port 3000                   ${BLUE}║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════╝${NC}"
