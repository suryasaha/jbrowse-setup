#!/bin/sh

# Surya Saha
# Purpose: setup LAS UF506 phage in sftp://surya@hlbws.sgn.cornell.edu/var/www/html/jbrowse/JBrowse-1.11.4/data/json/las_uf506
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
	$PROGNAME <jbrowse dir> <LAS phage genome dir>
    
	Example:
	$PROGNAME ARG1 ARG2"
	exit 1
}

if [ "$#" -ne 2 ]
then
	usage
fi

printf "JB  dir: %s \n" "$1"
printf "LAS phage dir: %s \n" "$2"

JB_DIR="$1"
GENOME_DIR="$2"

printf "Please store the data files in LAS phage dir %s \nCurrent files are.. \n" "$GENOME_DIR"

cd "$GENOME_DIR"
ls -lh

cd "$JB_DIR"

# cleanup
rm -rf data/json/las_uf506

# load refs and data source
bin/prepare-refseqs.pl --fasta "${GENOME_DIR}/HQ377374.fa" --out data/json/las_uf506
printf "[general]\ndataset_id = las_uf506\n" > data/json/las_uf506/tracks.conf                                 

# create annotation tracks
./bin/flatfile-to-json.pl --gff "${GENOME_DIR}/HQ377374.gbrowse.gff3"  --type gene  --trackLabel gene --key "Genes" --trackType CanvasFeatures --out data/json/las_uf506/ --clientConfig '{"label" : "name,id", "color" : "goldenrod" }' --metadata '{"description": "Genes from NCBI Refseq with links to NCBI Protein DB", "category": "Gene models" }' --urltemplate "http://www.ncbi.nlm.nih.gov/protein?term={name}" --config '{"menuTemplate" : [{"label" : "View details",}, {"label" : "Zoom this gene", "iconClass" : "dijitIconConnector"}, {"label" : "Highlight this gene"}, {"label" : "Ask NCBI about {name}", "iconClass" : "dijitIconDatabase", "action" : "newWindow", "url" : "http://www.ncbi.nlm.nih.gov/protein?term={name}"}, {"label" : "Ask EMBL about {name}", "iconClass" : "dijitIconDatabase", "action" : "newWindow", "url" : "http://www.ebi.ac.uk/ebisearch/search.ebi?db=proteinSequences&t={name}"}, {"label" : "Ask Google about {name}", "action" : "newWindow", "iconClass" : "dijitIconDatabase", "url" : "http://www.google.com/search?q={name}"}] }'

./bin/flatfile-to-json.pl --gff "${GENOME_DIR}/HQ377374.gbrowse.gff3" --type CDS --trackLabel CDS  --key "CDS" --trackType CanvasFeatures --out data/json/las_uf506/ --clientConfig '{"description" : "note", "label" : "name,id", "color" : "blue" }' --metadata '{"description": "CDS from NCBI Refseq with links to NCBI Blast", "category": "Gene models" }' --urltemplate "http://www.ncbi.nlm.nih.gov/sutils/blink.cgi?pid={name}"

./bin/flatfile-to-json.pl --gff "${GENOME_DIR}/HQ377374.gbrowse.gff3" --type repeat:RepeatScout --trackLabel RepeatScout  --key "RepeatScout repeats" --trackType CanvasFeatures --out data/json/las_uf506/ --clientConfig '{"description" : "note", "label" : "name,id", "color" : "green" }' --metadata '{"description": "ab-initio repeats predicted by RepeatScout", "category": "Repetitive elements" }'

./bin/flatfile-to-json.pl --gff "${GENOME_DIR}/HQ377374.gbrowse.gff3" --type repeat:RepeatMasker --trackLabel RepeatMasker  --key "RepeatMasker repeats" --trackType CanvasFeatures --out data/json/las_uf506/ --clientConfig '{"description" : "note", "label" : "name,id", "color" : "green" }' --metadata '{"description": "RepeatMasker matches to known repeats in RepBase", "category": "Repetitive elements" }'


# create assembly tracks
# NA

# index names
./bin/generate-names.pl --out data/json/las_uf506/ -v


