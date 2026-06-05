# Quick Start Guide - 5 Minutes Setup

Get the Network Monitoring ML system running in 5 minutes!

## ⚡ Prerequisites

- Docker & Docker Compose installed
- Git installed
- Basic terminal knowledge

## 🚀 Quick Start Steps

### Step 1: Clone and Navigate (1 min)

```bash
git clone https://github.com/habibullahturkmen/network-monitoring-ml.git
cd network-monitoring-ml
```

### Step 2: Setup Environment (1 min)

```bash
cp .env.example .env
# Review .env if needed
cat .env
```

### Step 3: Start Services with Docker Compose (2 min)

```bash
docker-compose up -d
```

This starts:
- **PostgreSQL** (database)
- **Backend API** (http://localhost:5000)
- **Frontend Dashboard** (http://localhost:3000)
- **ML Service** (http://localhost:5001)

### Step 4: Verify Installation (1 min)

```bash
# Check if all containers are running
docker-compose ps

# Expected output:
# NAME                    STATUS
# network-postgres        Up
# network-backend         Up
# network-frontend        Up
# network-ml-service      Up
```

### Step 5: Access the Dashboard

Open your browser and navigate to:

```
http://localhost:3000
```

**Default Credentials:**
- Username: `admin`
- Password: `password123`

## 🧪 Test the System

### Check Backend API

```bash
curl http://localhost:5000/api/health
```

Expected response:
```json
{
  "status": "ok",
  "timestamp": "2026-06-05T12:00:00Z",
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
  "model_loaded": true,
  "gpu_available": false
}
```

### Submit Sample Traffic Data

```bash
curl -X POST http://localhost:5000/api/traffic \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -d '{
    "src_ip": "192.168.1.100",
    "dst_ip": "10.0.0.1",
    "src_port": 54321,
    "dst_port": 443,
    "protocol": "TCP",
    "packets": 100,
    "bytes": 5000,
    "duration": 5.5
  }'
```

## 📊 Dashboard Features

Once logged in, you can see:

1. **Statistics Cards**
   - Total Traffic Records
   - Suspicious Detections
   - Normal Traffic
   - Alert Count

2. **Traffic Logs Table**
   - Source/Destination IPs
   - Detection Status
   - Confidence Score
   - Timestamp

3. **Alerts Panel**
   - Recent alerts
   - Alert severity
   - Quick actions

4. **Traffic Charts**
   - Detection trends
   - Protocol distribution
   - Port analysis

## 🛑 Stop Services

```bash
docker-compose down
```

To remove volumes (database data):
```bash
docker-compose down -v
```

## 📚 Next Steps

1. **Read the Complete Installation Guide:** [docs/02_INSTALLATION.md](02_INSTALLATION.md)
2. **Understand the Architecture:** [docs/03_ARCHITECTURE.md](03_ARCHITECTURE.md)
3. **Explore the API:** [docs/04_API_REFERENCE.md](04_API_REFERENCE.md)
4. **Follow Step-by-Step Implementation:** [docs/11_STEP_BY_STEP_GUIDE.md](11_STEP_BY_STEP_GUIDE.md)

## 🐛 Troubleshooting

### Containers not starting?
```bash
# Check logs
docker-compose logs -f

# Rebuild images
docker-compose build --no-cache
```

### Port already in use?
Edit `.env` and change ports:
```
BACKEND_PORT=5000
FRONTEND_PORT=3000
ML_SERVICE_PORT=5001
DB_PORT=5432
```

### Database connection error?
```bash
# Wait for database to be ready
docker-compose logs postgres

# Reinitialize database
docker-compose exec postgres psql -U postgres -d network_monitoring -f /docker-entrypoint-initdb.d/001_initial_schema.sql
```

## ✅ Success Indicators

- ✅ All 4 containers running
- ✅ Backend API responding to health check
- ✅ Frontend dashboard loads
- ✅ Can login with default credentials
- ✅ ML service reports model loaded
- ✅ Database connected

## 🔗 Quick Links

| Component | URL | Status |
|-----------|-----|--------|
| Frontend | http://localhost:3000 | Main Dashboard |
| Backend API | http://localhost:5000 | REST API |
| ML Service | http://localhost:5001 | Predictions |
| PostgreSQL | localhost:5432 | Database |

---

**Need help?** Check [docs/09_TROUBLESHOOTING.md](09_TROUBLESHOOTING.md)

**Ready for more?** Continue to [docs/02_INSTALLATION.md](02_INSTALLATION.md)
