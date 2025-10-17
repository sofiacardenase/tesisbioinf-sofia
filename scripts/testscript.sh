
#!/usr/bin/env bash
# Pipeline Immcantation con rutas relativas
# Descripción general:
# Este script ejecuta un flujo completo de análisis del repertorio
# inmunológico utilizando el framework Immcantation, incluyendo el paquete Change-O. 
# Está diseñado para trabajar con secuencias simuladas o reales
# de linfocitos B (archivo FASTA de entrada), realizando los pasos:
#
#   1️ Asignación de genes V(D)J mediante IgBLAST.
#   2️ Construcción de la base de datos de alineamientos con MakeDb.
#   3️ Definición y agrupamiento de clones con DefineClones.

# Estructura del proyecto: gitsofia/tesisbioinf-sofia/...
# Descargar base de datos Immcantation carpeta share, descargar igblast
# Construir la base de datos de IgBLAST a partir de las secuencias de referencia de IMGT
# Generar secuencias simuladas en R sea partir de codigoimmunesimR y comenzar los analisis de alineamiento, clustering y métricas.

set -e  # Detener el script si ocurre algún error

echo " Iniciando pipeline Immcantation..."

# 1️ Detectar carpeta raíz del proyecto
BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/.."

# 2️ Definir carpetas de entrada, salida y recursos
INPUT_DIR="$BASE_DIR/data/input"
OUTPUT_DIR="$BASE_DIR/data/output"
SHARE_DIR="$BASE_DIR/share"
GERMLINE_DIR="$SHARE_DIR/germlines/imgt/human/vdj"

# 3 Crear carpeta de salida si no existe
#mkdir -p "$OUTPUT_DIR"
#Instalar Change-O si no está
#if ! command -v AssignGenes.py &> /dev/null; then
#  echo "Change-O no encontrado, instalando vía mamba..."
# mamba install -c bioconda changeo -y

# 4️ Archivos de entrada y salida
INPUT_FASTA="$INPUT_DIR/repertorio_A_insilico_10_seqs.fasta"
FMT7_OUT="$OUTPUT_DIR/repertorio_A_insilico_10_seqs_igblast.fmt7"
DB_OUT="$OUTPUT_DIR/repertorio_A_insilico_10_seqs_db-pass.tsv"
CLONE_OUT="$OUTPUT_DIR/repertorio_A_insilico_10_seqs_clone-pass.tsv"

# 5️ Verificar que el archivo FASTA exista
if [ ! -f "$INPUT_FASTA" ]; then
  echo " ERROR: No se encontró el archivo de entrada: $INPUT_FASTA"
  exit 1
fi
echo " Archivo de entrada detectado: $INPUT_FASTA"

# 6️ Asignación de genes con IgBLAST
echo " Ejecutando AssignGenes.py..."
AssignGenes.py igblast \
  -s "$INPUT_FASTA" \
  -b "$SHARE_DIR/igblast" \
  --organism human --loci ig --format blast \
  -o "$FMT7_OUT"

# Verificar que el archivo .fmt7 se creó correctamente
if [ ! -s "$FMT7_OUT" ]; then
  echo " ERROR: AssignGenes.py no generó el archivo .fmt7"
  exit 1
fi
echo " AssignGenes.py completado: $FMT7_OUT"

# 7️ Creación de la base de datos de alineamientos con MakeDb
echo " Ejecutando MakeDb.py..."
MakeDb.py igblast \
  -i "$FMT7_OUT" \
  -s "$INPUT_FASTA" \
  -r "$GERMLINE_DIR" \
  --extended \
  -o "$DB_OUT"



# Verificar que el archivo _db-pass.tsv se creó correctamente
if [ ! -s "$DB_OUT" ]; then
  echo " ERROR: MakeDb.py no generó el archivo _db-pass.tsv. Revisa el contenido de $FMT7_OUT"
  exit 1
fi
echo " MakeDb.py completado: $DB_OUT"

# 8️ Agrupamiento de clones con DefineClones
echo " Ejecutando DefineClones.py..."
DefineClones.py \
  -d "$DB_OUT" \
  --act set --model ham --norm len --dist 0.16 \
  -o "$CLONE_OUT"

# Verificar que el archivo _clone-pass.tsv se creó correctamente
if [ ! -s "$CLONE_OUT" ]; then
  echo " ERROR: DefineClones.py no generó el archivo _clone-pass.tsv"
  exit 1
fi

#  Finalización
echo " Pipeline completado correctamente."
echo " Archivos generados:"
echo "   - IgBLAST output:    $FMT7_OUT"
echo "   - Base de datos:     $DB_OUT"
echo "   - Clones definidos:  $CLONE_OUT"
echo "============================================================"

# FAStA → AssignGenes → .fmt7 → MakeDb → _db-pass.tsv → DefineClones → _clone-pass.tsv
# Para correr este script: bash scripts/testscript.sh desde la raíz del proyecto
