#!/bin/bash
# Script to push Obsidian notes to GitHub for Codespaces

# Color formatting
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}╔════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║${GREEN}    Push Toddle Notes to GitHub Codespaces        ${BLUE}║${NC}"
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

# Check if there's a remote repository
REMOTE_URL=$(git config --get remote.origin.url)
if [ -z "$REMOTE_URL" ]; then
    echo -e "${YELLOW}No remote repository found. Do you want to add one? (y/n)${NC}"
    read -r ADD_REMOTE
    if [[ "$ADD_REMOTE" == "y" || "$ADD_REMOTE" == "Y" ]]; then
        echo -e "${YELLOW}Enter your GitHub repository URL (e.g., https://github.com/username/repo.git):${NC}"
        read -r REPO_URL
        git remote add origin "$REPO_URL"
        echo -e "${GREEN}Remote origin added: $REPO_URL${NC}"
    fi
else
    echo -e "${BLUE}Remote repository already set to: $REMOTE_URL${NC}"
fi

# Stage changes
echo -e "${YELLOW}Staging changes...${NC}"
git add obsidian_config/Toddle/

# Commit changes
echo -e "${YELLOW}Enter a commit message (default: 'Add Toddle notes'):${NC}"
read -r COMMIT_MESSAGE
if [ -z "$COMMIT_MESSAGE" ]; then
    COMMIT_MESSAGE="Add Toddle notes"
fi
git commit -m "$COMMIT_MESSAGE"

# Push to GitHub
echo -e "${YELLOW}Pushing to GitHub...${NC}"
BRANCH=$(git branch --show-current)
git push -u origin "$BRANCH"

if [ $? -eq 0 ]; then
    echo -e "${GREEN}Push successful! Your Toddle notes are now in GitHub.${NC}"
    echo -e "${BLUE}You can now access them in your GitHub Codespace.${NC}"
else
    echo -e "${RED}Push failed. Please check your GitHub credentials and repository access.${NC}"
    echo -e "${YELLOW}You may need to create the branch first with:${NC}"
    echo -e "${YELLOW}  git push -u origin $BRANCH${NC}"
fi

echo -e "${BLUE}╔════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║${GREEN}                  Next Steps                     ${BLUE}║${NC}"
echo -e "${BLUE}║${NC}                                                  ${BLUE}║${NC}"
echo -e "${BLUE}║${NC} 1. Open your GitHub Codespace                    ${BLUE}║${NC}"
echo -e "${BLUE}║${NC} 2. Run: ./obsidian.sh start                      ${BLUE}║${NC}"
echo -e "${BLUE}║${NC} 3. Open Obsidian and navigate to Toddle folder   ${BLUE}║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════╝${NC}"
