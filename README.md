
<img width="1625" height="672" alt="image" src="https://github.com/user-attachments/assets/9f0275d2-176a-4139-9b0e-3e5089ace183" />

Inventario Forestal y Análisis de Carbono | Urban FIADB 2024

**Forest Inventory / Carbon Accounting / SQL / SQLite / Data Analysis**

##Descripción del proyecto

Este proyecto consiste en el procesamiento y análisis de datos de inventario forestal mediante SQL y hojas de cálculo, utilizando la base de datos **Urban Forest Inventory and Analysis Database (Urban FIADB)** del USDA Forest Service.

El objetivo fue cuantificar biomasa aérea, carbono y dióxido de carbono equivalente (CO₂e) para el año de medición 2024, realizando análisis por parcela y especie.

El trabajo se desarrolló como el **Ejercicio 1 de un caso práctico de SQL forestal y carbono**, adaptando las consultas a la estructura y los campos disponibles en la base Urban FIADB.

## Objetivos

- Consultar y relacionar tablas de un inventario forestal relacional.
- Extraer registros de árboles asociados a parcelas clasificadas como bosque muestreado.
- Transformar variables dasométricas y de biomasa al Sistema Internacional.
- Calcular biomasa aérea, carbono y CO₂ equivalente.
- Analizar resultados por parcela y especie.
- Aplicar controles de integridad, consistencia y datos faltantes.
- Documentar consultas SQL, fórmulas y limitaciones metodológicas.

## Fuente de datos

**USDA Forest Service – Urban Forest Inventory and Analysis Database (Urban FIADB).**

Tablas utilizadas:

- `ID_PLOT`: información y estado de las parcelas y visitas.
- `ID_TREE`: mediciones y atributos individuales de los árboles.
- `REF_SPECIES`: catálogo taxonómico y parámetros de referencia de especies.

Fuentes oficiales:

- [Urban DataMart – USDA Forest Service](https://research.fs.usda.gov/products/dataandtools/urban-datamart)
- [Urban FIADB Database Description – Version 9.0 (2024)](https://research.fs.usda.gov/sites/default/files/2024-10/wo-v9-0_sept2024_ug_urbanfiadb_database_description.pdf)

La base SQLite original no se incluye en el repositorio. El libro de trabajo contiene la extracción filtrada de 5.131 registros utilizada en el análisis.

## Alcance y criterios de selección

El análisis se delimitó al año de medición 2024, mediante los siguientes filtros:

- `MEAS_YEAR = 2024`
- `PLOT_STATUS_CD = 1` (*Sampled: Forest*).

La relación entre `ID_PLOT` e `ID_TREE` se realizó mediante las claves `PLOTID`, `VISIT_NBR`, `STATECD`, `UNITCD`, `COUNTYCD` y `RETIRED_PLOT`.

La relación con `REF_SPECIES` se realizó mediante `SPCD`.

## Resultados principales

| Indicador | Resultado |
|---|---:|
| PLOTID seleccionados | 181 |
| Parcelas con registros de árboles | 179 |
| Registros de árboles analizados | 5.131 |
| Especies presentes en la muestra | 137 |
| Registros con biomasa y carbono disponibles | 4.537 |
| Registros con valores faltantes | 594 |
| Combinaciones parcela–especie | 987 |

### Resultados de biomasa y carbono

El método principal sigue el factor fijo de 0,47 indicado en el ejercicio:

| Indicador | Resultado |
|---|---:|
| Biomasa aérea de muestra | 1.880,041 t |
| Carbono calculado (factor 0,47) | 883,619 t C |
| CO₂ equivalente | 3.239,938 t CO₂e |

También se realizó una comparación independiente utilizando el campo `CARBON_AG` nativo de FIADB:

| Indicador | Resultado |
|---|---:|
| Carbono aéreo FIADB | 893,642 t C |
| CO₂ equivalente FIADB | 3.276,688 t CO₂e |

Los dos métodos se presentan por separado, sin aplicar el factor 0,47 nuevamente al campo `CARBON_AG`.

### Análisis de densidad

Se calcularon indicadores de biomasa, carbono y CO₂ equivalente por hectárea para cada combinación `PLOTID + SPCD`, utilizando `TPA_UNADJ` y conversiones de acres a hectáreas.

Los resultados se identifican como **densidades sin ajuste de estrato**. No deben interpretarse como estimaciones poblacionales definitivas del carbono forestal.

## Metodología y transformaciones

Las principales conversiones aplicadas fueron:

| Variable | Transformación |
|---|---|
| Diámetro | Pulgadas a centímetros (× 2,54) |
| Longitud total | Pies a metros (× 0,3048) |
| Biomasa aérea | Libras a kilogramos (× 0,45359237) |
| Carbono aéreo | Libras de C a kilogramos de C (× 0,45359237) |
| Densidad de árboles | Árboles/acre a árboles/hectárea (× 2,47105) |
| Carbono a CO₂ equivalente | t C × 44/12 |

Los valores faltantes se conservaron como NULL y no fueron imputados ni reemplazados por cero.

## Estructura del entregable

El archivo Excel contiene nueve pestañas:

1. `1_RAW_SQL`: extracción original de registros de árboles.
2. `2_TRANSFORMACIONES`: conversión de variables al Sistema Internacional.
3. `3_REF_ESPECIES`: catálogo de referencia taxonómica.
4. `4_ANALISIS_PARCELA`: resultados agrupados por parcela y especie.
5. `5_RESUMEN_PARCELA`: agregación de indicadores por parcela.
6. `6_RESUMEN_ESPECIE`: agregación de resultados por especie.
7. `7_DASHBOARD_RESULTADOS`: indicadores y visualizaciones principales.
8. `8_METODOLOGIA`: procedimiento, criterios, validaciones y limitaciones.
9. `9_CONSULTAS_SQL`: registro de consultas y procedimientos Q01–Q06.

## Herramientas utilizadas

- **SQLite:** consulta y gestión de datos relacionales.
- **DBeaver:** ejecución y validación de consultas SQL.
- **Google Sheets / Microsoft Excel:** transformaciones, agregaciones, controles y dashboard.
- **SQL:** `SELECT`, `INNER JOIN`, `WHERE`, `GROUP BY`, `COUNT`, `SUM`, `DISTINCT`, `CASE`, `CTE` y funciones de conversión.

## Control de calidad y reproducibilidad

Se realizaron controles sobre:

- Correspondencia entre registros originales y transformados.
- Integridad de las claves compuestas de árbol.
- Conteo de parcelas y especies.
- Identificación de valores faltantes.
- Consistencia de sumas de biomasa, carbono y CO₂e.
- Correspondencia entre consultas SQL y tablas de resultados.

Las consultas principales y sus criterios se encuentran documentados en `8_CONSULTAS_SQL`.

Para reproducir la extracción original es necesario disponer de una versión compatible de Urban FIADB y ejecutar las consultas sobre las tablas correspondientes. Las actualizaciones posteriores de la base podrían producir diferencias en los resultados.

## Alcance y limitaciones

Este proyecto representa un análisis descriptivo de los registros disponibles para el año 2024.

Las sumas de biomasa, carbono y CO₂ equivalente corresponden a los valores individuales disponibles en los registros seleccionados. No representan por sí solas el stock total de carbono de todos los bosques de la población.

Los indicadores por hectárea utilizan `TPA_UNADJ`, sin ajustes adicionales de estrato/subparcela. Por tanto, se presentan como densidades sin ajuste de estrato y no como estimaciones poblacionales definitivas.

El análisis considera biomasa y carbono de madera y corteza de la parte aérea; no incluye raíces, suelo, hojarasca ni otros reservorios.

## Competencias demostradas

- Análisis de bases de datos forestales relacionales.
- Consulta y transformación de datos mediante SQL.
- Interpretación de variables dasométricas y de biomasa.
- Cuantificación de carbono forestal y CO₂ equivalente.
- Integración de información taxonómica.
- Control de calidad y tratamiento de valores faltantes.
- Documentación de procedimientos y limitaciones metodológicas.
- Visualización y comunicación de resultados ambientales.

**Proyecto de portfolio profesional · Ingeniería Forestal y Análisis de Datos Ambientales**


# forest-carbon-analysis
Forest carbon data analysis using SQL and spreadsheet-based reporting.
