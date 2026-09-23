USE global_climate_db;

-- VIEW 1: Country-wise Climate Summary
CREATE OR REPLACE VIEW country_climate_summary AS
SELECT
    c.country_name,
    r.region_name,
    ci.indicator_name,
    COUNT(cm.measurement_id) AS total_measurements,
    ROUND(AVG(cm.measurement_value), 2) AS average_value,
    ROUND(MIN(cm.measurement_value), 2) AS minimum_value,
    ROUND(MAX(cm.measurement_value), 2) AS maximum_value
FROM climate_measurement cm
JOIN country c
    ON cm.country_id = c.country_id
JOIN region r
    ON c.region_id = r.region_id
JOIN climate_indicator ci
    ON cm.indicator_id = ci.indicator_id
GROUP BY
    c.country_name,
    r.region_name,
    ci.indicator_name;


-- VIEW 2: Regional Climate Summary
CREATE OR REPLACE VIEW regional_climate_summary AS
SELECT
    r.region_name,
    ci.indicator_name,
    cm.measurement_year,
    COUNT(cm.measurement_id) AS measurement_count,
    ROUND(AVG(cm.measurement_value), 2) AS average_value,
    ROUND(MIN(cm.measurement_value), 2) AS minimum_value,
    ROUND(MAX(cm.measurement_value), 2) AS maximum_value
FROM climate_measurement cm
JOIN country c
    ON cm.country_id = c.country_id
JOIN region r
    ON c.region_id = r.region_id
JOIN climate_indicator ci
    ON cm.indicator_id = ci.indicator_id
GROUP BY
    r.region_name,
    ci.indicator_name,
    cm.measurement_year;