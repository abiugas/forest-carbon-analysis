<img width="1625" height="672" alt="image" src="https://github.com/user-attachments/assets/a9a61f7d-b3b4-496d-976f-7111b1a208e9" />


# Forest Inventory and Carbon Analysis | Urban FIADB 2024

**Forest Inventory · Forest Carbon Accounting · SQL · SQLite · Environmental Data Analysis**

## Project Overview

This project focuses on processing and analyzing forest inventory data using SQL and spreadsheet tools, based on the **Urban Forest Inventory and Analysis Database (Urban FIADB)** developed by the USDA Forest Service.

The objective was to quantify aboveground biomass, carbon, and carbon dioxide equivalent (CO₂e) for the 2024 measurement year, conducting analyses at both plot and species levels.

This project was developed as **Exercise 1 of a practical SQL and forest carbon analysis case study**, adapting the queries to the database structure and fields available in Urban FIADB.

## Objectives

- Query and join relational forest inventory database tables.
- Extract tree records associated with plots classified as sampled forest.
- Convert dendrometric and biomass variables into the International System of Units (SI).
- Calculate aboveground biomass, carbon, and carbon dioxide equivalent.
- Analyze results by plot and tree species.
- Apply data integrity, consistency, and missing-value checks.
- Document SQL queries, calculation formulas, and methodological limitations.

## Data Source

**USDA Forest Service – Urban Forest Inventory and Analysis Database (Urban FIADB).**

Tables used:

- `ID_PLOT`: Plot information, status, and measurement visits.
- `ID_TREE`: Individual tree measurements and attributes.
- `REF_SPECIES`: Taxonomic reference catalog and species-related reference parameters.

Official sources:

- [Urban DataMart – USDA Forest Service](https://research.fs.usda.gov/products/dataandtools/urban-datamart)
- [Urban FIADB Database Description – Version 9.0 (2024)](https://research.fs.usda.gov/sites/default/files/2024-10/wo-v9-0_sept2024_ug_urbanfiadb_database_description.pdf)

The original SQLite database is not included in this repository. The workbook contains the filtered extraction of 5,131 records used in the analysis.

## Scope and Selection Criteria

The analysis was restricted to the 2024 measurement year using the following filters:

- `MEAS_YEAR = 2024`
- `PLOT_STATUS_CD = 1` (*Sampled: Forest*).

The relationship between `ID_PLOT` and `ID_TREE` was established using the following composite keys:

`PLOTID`, `VISIT_NBR`, `STATECD`, `UNITCD`, `COUNTYCD`, and `RETIRED_PLOT`.

The relationship with `REF_SPECIES` was established through the `SPCD` field.

## Key Results

| Indicator | Result |
|---|---:|
| Selected PLOTIDs | 181 |
| Plots with tree records | 179 |
| Tree records analyzed | 5,131 |
| Species represented in the sample | 137 |
| Records with available biomass and carbon values | 4,537 |
| Records with missing values | 594 |
| Plot–species combinations | 987 |

### Biomass and Carbon Results

The primary calculation method follows the fixed carbon conversion factor of 0.47 specified in the exercise:

| Indicator | Result |
|---|---:|
| Sample aboveground biomass | 1,880.041 t |
| Calculated carbon (0.47 factor) | 883.619 t C |
| Carbon dioxide equivalent | 3,239.938 t CO₂e |

An independent comparison was also performed using the native `CARBON_AG` field available in FIADB:

| Indicator | Result |
|---|---:|
| FIADB aboveground carbon | 893.642 t C |
| FIADB carbon dioxide equivalent | 3,276.688 t CO₂e |

Both methods are reported separately. The 0.47 conversion factor was not applied again to the native `CARBON_AG` field.

### Carbon and Biomass Density Analysis

Aboveground biomass, carbon, and CO₂e density indicators were calculated for each `PLOTID + SPCD` combination using `TPA_UNADJ` and acre-to-hectare conversion factors.

The resulting indicators are reported as **unstratified density estimates**. They should not be interpreted as definitive population-level estimates of forest carbon stocks.

## Methodology and Unit Conversions

The main unit conversions applied were:

| Variable | Conversion |
|---|---|
| Diameter | Inches to centimeters (× 2.54) |
| Total tree length | Feet to meters (× 0.3048) |
| Aboveground biomass | Pounds to kilograms (× 0.45359237) |
| Aboveground carbon | Pounds of C to kilograms of C (× 0.45359237) |
| Tree density | Trees per acre to trees per hectare (× 2.47105) |
| Carbon to CO₂ equivalent | t C × 44/12 |

Missing values were retained as `NULL` and were neither imputed nor replaced with zeros.

## Deliverable Structure

The Excel workbook contains nine worksheets:

1. `1_RAW_SQL`: Original extraction of individual tree records.
2. `2_TRANSFORMACIONES`: Variable conversions into SI units.
3. `3_REF_ESPECIES`: Taxonomic reference catalog.
4. `4_ANALISIS_PARCELA`: Results aggregated by plot and species.
5. `4_RESUMEN_PARCELA`: Plot-level indicator aggregation.
6. `5_RESUMEN_ESPECIE`: Species-level results aggregation.
7. `6_DASHBOARD_RESULTADOS`: Key indicators and data visualizations.
8. `7_METODOLOGIA`: Procedures, selection criteria, validation checks, and limitations.
9. `8_CONSULTAS_SQL`: Documentation of SQL queries and procedures Q01–Q06.

## Tools and Technologies

- **SQLite:** Relational database querying and data management.
- **DBeaver:** SQL query execution and validation.
- **Google Sheets / Microsoft Excel:** Data transformations, aggregations, quality checks, and dashboard development.
- **SQL:** `SELECT`, `INNER JOIN`, `WHERE`, `GROUP BY`, `COUNT`, `SUM`, `DISTINCT`, `CASE`, `CTE`, and data conversion functions.

## Data Quality Assurance and Reproducibility

The following validation checks were performed:

- Consistency between original and transformed records.
- Integrity of composite tree identification keys.
- Plot and species record counts.
- Identification and assessment of missing values.
- Consistency checks for biomass, carbon, and CO₂e totals.
- Cross-validation between SQL queries and the resulting analytical tables.

The main queries and selection criteria are documented in worksheet `8_CONSULTAS_SQL`.

To reproduce the original data extraction, access to a compatible version of Urban FIADB is required, along with execution of the documented queries against the corresponding database tables. Subsequent database updates may result in differences in the output.

## Scope and Methodological Limitations

This project represents a descriptive analysis of the records available for the 2024 measurement year.

The aggregated aboveground biomass, carbon, and carbon dioxide equivalent values correspond to the individual records available within the selected dataset. They do not, by themselves, represent the total carbon stock of the entire forest population.

Per-hectare indicators were calculated using `TPA_UNADJ`, without additional stratum or subplot adjustments. Therefore, they are reported as unstratified density estimates rather than definitive population-level estimates.

The analysis covers aboveground wood and bark biomass and carbon. It does not include belowground biomass, soil organic carbon, litter, or other carbon pools.

This project covers **Exercise 1** of the reference case study. Exercise 2, which involves auditing timber harvesting volumes, is not included because the required harvesting data are not available in the tables used for this analysis.

## Skills Demonstrated

- Relational forest inventory database analysis.
- SQL-based data extraction, querying, and transformation.
- Interpretation of dendrometric and biomass variables.
- Forest carbon and CO₂e quantification.
- Taxonomic data integration.
- Data quality assurance and missing-value management.
- Technical documentation and methodological limitations assessment.
- Environmental data visualization and results communication.

---

**Professional Portfolio Project | Forest Engineering & Environmental Data Analytics**
