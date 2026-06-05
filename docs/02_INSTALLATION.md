# Installation Guide - Complete Setup Instructions

This guide walks through the complete installation of the Network Monitoring ML System.

## Prerequisites

### System Requirements
- Ubuntu 20.04 LTS or similar (Windows WSL2/Mac Docker Desktop)
- 8GB RAM minimum (16GB recommended)
- 50GB disk space minimum
- Internet connection for package downloads

### Required Software

```bash
# Check Node.js (18+)
node --version

# Check npm (9+)
npm --version

# Check Python (3.9+)
python3 --version

# Check Docker
docker --version

# Check Docker Compose
docker-compose --version
```

## Installation Steps

### Step 1: Clone Repository

```bash
git clone https://github.com/habibullahturkmen/network-monitoring-ml.git
cd network-monitoring-ml
```

### Step 2: Environment Setup

```bash
# Copy environment file
cp .env.example .env

# Edit with your settings
nano .env
```

### Step 3: Backend Installation

```bash
cd backend

# Install dependencies
npm install

# Build TypeScript
npm run build

# Test startup
npm run dev
```

Expected output:
```
Backend server running on port 5000
```

### Step 4: Frontend Installation

```bash
cd ../frontend

# Install dependencies
npm install

# Start development server
npm start
```

Browser opens to http://localhost:3000

### Step 5: ML Service Installation

```bash
cd ../ml-service

# Create virtual environment
python3 -m venv venv
source venv/bin/activate  # On Windows: venv\\Scripts\\activate

# Install dependencies
pip install -r requirements.txt

# Download and prepare dataset
cd data
python3 download_dataset.py
cd ..

# Train model
python3 models/train_model.py

# Start service
python3 src/api.py
```

### Step 6: Database Setup

```bash
# Start PostgreSQL (if not using Docker)
sudo systemctl start postgresql

# Create database and tables
psql -U postgres -f database/schemas/001_initial_schema.sql
psql -U postgres -d network_monitoring -f database/schemas/002_add_indexes.sql
psql -U postgres -d network_monitoring -f database/seeds/sample_data.sql
```

### Step 7: Docker Setup (Recommended)

```bash
# Build and start all services
docker-compose build
docker-compose up -d

# Verify all containers
docker-compose ps

# View logs
docker-compose logs -f
```

## Verification

### Check Backend API

```bash
curl http://localhost:5000/api/health
```

Expected response:
```json
{
  "status": "ok",
  "database": "connected",
  "ml_service": "connected"
}
```

### Check ML Service

```bash
curl http://localhost:5001/health
```

Expected response:
```json
{
  "status": "healthy",
  "model_loaded": true
}
```

### Check Database Connection

```bash
psql -U postgres -d network_monitoring -c "SELECT COUNT(*) FROM users;"
```

## Troubleshooting

### Port Already in Use

```bash
# Find process using port
sudo lsof -i :5000  # or :3000, :5001, :5432

# Kill process
kill -9 <PID>

# Or change port in .env
BACKEND_PORT=5001
```

### Database Connection Failed

```bash
# Check PostgreSQL status
sudo systemctl status postgresql

# Start PostgreSQL
sudo systemctl start postgresql

# Reset database
dropdb -U postgres network_monitoring
createdb -U postgres network_monitoring
```

### Node Modules Issues

```bash
# Clear cache and reinstall
rm -rf node_modules package-lock.json
npm cache clean --force
npm install
```

## Next Steps

1. Read [docs/03_ARCHITECTURE.md](03_ARCHITECTURE.md) for system design
2. Follow [docs/07_DEVELOPMENT.md](07_DEVELOPMENT.md) for development workflow
3. Check [docs/04_API_REFERENCE.md](04_API_REFERENCE.md) for API documentation

---

**Estimated Installation Time:** 30-45 minutes
