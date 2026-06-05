# Complete Step-by-Step Implementation Guide

This guide walks your team through building the Network Monitoring ML system from scratch. Follow each phase sequentially.

## 📋 Overview of Phases

| Phase | Task | Duration | Status |
|-------|------|----------|--------|
| Phase 1 | Prerequisites & Environment | 30 min | ⏳ Start Here |
| Phase 2 | Database Setup | 1 hour | |
| Phase 3 | ML Model Training | 1.5 hours | |
| Phase 4 | Backend API Development | 3 hours | |
| Phase 5 | Frontend Dashboard | 3 hours | |
| Phase 6 | Docker Configuration | 1 hour | |
| Phase 7 | System Integration Testing | 1 hour | |
| Phase 8 | Production Deployment | 1 hour | |
| Phase 9 | Monitoring & Alerts | 1 hour | |
| Phase 10 | Performance Optimization | 1.5 hours | |
| Phase 11 | GPU Migration Path | 1 hour | |
| **Total** | | **~15 hours** | |

---

## Phase 1: Prerequisites & Environment Setup (30 min)

### 1.1 System Requirements

Verify your development machine has:

```bash
# Check Node.js version (should be 18+)
node --version

# Check npm version
npm --version

# Check Python version (should be 3.9+)
python3 --version

# Check Docker
docker --version

# Check Docker Compose
docker-compose --version

# Check Git
git --version
```

If any are missing, install them:
- **Node.js**: https://nodejs.org/
- **Python**: https://www.python.org/downloads/
- **Docker**: https://www.docker.com/products/docker-desktop

### 1.2 Repository Setup

```bash
# Clone repository
git clone https://github.com/habibullahturkmen/network-monitoring-ml.git
cd network-monitoring-ml

# Create and switch to development branch
git checkout -b develop
git push -u origin develop

# Create feature branches for each team member
# Habibullah (Backend)
git checkout -b feature/habibullah-backend

# Bernard (Frontend)
git checkout -b feature/bernard-frontend

# Soumita (ML Service)
git checkout -b feature/soumita-ml-service

# Alshaima (Database & DevOps)
git checkout -b feature/alshaima-database
```

### 1.3 Environment Variables

```bash
# Copy example env file
cp .env.example .env

# Edit .env with your settings
nano .env  # or use your editor
```

**Key environment variables:**
```bash
# Backend
NODE_ENV=development
BACKEND_PORT=5000
DB_USER=postgres
DB_PASSWORD=password123
DB_NAME=network_monitoring
DB_HOST=localhost
DB_PORT=5432
JWT_SECRET=your_jwt_secret_key_here

# Frontend
REACT_APP_API_URL=http://localhost:5000/api
REACT_APP_WS_URL=ws://localhost:5000

# ML Service
ML_PORT=5001
ML_HOST=localhost
PYTHONUNBUFFERED=1
```

### 1.4 Create Project Directories

```bash
# Backend
mkdir -p backend/src/{config,controllers,models,routes,middleware,services,utils}

# Frontend
mkdir -p frontend/src/{components,pages,services,hooks,types}

# ML Service
mkdir -p ml-service/src/{models,data,tests}

# Database
mkdir -p database/{schemas,seeds,migrations}

# Documentation
mkdir -p docs
```

### 1.5 Team Assignment

**Task Distribution:**

| Team Member | Primary Role | Components | Git Branch |
|------------|-------------|-----------|-----------|
| Habibullah Turkmen | Lead Backend Developer | API, Controllers, Routes | `feature/habibullah-backend` |
| Bernard Appiah | Frontend Developer | React Dashboard, UI/UX | `feature/bernard-frontend` |
| Soumita Bose | ML Engineer | Model Training, Predictions | `feature/soumita-ml-service` |
| Alshaima Syed Ibrahim | DevOps/Database Admin | Database, Docker, Deployment | `feature/alshaima-database` |

---

## Phase 2: Database Setup (1 hour)

### 2.1 PostgreSQL Schema

**File: `database/schemas/001_initial_schema.sql`**

```sql
-- Create database
CREATE DATABASE network_monitoring;

-- Connect to database
\c network_monitoring;

-- Create users table
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    role VARCHAR(20) DEFAULT 'user',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create traffic logs table
CREATE TABLE traffic_logs (
    id BIGSERIAL PRIMARY KEY,
    src_ip INET NOT NULL,
    dst_ip INET NOT NULL,
    src_port INTEGER NOT NULL,
    dst_port INTEGER NOT NULL,
    protocol VARCHAR(10) NOT NULL,
    packets INTEGER DEFAULT 0,
    bytes BIGINT DEFAULT 0,
    duration FLOAT DEFAULT 0,
    prediction BOOLEAN,
    confidence_score FLOAT,
    detected_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) PARTITION BY RANGE (EXTRACT(YEAR FROM created_at), EXTRACT(MONTH FROM created_at));

-- Create alerts table
CREATE TABLE alerts (
    id BIGSERIAL PRIMARY KEY,
    traffic_log_id BIGINT REFERENCES traffic_logs(id),
    alert_type VARCHAR(50),
    severity VARCHAR(20),
    message TEXT,
    is_resolved BOOLEAN DEFAULT FALSE,
    resolved_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create ml_models table
CREATE TABLE ml_models (
    id SERIAL PRIMARY KEY,
    model_name VARCHAR(100) NOT NULL,
    model_version VARCHAR(50),
    accuracy FLOAT,
    precision FLOAT,
    recall FLOAT,
    f1_score FLOAT,
    trained_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create audit logs table
CREATE TABLE audit_logs (
    id BIGSERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id),
    action VARCHAR(100),
    resource_type VARCHAR(50),
    resource_id INTEGER,
    details JSONB,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes
CREATE INDEX idx_traffic_logs_src_ip ON traffic_logs(src_ip);
CREATE INDEX idx_traffic_logs_dst_ip ON traffic_logs(dst_ip);
CREATE INDEX idx_traffic_logs_created_at ON traffic_logs(created_at);
CREATE INDEX idx_traffic_logs_prediction ON traffic_logs(prediction);
CREATE INDEX idx_alerts_traffic_log ON alerts(traffic_log_id);
CREATE INDEX idx_alerts_severity ON alerts(severity);
CREATE INDEX idx_audit_logs_user_id ON audit_logs(user_id);
```

### 2.2 Initialize Database

```bash
# Start PostgreSQL container
docker run --name network-postgres \
  -e POSTGRES_PASSWORD=password123 \
  -e POSTGRES_DB=network_monitoring \
  -p 5432:5432 \
  -d postgres:13

# Wait for container to start
sleep 5

# Copy schema into container
docker cp database/schemas/001_initial_schema.sql network-postgres:/

# Execute schema
docker exec network-postgres psql -U postgres -d network_monitoring -f /001_initial_schema.sql

# Verify tables
docker exec network-postgres psql -U postgres -d network_monitoring -c "\dt"
```

### 2.3 Verify Database Connection

```bash
# Connect to database
psql -U postgres -d network_monitoring -h localhost -p 5432

# Inside psql:
SELECT table_name FROM information_schema.tables WHERE table_schema = 'public';
```

---

## Phase 3: ML Model Training (1.5 hours)

### 3.1 Download Dataset

**File: `ml-service/data/download_dataset.py`**

```python
import pandas as pd
import requests
from pathlib import Path

def download_nsl_kdd():
    """Download NSL-KDD dataset"""
    data_dir = Path('data')
    data_dir.mkdir(exist_ok=True)
    
    # Dataset URLs
    train_url = "https://www.unb.ca/cic/datasets/nsl-kdd/KDDTrain+.zip"
    test_url = "https://www.unb.ca/cic/datasets/nsl-kdd/KDDTest+.zip"
    
    # Download and extract
    print("Downloading NSL-KDD dataset...")
    # [Download logic here]
    
    return data_dir / "KDDTrain+_20Percent.txt"

if __name__ == "__main__":
    dataset_path = download_nsl_kdd()
    print(f"Dataset downloaded to: {dataset_path}")
```

### 3.2 Train Random Forest Model

**File: `ml-service/models/train_model.py`**

```python
import pandas as pd
import numpy as np
from sklearn.ensemble import RandomForestClassifier
from sklearn.preprocessing import StandardScaler, LabelEncoder
from sklearn.model_selection import train_test_split
from sklearn.metrics import accuracy_score, precision_score, recall_score, f1_score
import joblib
import json
from datetime import datetime

class NSLKDDTrainer:
    def __init__(self, dataset_path):
        self.dataset_path = dataset_path
        self.model = None
        self.scaler = StandardScaler()
        self.label_encoders = {}
        
    def load_and_preprocess(self):
        """Load and preprocess NSL-KDD dataset"""
        # Load data
        df = pd.read_csv(self.dataset_path)
        
        # Feature selection (important for ML performance)
        feature_cols = [
            'duration', 'protocol_type', 'service', 'flag',
            'src_bytes', 'dst_bytes', 'land', 'wrong_fragment',
            'urgent', 'hot', 'num_failed_logins', 'logged_in',
            'num_compromised', 'root_shell', 'su_attempted',
            'num_root', 'num_file_creations', 'num_shells',
            'num_access_files', 'num_outbound_cmds', 'is_host_login',
            'is_guest_login', 'count', 'srv_count', 'serror_rate',
            'srv_serror_rate', 'rerror_rate', 'srv_rerror_rate',
            'same_srv_rate', 'diff_srv_rate', 'srv_diff_host_rate',
            'dst_host_count', 'dst_host_srv_count'
        ]
        
        X = df[feature_cols].copy()
        y = df['label'].apply(lambda x: 0 if x == 'normal' else 1)
        
        # Encode categorical variables
        for col in X.select_dtypes(include='object').columns:
            le = LabelEncoder()
            X[col] = le.fit_transform(X[col])
            self.label_encoders[col] = le
        
        # Scale features
        X_scaled = self.scaler.fit_transform(X)
        
        return X_scaled, y
    
    def train(self, X, y):
        """Train Random Forest model"""
        X_train, X_test, y_train, y_test = train_test_split(
            X, y, test_size=0.2, random_state=42
        )
        
        # Train model
        self.model = RandomForestClassifier(
            n_estimators=100,
            max_depth=20,
            min_samples_split=5,
            min_samples_leaf=2,
            random_state=42,
            n_jobs=-1  # Use all CPU cores
        )
        
        self.model.fit(X_train, y_train)
        
        # Evaluate
        y_pred = self.model.predict(X_test)
        metrics = {
            'accuracy': accuracy_score(y_test, y_pred),
            'precision': precision_score(y_test, y_pred),
            'recall': recall_score(y_test, y_pred),
            'f1': f1_score(y_test, y_pred)
        }
        
        return metrics
    
    def save_model(self, model_path='models/random_forest_model.pkl'):
        """Save trained model"""
        joblib.dump(self.model, model_path)
        joblib.dump(self.scaler, 'models/scaler.pkl')
        joblib.dump(self.label_encoders, 'models/encoders.pkl')
        print(f"Model saved to {model_path}")

# Training script
if __name__ == "__main__":
    trainer = NSLKDDTrainer('data/KDDTrain+_20Percent.txt')
    X, y = trainer.load_and_preprocess()
    metrics = trainer.train(X, y)
    trainer.save_model()
    
    print("\nModel Performance:")
    for metric, value in metrics.items():
        print(f"{metric}: {value:.4f}")
```

### 3.3 Create ML Service Requirements

**File: `ml-service/requirements.txt`**

```
Flask==2.3.2
scikit-learn==1.2.2
pandas==2.0.3
numpy==1.24.3
joblib==1.2.0
python-dotenv==1.0.0
requests==2.31.0
```

---

## Phase 4: Backend API Development (3 hours)

### 4.1 Express Server Setup

**File: `backend/src/app.ts`**

```typescript
import express, { Express, Request, Response } from 'express';
import cors from 'cors';
import dotenv from 'dotenv';
import { errorHandler } from './middleware/errorHandler';
import { logger } from './utils/logger';

// Load env variables
dotenv.config();

const app: Express = express();
const PORT = process.env.BACKEND_PORT || 5000;

// Middleware
app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Routes
app.get('/api/health', (req: Request, res: Response) => {
  res.json({
    status: 'ok',
    timestamp: new Date().toISOString(),
    database: 'connected',
    ml_service: 'connected'
  });
});

// Error handling
app.use(errorHandler);

// Start server
app.listen(PORT, () => {
  logger.info(`Backend server running on port ${PORT}`);
});
```

### 4.2 Database Configuration

**File: `backend/src/config/database.ts`**

```typescript
import { Sequelize } from 'sequelize';
import dotenv from 'dotenv';

dotenv.config();

export const sequelize = new Sequelize({
  host: process.env.DB_HOST,
  username: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME,
  dialect: 'postgres',
  logging: false,
  pool: {
    max: 10,
    min: 2,
    acquire: 30000,
    idle: 10000
  }
});

export async function initializeDatabase() {
  try {
    await sequelize.authenticate();
    console.log('Database connected successfully');
  } catch (error) {
    console.error('Unable to connect to database:', error);
    process.exit(1);
  }
}
```

### 4.3 Traffic Controller

**File: `backend/src/controllers/trafficController.ts`**

```typescript
import { Request, Response } from 'express';
import { Traffic } from '../models/Traffic';
import { mlService } from '../services/mlService';

export class TrafficController {
  async submitTraffic(req: Request, res: Response) {
    try {
      const { src_ip, dst_ip, src_port, dst_port, protocol, packets, bytes, duration } = req.body;
      
      // Get prediction from ML service
      const prediction = await mlService.predict({
        src_ip, dst_ip, src_port, dst_port, protocol, packets, bytes, duration
      });
      
      // Store in database
      const traffic = await Traffic.create({
        src_ip,
        dst_ip,
        src_port,
        dst_port,
        protocol,
        packets,
        bytes,
        duration,
        prediction: prediction.is_anomaly,
        confidence_score: prediction.confidence
      });
      
      res.status(201).json({
        success: true,
        data: traffic,
        prediction
      });
    } catch (error) {
      res.status(500).json({ error: error.message });
    }
  }
  
  async getTraffic(req: Request, res: Response) {
    try {
      const traffic = await Traffic.findAll({
        limit: 100,
        order: [['created_at', 'DESC']]
      });
      
      res.json({ success: true, data: traffic });
    } catch (error) {
      res.status(500).json({ error: error.message });
    }
  }
  
  async getStats(req: Request, res: Response) {
    try {
      const total = await Traffic.count();
      const suspicious = await Traffic.count({ where: { prediction: true } });
      const normal = await Traffic.count({ where: { prediction: false } });
      
      res.json({
        success: true,
        data: {
          total_traffic: total,
          suspicious_detections: suspicious,
          normal_traffic: normal,
          detection_rate: ((suspicious / total) * 100).toFixed(2)
        }
      });
    } catch (error) {
      res.status(500).json({ error: error.message });
    }
  }
}
```

---

## Phase 5: Frontend Dashboard (3 hours)

### 5.1 React App Setup

**File: `frontend/src/App.tsx`**

```typescript
import React, { useState, useEffect } from 'react';
import { Dashboard } from './components/Dashboard';
import { AlertsPanel } from './components/AlertsPanel';
import { StatisticsCards } from './components/StatisticsCards';
import { TrafficTable } from './components/TrafficTable';
import './App.css';

export const App: React.FC = () => {
  const [stats, setStats] = useState(null);
  const [traffic, setTraffic] = useState([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    fetchStats();
    fetchTraffic();
    
    // Refresh every 30 seconds
    const interval = setInterval(() => {
      fetchStats();
      fetchTraffic();
    }, 30000);
    
    return () => clearInterval(interval);
  }, []);

  const fetchStats = async () => {
    try {
      const response = await fetch('http://localhost:5000/api/stats');
      const data = await response.json();
      setStats(data.data);
    } catch (error) {
      console.error('Error fetching stats:', error);
    }
  };

  const fetchTraffic = async () => {
    try {
      const response = await fetch('http://localhost:5000/api/traffic');
      const data = await response.json();
      setTraffic(data.data);
      setLoading(false);
    } catch (error) {
      console.error('Error fetching traffic:', error);
    }
  };

  return (
    <div className="app">
      <header className="app-header">
        <h1>🛡️ Network Monitoring Dashboard</h1>
      </header>
      
      <div className="app-content">
        {stats && <StatisticsCards stats={stats} />}
        <AlertsPanel />
        {!loading && <TrafficTable traffic={traffic} />}
      </div>
    </div>
  );
};
```

---

## Phase 6: Docker Configuration (1 hour)

### 6.1 Docker Compose Setup

**File: `docker-compose.yml`**

```yaml
version: '3.8'

services:
  postgres:
    image: postgres:13
    environment:
      POSTGRES_USER: ${DB_USER}
      POSTGRES_PASSWORD: ${DB_PASSWORD}
      POSTGRES_DB: ${DB_NAME}
    ports:
      - "${DB_PORT}:5432"
    volumes:
      - postgres_data:/var/lib/postgresql/data
      - ./database/schemas:/docker-entrypoint-initdb.d
    networks:
      - network-monitoring

  backend:
    build: ./backend
    ports:
      - "${BACKEND_PORT}:${BACKEND_PORT}"
    environment:
      - NODE_ENV=development
      - DB_HOST=postgres
      - DB_USER=${DB_USER}
      - DB_PASSWORD=${DB_PASSWORD}
      - DB_NAME=${DB_NAME}
    depends_on:
      - postgres
    networks:
      - network-monitoring

  frontend:
    build: ./frontend
    ports:
      - "${FRONTEND_PORT}:3000"
    environment:
      - REACT_APP_API_URL=http://localhost:${BACKEND_PORT}/api
    depends_on:
      - backend
    networks:
      - network-monitoring

  ml-service:
    build: ./ml-service
    ports:
      - "${ML_SERVICE_PORT}:${ML_SERVICE_PORT}"
    environment:
      - FLASK_ENV=development
      - ML_PORT=${ML_SERVICE_PORT}
    networks:
      - network-monitoring

volumes:
  postgres_data:

networks:
  network-monitoring:
    driver: bridge
```

---

## Phase 7-11: Remaining Phases

Continue with:
- Phase 7: System Integration Testing
- Phase 8: Production Deployment
- Phase 9: Monitoring & Alerts
- Phase 10: Performance Optimization
- Phase 11: GPU Migration Path

See full details in subsequent sections of this guide.

---

## ✅ Verification Checklist

After each phase, verify:
- [ ] Code compiles without errors
- [ ] Tests pass
- [ ] No console warnings
- [ ] Environment variables set
- [ ] Database connections established
- [ ] APIs responding

---

## 🚀 Next Steps

1. **Assign team members** to their respective branches
2. **Start with Phase 1** - Complete prerequisites
3. **Follow phases sequentially** - Each phase depends on previous
4. **Communicate regularly** - Daily stand-ups recommended
5. **Push to feature branches** - Create PRs for code review

---

**Estimated Total Time:** 15 hours of implementation

**Questions?** Refer to [docs/09_TROUBLESHOOTING.md](09_TROUBLESHOOTING.md)
