# Análisis de repertorios BCR simulados

Este repositorio contiene los notebooks, scripts y resultados del proyecto de simulación y análisis de repertorios de receptores de células B (BCR), utilizando `immuneSIM` y herramientas del framework `Immcantation`.

El objetivo es caracterizar la arquitectura de los repertorios de inmunoglobulinas bajo distintos escenarios biológicos simulados y evaluar cómo la profundidad de secuenciación y los métodos de agrupamiento clonal influyen en las métricas de diversidad, la hipermutación somática (SHM) y la expansión clonal.

## Diseño de las simulaciones

Se generaron cinco escenarios biológicos mediante `immuneSIM`, cada uno evaluado a once profundidades de secuenciación, desde 100 hasta 102.400 secuencias.

Los escenarios se definieron mediante diferentes distribuciones clonales y modelos de hipermutación somática:

| Escenario | Contexto biológico | Distribución clonal | Modelo SHM |
|---|---|---|---|
| A | Control | `equal_cc = TRUE` | `none` |
| B | Naïve | α = 3,0 | `none` |
| C | Sangre periférica | α = 2,0 | `data` |
| D | Folicular | α = 1,5 | `motif` |
| E | Extrafolicular | α = 2,5 | `poisson` |

Las profundidades de secuenciación evaluadas fueron:

`100`, `200`, `400`, `800`, `1.600`, `3.200`, `6.400`, `12.800`, `25.600`, `51.200` y `102.400` secuencias.

En total, el diseño contempla 55 combinaciones de escenario y profundidad de secuenciación.

### Estrategias de análisis clonal

Se utilizaron dos estrategias para estudiar la estructura clonal de los repertorios.

**1. Agrupamiento clonal mediante Change-O**

Las secuencias simuladas se procesaron mediante herramientas de `Immcantation`, incluyendo `IgBLAST`, `MakeDb`, `SHazaM` y `DefineClones` de `Change-O`.

Esta estrategia permite reconstruir los grupos clonales a partir de las secuencias anotadas y calcular métricas de diversidad basadas en las asignaciones obtenidas mediante el pipeline.

**2. Ground truth de immuneSIM**

Se utilizaron las asignaciones clonales originales generadas durante la simulación como referencia (*ground truth*).

Esta estrategia permite calcular métricas de diversidad a partir de la estructura clonal conocida de los repertorios simulados, sin depender de la reconstrucción realizada mediante `DefineClones`.

La comparación entre ambas estrategias permite evaluar las diferencias entre las asignaciones clonales originales y las recuperadas mediante Change-O.

### Downsampling

Se realizó un procedimiento de *downsampling* a partir de los repertorios de 102.400 secuencias de cada escenario.

El objetivo es evaluar cómo la reducción de la profundidad de secuenciación afecta la recuperación de la estructura clonal y las métricas de diversidad, SHM y expansión clonal.

Este procedimiento permite comparar repertorios derivados de una misma simulación de alta profundidad, utilizando distintos tamaños de muestra.

### Simulación complementaria de SHM para el escenario D

Durante la simulación del escenario D (folicular), el modelo `motif` de `immuneSIM` presentó dificultades para generar el patrón de mutaciones esperado.

Por este motivo, se incorporó un paso adicional mediante `shmulateSeq`, utilizando una estrategia alternativa de generación de mutaciones para obtener secuencias con hipermutación somática y continuar con los análisis posteriores.

Este procedimiento se documenta en el notebook 2.2 y debe distinguirse de la simulación original de los cinco escenarios.

## Pipeline general

El flujo de trabajo contempla las siguientes etapas:

1. Simulación de repertorios mediante `immuneSIM`.
2. Procesamiento y anotación de secuencias mediante `IgBLAST` y `MakeDb`.
3. Evaluación de umbrales de agrupamiento mediante `SHazaM`.
4. Asignación y agrupamiento clonal mediante `DefineClones` de `Change-O`.
5. Obtención de las asignaciones clonales originales de `immuneSIM` (*ground truth*).
6. Cálculo de métricas de diversidad para ambas estrategias.
7. Integración de resultados en matrices para su comparación.
8. Análisis de la estructura clonal, SHM, targeting y baseline.
9. Downsampling de los repertorios de mayor profundidad.
10. Análisis estadísticos comparativos entre escenarios y profundidades.

## Organización de los notebooks

Los notebooks se encuentran en la carpeta [`notebooks/`](https://github.com/sofiacardenase/tesisbioinf-sofia/tree/main/notebooks) y están organizados según las distintas etapas del proyecto.

| Notebook | Contenido |
|---|---|
| **1. Simulación y procesamiento con Change-O** | Generación de repertorios y procesamiento de las secuencias para su anotación y posterior asignación clonal mediante el pipeline de `Immcantation` y `Change-O`. |
| **2. Análisis con GrowthThroughP** | Análisis de la estructura y el crecimiento clonal mediante `GrowthThroughP`. |
| **2.1. Cálculo de umbrales con SHazaM** | Evaluación y determinación de los umbrales utilizados para el agrupamiento clonal. |
| **2.2. Simulación complementaria de SHM** | Debido a las dificultades observadas con el modelo `motif` de `immuneSIM` en el escenario D (folicular), se incorporó un paso adicional con `shmulateSeq` para generar mutaciones de forma alternativa y obtener secuencias con SHM para los análisis posteriores. |
| **3. Métricas de diversidad: Change-O** | Cálculo de métricas de diversidad a partir de las asignaciones clonales obtenidas mediante `Change-O`. |
| **4. Métricas de diversidad: ground truth** | Cálculo de métricas de diversidad utilizando las asignaciones clonales originales de `immuneSIM`. |
| **5. Matriz consolidada de diversidad: Change-O** | Integración y concatenación de los resultados de diversidad para los diferentes escenarios y niveles de profundidad analizados mediante `Change-O`. |
| **6. Matriz consolidada de diversidad: ground truth** | Integración de las métricas de diversidad calculadas a partir de las asignaciones clonales originales de `immuneSIM`. |
| **7. Análisis de agrupamiento clonal** | Evaluación de la distribución y recuperación de los grupos clonales en los repertorios analizados. |
| **7.2. Visualización de la estructura clonal** | Generación de gráficos para explorar y comparar la estructura y distribución de los clones. |
| **8. Análisis general de mutaciones SHM** | Análisis de las mutaciones asociadas a la hipermutación somática en los repertorios simulados. |
| **9. Análisis de targeting de SHM** | Evaluación de los patrones de direccionamiento de las mutaciones y su distribución en las secuencias. |
| **10. Análisis de baseline de SHM** | Análisis del baseline utilizado como referencia para estudiar los patrones de mutación somática. |
| **11. Downsampling** | Implementación del procedimiento de reducción de profundidad a partir de repertorios de 102.400 secuencias y organización de los datos resultantes. |
| **12. Análisis estadísticos** | Análisis estadístico comparativo de las métricas y resultados obtenidos entre escenarios, profundidades y estrategias de agrupamiento. |

*Nota: los títulos de esta tabla describen el contenido de los notebooks y pueden ajustarse a los nombres reales de los archivos.*

## Estructura del repositorio

```text
tesisbioinf-sofia/
├── notebooks/
│   ├── 1. Simulación y procesamiento con Change-O
│   ├── 2. Análisis con GrowthThroughP
│   ├── 2.1. Cálculo de umbrales con SHazaM
│   ├── 2.2. Simulación complementaria de SHM
│   ├── 3. Métricas de diversidad: Change-O
│   ├── 4. Métricas de diversidad: ground truth
│   ├── 5. Matriz de diversidad: Change-O
│   ├── 6. Matriz de diversidad: ground truth
│   ├── 7. Análisis de agrupamiento clonal
│   ├── 7.2. Visualización de la estructura clonal
│   ├── 8. Análisis general de mutaciones SHM
│   ├── 9. Análisis de targeting de SHM
│   ├── 10. Análisis de baseline de SHM
│   ├── 11. Downsampling
│   └── 12. Análisis estadísticos
├── scripts/
│   └── Scripts auxiliares para procesamiento y análisis
├── testscript.sh
│   └── Automatización de pasos de asignación y clustering clonal
├── results/
│   └── Figuras y tablas generadas durante los análisis
├── share/
│   └── Archivos y recursos compartidos del proyecto
├── Tabla parametros escenarios.xlsx
├── renv.lock
├── README.md
└── .gitignore
```

La estructura anterior es esquemática. Los nombres y la ubicación de los archivos deben corresponder a los que existen realmente en el repositorio.

## Requisitos y herramientas

El proyecto utiliza R, Python y Jupyter Notebook, junto con las siguientes herramientas y paquetes:

- **immuneSIM:** simulación de repertorios de células B.
- **Immcantation:** framework para el procesamiento y análisis de repertorios inmunológicos.
- **IgBLAST:** anotación de secuencias de inmunoglobulinas.
- **MakeDb:** construcción de bases de datos a partir de las anotaciones.
- **Change-O:** asignación y agrupamiento clonal mediante `DefineClones`.
- **SHazaM:** análisis de repertorios y evaluación de umbrales de agrupamiento.
- **shmulateSeq:** generación de secuencias con hipermutación somática.
- **Alakazam:** análisis de repertorios y cálculo de métricas de diversidad.
- **Polars:** manipulación de datos tabulares.
- **Bash:** automatización de procesos mediante scripts como `testscript.sh`.
- **renv:** gestión de las dependencias y versiones de paquetes de R.

Las versiones de los paquetes de R se registran en `renv.lock`. Las dependencias de Python y las herramientas externas pueden requerir configuraciones adicionales.

## Reproducibilidad

Los análisis están organizados en notebooks de Jupyter, scripts y archivos auxiliares. Se recomienda seguir las etapas descritas en este README, respetando las dependencias entre los archivos de entrada y los resultados generados.

### Entorno de R

El archivo `renv.lock` registra las versiones de los paquetes de R utilizados en el proyecto y permite reconstruir el entorno de dependencias.

Para restaurar las dependencias registradas, se puede utilizar:

```r
install.packages("renv")
renv::restore()
```

La restauración requiere que las dependencias estén disponibles en los repositorios correspondientes y puede depender de la versión de R y del sistema operativo.

### Parámetros y resultados

Los parámetros de simulación se documentan en `Tabla parametros escenarios.xlsx`. Los archivos de entrada, matrices consolidadas, figuras y tablas se organizan en las carpetas correspondientes.

El script `testscript.sh` contiene los pasos de automatización asociados a la asignación y el clustering clonal. Su ejecución puede requerir que las herramientas externas y las rutas de los archivos estén configuradas correctamente.

## Estado del proyecto

### Completado

- [x] Diseño de cinco escenarios biológicos.
- [x] Definición de los parámetros de simulación.
- [x] Simulación de repertorios a once profundidades de secuenciación.
- [x] Procesamiento y anotación de secuencias.
- [x] Agrupamiento clonal mediante Change-O.
- [x] Obtención y análisis de las asignaciones clonales de referencia (*ground truth*).
- [x] Cálculo de métricas de diversidad para ambas estrategias.
- [x] Construcción de matrices consolidadas de diversidad.
- [x] Desarrollo de análisis de targeting de SHM.
- [x] Implementación del procedimiento de downsampling.
- [x] Generación de figuras y tablas preliminares.

### En desarrollo

- [ ] Evaluación y resolución de las dificultades del modelo de SHM del escenario D.
- [ ] Consolidación del análisis general de mutaciones SHM.
- [ ] Análisis del baseline de SHM.
- [ ] Análisis de expansión clonal.
- [ ] Consolidación de los análisis estadísticos comparativos.
- [ ] Definición de la estrategia final de comparación entre escenarios y profundidades.
- [ ] Incorporación y análisis de datos reales.
- [ ] Selección y ajuste de las figuras finales.
- [ ] Revisión y consolidación de los resultados para la tesis.

## Objetivo final

Caracterizar cómo la distribución clonal, la hipermutación somática y la profundidad de secuenciación influyen en la arquitectura de los repertorios BCR simulados. Para ello, se comparan las asignaciones clonales originales de `immuneSIM` con las obtenidas mediante `Change-O`, evaluando las implicaciones para las métricas de diversidad, la estructura clonal, los patrones de SHM y la expansión de clones.
