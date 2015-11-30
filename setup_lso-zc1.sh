#!/bin/sh

# Surya Saha
# Purpose: setup LSO ZC1 phage in sftp://surya@hlbws.sgn.cornell.edu/var/www/html/jbrowse/JBrowse-1.11.4/data/json/lso_zc1

set -u #exit if uninit var
set -e #exit if non-zero return value (error), use command || {echo 'command failed'; exit 1;}
set -o nounset
set -o errexit

readonly PROGNAME=$(basename "$0")
readonly PROGDIR=$(readlink -m "$(dirname "$0")")
readonly WDIR=$(pwd)

usage() {
	echo "usage:
	$PROGNAME <jbrowse dir> <LSO ZC1 genome dir>
    
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

printf "Please store the data files in LSO ZC1 dir %s \nCurrent files are.. \n" "$GENOME_DIR"

cd "$GENOME_DIR"
ls -lh

cd "$JB_DIR"

# cleanup
rm -rf data/json/lso_zc1

# load refs and data source
./bin/prepare-refseqs.pl --fasta "${GENOME_DIR}/NC_014774.1.fa" --out data/json/lso_zc1
printf "[general]\ndataset_id = lso_zc1\n" > data/json/lso_zc1/tracks.conf

# create annotation tracks
./bin/flatfile-to-json.pl --gff "${GENOME_DIR}/NC_014774.gbrowse.gff3"  --type gene  --trackLabel gene --key "Genes" --trackType CanvasFeatures --out data/json/lso_zc1/ --clientConfig '{"label" : "name,id", "color" : "goldenrod" }' --metadata '{"description": "Genes from NCBI Refseq with links to NCBI Protein DB", "category": "Gene models" }' --urltemplate "http://www.ncbi.nlm.nih.gov/protein?term={name}" --config '{"menuTemplate" : [{"label" : "View details",}, {"label" : "Zoom this gene", "iconClass" : "dijitIconConnector"}, {"label" : "Highlight this gene"}, {"label" : "Ask NCBI about {name}", "iconClass" : "dijitIconDatabase", "action" : "newWindow", "url" : "http://www.ncbi.nlm.nih.gov/protein?term={name}"}, {"label" : "Ask EMBL about {name}", "iconClass" : "dijitIconDatabase", "action" : "newWindow", "url" : "http://www.ebi.ac.uk/ebisearch/search.ebi?db=proteinSequences&t={name}"}, {"label" : "Ask Google about {name}", "action" : "newWindow", "iconClass" : "dijitIconDatabase", "url" : "http://www.google.com/search?q={name}"}] }'

./bin/flatfile-to-json.pl --gff "${GENOME_DIR}/NC_014774.gbrowse.gff3" --type CDS --trackLabel CDS  --key "CDS" --trackType CanvasFeatures --out data/json/lso_zc1/ --clientConfig '{"description" : "note", "label" : "name,id", "color" : "blue" }' --metadata '{"description": "CDS from NCBI Refseq with links to NCBI Blast", "category": "Gene models" }' --urltemplate "http://www.ncbi.nlm.nih.gov/sutils/blink.cgi?pid={name}"

./bin/flatfile-to-json.pl --gff "${GENOME_DIR}/NC_014774.gbrowse.gff3" --type COG --trackLabel COG  --key "COG" --trackType CanvasFeatures --out data/json/lso_zc1/ --clientConfig '{"description" : "note", "label" : "name,id", "color" : "orange" }' --metadata '{"description": "COGS from NCBI with links to NCBI CDD", "category": "Predicted features (de novo)" }' --urltemplate "http://www.ncbi.nlm.nih.gov/cdd/?term={name}"

./bin/flatfile-to-json.pl --gff "${GENOME_DIR}/NC_014774.gbrowse.gff3" --type LAS_BlastHit --trackLabel LAS_BlastHit  --key "LAS BlastHit" --trackType CanvasFeatures --out data/json/lso_zc1/ --clientConfig '{"label" : "note", "color" : "orange" }' --metadata '{"description": "Unique regions in LSO when compared to LAS with NCBI Blast Eval 1e-5", "category": "Predicted features (de novo)" }'

./bin/flatfile-to-json.pl --gff "${GENOME_DIR}/NC_014774.gbrowse.gff3" --type Loc_PSORTb --trackLabel Loc_PSORTb  --key "PSORTb subcellular localization" --trackType CanvasFeatures --out data/json/lso_zc1/ --clientConfig '{"description" : "note", "label" : "name,id", "color" : "orange" }' --metadata '{"description": "Subcellular localization predictions with links to PSORTb website", "category": "Predicted features (de novo)" }' --urltemplate "http://db.psort.org/browse/genome/sequence?version=3.00&dataset=c&refseq={name}"

./bin/flatfile-to-json.pl --gff "${GENOME_DIR}/NC_014774.gbrowse.gff3" --type MetPathway --trackLabel MetPathway  --key "Metabolic Pathways" --trackType CanvasFeatures --out data/json/lso_zc1/ --clientConfig '{"label" : "name,id", "color" : "orange" }' --metadata '{"description": "Metabolic pathway predictions with links to KEGG", "category": "Predicted features (de novo)" }' --urltemplate "http://www.genome.jp/dbget-bin/www_bget?lso:{name}" --config '{"menuTemplate" : [{"label" : "View details",}, {"label" : "Highlight this gene"}, {"label" : "Ask KEGG about {name}", "iconClass" : "dijitIconDatabase", "action" : "newWindow", "url" : "http://www.genome.jp/dbget-bin/www_bget?lso:{name}"}, {"label" : "Ask BioCyc about {name}", "iconClass" : "dijitIconDatabase", "action" : "newWindow", "url" : "http://biocyc.org/CLIB658172/NEW-IMAGE?type=GENE-IN-PWY&object={name}"}] }'

./bin/flatfile-to-json.pl --gff "${GENOME_DIR}/NC_014774.gbrowse.gff3" --type repeat:RepeatMasker --trackLabel RepeatMasker  --key "RepeatMasker repeats" --trackType CanvasFeatures --out data/json/lso_zc1/ --clientConfig '{"description" : "note", "label" : "name", "color" : "green" }' --metadata '{"description": "Repeats from RepeatMasker", "category": "Repetitive elements" }'

./bin/flatfile-to-json.pl --gff "${GENOME_DIR}/NC_014774.gbrowse.gff3" --type repeat:RepeatScout --trackLabel RepeatScout  --key "RepeatScout repeats" --trackType CanvasFeatures --out data/json/lso_zc1/ --clientConfig '{"description" : "note", "label" : "name", "color" : "green" }' --metadata '{"description": "Ab-initio repeats from RepeatDcout", "category": "Repetitive elements" }'

# create assembly tracks
# NA

# index names
./bin/generate-names.pl -v --out data/json/lso_zc1/


