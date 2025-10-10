#!/bin/bash
set -euox pipefail

INPUT_FILE=$1
OUTPUT_BASENAME=$2

ffmpeg -i $INPUT_FILE -c:v libvpx-vp9 -b:v 0 -crf 42 -row-mt 1 -vf "scale=550:-2" -deadline best -an -pass 1 -f null /dev/null
ffmpeg -i $INPUT_FILE -c:v libvpx-vp9 -b:v 0 -crf 42 -row-mt 1 -vf "scale=550:-2" -deadline best -an -pass 2 $OUTPUT_BASENAME.webm
ffmpeg -ss 2 -i $INPUT_FILE -vf "scale=550:-2" -frames:v 1 -q:v 2 $OUTPUT_BASENAME.jpg
