# System Architecture & Design

## System Overview

The Network Monitoring ML System is designed as a distributed microservices architecture with the following components:

```
┌─────────────────────────────────────────────────────────────┐
│                  Network Traffic Sources                     │
│  (Devices, Servers, Network Interfaces)                     │
└──────────────────────┬──────────────────────────────────────┘
                       │
                       ▼
┌─────────────────────────────────────────────────────────────┐
│          Traffic Collection & Processing                     │
│  (Packet Capture, Feature Extraction)                       │
└──────────────────────┬──────────────────────────────────────┘
                       │
         ┌─────────────┼─────────────┐
         │             │             │
         ▼             ▼             ▼
    ┌─────────┐ ┌──────────┐ ┌─────────────┐
    │ Backend │ │ Frontend │ │ ML Service  │
    │  API    │ │Dashboard │ │ (Python)    │
    │ (Node)  │ │ (React)  │ │(scikit-learn)│
    └────┬────┘ └────┬─────┘ └─────────────┘
         │           │             │
         └─────────────┼────────────┘
                       │
                       ▼
         ┌──────────────────────────┐
         │   PostgreSQL Database     │
         │  (Traffic Logs, Alerts)   │
         └──────────────────────────┘
```

## Component Details

### 1. Backend API (Node.js/TypeScript)

**Responsibilities:**
- Accept traffic data from monitoring agents
- Validate incoming data
- Route data to ML service for predictions
- Store results in database
- Provide REST API endpoints
- Handle authentication and authorization
- Generate alerts

**Key Technologies:**
- Express.js (HTTP server)
- Sequelize (ORM)
- JWT (authentication)
- Winston (logging)

**API Endpoints:**
```
POST   /api/traffic              Submit traffic data
GET    /api/traffic              Get traffic logs
GET    /api/stats                Get statistics
GET    /api/alerts               Get alerts
POST   /api/auth/login           User login
GET    /api/health               Health check
```

### 2. Frontend Dashboard (React)

**Responsibilities:**
- Display real-time statistics
- Show traffic logs and alerts
- Visualize metrics with charts
- Provide user interface
- Handle user authentication

**Key Technologies:**
- React 18
- TypeScript
- Recharts (visualization)
- Tailwind CSS (styling)

**Main Views:**
- Dashboard (statistics overview)
- Traffic Logs (detailed records)
- Alerts (suspicious activities)
- Analytics (trends and patterns)
- Settings (system configuration)

### 3. ML Service (Python/Flask)

**Responsibilities:**
- Load trained ML model
- Extract features from traffic data
- Make predictions (normal/suspicious)
- Return confidence scores
- Provide health status

**Key Technologies:**
- Flask (HTTP server)
- scikit-learn (Random Forest)
- pandas (data processing)
- joblib (model persistence)

**Endpoints:**
```
POST   /predict           Single prediction
POST   /batch-predict     Batch prediction
GET    /health            Health status
GET    /model-info        Model metadata
```

### 4. Database (PostgreSQL)

**Data Storage:**
- User accounts and credentials
- Traffic logs with predictions
- Alerts and notifications
- ML model metadata
- Audit logs

**Key Tables:**
- `users` - User accounts
- `traffic_logs` - Network traffic records
- `alerts` - Alert history
- `ml_models` - Model versions and metrics
- `audit_logs` - System activity

## Data Flow

### Normal Traffic Analysis Workflow

```
1. Traffic Data Arrives
   ↓
2. Backend Validates Input
   ↓
3. Forward to ML Service
   ↓
4. ML Service Predicts (0-10ms)
   ↓
5. Store in Database
   ↓
6. Dashboard Updates
   ↓
7. User Sees Prediction
```

### Anomaly Detection Workflow

```
1. Suspicious Traffic Detected (prediction=true)
   ↓
2. Generate Alert
   ↓
3. Store Alert in Database
   ↓
4. Notify Frontend (WebSocket)
   ↓
5. Display in Alerts Panel
   ↓
6. Admin Takes Action
```

## Technology Stack Summary

| Layer | Technology | Version |
|-------|-----------|---------|
| Frontend | React | 18+ |
| Backend | Node.js | 18+ |
| Backend Framework | Express | 4.18+ |
| Language (Backend) | TypeScript | 5.1+ |
| ML | Python | 3.9+ |
| ML Framework | scikit-learn | 1.2+ |
| Database | PostgreSQL | 13+ |
| ORM | Sequelize | 6.32+ |
| Containerization | Docker | 20+ |
| Orchestration | Docker Compose | 1.29+ |

## Security Architecture

### Authentication
- JWT tokens for API requests
- Bcrypt password hashing
- Token expiration (7 days default)

### Authorization
- Role-based access control (admin, operator, viewer)
- Resource-level permissions
- Audit logging of all actions

### Data Protection
- HTTPS in production
- SQL injection prevention (Sequelize ORM)
- CORS configuration
- Rate limiting on API endpoints

### Network Security
- Docker network isolation
- Service-to-service communication
- Firewall rules

## Scaling Considerations

### Horizontal Scaling
- Load balancer (Nginx)
- Multiple backend instances
- Database connection pooling
- Caching layer (Redis)

### Vertical Scaling
- Increase container resources
- Database optimization
- Query caching
- Model optimization

### Performance Optimization
- Database indexes
- Query optimization
- Connection pooling
- Batch processing
- Caching frequent queries

## Monitoring & Observability

### Logging
- Winston for backend logging
- Structured JSON logs
- Log rotation and archival
- Centralized log collection (ELK stack in production)

### Metrics
- Request/response times
- Error rates
- Prediction accuracy
- System resource usage
- Database performance

### Health Checks
- Database connectivity
- ML service availability
- API responsiveness
- Disk space monitoring

## Disaster Recovery

### Backup Strategy
- Daily database backups
- Model version control
- Configuration backups
- Log archival

### Recovery Procedures
- Database restore procedures
- Model rollback process
- Service restart procedures
- Data consistency checks

---

For more details, see:
- [API Reference](04_API_REFERENCE.md)
- [Database Schema](05_DATABASE.md)
- [Deployment Guide](06_DEPLOYMENT.md)
