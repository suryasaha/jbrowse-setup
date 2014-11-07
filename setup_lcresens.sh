#!/bin/sh

# Surya Saha
# Purpose: setup L CRESENS in sftp://surya@hlbws.sgn.cornell.edu/var/www/html/jbrowse/JBrowse-1.11.4/data/json/lcresens

set -u #exit if uninit var
set -o nounset
set -o errexit

# cleanup
if [ -d data/json/lcresens ]
then
	rm -rf data/json/lcresens
fi

# load refs and data source
bin/prepare-refseqs.pl --fasta ~/work/jbrowse_setup/lcresens/NC_019907.fa --out data/json/lcresens
printf "[general]\ndataset_id = lcresens\n" > data/json/lcresens/tracks.conf

# create annotation tracks
bin/flatfile-to-json.pl --gff ~/work/jbrowse_setup/lcresens/NC_019907.gbrowse.gff3  --type gene  --trackLabel gene --key "Genes" --trackType CanvasFeatures --out data/json/lcresens/ --clientConfig '{"label" : "name,id", "color" : "yellow" }' --metadata '{"description": "Genes from NCBI Refseq with links to NCBI Protein DB", "category": "General" }' --urltemplate "http://www.ncbi.nlm.nih.gov/protein?term={name}" --config '{"menuTemplate" : [{"label" : "View details",}, {"label" : "Highlight this gene"}, {"label" : "Ask NCBI about {name}", "iconClass" : "dijitIconDatabase", "action" : "newWindow", "url" : "http://www.ncbi.nlm.nih.gov/protein?term={name}"}, {"label" : "Ask EMBL about {name}", "iconClass" : "dijitIconDatabase", "action" : "newWindow", "url" : "http://www.ebi.ac.uk/ebisearch/search.ebi?db=proteinSequences&t={name}"}, {"label" : "Ask Google about {name}", "action" : "newWindow", "iconClass" : "dijitIconDatabase", "url" : "http://www.google.com/search?q={name}"}] }'

bin/flatfile-to-json.pl --gff ~/work/jbrowse_setup/lcresens/NC_019907.gbrowse.gff3 --type CDS --trackLabel CDS  --key "CDS" --trackType CanvasFeatures --out data/json/lcresens/ --clientConfig '{"description" : "note", "label" : "name,id", "color" : "blue" }' --metadata '{"description": "CDS from NCBI Refseq with links to NCBI Blast", "category": "General" }' --urltemplate "http://www.ncbi.nlm.nih.gov/sutils/blink.cgi?pid={name}"

bin/flatfile-to-json.pl --gff ~/work/jbrowse_setup/lcresens/NC_019907.gbrowse.gff3 --type LAS_BlastHit --trackLabel LAS_BlastHit  --key "LAS BlastHit" --trackType CanvasFeatures --out data/json/lcresens/ --clientConfig '{"label" : "note", "color" : "orange" }' --metadata '{"description": "Unique regions in Lcresens when compared to LAS with NCBI Blast Eval 1e-5", "category": "Prediction" }'

bin/flatfile-to-json.pl --gff ~/work/jbrowse_setup/lcresens/NC_019907.gbrowse.gff3 --type LSO_BlastHit --trackLabel LSO_BlastHit  --key "LSO BlastHit" --trackType CanvasFeatures --out data/json/lcresens/ --clientConfig '{"label" : "note", "color" : "orange" }' --metadata '{"description": "Unique regions in Lcresens when compared to LSO with NCBI Blast Eval 1e-5", "category": "Prediction" }'

bin/flatfile-to-json.pl --gff ~/work/jbrowse_setup/lcresens/NC_019907.gbrowse.gff3 --type mat_peptide  --trackLabel mat_peptide --key "Mature peptides" --trackType CanvasFeatures --out data/json/lcresens/ --clientConfig '{"description" : "note", "label" : "name,id", "color" : "orange" }' --metadata '{"description": "SignalP 4.1 and LipoP 1.0 predictions of cleaved mature peptides for a protein", "category": "Prediction" }'

bin/flatfile-to-json.pl --gff ~/work/jbrowse_setup/lcresens/NC_019907.gbrowse.gff3 --type MetPathway --trackLabel MetPathway  --key "Metabolic Pathways" --trackType CanvasFeatures --out data/json/lcresens/ --clientConfig '{"label" : "name,id", "color" : "orange" }' --metadata '{"description": "Metabolic pathway predictions with links to KEGG", "category": "Prediction" }' --urltemplate "http://www.genome.jp/dbget-bin/www_bget?lcc:{name}"

# create assembly tracks


# index names
bin/generate-names.pl -v --out data/json/lcresens/                                                                
