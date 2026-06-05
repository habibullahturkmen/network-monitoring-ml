-- Insert sample user
INSERT INTO users (username, email, password_hash, role, is_active) VALUES
('admin', 'admin@network-monitoring.local', '$2a$10$YourHashedPasswordHere', 'admin', true),
('operator', 'operator@network-monitoring.local', '$2a$10$YourHashedPasswordHere', 'operator', true)
ON CONFLICT (username) DO NOTHING;

-- Insert sample ML model
INSERT INTO ml_models (model_name, model_version, model_type, accuracy, precision, recall, f1_score, is_active) VALUES
('Random Forest Classifier', 'v1.0.0', 'random_forest', 0.95, 0.93, 0.94, 0.935, true)
ON CONFLICT (model_version) DO NOTHING;

-- Initialize system stats
INSERT INTO system_stats (total_traffic_records, suspicious_detections, normal_traffic, detection_rate, average_confidence) VALUES
(0, 0, 0, 0.0, 0.0)
ON CONFLICT DO NOTHING;
