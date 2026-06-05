-- Create Users Table
CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    role VARCHAR(20) DEFAULT 'user',
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create Traffic Logs Table
CREATE TABLE IF NOT EXISTS traffic_logs (
    id BIGSERIAL PRIMARY KEY,
    src_ip INET NOT NULL,
    dst_ip INET NOT NULL,
    src_port INTEGER NOT NULL,
    dst_port INTEGER NOT NULL,
    protocol VARCHAR(10) NOT NULL,
    packets INTEGER DEFAULT 0,
    bytes BIGINT DEFAULT 0,
    duration FLOAT DEFAULT 0,
    prediction BOOLEAN DEFAULT NULL,
    confidence_score FLOAT DEFAULT NULL,
    model_version VARCHAR(50),
    detected_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT valid_ports CHECK (src_port > 0 AND src_port <= 65535 AND dst_port > 0 AND dst_port <= 65535)
);

-- Create Alerts Table
CREATE TABLE IF NOT EXISTS alerts (
    id BIGSERIAL PRIMARY KEY,
    traffic_log_id BIGINT REFERENCES traffic_logs(id) ON DELETE CASCADE,
    alert_type VARCHAR(50) NOT NULL,
    severity VARCHAR(20) NOT NULL,
    message TEXT NOT NULL,
    is_resolved BOOLEAN DEFAULT FALSE,
    resolved_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create ML Models Table
CREATE TABLE IF NOT EXISTS ml_models (
    id SERIAL PRIMARY KEY,
    model_name VARCHAR(100) NOT NULL,
    model_version VARCHAR(50) NOT NULL UNIQUE,
    model_type VARCHAR(50),
    accuracy FLOAT,
    precision FLOAT,
    recall FLOAT,
    f1_score FLOAT,
    trained_at TIMESTAMP,
    deployed_at TIMESTAMP,
    is_active BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create Audit Logs Table
CREATE TABLE IF NOT EXISTS audit_logs (
    id BIGSERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id) ON DELETE SET NULL,
    action VARCHAR(100) NOT NULL,
    resource_type VARCHAR(50),
    resource_id VARCHAR(255),
    details JSONB,
    ip_address INET,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create System Stats Table (for caching stats)
CREATE TABLE IF NOT EXISTS system_stats (
    id SERIAL PRIMARY KEY,
    total_traffic_records BIGINT DEFAULT 0,
    suspicious_detections BIGINT DEFAULT 0,
    normal_traffic BIGINT DEFAULT 0,
    detection_rate FLOAT DEFAULT 0,
    average_confidence FLOAT DEFAULT 0,
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create Indexes for Performance
CREATE INDEX IF NOT EXISTS idx_traffic_logs_src_ip ON traffic_logs(src_ip);
CREATE INDEX IF NOT EXISTS idx_traffic_logs_dst_ip ON traffic_logs(dst_ip);
CREATE INDEX IF NOT EXISTS idx_traffic_logs_created_at ON traffic_logs(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_traffic_logs_prediction ON traffic_logs(prediction);
CREATE INDEX IF NOT EXISTS idx_traffic_logs_confidence ON traffic_logs(confidence_score);
CREATE INDEX IF NOT EXISTS idx_alerts_traffic_log ON alerts(traffic_log_id);
CREATE INDEX IF NOT EXISTS idx_alerts_severity ON alerts(severity);
CREATE INDEX IF NOT EXISTS idx_alerts_created_at ON alerts(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_audit_logs_user_id ON audit_logs(user_id);
CREATE INDEX IF NOT EXISTS idx_audit_logs_created_at ON audit_logs(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_ml_models_active ON ml_models(is_active);

-- Create Views
CREATE OR REPLACE VIEW v_traffic_summary AS
SELECT 
    DATE(created_at) as date,
    COUNT(*) as total_records,
    SUM(CASE WHEN prediction = true THEN 1 ELSE 0 END) as suspicious,
    SUM(CASE WHEN prediction = false THEN 1 ELSE 0 END) as normal,
    AVG(confidence_score) as avg_confidence,
    SUM(bytes) as total_bytes
FROM traffic_logs
GROUP BY DATE(created_at);

CREATE OR REPLACE VIEW v_top_suspicious_ips AS
SELECT 
    src_ip,
    COUNT(*) as suspicious_count,
    AVG(confidence_score) as avg_confidence,
    MAX(created_at) as last_seen
FROM traffic_logs
WHERE prediction = true
GROUP BY src_ip
ORDER BY suspicious_count DESC
LIMIT 100;
