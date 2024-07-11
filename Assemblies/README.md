This directory contains information about de novo genome assembly steps.  
We will be using Flye, Canu, MetaMDBG, and HaploFlow for metagenome assemblies.  

## To-do list  

- [ ] Perform assemblies under the default settings for each assembler (for Canu, we'll use settings recommended for metagenomics assemblies, not the defaults);  
- [ ] Visualize assembly graphs in Bandage;
- [ ] Check BLAST databases available on Compute Canada (/cvmfs/bio.data.computecanada.ca/content/databases/Core/blast_dbs/2022_03_23/);  
- [ ] Classify assembled contigs using BLAST search;  


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


## Bandage  
Visualize assembly graphs using Bandage: https://rrwick.github.io/Bandage/
