From the BLAST results, extract info for each contig that matches viruses included in the simulaiton (use the full blastn.out results for this, not just the top hit):  
```
grep "Hendra" path/to/blastn.out > Hendra_contigs.out
```

Next, get the unique contig IDs from the list of the virus-matched contigs:  
```
awk '{print $1}' Hendra_contigs.out | uniq > Hendra_unique_contig_IDs.out
```

Extract unique Hendra contigs from the assembly .fasta file using generated ID file (e.g. using FLYE final assembly.fasta file):  
```
seqtk subseq FLYE_assembly.fasta Hendra_unique_contig_IDs.out > Hendra_unique_contigs.fasta
```

Map extracted contigs back to the reference viral genome used to generate simulated dataset (minimap2), convert to .bam, sort and index final .bam file and index assembly fasta file:  
```
minimap2 -a -x map-ont -o Hendra_contigs_mapped.sam Hendra_ref_genome.fasta Hendra_unique_contigs.fasta
samtools view -b Hendra_contigs_mapped.sam > Hendra_contigs_mapped.bam
samtools sort Hendra_contigs_mapped.bam > Hendra_contigs_mapped_sorted.bam
samtools index Hendra_contigs_mapped_sorted.bam  
```

Calculate breadth of coverage and other quick general stats for all contigs mapped:  
```
samtools coverage Hendra_contigs_mapped_sorted.bam
```
Sample output:  
```
#rname       startpos  endpos  numreads     covbases     coverage     meandepth      meanbaseq    meanmapq  
NC_001906.3     1       18234     3           15846       86.9036      0.869036        255           60
```
Alternatively, use samtools + awk to calculate breadth of coverage:  
```
samtools depth -a Hendra_contigs_mapped_sorted.bam | awk '{c++; if($3>0) total+=1}END{print (total/c)*100}'
```

Calculate % identity:  
Use Cramino (https://github.com/wdecoster/cramino) to calculate stats including % identity for bam files.  
```
cramino Hendra_contigs_mapped_corted.bam
```

