#!/bin/bash

# Simple deployment script for GitHub Pages

echo "Preparing for deployment..."

# Ensure all files are generated
if [ ! -f "directory.json" ]; then
    echo "Error: directory.json not found. Run the generation script first."
    exit 1
fi

# Check if we're in a git repository
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo "Initializing git repository..."
    git init
    git add .
    git commit -m "Initial commit"
fi

# Create gh-pages branch if it doesn't exist
if ! git show-ref --verify --quiet refs/heads/gh-pages; then
    echo "Creating gh-pages branch..."
    git checkout -b gh-pages
else
    echo "Switching to gh-pages branch..."
    git checkout gh-pages
fi

# Add all files
git add .
git commit -m "Update RADIUS/TACACS+ attributes $(date)"

echo "Deployment prepared. To deploy to GitHub Pages:"
echo "1. Add your GitHub repository as origin:"
echo "   git remote add origin https://github.com/YOUR_USERNAME/YOUR_REPO.git"
echo "2. Push to GitHub:"
echo "   git push -u origin gh-pages"
echo "3. Enable GitHub Pages in your repository settings"
echo "4. Your site will be available at: https://YOUR_USERNAME.github.io/YOUR_REPO/"
