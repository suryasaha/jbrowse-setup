#!/bin/sh

# Surya Saha
# Purpose: setup LAM Sao Paulo in sftp://surya@hlbws.sgn.cornell.edu/var/www/html/jbrowse/JBrowse-1.11.4/data/json/lam_saopaulo

set -u #exit if uninit var
set -e #exit if non-zero return value (error), use command || {echo 'command failed'; exit 1;}
set -o nounset
set -o errexit

readonly PROGNAME=$(basename "$0")
readonly PROGDIR=$(readlink -m "$(dirname "$0")")
readonly WDIR=$(pwd)

usage() {
	echo "usage:
	$PROGNAME <jbrowse dir> <LAM Sao Paulo genome dir>
    
	Example:
	$PROGNAME ARG1 ARG2"
	exit 1
}

if [ "$#" -ne 2 ]
then
	usage
fi

printf "JB  dir: %s \n" "$1"
printf "LAM dir: %s \n" "$2"

JB_DIR="$1"
GENOME_DIR="$2"

printf "Please store the data files in LAM Sao Paulo dir %s \nCurrent files are.. \n" "$GENOME_DIR"

cd "$GENOME_DIR"
ls -lh

cd "$JB_DIR"

# cleanup
rm -rf data/json/lam_saopaulo

# load refs and data source
./bin/prepare-refseqs.pl --fasta "${GENOME_DIR}/NC_022793.1.fa" --out data/json/lam_saopaulo      
printf "[general]\ndataset_id = lam_saopaulo\n" > data/json/lam_saopaulo/tracks.conf                                 

# create annotation tracks
./bin/flatfile-to-json.pl --gff "${GENOME_DIR}/NC_022793.gbrowse.gff3" --type gene  --trackLabel gene --key "Genes" --trackType CanvasFeatures --out data/json/lam_saopaulo/ --clientConfig '{ "label" : "name,id", "color" : "goldenrod" }' --metadata '{"description": "Genes from NCBI Refseq with links to NCBI Protein", "category": "Gene models" }' --urltemplate "http://www.ncbi.nlm.nih.gov/protein?term={name}" --config '{"menuTemplate" : [{"label" : "View details",}, {"label" : "Zoom this gene", "iconClass" : "dijitIconConnector"}, {"label" : "Highlight this gene"}, {"label" : "Ask NCBI about {name}", "iconClass" : "dijitIconDatabase", "action" : "newWindow", "url" : "http://www.ncbi.nlm.nih.gov/protein?term={name}"}, {"label" : "Ask EMBL about {name}", "iconClass" : "dijitIconDatabase", "action" : "newWindow", "url" : "http://www.ebi.ac.uk/ebisearch/search.ebi?db=proteinSequences&t={name}"}, {"label" : "Ask Google about {name}", "action" : "newWindow", "iconClass" : "dijitIconDatabase", "url" : "http://www.google.com/search?q={name}"}] }'

./bin/flatfile-to-json.pl --gff "${GENOME_DIR}/NC_022793.gbrowse.gff3" --type CDS --trackLabel CDS  --key "CDS" --trackType CanvasFeatures --out data/json/lam_saopaulo/ --clientConfig '{"description" : "note", "label" : "name,id", "color" : "blue" }' --metadata '{"description": "CDS from NCBI Refseq with links to NCBI Blink", "category": "Gene models" }' --urltemplate "http://www.ncbi.nlm.nih.gov/sutils/blink.cgi?pid={name}"

# create assembly tracks
# NA

# index names
./bin/generate-names.pl --out data/json/lam_saopaulo/ -v

