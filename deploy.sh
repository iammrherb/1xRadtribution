#!/bin/bash

# Enhanced deployment script for 1Xer Radtribution

echo "🚀 Preparing for deployment to the authentication galaxy..."

# Ensure all files are generated
if [ ! -f "directory.json" ]; then
    echo "Error: directory.json not found. Run the generation script first."
    exit 1
fi

# Check for required files
required_files=("index.html" "viewer.html" "diagrams.html" "README.md" "LICENSE")
for file in "${required_files[@]}"; do
    if [ ! -f "$file" ]; then
        echo "Error: Required file $file not found."
        exit 1
    fi
done

# Check if we're in a git repository
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo "Initializing git repository..."
    git init
    git add .
    git commit -m "Initial commit: The Universe begins"
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
git commit -m "Update 1Xer Radtribution $(date)"

echo "
================================
 Deployment prepared! 🛸
================================

To deploy to GitHub Pages:

1. Add your GitHub repository as origin:
   git remote add origin https://github.com/YOUR_USERNAME/1xer-radtribution.git

2. Push to GitHub:
   git push -u origin gh-pages

3. Enable GitHub Pages in your repository settings:
   - Go to Settings > Pages
   - Source: Deploy from branch
   - Branch: gh-pages
   - Folder: / (root)

4. Your site will be available at:
   https://YOUR_USERNAME.github.io/1xer-radtribution/

Don't forget your towel! 🌌
"
