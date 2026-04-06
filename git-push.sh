#!/bin/bash

# Git Push Script for Production Deployment v2.0.1

echo "🚀 Pushing changes to Git repository..."

# Check if remote exists
if git remote -v | grep -q 'origin'; then
    echo "✅ Remote 'origin' found"
    
    # Get current branch
    BRANCH=$(git rev-parse --abbrev-ref HEAD)
    echo "📍 Current branch: $BRANCH"
    
    # Push to remote
    echo "⬆️  Pushing to origin/$BRANCH..."
    git push origin $BRANCH
    
    if [ $? -eq 0 ]; then
        echo "✅ Successfully pushed to remote repository!"
        echo ""
        echo "📋 Next steps:"
        echo "1. SSH to server: ssh root@167.71.223.157"
        echo "2. Navigate to: cd /var/www/fixed-asset"
        echo "3. Clone repository: git clone YOUR_REPO_URL ."
        echo "4. Or pull changes: git pull origin $BRANCH"
    else
        echo "❌ Failed to push to remote repository"
        echo "Please check your git credentials and remote URL"
    fi
else
    echo "⚠️  No remote 'origin' found"
    echo ""
    echo "To add a remote repository, run:"
    echo "git remote add origin YOUR_REPOSITORY_URL"
    echo ""
    echo "Example:"
    echo "git remote add origin https://github.com/username/fixed-asset.git"
    echo "git remote add origin git@github.com:username/fixed-asset.git"
fi
