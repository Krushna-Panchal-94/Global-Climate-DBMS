USE global_climate_db;

-- Audit table
CREATE TABLE IF NOT EXISTS climate_measurement_audit (
    audit_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    measurement_id BIGINT NOT NULL,
    operation_type VARCHAR(20) NOT NULL,
    old_value DECIMAL(18,6),
    new_value DECIMAL(18,6),
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

DROP TRIGGER IF EXISTS trg_measurement_update;

DELIMITER //

CREATE TRIGGER trg_measurement_update
AFTER UPDATE ON climate_measurement
FOR EACH ROW
BEGIN

    INSERT INTO climate_measurement_audit
    (
        measurement_id,
        operation_type,
        old_value,
        new_value
    )
    VALUES
    (
        OLD.measurement_id,
        'UPDATE',
        OLD.measurement_value,
        NEW.measurement_value
    );

END //

DELIMITER ;
SELECT *
FROM climate_measurement
LIMIT 1;

UPDATE climate_measurement
SET measurement_value = measurement_value + 1
WHERE measurement_id = 1;