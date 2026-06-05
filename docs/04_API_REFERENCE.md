# Complete API Reference

## Base URL
```
http://localhost:5000/api
```

## Authentication

All protected endpoints require JWT token:
```
Authorization: Bearer <token>
```

## Health Check

### GET /health
Check system health status.

**Response (200 OK):**
```json
{
  "status": "ok",
  "timestamp": "2026-06-05T12:00:00Z",
  "database": "connected",
  "ml_service": "connected",
  "version": "1.0.0"
}
```

## Authentication Endpoints

### POST /auth/login
User login.

**Request Body:**
```json
{
  "username": "admin",
  "password": "password123"
}
```

**Response (200 OK):**
```json
{
  "success": true,
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "user": {
    "id": 1,
    "username": "admin",
    "email": "admin@example.com",
    "role": "admin"
  }
}
```

## Traffic Endpoints

### POST /traffic
Submit new traffic record.

**Request Body:**
```json
{
  "src_ip": "192.168.1.100",
  "dst_ip": "10.0.0.1",
  "src_port": 54321,
  "dst_port": 443,
  "protocol": "TCP",
  "packets": 100,
  "bytes": 5000,
  "duration": 5.5
}
```

**Response (201 Created):**
```json
{
  "success": true,
  "data": {
    "id": 12345,
    "src_ip": "192.168.1.100",
    "dst_ip": "10.0.0.1",
    "prediction": false,
    "confidence_score": 0.95,
    "created_at": "2026-06-05T12:00:00Z"
  },
  "prediction": {
    "is_anomaly": false,
    "confidence": 0.95
  }
}
```

### GET /traffic
Get traffic logs with pagination and filtering.

**Query Parameters:**
```
page=1&limit=50&prediction=true&days=7
```

**Response (200 OK):**
```json
{
  "success": true,
  "data": [
    {
      "id": 12345,
      "src_ip": "192.168.1.100",
      "dst_ip": "10.0.0.1",
      "src_port": 54321,
      "dst_port": 443,
      "protocol": "TCP",
      "packets": 100,
      "bytes": 5000,
      "prediction": false,
      "confidence_score": 0.95,
      "created_at": "2026-06-05T12:00:00Z"
    }
  ],
  "pagination": {
    "page": 1,
    "limit": 50,
    "total": 1000,
    "pages": 20
  }
}
```

## Statistics Endpoints

### GET /stats
Get system statistics.

**Response (200 OK):**
```json
{
  "success": true,
  "data": {
    "total_traffic": 10000,
    "suspicious_detections": 250,
    "normal_traffic": 9750,
    "detection_rate": 2.5,
    "average_confidence": 0.92,
    "last_updated": "2026-06-05T12:00:00Z"
  }
}
```

### GET /stats/timeline
Get statistics timeline for charts.

**Query Parameters:**
```
period=24h&interval=1h
```

**Response (200 OK):**
```json
{
  "success": true,
  "data": [
    {
      "timestamp": "2026-06-05T00:00:00Z",
      "total": 100,
      "suspicious": 5,
      "detection_rate": 5.0
    }
  ]
}
```

## Alert Endpoints

### GET /alerts
Get active alerts.

**Query Parameters:**
```
severity=high&unresolved=true&limit=50
```

**Response (200 OK):**
```json
{
  "success": true,
  "data": [
    {
      "id": 1,
      "traffic_log_id": 12345,
      "alert_type": "SUSPICIOUS_PATTERN",
      "severity": "high",
      "message": "Unusual traffic pattern detected",
      "is_resolved": false,
      "created_at": "2026-06-05T12:00:00Z"
    }
  ]
}
```

### PUT /alerts/:id/resolve
Resolve an alert.

**Request Body:**
```json
{
  "resolution_note": "False positive - known pattern"
}
```

**Response (200 OK):**
```json
{
  "success": true,
  "message": "Alert resolved"
}
```

## Error Responses

### 400 Bad Request
```json
{
  "success": false,
  "error": "Invalid request parameters",
  "details": {
    "field": "src_ip",
    "message": "Invalid IP address format"
  }
}
```

### 401 Unauthorized
```json
{
  "success": false,
  "error": "Authentication required"
}
```

### 500 Internal Server Error
```json
{
  "success": false,
  "error": "Internal server error",
  "request_id": "req-12345"
}
```

## Rate Limiting

API endpoints have rate limiting:
- **Standard endpoints**: 100 requests per 15 minutes
- **Traffic submission**: 1000 requests per 15 minutes

Headers in response:
```
X-RateLimit-Limit: 100
X-RateLimit-Remaining: 99
X-RateLimit-Reset: 1623000000
```

## Pagination

List endpoints support pagination:

**Query Parameters:**
```
page=1         # Page number (default: 1)
limit=50       # Items per page (default: 50, max: 500)
sort=created_at&order=DESC
```

---

For more information, see [docs/06_DEPLOYMENT.md](06_DEPLOYMENT.md)
