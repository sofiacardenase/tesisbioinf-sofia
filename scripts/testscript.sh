
#!/usr/bin/env bash
# Pipeline Immcantation con rutas relativas
# Estructura del proyecto: gitsofia/tesisbioinf-sofia/...

#Descargar base de datos Immcantation carpeta share, descargar igblast
#Construir la base de datos de IgBLAST a partir de las secuencias de referencia de IMGT
#Generar secuencias simuladas en R sea partir de codigoimmunesimR y comenzar los analisis de alineamiento, clustering y métricas.
#Activar entorno 
mamba activate immunesim_env

# 1. Detectar la carpeta donde está este script
BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# 2. Activar el entorno (debe existir en cada equipo)
mamba activate immunesim_env

# 3. Instalar Change-O si no está (opcional, solo una vez)
mamba install -c bioconda changeo -y

# 4. Variables de rutas según la nueva organización
INPUT_FASTA="$BASE_DIR/../data/input/repertorio_A_insilico_10_seqs.fasta"
IGBLAST_DB="$BASE_DIR/../share/igblast"
GERMLINE_DIR="$BASE_DIR/../share/germlines/human"

# 5. Asignar genes con IgBLAST
AssignGenes.py igblast \
  -s "$INPUT_FASTA" \
  -b "$IGBLAST_DB" \
  --organism human --loci ig --format blast

# 6. Crear base de datos con MakeDb
MakeDb.py igblast \
  -i "repertorio_A_insilico_10_seqs.fmt7" \
  -s "$INPUT_FASTA" \
  -r "$GERMLINE_DIR/IMGT_Human_IGHV.fasta" \
     "$GERMLINE_DIR/IMGT_Human_IGHD.fasta" \
     "$GERMLINE_DIR/IMGT_Human_IGHJ.fasta" \
  --extended

# 7. Clustering de clones
DefineClones.py \
  -d "repertorio_A_insilico_10_seqs_db-pass.tsv" \
  --act set --model ham --norm len --dist 0.16

#FASTA → AssignGenes → .fmt7 → MakeDb → _db-pass.tsv → DefineClones → _clone-pass.tsv
#Para correr este script con bash testscript.sh en terminal
