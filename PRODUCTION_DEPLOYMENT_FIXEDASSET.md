# 🚀 Production Deployment Guide
## 29 Asset Management System - fixedasset.29jewellery.com

**Domain:** https://fixedasset.29jewellery.com  
**Version:** 2.0.1  
**Generated:** April 6, 2026

---

## ✅ Configuration Updates Completed

### Domain Configuration
- ✅ **Primary Domain:** `fixedasset.29jewellery.com`
- ✅ **WWW Domain:** `www.fixedasset.29jewellery.com`
- ✅ **JWT Issuer/Audience:** Updated to production domain
- ✅ **CORS Policy:** Configured for production domain
- ✅ **SSL/HTTPS:** Configured for secure connections

### Files Updated
- ✅ `appsettings.Production.json` - Production domain settings
- ✅ `appsettings.json` - Development JWT settings
- ✅ `Program.cs` - CORS policy for production domain
- ✅ `.env` - Environment variables for production

---

## 🔴 CRITICAL - Pre-Deployment Actions

### 1. **Generate Production Secrets** (URGENT)

```bash
# Generate JWT Secret (64 characters)
openssl rand -base64 64

# Generate Database Passwords (32 characters each)
openssl rand -base64 32
openssl rand -base64 32

# Generate Admin Password (32 characters)
openssl rand -base64 32
```

### 2. **Update .env File** (URGENT)

```bash
# Database Configuration
DB_HOST=your-production-db-host
DB_NAME=AMS
DB_USER=ams_user
DB_PASSWORD=GENERATED_PASSWORD_HERE
DB_PORT=3306
DB_ROOT_PASSWORD=GENERATED_ROOT_PASSWORD_HERE

# JWT Configuration
JWT_SECRET_KEY=GENERATED_JWT_SECRET_HERE
JWT_ISSUER=https://fixedasset.29jewellery.com
JWT_AUDIENCE=https://fixedasset.29jewellery.com

# Admin Configuration
ADMIN_PASSWORD=GENERATED_ADMIN_PASSWORD_HERE

# Email Configuration
SMTP_SERVER=smtp.gmail.com
SMTP_PORT=587
SMTP_USERNAME=your-email@29jewellery.com
SMTP_PASSWORD=your-app-password
FROM_EMAIL=your-email@29jewellery.com
```

### 3. **Database Setup** (URGENT)

```bash
# Create Production Database
mysql -u root -p
CREATE DATABASE AMS CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER 'ams_user'@'%' IDENTIFIED BY 'STRONG_PASSWORD_HERE';
GRANT ALL PRIVILEGES ON AMS.* TO 'ams_user'@'%';
FLUSH PRIVILEGES;

# Run Migrations
dotnet ef database update --connection "server=your-db-host;port=3306;database=AMS;user=ams_user;password=PASSWORD_HERE"
```

---

## 🟡 HIGH PRIORITY - Production Setup

### 1. **SSL Certificate Configuration**

#### Option A: Let's Encrypt (Free)
```bash
# Install Certbot
sudo apt-get update
sudo apt-get install certbot python3-certbot-nginx

# Get SSL Certificate
sudo certbot --nginx -d fixedasset.29jewellery.com -d www.fixedasset.29jewellery.com
```

#### Option B: Commercial SSL
- Purchase SSL certificate for `fixedasset.29jewellery.com`
- Install certificate on web server
- Configure HTTPS redirection

### 2. **Web Server Configuration**

#### Nginx Configuration
```nginx
server {
    listen 80;
    server_name fixedasset.29jewellery.com www.fixedasset.29jewellery.com;
    return 301 https://$server_name$request_uri;
}

server {
    listen 443 ssl http2;
    server_name fixedasset.29jewellery.com www.fixedasset.29jewellery.com;

    ssl_certificate /etc/letsencrypt/live/fixedasset.29jewellery.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/fixedasset.29jewellery.com/privkey.pem;

    location / {
        proxy_pass http://localhost:5000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection keep-alive;
        proxy_set_header Host $host;
        proxy_set_header X-Forwared-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_cache_bypass $http_upgrade;
    }
}
```

#### IIS Configuration (Windows)
```xml
<?xml version="1.0" encoding="utf-8"?>
<configuration>
  <system.webServer>
    <rewrite>
      <rules>
        <rule name="Redirect to HTTPS" stopProcessing="true">
          <match url=".*" />
          <conditions>
            <add input="{HTTPS}" pattern="off" ignoreCase="true" />
          </conditions>
          <action type="Redirect" url="https://{HTTP_HOST}{REQUEST_URI}" redirectType="Permanent" />
        </rule>
      </rules>
    </rewrite>
  </system.webServer>
</configuration>
```

### 3. **Application Pool Configuration**

#### Kestrel Configuration
```json
{
  "Kestrel": {
    "Endpoints": {
      "Http": {
        "Url": "http://localhost:5000"
      },
      "Https": {
        "Url": "https://localhost:5001"
      }
    }
  }
}
```

---

## 🟢 DEPLOYMENT OPTIONS

### Option 1: **Docker Deployment** (Recommended)

#### docker-compose.yml
```yaml
version: '3.8'

services:
  mysql:
    image: mysql:8.0
    container_name: ams-mysql-prod
    restart: unless-stopped
    environment:
      MYSQL_ROOT_PASSWORD: ${DB_ROOT_PASSWORD}
      MYSQL_DATABASE: ${DB_NAME}
      MYSQL_USER: ${DB_USER}
      MYSQL_PASSWORD: ${DB_PASSWORD}
    volumes:
      - mysql_data:/var/lib/mysql
    networks:
      - ams-network

  ams-app:
    build: .
    container_name: ams-app-prod
    restart: unless-stopped
    depends_on:
      - mysql
    environment:
      - ASPNETCORE_ENVIRONMENT=Production
      - DB_HOST=${DB_HOST}
      - DB_NAME=${DB_NAME}
      - DB_USER=${DB_USER}
      - DB_PASSWORD=${DB_PASSWORD}
      - DB_PORT=${DB_PORT}
      - JWT_SECRET_KEY=${JWT_SECRET_KEY}
      - JWT_ISSUER=${JWT_ISSUER}
      - JWT_AUDIENCE=${JWT_AUDIENCE}
      - ADMIN_PASSWORD=${ADMIN_PASSWORD}
    ports:
      - "5000:80"
      - "5001:443"
    volumes:
      - ./wwwroot/upload:/app/wwwroot/upload
    networks:
      - ams-network

volumes:
  mysql_data:

networks:
  ams-network:
    driver: bridge
```

#### Deployment Commands
```bash
# Build and Deploy
docker-compose -f docker-compose.yml up -d

# Check Status
docker-compose ps

# View Logs
docker-compose logs -f ams-app
```

### Option 2: **Direct Server Deployment**

#### Build Application
```bash
# Clean Build
dotnet clean
dotnet restore

# Build for Production
dotnet build -c Release

# Publish
dotnet publish -c Release -o ./publish
```

#### Service Configuration (systemd)
```ini
[Unit]
Description=29 Asset Management System
After=network.target

[Service]
Type=notify
WorkingDirectory=/path/to/publish
ExecStart=/path/to/publish/AMS
Restart=always
RestartSec=10
KillSignal=SIGINT
SyslogIdentifier=ams
User=www-data
Environment=ASPNETCORE_ENVIRONMENT=Production
Environment=DOTNET_PRINT_TELEMETRY_MESSAGE=false

[Install]
WantedBy=multi-user.target
```

---

## 🔧 Environment Variables

### Production Environment
```bash
# Database
ConnectionStrings__connMySQL="server=your-db-host;port=3306;database=AMS;user=ams_user;password=PASSWORD_HERE"

# JWT
JWT__Secret="GENERATED_JWT_SECRET_HERE"
JWT__Issuer="https://fixedasset.29jewellery.com"
JWT__Audience="https://fixedasset.29jewellery.com"

# Admin
SuperAdminDefaultOptions__Email="admin@29jewellery.com"
SuperAdminDefaultOptions__Password="GENERATED_ADMIN_PASSWORD_HERE"

# Email
EmailSettings__SmtpServer="smtp.gmail.com"
EmailSettings__SmtpPort="587"
EmailSettings__SmtpUsername="your-email@29jewellery.com"
EmailSettings__SmtpPassword="your-app-password"
EmailSettings__FromEmail="your-email@29jewellery.com"
```

---

## 📊 Monitoring & Logging

### 1. **Application Logging**
```json
{
  "Logging": {
    "LogLevel": {
      "Default": "Information",
      "Microsoft.AspNetCore": "Warning",
      "Microsoft.EntityFrameworkCore": "Warning"
    }
  }
}
```

### 2. **Health Checks**
- **Endpoint:** `https://fixedasset.29jewellery.com/health`
- **Database Connectivity:** Automatic
- **Application Status:** HTTP 200 OK

### 3. **Performance Monitoring**
```bash
# Monitor Application
curl -f https://fixedasset.29jewellery.com/health

# Check Logs
journalctl -u ams -f

# Monitor Database
mysql -u ams_user -p -e "SHOW PROCESSLIST;"
```

---

## 🔒 Security Checklist

### ✅ Implemented
- [x] HTTPS enforcement
- [x] Security headers
- [x] CORS policy for production domain
- [x] Password policy (12+ characters)
- [x] Account lockout (3 attempts, 60 min)
- [x] Session security
- [x] Input validation
- [x] SQL injection protection

### 🔧 Configure Before Launch
- [ ] Generate strong JWT secret
- [ ] Set strong database passwords
- [ ] Configure SSL certificates
- [ ] Set up firewall rules
- [ ] Configure backup strategy
- [ ] Set up monitoring alerts

---

## 🚀 Pre-Launch Checklist

### Security (CRITICAL)
- [ ] Generate and set strong JWT secret key
- [ ] Set strong database passwords
- [ ] Configure production admin credentials
- [ ] Set up email SMTP with app password
- [ ] Configure SSL/TLS certificates
- [ ] Verify .env file is secure

### Infrastructure
- [ ] Set up production database server
- [ ] Configure reverse proxy (Nginx/IIS)
- [ ] Set up SSL certificates
- [ ] Configure firewall rules
- [ ] Set up domain DNS records

### Application
- [ ] Build application in Release mode
- [ ] Update all configuration files
- [ ] Test all major features
- [ ] Verify email functionality
- [ ] Test file upload/download

### Database
- [ ] Create production database
- [ ] Run Entity Framework migrations
- [ ] Verify seed data
- [ ] Set up automated backups
- [ ] Test database connectivity

### Post-Deployment
- [ ] Change default admin password
- [ ] Test login functionality
- [ ] Verify all features working
- [ ] Monitor error logs
- [ ] Check performance metrics
- [ ] Verify backup jobs

---

## 📱 Access Information

### Production URL
- **Primary:** https://fixedasset.29jewellery.com
- **WWW:** https://www.fixedasset.29jewellery.com
- **Health Check:** https://fixedasset.29jewellery.com/health

### Default Admin Login
- **Email:** `admin@ams.local` (change after deployment)
- **Password:** `Admin@123456` (change immediately)

### Support
- **Application:** 29 Asset Management System v2.0.1
- **Domain:** fixedasset.29jewellery.com
- **Documentation:** Available in project repository

---

## 🔄 Backup Strategy

### Database Backup (Daily)
```bash
# Automated Backup Script
#!/bin/bash
DATE=$(date +%Y%m%d_%H%M%S)
mysqldump -h $DB_HOST -u $DB_USER -p$DB_PASSWORD AMS > backup_$DATE.sql
gzip backup_$DATE.sql

# Keep last 7 days
find /path/to/backups -name "backup_*.sql.gz" -mtime +7 -delete
```

### Application Backup (Weekly)
- Backup published application files
- Backup configuration files
- Backup uploaded files (`/wwwroot/upload`)
- Document backup procedures

---

## 🎯 Deployment Timeline

### Phase 1: Preparation (2-4 hours)
- Generate production secrets
- Update configuration files
- Set up production database
- Configure SSL certificates

### Phase 2: Deployment (1-2 hours)
- Build and publish application
- Deploy to production server
- Configure reverse proxy
- Test all functionality

### Phase 3: Verification (1 hour)
- Test all features
- Monitor performance
- Verify security measures
- Document deployment

---

## 📞 Emergency Contacts

### Technical Support
- **Database:** MySQL 8.0+ support
- **Web Server:** Nginx/IIS support
- **Application:** ASP.NET Core 9.0 support

### Domain & DNS
- **Domain Registrar:** Manage DNS records
- **SSL Provider:** Certificate renewal
- **Hosting Provider:** Server maintenance

---

**Last Updated:** April 6, 2026  
**Next Review:** May 6, 2026  
**Document Version:** 1.0

---

## 🚀 Quick Start Commands

```bash
# 1. Generate Secrets
openssl rand -base64 64 > jwt_secret.txt
openssl rand -base64 32 > db_password.txt
openssl rand -base64 32 > admin_password.txt

# 2. Update .env
nano .env

# 3. Build Application
dotnet publish -c Release -o ./publish

# 4. Deploy
docker-compose up -d

# 5. Verify
curl -f https://fixedasset.29jewellery.com/health
```

**Ready for Production Launch! 🎉**
