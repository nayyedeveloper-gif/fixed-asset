#!/bin/bash

# Setup New Git Repository for fixed-asset project
echo "🚀 Setting up new Git repository..."

# Remove old git repository
echo "🗑️  Removing old git repository..."
rm -rf .git

# Initialize new git repository
echo "📁 Initializing new git repository..."
git init

# Create new README.md
echo "📄 Creating README.md..."
cat > README.md << 'EOF'
# 29 Asset Management System

**Version:** 2.0.1  
**Domain:** fixedasset.29jewellery.com  
**Framework:** ASP.NET Core 9.0

## Features
- Asset Management
- User Management
- Department Management
- Asset Tracking
- Reporting
- Audit Logs

## Technology Stack
- ASP.NET Core 9.0
- Entity Framework Core
- MySQL 8.0
- Bootstrap 5
- jQuery

## Installation

### Prerequisites
- .NET 9.0 SDK
- MySQL Server 8.0
- Visual Studio 2022 or VS Code

### Setup
1. Clone this repository
2. Update appsettings.json with your database connection
3. Run migrations: `dotnet ef database update`
4. Run application: `dotnet run`

## Deployment
See `PRODUCTION_DEPLOYMENT_FIXEDASSET.md` for production deployment guide.

## Default Admin Login
- Email: admin@ams.local
- Password: Admin@123456

## License
© 2024 29 Asset Management
EOF

# Add all files
echo "➕ Adding all files..."
git add .

# Initial commit
echo "💾 Making initial commit..."
git commit -m "Initial commit - 29 Asset Management System v2.0.1"

# Create main branch
echo "🌿 Setting up main branch..."
git branch -M main

# Add new remote
echo "🔗 Adding new remote repository..."
git remote add origin https://github.com/nayyedeveloper-gif/fixed-asset.git

# Push to new repository
echo "⬆️  Pushing to new repository..."
git push -u origin main

echo ""
echo "✅ New Git repository setup complete!"
echo "📍 Repository: https://github.com/nayyedeveloper-gif/fixed-asset.git"
echo ""
echo "📋 Next steps:"
echo "1. Verify repository at: https://github.com/nayyedeveloper-gif/fixed-asset"
echo "2. On server: cd /var/www/fixed-asset"
echo "3. On server: git clone https://github.com/nayyedeveloper-gif/fixed-asset.git ."
echo "4. On server: Follow deployment steps"
EOF
