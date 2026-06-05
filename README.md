# Network Monitoring ML - Intrusion Detection System

A lightweight machine learning-based network monitoring and intrusion detection system designed for educational labs and small organizations.

## 📋 Project Overview

This project implements an intelligent network monitoring system that uses machine learning to detect suspicious network activities. The system collects network traffic, extracts features, applies machine learning classification, and presents results through a web dashboard.

**Team Members:**
- Habibullah Turkmen
- Bernard Appiah
- Soumita Bose
- Alshaima Syed Ibrahim

## 🎯 Key Features

- ✅ Network traffic monitoring and logging
- ✅ ML-based anomaly detection (Random Forest)
- ✅ PostgreSQL database for persistent storage
- ✅ Real-time React dashboard
- ✅ RESTful API for traffic analysis
- ✅ Alert generation and notifications
- ✅ Historical log retrieval with filtering
- ✅ System health monitoring
- ✅ JWT authentication
- ✅ Docker containerization

## 🛠️ Tech Stack

### Backend
- Node.js 18+
- TypeScript
- Express.js
- Sequelize ORM
- PostgreSQL

### Frontend
- React 18+
- TypeScript
- Axios
- Recharts (charting)
- Tailwind CSS (styling)

### ML Service
- Python 3.9+
- scikit-learn
- pandas
- numpy
- Flask

### Deployment
- Docker
- Docker Compose
- PostgreSQL 13+

## 📦 Project Structure

```
network-monitoring-ml/
├── backend/              # Node.js/TypeScript API
├── frontend/             # React Dashboard
├── ml-service/           # Python ML Service
├── database/             # PostgreSQL schemas
├── docker-compose.yml    # Container orchestration
├── docs/                 # Comprehensive documentation
└── README.md
```

## 🚀 Quick Start

For a 5-minute quick start, see [docs/01_QUICK_START.md](docs/01_QUICK_START.md)

## 📚 Documentation

Complete documentation is available in the `docs/` directory:

1. [01_QUICK_START.md](docs/01_QUICK_START.md) - Get running in 5 minutes
2. [02_INSTALLATION.md](docs/02_INSTALLATION.md) - Detailed installation guide
3. [03_ARCHITECTURE.md](docs/03_ARCHITECTURE.md) - System design and architecture
4. [04_API_REFERENCE.md](docs/04_API_REFERENCE.md) - Complete API documentation
5. [05_DATABASE.md](docs/05_DATABASE.md) - Database schema and optimization
6. [06_DEPLOYMENT.md](docs/06_DEPLOYMENT.md) - Production deployment guide
7. [07_DEVELOPMENT.md](docs/07_DEVELOPMENT.md) - Development workflow
8. [08_CONTRIBUTING.md](docs/08_CONTRIBUTING.md) - Contributing guidelines
9. [09_TROUBLESHOOTING.md](docs/09_TROUBLESHOOTING.md) - Common issues
10. [10_GPU_MIGRATION.md](docs/10_GPU_MIGRATION.md) - GPU integration guide
11. [11_STEP_BY_STEP_GUIDE.md](docs/11_STEP_BY_STEP_GUIDE.md) - Implementation steps
12. [12_TESTING.md](docs/12_TESTING.md) - Testing strategy
13. [13_MONITORING.md](docs/13_MONITORING.md) - System monitoring
14. [14_SCALING.md](docs/14_SCALING.md) - Scaling guide (50-250 devices)

## 🎓 Target Users

- Educational institutions and computer labs
- Small organizations (50-250 devices)
- Security researchers
- Network administrators

## 📊 System Architecture

```
Network Traffic → Traffic Capture → Feature Extraction → ML Detection 
    ↓
PostgreSQL Database ← Backend API ← Prediction Results
    ↓
React Dashboard (Visualization & Alerts)
```

## 🔧 Prerequisites

- Docker & Docker Compose
- Node.js 18+ (for backend development)
- Python 3.9+ (for ML service)
- PostgreSQL 13+ (can run in Docker)

## 📖 Getting Started

1. **Clone the repository:**
   ```bash
   git clone https://github.com/habibullahturkmen/network-monitoring-ml.git
   cd network-monitoring-ml
   ```

2. **Start with Quick Start Guide:**
   See [docs/01_QUICK_START.md](docs/01_QUICK_START.md)

3. **Follow Step-by-Step Implementation:**
   See [docs/11_STEP_BY_STEP_GUIDE.md](docs/11_STEP_BY_STEP_GUIDE.md)

## 🤝 Contributing

We welcome contributions from team members! Please see [docs/08_CONTRIBUTING.md](docs/08_CONTRIBUTING.md) for guidelines.

## 📝 License

This project is for educational purposes.

## 📞 Support

For issues, questions, or suggestions:
1. Check [docs/09_TROUBLESHOOTING.md](docs/09_TROUBLESHOOTING.md)
2. Review [docs/04_API_REFERENCE.md](docs/04_API_REFERENCE.md)
3. Check GitHub Issues

---

**Last Updated:** 2026-06-05
**Version:** 1.0.0-beta
