## Snail plot with BlobTools  

To install BlobTools folow instructions here: https://github.com/blobtoolkit/blobtoolkit  

To create a dataset: https://blobtoolkit.genomehubs.org/blobtools2/blobtools2-tutorials/creating-a-dataset/  
Create a dataset/directory for each assembly.  

To add BLAST hits:  
```
blobtools add --hits ~/full_blast_results/NBDv14_Scenario_2_metaMDBG_contigs_blast.out --hits-cols 1=qseqid,16=staxids,12=bitscore,2=sseqid,7=qstart,8=qend,12=evalue --taxrule bestsumorder --taxdump "~/UofG_2024/BloobTools/taxdump/" .
```

To create a snail plot with general assembly statistics:  
```
blobtools view --plot --view snail path/to/BlobTools/dataset/directory
```

<img src="https://github.com/OksanaVe/BINF-6999-Summer-2024/blob/main/Visualization/NBDv14_Scenario2_metaMDBG.snail.png" width=300>  
