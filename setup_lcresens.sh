#!/bin/sh

# Surya Saha
# Purpose: setup L CRESENS in sftp://surya@hlbws.sgn.cornell.edu/var/www/html/jbrowse/JBrowse-1.11.4/data/json/lcresens

set -u #exit if uninit var
set -e #exit if non-zero return value (error), use command || {echo 'command failed'; exit 1;}
set -o nounset
set -o errexit

readonly PROGNAME=$(basename "$0")
readonly PROGDIR=$(readlink -m "$(dirname "$0")")
readonly WDIR=$(pwd)

usage() {
	echo "usage:
	$PROGNAME <jbrowse dir> <Lcresens genome dir>
    
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

printf "Please store the data files in Lcresens dir %s \nCurrent files are.. \n" "$GENOME_DIR"

cd "$GENOME_DIR"
ls -lh

cd "$JB_DIR"

# cleanup
if [ -d data/json/lcresens ]
then
	rm -rf data/json/lcresens
fi

# load refs and data source
./bin/prepare-refseqs.pl --fasta "${GENOME_DIR}/NC_019907.fa" --out data/json/lcresens
printf "[general]\ndataset_id = lcresens\n" > data/json/lcresens/tracks.conf

# create annotation tracks
./bin/flatfile-to-json.pl --gff "${GENOME_DIR}/NC_019907.gbrowse.gff3"  --type gene  --trackLabel gene --key "Genes" --trackType CanvasFeatures --out data/json/lcresens/ --clientConfig '{"label" : "name,id", "color" : "goldenrod" }' --metadata '{"description": "Genes from NCBI Refseq with links to NCBI Protein DB", "category": "Gene models" }' --urltemplate "http://www.ncbi.nlm.nih.gov/protein?term={name}" --config '{"menuTemplate" : [{"label" : "View details",}, {"label" : "Zoom this gene", "iconClass" : "dijitIconConnector"}, {"label" : "Highlight this gene"}, {"label" : "Ask NCBI about {name}", "iconClass" : "dijitIconDatabase", "action" : "newWindow", "url" : "http://www.ncbi.nlm.nih.gov/protein?term={name}"}, {"label" : "Ask EMBL about {name}", "iconClass" : "dijitIconDatabase", "action" : "newWindow", "url" : "http://www.ebi.ac.uk/ebisearch/search.ebi?db=proteinSequences&t={name}"}, {"label" : "Ask Google about {name}", "action" : "newWindow", "iconClass" : "dijitIconDatabase", "url" : "http://www.google.com/search?q={name}"}] }'

./bin/flatfile-to-json.pl --gff "${GENOME_DIR}/NC_019907.gbrowse.gff3" --type CDS --trackLabel CDS  --key "CDS" --trackType CanvasFeatures --out data/json/lcresens/ --clientConfig '{"description" : "note", "label" : "name,id", "color" : "cadetblue" }' --metadata '{"description": "CDS from NCBI Refseq with links to NCBI Blast", "category": "Gene models" }' --urltemplate "http://www.ncbi.nlm.nih.gov/sutils/blink.cgi?pid={name}"

./bin/flatfile-to-json.pl --gff "${GENOME_DIR}/NC_019907.gbrowse.gff3" --type LAS_BlastHit --trackLabel LAS_BlastHit  --key "LAS BlastHit" --trackType CanvasFeatures --out data/json/lcresens/ --clientConfig '{"label" : "note", "color" : "orange" }' --metadata '{"description": "Unique regions in Lcresens when compared to LAS with NCBI Blast Eval 1e-5", "category": "Predicted features (de novo)" }'

./bin/flatfile-to-json.pl --gff "${GENOME_DIR}/NC_019907.gbrowse.gff3" --type LSO_BlastHit --trackLabel LSO_BlastHit  --key "LSO BlastHit" --trackType CanvasFeatures --out data/json/lcresens/ --clientConfig '{"label" : "note", "color" : "orange" }' --metadata '{"description": "Unique regions in Lcresens when compared to LSO with NCBI Blast Eval 1e-5", "category": "Predicted features (de novo)" }'

./bin/flatfile-to-json.pl --gff "${GENOME_DIR}/NC_019907.gbrowse.gff3" --type mat_peptide  --trackLabel mat_peptide --key "Mature peptides" --trackType CanvasFeatures --out data/json/lcresens/ --clientConfig '{"description" : "note", "label" : "name,id", "color" : "orange" }' --metadata '{"description": "SignalP 4.1 and LipoP 1.0 predictions of cleaved mature peptides for a protein", "category": "Predicted features (de novo)" }'

./bin/flatfile-to-json.pl --gff "${GENOME_DIR}/NC_019907.gbrowse.gff3" --type MetPathway --trackLabel MetPathway  --key "Metabolic Pathways" --trackType CanvasFeatures --out data/json/lcresens/ --clientConfig '{"label" : "name,id", "color" : "orange" }' --metadata '{"description": "Metabolic pathway predictions with links to KEGG", "category": "Predicted features (de novo)" }' --urltemplate "http://www.genome.jp/dbget-bin/www_bget?lcc:{name}"

# create assembly tracks


# index names
./bin/generate-names.pl -v --out data/json/lcresens/                                                                
