#!/bin/bash

# Surya Saha
# Purpose: setup LAS gxpsy in sftp://surya@hlbws.sgn.cornell.edu/var/www/html/jbrowse/JBrowse-1.11.4/data/json/las_gxpsy
# Updated to be path agnostic and use from parameters

set -u #exit if uninit var
set -e #exit if non-zero return value (error), use command || {echo 'command failed'; exit 1;}
set -o nounset
set -o errexit

readonly PROGNAME=$(basename "$0")
readonly PROGDIR=$(readlink -m "$(dirname "$0")")
readonly WDIR=$(pwd)

usage() {
	echo "usage:
	$PROGNAME <jbrowse dir> <LAS gxpsy genome dir>
    
	Example:
	$PROGNAME ARG1 ARG2"
	exit 1
}

if [ "$#" -ne 2 ]
then
	usage
fi

printf "JB  dir: %s \n" "$1"
printf "LAS dir: %s \n" "$2"

JB_DIR="$1"
GENOME_DIR="$2"

printf "Please store the data files in LAS gxpsy dir %s \nCurrent files are.. \n" "$GENOME_DIR"

cd "$GENOME_DIR"
ls -lh

cd "$JB_DIR"
# cleanup
rm -rf data/json/las_gxpsy

# load refs and data source
bin/prepare-refseqs.pl --fasta "${GENOME_DIR}/NC_020549.1.fa" --out data/json/las_gxpsy
printf "[general]\ndataset_id = las_gxpsy\n" > data/json/las_gxpsy/tracks.conf

# create annotation tracks
./bin/flatfile-to-json.pl --gff "${GENOME_DIR}/NC_020549.gbrowse.gff3"  --type gene  --trackLabel gene --key "Genes" --trackType CanvasFeatures --out data/json/las_gxpsy/ --clientConfig '{"label" : "name,id", "color" : "goldenrod" }' --metadata '{"description": "Genes from NCBI Refseq linked to NCBI Protein DB", "category": "Gene models" }' --urltemplate "http://www.ncbi.nlm.nih.gov/protein?term={name}" --config '{"menuTemplate" : [{"label" : "View details",}, {"label" : "Zoom this gene", "iconClass" : "dijitIconConnector"}, {"label" : "Highlight this gene"}, {"label" : "Ask NCBI about {name}", "iconClass" : "dijitIconDatabase", "action" : "newWindow", "url" : "http://www.ncbi.nlm.nih.gov/protein?term={name}"}, {"label" : "Ask EMBL about {name}", "iconClass" : "dijitIconDatabase", "action" : "newWindow", "url" : "http://www.ebi.ac.uk/ebisearch/search.ebi?db=proteinSequences&t={name}"}, {"label" : "Ask Google about {name}", "action" : "newWindow", "iconClass" : "dijitIconDatabase", "url" : "http://www.google.com/search?q={name}"}] }'

./bin/flatfile-to-json.pl --gff "${GENOME_DIR}/NC_020549.gbrowse.gff3" --type CDS --trackLabel CDS  --key "CDS" --trackType CanvasFeatures --out data/json/las_gxpsy/ --clientConfig '{"description" : "note", "label" : "name,id", "color" : "blue" }' --metadata '{"description": "CDS from NCBI Refseq linked to NCBI Blink", "category": "Gene models" }' --urltemplate "http://www.ncbi.nlm.nih.gov/sutils/blink.cgi?pid={name}"

# create assembly tracks
# NA

# index names
./bin/generate-names.pl -v --out data/json/las_gxpsy/

