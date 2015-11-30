#!/bin/sh

# Surya Saha
# Purpose: setup LAS psy62 in sftp://surya@hlbws.sgn.cornell.edu/var/www/html/jbrowse/JBrowse-1.11.4/data/json/las_psy62
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
	$PROGNAME <jbrowse dir> <LAS genome dir>
    
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

printf "Please store only the data files in LAS dir %s \nCurrent files are.. \n" "$GENOME_DIR"

cd "$GENOME_DIR"
ls -lh

cd "$JB_DIR"
# cleanup
rm -rf data/json/las_psy62

# load refs and data source
./bin/prepare-refseqs.pl --fasta "${GENOME_DIR}/NC_012985.3.fa" --out data/json/las_psy62/
printf "[general]\ndataset_id = las_psy62\n" > data/json/las_psy62/tracks.conf                                 

# create annotation tracks
./bin/flatfile-to-json.pl --gff "${GENOME_DIR}/NC_012985.gbrowse.gff3" --type gene  --trackLabel gene --urltemplate "http://www.ncbi.nlm.nih.gov/protein?term={name}" --key "Genes" --trackType CanvasFeatures --out data/json/las_psy62/ --clientConfig '{"description" : "note", "label" : "name,id", "color" : "goldenrod" }' --metadata '{"description": "Genes from NCBI RefSeq", "category": "Gene models" }' --config '{"menuTemplate" : [{"label" : "View details",}, {"label" : "Zoom this gene", "iconClass" : "dijitIconConnector"}, {"label" : "Highlight this gene"}, {"label" : "Ask NCBI about {name}", "iconClass" : "dijitIconDatabase", "action" : "newWindow", "url" : "http://www.ncbi.nlm.nih.gov/protein?term={name}"}, {"label" : "Ask EMBL about {name}", "iconClass" : "dijitIconDatabase", "action" : "newWindow", "url" : "http://www.ebi.ac.uk/ebisearch/search.ebi?db=proteinSequences&t={name}"}, {"label" : "Ask Google about {name}", "action" : "newWindow", "iconClass" : "dijitIconDatabase", "url" : "http://www.google.com/search?q={name}"}] }'

./bin/flatfile-to-json.pl --gff "${GENOME_DIR}/NC_012985.gbrowse.gff3" --type CDS  --trackLabel CDS --urltemplate "http://www.ncbi.nlm.nih.gov/sutils/blink.cgi?pid={name}" --key "CDS" --trackType CanvasFeatures --out data/json/las_psy62/ --clientConfig '{"description" : "note", "label" : "name", "color" : "blue" }' --metadata '{"description": "CDS from NCBI RefSeq  with links to top BLAST hits using NCBI Blink", "category": "Gene models" }'

# Pathways
# test if biocyc link is correct
./bin/flatfile-to-json.pl --gff "${GENOME_DIR}/NC_012985.gbrowse.gff3" --type MetPathway  --trackLabel MetPathway --urltemplate "http://www.genome.jp/dbget-bin/www_bget?las:{name}" --key "Metabolic Pathways" --trackType CanvasFeatures --out data/json/las_psy62/ --clientConfig '{ "label" : "name,id", "color" : "orange" }' --metadata '{"description": "Metabolic Pathway predictions with links to KEGG", "category": "Predicted features (de novo)" }' --config '{"menuTemplate" : [{"label" : "View details",}, {"label" : "Highlight this gene"}, {"label" : "Ask KEGG about {name}", "iconClass" : "dijitIconDatabase", "action" : "newWindow", "url" : "http://www.genome.jp/dbget-bin/www_bget?las:{name}"}, {"label" : "Ask BioCyc about {name}", "iconClass" : "dijitIconDatabase", "action" : "newWindow", "url" : "http://biocyc.org/CLIB537021/NEW-IMAGE?type=GENE-IN-PWY&object={name}"}] }'

./bin/flatfile-to-json.pl --gff "${GENOME_DIR}/NC_012985.gbrowse.gff3" --type mat_peptide  --trackLabel mat_peptide --urltemplate "http://hlbws.sgn.cornell.edu/archive/HLB-genome-resources.html#SignalPeptides" --key "Mature peptides" --trackType CanvasFeatures --out data/json/las_psy62/ --clientConfig '{"description" : "note", "label" : "name,id", "color" : "orange" }'  --metadata '{"description": "SignalP 4.1 and LipoP 1.0 predictions of cleaved mature peptides for a protein", "category": "Predicted features (de novo)" }'

./bin/flatfile-to-json.pl --gff "${GENOME_DIR}/NC_012985.gbrowse.gff3" --type Loc_PSORTb  --trackLabel Loc_PSORTb --urltemplate "http://db.psort.org/browse/genome/sequence?version=3.00&dataset=c&refseq={name}" --key "PSORTb subcellular localization" --trackType CanvasFeatures --out data/json/las_psy62/ --clientConfig '{"description" : "note", "label" : "name,id", "color" : "orange" }' --metadata '{"description": "PSORTb subcellular localization predictions with links to PSORTb website", "category": "Predicted features (de novo)" }'

# repeats
./bin/flatfile-to-json.pl --gff "${GENOME_DIR}/NC_012985.gbrowse.gff3" --type repeat:RepeatScout  --trackLabel repeat:RepeatScout --key "RepeatScout repeats" --trackType CanvasFeatures --out data/json/las_psy62/ --clientConfig '{"description" : "description", "label" : "name,id", "color" : "green" }' --metadata '{"description": "RepeatScout predictions", "category": "Repetitive elements" }'

./bin/flatfile-to-json.pl --gff "${GENOME_DIR}/NC_012985.gbrowse.gff3" --type repeat:RepeatMasker  --trackLabel repeat:RepeatMasker --key "RepeatMasker repeats" --trackType CanvasFeatures --out data/json/las_psy62/ --clientConfig '{"description" : "description", "label" : "name,id", "color" : "green" }' --metadata '{"description": "RepeatMasker matches to known repeats in RepBase", "category": "Repetitive elements" }'

# Nick Grishin's annotations
./bin/flatfile-to-json.pl --gff "${GENOME_DIR}/NC_012985.gbrowse.gff3" --type ext_annotation  --trackLabel Nick_Grishin --urltemplate "http://prodata.swmed.edu/congqian/{name}.html" --key "Grishin lab annotations" --trackType CanvasFeatures --out data/json/las_psy62/ --clientConfig '{"label" : "name,id", "color" : "orange" }' --metadata '{"description": "Protein annotations from Nick Grishins lab. See http://prodata.swmed.edu/congqian/Candidatus_Liberibacter_genome_home.html", "category": "Predicted features (de novo)" }'

./bin/flatfile-to-json.pl --gff "${GENOME_DIR}/NC_012985.gbrowse.gff3" --type BlastHit:LSO  --trackLabel LSO_BlastHit --key "Blast hits to LSO" --trackType CanvasFeatures --out data/json/las_psy62/ --clientConfig '{"label" : "note", "color" : "orange" }'  --metadata '{"description": "Unique regions in LAS when compared to LSO", "category": "Predicted features (de novo)" }'

./bin/flatfile-to-json.pl --gff "${GENOME_DIR}/NC_012985.gbrowse.gff3" --type GeneExpr  --trackLabel GeneExpr --key "Differentially expressed genes" --trackType CanvasFeatures --out data/json/las_psy62/ --clientConfig '{"description" : "note", "label" : "name,id", "color" : "violet" }' --metadata '{"description": "Differentially expressed (DE) genes from Yan et al. 2013. See http://onlinelibrary.wiley.com/doi/10.1111/mpp.12015/abstract", "category": "Expression" }'

# create assembly tracks
# NA

# index names
./bin/generate-names.pl --out data/json/las_psy62/ -v


