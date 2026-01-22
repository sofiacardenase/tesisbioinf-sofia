#!/usr/bin/env bash
INPUT_FILE=$1
OUTPUT_FILE=$2
echo "$INPUT_FILE"
echo "$OUTPUT_FILE"

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/.."
echo "$BASE_DIR"