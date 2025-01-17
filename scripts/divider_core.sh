#!/bin/bash

SCRIPT_DIR=$(cd $(dirname $0); pwd)
DIV_DIR=${SCRIPT_DIR%/*}
SRC_DIR=${DIV_DIR%/*}
BASE_DIR=${SRC_DIR%/*}

PCD_DIV=$BASE_DIR"/../install/pointcloud_divider/lib/pointcloud_divider/pointcloud_divider_node"

# Show usage
function usage() {
cat <<_EOT_
Usage:
  $0 <PCD_0> ... <PCD_N> <OUTPUT_PCD_DIR> <PREFIX> <CONFIG_FILE>

Description:
  Dividing and downsampling PCD files into XY 2D rectangle grids.

Options:
  None

_EOT_
}

# Parse options
if [ "$OPTIND" = 1 ]; then
  while getopts h OPT
  do
    case $OPT in
      h)
        usage
        exit 0 ;;
      \?)
        echo "Undefined option $OPT"
        usage
        exit 1 ;;
    esac
  done
else
  echo "No installed getopts-command." 1>&2
  exit 1
fi
shift $(($OPTIND - 1))

# Input arguments
ARGC=$#
ARGV=("$@")

# Total number of input ROSBAGs
N_PCD=$(($ARGC-3))

# Prepare ROSBAG names
PCD_FILES=""
for (( i=0; i<N_PCD; i++ ))
do
  PCD_FILES+="${ARGV[i]}"" "
done
# Remove trailing space if any
PCD_FILES="$(echo -e "${PCD_FILES}" | sed -e 's/[[:space:]]*$//')"

OUTPUT_DIR=${ARGV[$(($ARGC-3))]}"/"
PREFIX=${ARGV[$(($ARGC-2))]}
CONFIG_FILE=${ARGV[$(($ARGC-1))]}

$PCD_DIV $N_PCD $PCD_FILES $OUTPUT_DIR $PREFIX $CONFIG_FILE
