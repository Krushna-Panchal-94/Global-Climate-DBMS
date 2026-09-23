import pandas as pd
from pathlib import Path

# 1. Setup Paths
BASE = Path(__file__).resolve().parent
RAW, OUT = BASE / "raw_data", BASE / "cleaned_data"
OUT.mkdir(exist_ok=True)

# 2. Load Data (Finding the header row dynamically)
with open(RAW / "API_19_DS2_en_csv_v2_42074.csv", "r", encoding="utf-8-sig") as f:
    skip = next(i for i, line in enumerate(f) if "Country Name" in line)

main = pd.read_csv(RAW / "API_19_DS2_en_csv_v2_42074.csv", skiprows=skip)
country = pd.read_csv(RAW / "Metadata_Country_API_19_DS2_en_csv_v2_42074.csv")
indicator = pd.read_csv(RAW / "Metadata_Indicator_API_19_DS2_en_csv_v2_42074.csv")

# Clean unnamed columns from all files
main = main.loc[:, ~main.columns.str.startswith("Unnamed")]
country = country.loc[:, ~country.columns.str.startswith("Unnamed")]
indicator = indicator.loc[:, ~indicator.columns.str.startswith("Unnamed")]

# 3. Create Lookup Tables (Region, Income Group, Source Organization)
region = pd.DataFrame({"region_name": country["Region"].dropna().unique()})
region.insert(0, "region_id", range(1, len(region) + 1))

income = pd.DataFrame({"income_group_name": country["IncomeGroup"].dropna().unique()})
income.insert(0, "income_group_id", range(1, len(income) + 1))

source = pd.DataFrame({"organization": indicator["SOURCE_ORGANIZATION"].dropna().unique()})
source.insert(0, "organization_id", range(1, len(source) + 1))

# 4. Clean Indicator Data
climate_indicator = indicator[["INDICATOR_CODE", "INDICATOR_NAME"]].drop_duplicates()
climate_indicator.columns = ["indicator_code", "indicator_name"]
climate_indicator.insert(0, "indicator_id", range(1, len(climate_indicator) + 1))

ind_meta = indicator.rename(columns={"INDICATOR_CODE": "indicator_code", "SOURCE_NOTE": "source_note", "SOURCE_ORGANIZATION": "organization"})
ind_meta = ind_meta.merge(climate_indicator[["indicator_code", "indicator_id"]], on="indicator_code", how="left")
ind_meta = ind_meta[["indicator_id", "source_note", "organization"]].drop_duplicates()

# 5. Clean Country Data
country_df = country.rename(columns={"Country Code": "country_code", "TableName": "country_name", "Region": "region_name", "IncomeGroup": "income_group_name"})
country_df = country_df.merge(region, on="region_name", how="left").merge(income, on="income_group_name", how="left")
country_df = country_df[["country_code", "country_name", "region_id", "income_group_id"]].drop_duplicates()
country_df.insert(0, "country_id", range(1, len(country_df) + 1))

# 6. Transform and Map Measurements
years = [c for c in main.columns if c.isdigit()]
meas = main.melt(id_vars=["Country Code", "Indicator Code"], value_vars=years, var_name="measurement_year", value_name="measurement_value")
meas = meas.dropna(subset=["measurement_value"]).drop_duplicates()

# Merge foreign keys
meas = meas.merge(country_df[["country_code", "country_id"]], left_on="Country Code", right_on="country_code")
meas = meas.merge(climate_indicator[["indicator_code", "indicator_id"]], left_on="Indicator Code", right_on="indicator_code")

# Finalize Measurements Table
meas["measurement_year"] = meas["measurement_year"].astype(int)
meas = meas[["country_id", "indicator_id", "measurement_year", "measurement_value"]]
meas.insert(0, "measurement_id", range(1, len(meas) + 1))

# 7. Batch Export
datasets = {
    "region": region,
    "income_group": income,
    "country": country_df,
    "climate_indicator": climate_indicator,
    "indicator_metadata": ind_meta,
    "source_organization": source,
    "climate_measurement": meas
}

print(f"{'DATA EXPORT REPORT':-^40}")
for name, df in datasets.items():
    df.to_csv(OUT / f"{name}.csv", index=False)
    print(f"{name + '.csv':<25} {df.shape}")