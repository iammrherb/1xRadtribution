#!/bin/bash

# GitHub Pages Deployment Script for Radtribution Dictionary

# This script will:
# 1. Check if repository exists and create if needed
# 2. Configure GitHub Pages
# 3. Push updates to GitHub

echo "=== Radtribution Dictionary Deployment Script ==="

# Check if git is installed
if ! command -v git &> /dev/null; then
    echo "Error: Git is not installed. Please install git to continue."
    exit 1
fi

# Check if GitHub CLI is installed (optional)
HAS_GH=false
if command -v gh &> /dev/null; then
    HAS_GH=true
    # Check if user is logged in
    if ! gh auth status &> /dev/null; then
        echo "GitHub CLI detected but not logged in. Please run 'gh auth login' first."
        HAS_GH=false
    fi
fi

# Check if git repository is initialized
if [ ! -d ".git" ]; then
    echo "Initializing git repository..."
    git init
    git add .
    git commit -m "Initial commit for Radtribution Dictionary"
fi

# Get remote repository URL
REMOTE_URL=$(git config --get remote.origin.url)
if [ -z "$REMOTE_URL" ]; then
    echo "No remote repository configured."
    
    if [ "$HAS_GH" = true ]; then
        echo "Creating repository using GitHub CLI..."
        gh repo create radtribution-dictionary --public --source=. --remote=origin
    else
        echo "Please enter your GitHub username:"
        read GITHUB_USERNAME
        
        echo "Setting up remote repository..."
        git remote add origin "https://github.com/$GITHUB_USERNAME/radtribution-dictionary.git"
        
        echo "Please create a repository named 'radtribution-dictionary' on GitHub if you haven't already."
        echo "Then push to GitHub with: git push -u origin main"
        exit 0
    fi
fi

# Make sure we're on the main branch
CURRENT_BRANCH=$(git branch --show-current)
if [ "$CURRENT_BRANCH" != "main" ]; then
    echo "Switching to main branch..."
    git checkout -b main
fi

# Add all changes
git add .

# Check if there are changes to commit
if git diff-index --quiet HEAD --; then
    echo "No changes to commit."
else
    echo "Committing changes..."
    git commit -m "Update Radtribution Dictionary content"
fi

# Push to GitHub
echo "Pushing to GitHub..."
git push -u origin main

# Configure GitHub Pages if GitHub CLI is available
if [ "$HAS_GH" = true ]; then
    echo "Configuring GitHub Pages..."
    gh repo edit --enable-pages --branch main --path / 
    
    # Get the GitHub Pages URL
    PAGES_URL=$(gh repo view --json homepageUrl --jq .homepageUrl)
    if [ -z "$PAGES_URL" ]; then
        PAGES_URL="https://$GITHUB_USERNAME.github.io/radtribution-dictionary/"
    fi
    
    echo ""
    echo "=== Deployment Successful! ==="
    echo "Your Radtribution Dictionary should be available at:"
    echo "$PAGES_URL"
    echo ""
    echo "Note: It may take a few minutes for GitHub Pages to build and deploy your site."
else
    echo ""
    echo "=== Repository Updated! ==="
    echo "To enable GitHub Pages:"
    echo "1. Go to your repository on GitHub"
    echo "2. Navigate to Settings > Pages"
    echo "3. Under 'Source', select 'main' branch and root folder '/' then click 'Save'"
    echo ""
    echo "Your Radtribution Dictionary will be available at: https://yourusername.github.io/radtribution-dictionary/"
fi
