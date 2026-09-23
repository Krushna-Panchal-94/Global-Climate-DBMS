-- CREATE DATABASE global_climate_db;


-- USE global_climate_db;

CREATE TABLE region (
    region_id INT PRIMARY KEY,
    region_name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE income_group (
    income_group_id INT PRIMARY KEY,
    income_group_name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE country (
    country_id INT PRIMARY KEY,
    country_code VARCHAR(10) NOT NULL UNIQUE,
    country_name VARCHAR(100) NOT NULL,
    region_id INT,
    income_group_id INT,

    FOREIGN KEY (region_id)
        REFERENCES region(region_id),

    FOREIGN KEY (income_group_id)
        REFERENCES income_group(income_group_id)
);

CREATE TABLE climate_indicator (
    indicator_id INT PRIMARY KEY,
    indicator_code VARCHAR(50) NOT NULL UNIQUE,
    indicator_name VARCHAR(255) NOT NULL
);

CREATE TABLE source_organization (
    organization_id INT PRIMARY KEY,
    organization VARCHAR(255) NOT NULL UNIQUE
);

CREATE TABLE indicator_metadata (
    metadata_id INT AUTO_INCREMENT PRIMARY KEY,
    indicator_id INT NOT NULL,
    source_note TEXT,
    organization VARCHAR(255),

    FOREIGN KEY (indicator_id)
        REFERENCES climate_indicator(indicator_id)
);

CREATE TABLE climate_measurement (
    measurement_id BIGINT PRIMARY KEY,
    country_id INT NOT NULL,
    indicator_id INT NOT NULL,
    measurement_year INT NOT NULL,
    measurement_value DECIMAL(18,6),

    FOREIGN KEY (country_id)
        REFERENCES country(country_id),

    FOREIGN KEY (indicator_id)
        REFERENCES climate_indicator(indicator_id)
);
