SELECT
    c.country_name,
    r.region_name,
    ig.income_group_name,
    ci.indicator_name,
    cm.measurement_year,
    cm.measurement_value
FROM climate_measurement cm
INNER JOIN country c
    ON cm.country_id = c.country_id
INNER JOIN region r
    ON c.region_id = r.region_id
INNER JOIN income_group ig
    ON c.income_group_id = ig.income_group_id
INNER JOIN climate_indicator ci
    ON cm.indicator_id = ci.indicator_id;
    
    
    -- =========================================
-- 2. LEFT OUTER JOIN
-- =========================================

SELECT
    r.region_name,
    c.country_name,
    cm.measurement_year,
    cm.measurement_value
FROM region r
LEFT JOIN country c
    ON r.region_id = c.region_id
LEFT JOIN climate_measurement cm
    ON c.country_id = cm.country_id;
    
    
    -- =========================================
-- 2. LEFT OUTER JOIN
-- =========================================

SELECT
    r.region_name,
    c.country_name,
    cm.measurement_year,
    cm.measurement_value
FROM region r
LEFT JOIN country c
    ON r.region_id = c.region_id
LEFT JOIN climate_measurement cm
    ON c.country_id = cm.country_id;
    
    -- =========================================
-- 4. SELF JOIN
-- =========================================

SELECT
    c.country_name,
    ci.indicator_name,
    m1.measurement_year AS year_1,
    m1.measurement_value AS value_1,
    m2.measurement_year AS year_2,
    m2.measurement_value AS value_2
FROM climate_measurement m1
JOIN climate_measurement m2
    ON m1.country_id = m2.country_id
    AND m1.indicator_id = m2.indicator_id
    AND m1.measurement_year < m2.measurement_year
JOIN country c
    ON m1.country_id = c.country_id
JOIN climate_indicator ci
    ON m1.indicator_id = ci.indicator_id
LIMIT 100;

-- =========================================
-- 5. AGGREGATE FUNCTIONS
-- =========================================

SELECT
    MIN(measurement_value) AS minimum_value,
    MAX(measurement_value) AS maximum_value,
    AVG(measurement_value) AS average_value,
    COUNT(*) AS total_records
FROM climate_measurement;

-- =========================================
-- 7. GROUP BY + HAVING
-- =========================================

SELECT
    c.country_name,
    COUNT(cm.measurement_id) AS total_measurements
FROM country c
JOIN climate_measurement cm
    ON c.country_id = cm.country_id
GROUP BY
    c.country_id,
    c.country_name
HAVING COUNT(cm.measurement_id) > 100;

-- =========================================
-- 9. CORRELATED SUBQUERY
-- =========================================

SELECT
    c.country_name,
    r.region_name,
    ci.indicator_name,
    cm.measurement_year,
    cm.measurement_value
FROM climate_measurement cm
JOIN country c
    ON cm.country_id = c.country_id
JOIN region r
    ON c.region_id = r.region_id
JOIN climate_indicator ci
    ON cm.indicator_id = ci.indicator_id
WHERE cm.measurement_value >
(
    SELECT AVG(cm2.measurement_value)
    FROM climate_measurement cm2
    JOIN country c2
        ON cm2.country_id = c2.country_id
    WHERE c2.region_id = c.region_id
      AND cm2.indicator_id = cm.indicator_id
      AND cm2.measurement_year = cm.measurement_year
);
-- =========================================
-- 11. STORED PROCEDURE
-- =========================================

DROP PROCEDURE IF EXISTS add_climate_measurement;

DELIMITER //

CREATE PROCEDURE add_climate_measurement(
    IN p_country_id INT,
    IN p_indicator_id INT,
    IN p_year YEAR,
    IN p_value DECIMAL(20,6)
)
BEGIN

    INSERT INTO climate_measurement
    (
        country_id,
        indicator_id,
        measurement_year,
        measurement_value
    )
    VALUES
    (
        p_country_id,
        p_indicator_id,
        p_year,
        p_value
    );

END //

DELIMITER ;

-- =========================================
-- 12. TRIGGER
-- =========================================

DROP TRIGGER IF EXISTS trg_climate_measurement_update;

DELIMITER //

CREATE TRIGGER trg_climate_measurement_update
AFTER UPDATE ON climate_measurement
FOR EACH ROW
BEGIN

    INSERT INTO climate_measurement_audit
    (
        measurement_id,
        action_type,
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

-- =========================================
-- 13. VIEW 1
-- =========================================

CREATE OR REPLACE VIEW country_climate_report AS
SELECT
    c.country_name,
    r.region_name,
    ig.income_group_name,
    ci.indicator_name,
    cm.measurement_year,
    cm.measurement_value
FROM climate_measurement cm
JOIN country c
    ON cm.country_id = c.country_id
JOIN region r
    ON c.region_id = r.region_id
JOIN income_group ig
    ON c.income_group_id = ig.income_group_id
JOIN climate_indicator ci
    ON cm.indicator_id = ci.indicator_id;
    
    -- =========================================
-- 14. VIEW 2
-- =========================================

CREATE OR REPLACE VIEW regional_climate_report AS
SELECT
    r.region_name,
    ci.indicator_name,
    COUNT(cm.measurement_id) AS total_records,
    AVG(cm.measurement_value) AS average_value,
    MIN(cm.measurement_value) AS minimum_value,
    MAX(cm.measurement_value) AS maximum_value
FROM region r
JOIN country c
    ON r.region_id = c.region_id
JOIN climate_measurement cm
    ON c.country_id = cm.country_id
JOIN climate_indicator ci
    ON cm.indicator_id = ci.indicator_id
GROUP BY
    r.region_id,
    r.region_name,
    ci.indicator_id,
    ci.indicator_name;
    
    