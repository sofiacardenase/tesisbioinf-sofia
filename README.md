# Análisis de repertorios BCR simulados

Este repositorio contiene los códigos, notebooks y resultados utilizados para la simulación y análisis de repertorios de células B mediante `immuneSIM` y el framework `Immcantation`.

El proyecto busca caracterizar la arquitectura de los repertorios de inmunoglobulinas bajo distintos escenarios biológicos simulados, evaluando aspectos de diversidad, hipermutación somática (SHM), agrupamiento clonal y expansión clonal.

Los repertorios fueron simulados en cinco escenarios biológicos y once profundidades de secuenciación, desde 100 hasta 102.400 secuencias.


## Diseño de las simulaciones

Se generaron cinco escenarios biológicos de repertorios de células B mediante `immuneSIM`, cada uno simulado a once profundidades de secuenciación: 100, 200, 400, 800, 1.600, 3.200, 6.400, 12.800, 25.600, 51.200 y 102.400 secuencias.

Los escenarios fueron definidos mediante diferentes distribuciones clonales y modelos de hipermutación somática (SHM):

| Escenario | Contexto biológico | Distribución clonal | Modelo SHM |
|-----------|--------------------|---------------------|------------|
| A | Control | `equal_cc = TRUE` | `none` |
| B | Naïve | α = 3.0 | `none` |
| C | Sangre periférica | α = 2.0 | `data` |
| D | Folicular | α = 1.5 | `motif` |
| E | Extrafolicular | α = 2.5 | `poisson` |

En todos los escenarios se utilizó `sequence_similarity = 0` y `vdj_noise = 0`. La primera configuración permite representar cada clon mediante una única secuencia, mientras que la segunda mantiene constantes las frecuencias de uso de los segmentos V, D y J.

## Pipeline de análisis

immuneSIM  
↓  
IgBLAST  
↓  
MakeDb  
↓  
SHazaM  
↓  
DefineClones (Change-O) / GrowthThroughP  
↓  
Análisis de diversidad, SHM y expansión clonal

## Estructura del repositorio

```text
tesisbioinf-sofia/
│
├── notebooks/
│   ├── Simulación de repertorios
│   │   ├── immuneSIM
│   │   └── generación de escenarios A–E
│   │
│   ├── Agrupamiento y estructura clonal
│   │   ├── cálculo de thresholds
│   │   ├── DefineClones (Change-O)
│   │   └── análisis de expansión clonal
│   │
│   ├── Diversidad
│   │   ├── cálculo de métricas
│   │   ├── matrices de diversidad
│   │   └── visualización de resultados
│   │
│   └── SHM
│       ├── modelos de mutación
│       ├── targeting
│       └── baseline
│
├── scripts/
│   └── Scripts auxiliares para procesamiento y análisis
│
├── results/
│   └── Figuras y tablas generadas durante los análisis
│
├── share/
│   └── Archivos y recursos compartidos del proyecto
│
├── Tabla parametros escenarios.xlsx
│   └── Parámetros utilizados para definir los escenarios
│
├── README.md
│   └── Documentación del proyecto
│
└── .gitignore
    └── Archivos excluidos del control de versiones
```

## Requisitos

El análisis fue desarrollado utilizando R y Python, junto con las siguientes herramientas y paquetes:

- R
- Python
- immuneSIM
- Immcantation
- Change-O
- SHazaM
- Alakazam
- Polars
- Jupyter Notebook

Las versiones específicas de los paquetes y dependencias se encuentran en los archivos de configuración correspondientes del repositorio.

## Reproducibilidad

Los análisis se encuentran organizados en notebooks de Jupyter y scripts asociados. Para reproducir el análisis, se recomienda seguir las etapas del pipeline en el orden descrito en este README, comenzando con la generación de los repertorios simulados y continuando con la anotación, agrupamiento clonal y análisis posteriores.

Los archivos de entrada, parámetros de simulación y resultados generados se encuentran organizados en las carpetas correspondientes del repositorio.

## Estado del proyecto

### Completado

- [x] Diseño de los cinco escenarios biológicos.
- [x] Definición de los parámetros de simulación.
- [x] Simulación de los repertorios mediante immuneSIM.
- [x] Procesamiento y anotación de las secuencias.
- [x] Agrupamiento clonal mediante Change-O.
- [x] Cálculo de métricas de diversidad para immuneSIM ground truth y clustering Change-o.
- [x] Desarrollo de los análisis de targeting de SHM.
- [x] Desarrollo de figuras y tablas preliminares.


### En desarrollo


- [ ] Evaluación del problema de targeting en el escenario D (folicular).
- [ ] Análisis de mutaciones genelares de SHM.
- [ ] Análisis del baseline de SHM.
- [ ] Análisis de expansión clonal.
- [ ] Definición de la estrategia final para la comparación entre escenarios.
- [ ] Análisis con datos reales
- [ ] Selección y ajuste de las figuras finales.
- [ ] Revisión y consolidación de los resultados para la tesis.
