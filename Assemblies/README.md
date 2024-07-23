This directory contains information about de novo genome assembly steps.  
We will be using Flye, Canu, MetaMDBG, and ~~HaploFlow~~ for metagenome assemblies.  

## To-do list  

- [x] Perform assemblies under the default settings for each assembler (for Canu, we'll use settings recommended for metagenomics assemblies, not the defaults);  
- [x] Visualize assembly graphs in Bandage;
- [x] Check BLAST databases available on Compute Canada (/cvmfs/bio.data.computecanada.ca/content/databases/Core/blast_dbs/2022_03_23/);  
- [x] Classify assembled contigs using BLAST search;
- [ ] Summarize BLAST results (top hit per contig);
- [ ] Identify scenario(s) where not all subtypes of FMDV recovered;
- [ ] Run Strainberry to recover missing FMDV subtypes;


## Flye  
GitHub: https://github.com/fenderglass/Flye/tree/flye  
Example of simple bash script to run Flye in 'meta' mode:  

```
#!/bin/bash  
FILES="./*.fq.gz"  

for f in $FILES  
do  
s=${f##*/}  

flye --nano-corr ${f} --threads 52 --meta --min-overlap 1000 --out-dir "${s%_concat*}_metaFlye"  

done
```

## Canu  
GitHub: https://github.com/marbl/canu  

```
#!/bin/bash
FILES="./*.fq.gz"

for f in $FILES
do
s=${f##*/}

canu -d "${s%.fq.gz*}_canu_5m" -p "canu_NanoSim_${s%.fq.gz*}_5m" corOutCoverage=10000 corMhapSensitivity=high corMinCoverage=0 redMemory=32 oeaMemory=32 batMemory=200 correctedErrorRate=0.105 genomeSize=5m corMaxEvidenceCoverageLocal=10 corMaxEvidenceCoverageGlobal=10 -corrected -trimmed -nanopore ${f}

done
```

## MetaMDBG  
GitHub: https://github.com/GaetanBenoitDev/metaMDBG  
Best to install from source using conda/mamba (if installing directly with conda, assembly graph function won't work correctly)    
Run assembler under the default settings first:  
```
metaMDBG asm path/to/output_directory reads_concat.fq.gz -t 52
```
After assembly is done, generate an assembly graph:  
```
metaMDBG gfa assemblyDir k --contigpath --readpath
```  

## HaploFlow  
GitHub: https://github.com/hzi-bifo/Haploflow  
If installing with conda, extract .fq.gz file before running HaploFlow (doesn't work with compressed Fastq files).  
Run under the default settings:  
```
haploflow --read-file path_to_fastq_file --out path_to_output_directory
```

## BLAST  
```
#!/bin/bash
FILES="./*.fasta"
for f in $FILES
do
blastn \
  -db path/to/blast/database \
  -query "${f}" \
  -outfmt "6 qaccver saccver pident length mismatch gapopen qstart qend sstart send evalue bitscore qlen slen stitle staxid ssciname" \
  -evalue 1e-100 \
  -out "${f%.*}_blast.out"
  
done
```
## Parse BLAST output  
Example R script to parse BLAST output and pick the top match (by % identity) per contig:  
```
setwd("/Oksana/path-to-blast-results-directory")

blast_fs <- list.files(path=".", pattern="_blast.out", all.files=TRUE, 
	full.names=F)

for(j in 1:length(blast_fs)){

dt <- read.csv(blast_fs[j], header=F, sep="\t")

header <- c("contig", "accession", "ident", "length", "mismatch", "gap", "qstart", "qend", "sstart", "send", "eval", "bitscore", "qlen", "slen", "stitle", "staxid", "ssciname")
names(dt) = header
tigs = dt$contig
uni_tigs <- unique(tigs)
top_hit <- data.frame(contig = character(), accession = character(), ident = numeric(), length = numeric(), mismatch = numeric(), gap = numeric(), qstart = numeric(), qend = numeric(), sstart = numeric(), send = numeric(), eval = numeric(), bitscore = numeric(), qlen = numeric(), slen = numeric(), stitle = character(), staxid = character(), ssciname = character())
for(i in 1:length(uni_tigs)){
     dt_tmp <- subset(dt, dt$contig == uni_tigs[i])
     dt_tmp_ord <- dt_tmp[order(dt_tmp$ident),]
     top <- dt_tmp_ord[1,]
     top_hit <- rbind(top_hit, top)
}

nm <- paste0(unlist(strsplit(blast_fs[j], ".out"))[1], "_topHit.csv")
write.table(top_hit, nm, quote = F, sep="\t", row.names=F)

}
```


## Bandage  
Visualize assembly graphs using Bandage: https://rrwick.github.io/Bandage/
