-- **Forest Carbon Data Analysis**
___________________________________________
___	Q1_1_RAW_DATA_BASE

-- *Purpose: Extraction of forestry records for the year 2024*

SELECT 
    p.MEAS_YEAR,
    p.MANUAL_NATIONAL,     
    t.PLOTID,
    t.VISIT_NBR,
    t.STATECD,
    t.UNITCD,
    t.COUNTYCD,
    t.RETIRED_PLOT,
    t.SUBP,                
    t.CONDID,              
    t.TREE,                
    t.STEM,                
    t.STATUSCD,            
    t.SPCD,                
    t.DIA,
    t.TOTAL_LENGTH,
    t.DRYBIO_AG,
    t.CARBON_AG,
    t.TPA_UNADJ
FROM ID_PLOT AS p
INNER JOIN ID_TREE AS t 
    ON t.PLOTID = p.PLOTID 
   AND t.VISIT_NBR = p.VISIT_NBR 
   AND t.STATECD = p.STATECD 
   AND t.UNITCD = p.UNITCD 
   AND t.COUNTYCD = p.COUNTYCD 
   AND t.RETIRED_PLOT = p.RETIRED_PLOT
WHERE p.MEAS_YEAR = 2024 
  AND p.PLOT_STATUS_CD = 1;

_______________________________________

___	Q3_3_REF_ESPECIES

-- *Purpose: Aggregation and calculation of forest metrics*


__  


SELECT 
    p.PLOTID,
    p.STATECD,
    p.UNITCD,
    p.COUNTYCD,
    COUNT(t.TREE) AS TOTAL_ARBOLES,
    SUM(t.DRYBIO_AG) AS SUM_BIOMASA_AG,
    SUM(t.CARBON_AG) AS SUM_CARBONO_AG,
    AVG(t.DIA) AS DIAMETRO_PROMEDIO
FROM ID_PLOT AS p
INNER JOIN ID_TREE AS t 
    ON t.PLOTID = p.PLOTID 
   AND t.VISIT_NBR = p.VISIT_NBR 
   AND t.STATECD = p.STATECD 
   AND t.UNITCD = p.UNITCD 
   AND t.COUNTYCD = p.COUNTYCD 
   AND t.RETIRED_PLOT = p.RETIRED_PLOT
WHERE p.MEAS_YEAR = 2024 
  AND p.PLOT_STATUS_CD = 1
GROUP BY 
    p.PLOTID,
    p.STATECD,
    p.UNITCD,
    p.COUNTYCD;

___________________________________________

___	Q4_4_ANALISIS_PARCELA

-- *Purpose: Taxonomic enrichment and species catalog join*


SELECT 
    t.PLOTID,
    t.VISIT_NBR,
    t.TREE,
    t.SPCD,
    s.COMMON_NAME,
    s.GENUS,
    s.SPECIES AS SCIENTIFIC_NAME,
    t.DIA,
    t.TOTAL_LENGTH,
    t.DRYBIO_AG,
    t.CARBON_AG
FROM ID_TREE AS t
INNER JOIN REF_SPECIES AS s 
    ON t.SPCD = s.SPCD
WHERE t.PLOTID IN (
    SELECT PLOTID 
    FROM ID_PLOT 
    WHERE MEAS_YEAR = 2024 
      AND PLOT_STATUS_CD = 1

_______________________________________________

___	**Q5_5_RESUMEN_ESPECIE**

-- *Purpose: Forest stock calculation*


SELECT 
    t.SPCD,
    s.GENUS,
    s.SPECIES AS SCIENTIFIC_NAME,
    COUNT(t.TREE) AS TOTAL_INDIVIDUOS,
    ROUND(AVG(t.DIA), 2) AS DIAMETRO_PROMEDIO_CM,
    ROUND(SUM(t.DRYBIO_AG), 2) AS TOTAL_BIOMASA_AG,
    ROUND(SUM(t.CARBON_AG), 2) AS TOTAL_CARBONO_AG
FROM ID_TREE AS t
INNER JOIN REF_SPECIES AS s 
    ON t.SPCD = s.SPCD
WHERE t.PLOTID IN (
    SELECT PLOTID 
    FROM ID_PLOT 
    WHERE MEAS_YEAR = 2024 
      AND PLOT_STATUS_CD = 1
)
GROUP BY 
    t.SPCD,
    s.GENUS,
    s.SPECIES
ORDER BY TOTAL_INDIVIDUOS DESC;

___________________________________________

___**Q6_VALIDACION_DATOS**

-- *Purpose: Results validation and quality control*




SELECT 
    COUNT(DISTINCT p.PLOTID) AS TOTAL_PARCELAS_VALIDADAS,
    COUNT(t.TREE) AS TOTAL_ARBOLES_REGISTRADOS,
    SUM(CASE WHEN t.STATUSCD = 1 THEN 1 ELSE 0 END) AS ARBOLES_VIVOS,
    SUM(CASE WHEN t.STATUSCD != 1 THEN 1 ELSE 0 END) AS ARBOLES_NO_VIVOS,
    ROUND(SUM(t.CARBON_AG), 2) AS CARBONO_TOTAL_VERIFICADO
FROM ID_PLOT AS p
LEFT JOIN ID_TREE AS t 
    ON t.PLOTID = p.PLOTID 
   AND t.VISIT_NBR = p.VISIT_NBR 
WHERE p.MEAS_YEAR = 2024 
  AND p.PLOT_STATUS_CD = 1;