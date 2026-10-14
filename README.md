# Simulación y análisis de repertorios de receptores B

## Descripción del proyecto

Este repositorio contiene el código desarrollado para mi tesis, centrada en la simulación y el análisis de repertorios de receptores de células B (BCR). El objetivo es evaluar cómo diferentes escenarios biológicos y profundidades de secuenciación afectan la caracterización de la diversidad, la expansión clonal y la hipermutación somática (SHM).

Los repertorios se simularon utilizando el paquete **immuneSIM** en R. Posteriormente, se analizaron mediante dos estrategias de asignación clonal: las asignaciones originales de immuneSIM, utilizadas como referencia (*ground truth*), y la estrategia basada en Change-O.

## Escenarios de simulación

Se definieron cinco escenarios para representar diferentes distribuciones clonales y modelos de hipermutación somática.

| Escenario | Descripción | Parámetros principales | Modelo SHM |
|---|---|---|---|
| A | Control | `equal_cc = TRUE` | `none` |
| B | Naïve | `alpha = 3.0` | `none` |
| C | Sangre periférica | `alpha = 2.0` | `data` |
| D | Folicular | `alpha = 1.5` | `motif` |
| E | Extrafolicular | `alpha = 2.5` | `poisson` |

Los repertorios se simularon con profundidades de secuenciación entre **100 y 102.400 secuencias**. Para evaluar el efecto de la profundidad, se realizaron procedimientos de *downsampling* a partir de los repertorios de mayor tamaño.

## Metodología

### 1. Simulación de repertorios

Se generaron repertorios BCR utilizando immuneSIM, definiendo los escenarios biológicos, las distribuciones clonales, los modelos de SHM y las profundidades de secuenciación.

### 2. Asignación clonal

Se compararon dos estrategias:

- **Change-O:** asignación de clones mediante un flujo de trabajo que incluye IgBLAST, MakeDb, cálculo de umbrales de distancia con SHazaM y definición de clones con DefineClones.
- **immuneSIM:** utilización de las asignaciones clonales originales generadas durante la simulación, como referencia (*ground truth*).

### 3. Análisis de diversidad

Se calcularon métricas de diversidad para evaluar la riqueza y la distribución de las secuencias y clones. Los resultados se organizaron en matrices para comparar escenarios, profundidades y estrategias de asignación clonal.

### 4. Expansión clonal

Se evaluó la distribución de los tamaños clonales, la proporción de secuencias únicas y la contribución de los clones más abundantes en cada escenario.

### 5. Hipermutación somática

Se analizaron los modelos de mutación, las tablas de mutaciones, los patrones de direccionamiento de SHM y los niveles basales de mutación.

### 6. Downsampling

Se evaluó cómo la reducción del número de secuencias afecta las métricas de diversidad y la caracterización de los repertorios.

### 7. Correlaciones

Se analizaron las relaciones entre métricas para explorar sus asociaciones y comparar los resultados obtenidos en los distintos escenarios y profundidades.

## Estructura del repositorio


tesisbioinf-sofia/
├── notebooks/
│   ├── 1-simulation_immunesimR_A.ipynb
│   ├── 1.1-plots_simulados.ipynb
│   ├── 2-similation_immunesimR_B.ipynb
│   ├── 2.1-threshold_calculation.ipynb
│   ├── 2.2-shmulatedSeq.ipynb
│   ├── 3-diversity_metrics_A_changeo.ipynb
│   ├── 3.1-plots_diversity.ipynb
│   ├── 4-diversity_metrics_B_immunesim.ipynb
│   ├── 5-matrix_diversity_A+downsampling.ipynb
│   ├── 6-matrix_diversity_B_immunesim.ipynb
│   ├── 7-expansion.ipynb
│   ├── 7.1-clonal_tableA.ipynb
│   ├── 7.2-clonal_plotA.ipynb
│   ├── 8-shm_models_mutation_table.ipynb
│   ├── 9-shm_targeting.ipynb
│   ├── 9.1-shm_targeting_models_plot.ipynb
│   ├── 10-shm_baseline.ipynb
│   ├── 11-downsampling.ipynb
│   └── 12-correlation.ipynb
├── scripts/
├── testscript.sh
├── share/
├── renv/
├── .Rprofile
├── renv.lock
├── Tabla parametros escenarios.xlsx
├── README.md
└── .gitignore


## Tecnologías y herramientas

- **R:** simulación y análisis de repertorios.
- **immuneSIM:** generación de repertorios BCR simulados.
- **Change-O:** procesamiento y asignación clonal.
- **IgBLAST:** alineamiento de secuencias frente a segmentos de referencia.
- **SHazaM:** análisis de repertorios y cálculo de umbrales de distancia.
- **Jupyter Notebook:** organización y ejecución del análisis.
- **renv:** gestión y reproducibilidad del entorno de paquetes de R.

## Reproducibilidad

El proyecto utiliza `renv` para registrar las dependencias de R. El archivo `renv.lock` contiene las versiones registradas de los paquetes, mientras que `.Rprofile` permite activar el entorno del proyecto.

Para restaurar las dependencias en un entorno compatible, abre R desde el directorio del proyecto y ejecuta:


install.packages("renv")
renv::restore()


Algunos pasos del análisis pueden requerir herramientas externas, como IgBLAST, y que las rutas y dependencias correspondientes estén configuradas correctamente.

## Objetivo general

Evaluar cómo los escenarios biológicos simulados, la profundidad de secuenciación y la estrategia de asignación clonal influyen en las métricas utilizadas para caracterizar repertorios BCR, considerando la diversidad, la expansión clonal y la hipermutación somática.
