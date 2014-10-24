#!/bin/sh

# Surya Saha
# Purpose: setup LAM Sao Paulo in sftp://surya@hlbws.sgn.cornell.edu/var/www/html/jbrowse/JBrowse-1.11.4/data/json/lam_saopaulo

set -u #exit if uninit var
set -o nounset
set -o errexit

# cleanup
rm -rf data/json/lam_saopaulo

# load refs and data source

printf "[general]\ndataset_id = las_psy62\n" > data/json/las_psy62/tracks.conf                                 

# create annotation tracks










####
bin/flatfile-to-json.pl --gff ~/work/jbrowse_setup/las_psy62/NC_012985.gbrowse.gff3 --type gene  --trackLabel gene --urltemplate "http://www.ncbi.nlm.nih.gov/protein?term={name}" --key "Genes" --trackType CanvasFeatures --out data/json/las_psy62/ --clientConfig '{"description" : "note", "label" : "name,id", "color" : "yellow" }' --metadata '{"description": "Genes from NCBI RefSeq", "category": "General" }'

bin/flatfile-to-json.pl --gff ~/work/jbrowse_setup/las_psy62/NC_012985.gbrowse.gff3 --type CDS  --trackLabel CDS --urltemplate "http://www.ncbi.nlm.nih.gov/sutils/blink.cgi?pid={name}" --key "CDS" --trackType CanvasFeatures --out data/json/las_psy62/ --clientConfig '{"description" : "note", "label" : "name", "color" : "blue" }' --metadata '{"description": "CDS from NCBI RefSeq  with links to top BLAST hits using NCBI Blink", "category": "General" }'

bin/flatfile-to-json.pl --gff ~/work/jbrowse_setup/las_psy62/NC_012985.gbrowse.gff3 --type MetPathway  --trackLabel MetPathway --urltemplate "http://www.genome.jp/dbget-bin/www_bget?las:{name}" --key "Metabolic Pathways" --trackType CanvasFeatures --out data/json/las_psy62/ --clientConfig '{ "label" : "name,id", "color" : "orange" }' --metadata '{"description": "Metabolic Pathway predictions with links to KEGG", "category": "Predictions" }'

bin/flatfile-to-json.pl --gff ~/work/jbrowse_setup/las_psy62/NC_012985.gbrowse.gff3 --type mat_peptide  --trackLabel mat_peptide --urltemplate "http://citrusgreening.org/HLB-genome-resources.html#SignalPeptides" --key "Mature peptides" --trackType CanvasFeatures --out data/json/las_psy62/ --clientConfig '{"description" : "note", "label" : "name,id", "color" : "orange" }'  --metadata '{"description": "SignalP 4.1 and LipoP 1.0 predictions of cleaved mature peptides for a protein", "category": "Predictions" }'

bin/flatfile-to-json.pl --gff ~/work/jbrowse_setup/las_psy62/NC_012985.gbrowse.gff3 --type Loc_PSORTb  --trackLabel Loc_PSORTb --urltemplate "http://db.psort.org/browse/genome/sequence?version=3.00&dataset=c&refseq={name}" --key "PSORTb subcellular localization" --trackType CanvasFeatures --out data/json/las_psy62/ --clientConfig '{"description" : "note", "label" : "name,id", "color" : "orange" }' --metadata '{"description": "PSORTb subcellular localization predictions with links to PSORTb website", "category": "Predictions" }'

bin/flatfile-to-json.pl --gff ~/work/jbrowse_setup/las_psy62/NC_012985.gbrowse.gff3 --type repeat  --trackLabel repeat --key "Repeats" --trackType CanvasFeatures --out data/json/las_psy62/ --clientConfig '{"description" : "description", "label" : "name,id", "color" : "green" }' --metadata '{"description": "RepeatMasker and RepeatScout predictions", "category": "Predictions" }'

bin/flatfile-to-json.pl --gff ~/work/jbrowse_setup/las_psy62/NC_012985.gbrowse.gff3 --type Nick_Grishin  --trackLabel Nick_Grishin --urltemplate "http://prodata.swmed.edu/congqian/{name}.html" --key "Protein annotations" --trackType CanvasFeatures --out data/json/las_psy62/ --clientConfig '{"label" : "name,id", "color" : "orange" }' --metadata '{"description": "Protein annotations from Nick Grishins lab", "category": "Predictions" }'

bin/flatfile-to-json.pl --gff ~/work/jbrowse_setup/las_psy62/NC_012985.gbrowse.gff3 --type LSO_BlastHit  --trackLabel LSO_BlastHit --key "Blast hits to LSO" --trackType CanvasFeatures --out data/json/las_psy62/ --clientConfig '{"label" : "note", "color" : "orange" }'  --metadata '{"description": "Unique regions in LAS when compared to LSO", "category": "Predictions" }'

bin/flatfile-to-json.pl --gff ~/work/jbrowse_setup/las_psy62/NC_012985.gbrowse.gff3 --type GeneExpr  --trackLabel GeneExpr --urltemplate "http://onlinelibrary.wiley.com/doi/10.1111/mpp.12015/abstract" --key "Yan et al. 2013" --trackType CanvasFeatures --out data/json/las_psy62/ --clientConfig '{"description" : "note", "label" : "name,id", "color" : "violet" }' --metadata '{"description": "Gene expression data from Yan et al. 2013", "category": "Predictions" }'

# create assembly tracks
# NA

# index names
bin/generate-names.pl --out data/json/las_psy62/ -v


