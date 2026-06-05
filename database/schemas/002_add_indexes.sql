-- Additional performance indexes
CREATE INDEX IF NOT EXISTS idx_traffic_logs_composite ON traffic_logs(src_ip, dst_ip, created_at DESC);
CREATE INDEX IF NOT EXISTS idx_traffic_logs_protocol ON traffic_logs(protocol);
CREATE INDEX IF NOT EXISTS idx_traffic_logs_ports ON traffic_logs(src_port, dst_port);
CREATE INDEX IF NOT EXISTS idx_alerts_unresolved ON alerts(is_resolved, created_at DESC);

-- Enable statistics for query optimization
ANALYZE users;
ANALYZE traffic_logs;
ANALYZE alerts;
ANALYZE audit_logs;
