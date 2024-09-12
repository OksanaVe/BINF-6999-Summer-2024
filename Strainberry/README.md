Strain-level assembly of viral genomes    

## To-do list  

- [ ] Add scenario where not all subtypes of FMDV recovered;
- [ ] Run de novo assemblers under the default settings and identify which assemblers don't recover all four strains;
- [ ] Identify and extract all contigs match to FMDV;  
- [ ] Run Strainberry to recover missing FMDV subtypes;


## Dataset  

Dataset for the strain separation analysis is available here: https://drive.google.com/drive/folders/1uj9ZExmKr7oCrYq9YaBeVDrsj2P2QFi4?usp=sharing  

Dataset was simulated using a modified Scenario 2 abundance settings and an NBDv14-trained model.  

## Strainberry  

Run assemblers and BLASTn search as usual.  
When blast results are done, extract info for contigs matched to FMDV (use the full blastn.out results for this, not just the top hit):  
```
grep "Foot-and-mouth" path/to/blastn.out > FMDV_matched_contigs.out
```

Next, get the unique contig IDs from the list of the FMDV-matched contigs:  
```
awk '{print $1}' FMDV_matched_contigs.out | uniq > FMDV_unique_contig_IDs.out
```

Extract unique FMDV contigs from the assembly .fasta file using generated ID file (e.g. using FLYE final assembly.fasta file):  
```
seqtk subseq FLYE_assembly.fasta FMDV_unique_contig_IDs.out > FMDV_unique_contigs.fasta
```

Map simulated reads back to the extracted FMDV contigs using minimap2, convert to .bam, sort and index final .bam file and index extracted contig fasta file:  
```
minimap2 -a -x map-ont -o FMDV_contigs_mapped.sam FMDV_unique_contigs.fasta Strains_simulation2_concat.fq.gz
samtools view -b FMDV_contigs_mapped.sam > FMDV_contigs_mapped.bam
samtools sort FMDV_contigs_mapped.bam > FMDV_contigs_mapped_sorted.bam
samtools index FMDV_contigs_mapped_sorted.bam
samtools faidx FMDV_unique_contigs.fasta
```



