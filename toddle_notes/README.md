# Toddle Notes

This directory contains notes for the Toddle project. These notes are meant to be used with Obsidian in GitHub Codespaces.

## How to Use

1. Clone this repository to your GitHub Codespace
2. Copy these notes to your Obsidian vault
3. Open Obsidian to view and edit the notes

## Directory Structure

- `index.md` - Main entry point and navigation
- `project-overview.md` - Overview of the Toddle project
- `development-setup.md` - Development environment setup instructions
- `feature-ideas.md` - Ideas for new features
- `meeting-notes.md` - Notes from team meetings

## Setup Instructions for Codespaces

To use these notes in your GitHub Codespace:

1. Start your Codespace
2. Open a terminal and run:
   ```bash
   # Create the Toddle directory in Obsidian
   mkdir -p obsidian_config/Toddle
   
   # Copy notes to Obsidian
   cp toddle_notes/*.md obsidian_config/Toddle/
   ```
3. Start Obsidian:
   ```bash
   ./obsidian.sh start
   ```
4. Open Obsidian via port 3000 and navigate to the Toddle folder
