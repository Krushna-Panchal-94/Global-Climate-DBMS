START TRANSACTION;

UPDATE climate_measurement
SET measurement_value = measurement_value + 100
WHERE measurement_id = 1;

SELECT
    measurement_id,
    measurement_value
FROM climate_measurement
WHERE measurement_id = 1;

ROLLBACK;

SELECT
    measurement_id,
    measurement_value
FROM climate_measurement
WHERE measurement_id = 1;

START TRANSACTION;

UPDATE climate_measurement
SET measurement_value = measurement_value + 5
WHERE measurement_id = 1;

SAVEPOINT before_second_update;

UPDATE climate_measurement
SET measurement_value = measurement_value + 50
WHERE measurement_id = 1;

ROLLBACK TO before_second_update;

COMMIT;