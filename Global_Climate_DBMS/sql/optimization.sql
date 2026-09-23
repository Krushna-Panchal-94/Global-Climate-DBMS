CREATE INDEX idx_measurement_year_value
ON climate_measurement (
    measurement_year,
    measurement_value
);

EXPLAIN
SELECT
    c.country_name,
    ci.indicator_name,
    cm.measurement_year,
    cm.measurement_value
FROM climate_measurement cm
JOIN country c
    ON cm.country_id = c.country_id
JOIN climate_indicator ci
    ON cm.indicator_id = ci.indicator_id
WHERE cm.measurement_year = 2020
  AND cm.measurement_value > 50;
  
  