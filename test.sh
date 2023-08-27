nohup mosdepth -n --fast-mode --by 500 cs_30x CS_sg_2017_30x.bam   &
paste  jm44_depth.regions.bed <(cut -f4  jm44.splitters.regions.bed) <(cut -f4 jm44.discordants.regions.bed) > jm44.depth.bed

## 提取断裂位点 py2 envs
nohup samtools view -h CS_sg_2017_30x.bam | extractSplitReads_BwaMem -i stdin | samtools view -Sb - > cs30x.splitters.unsorted.bam &
nohup samtools view -b -F 1294  CS_sg_2017_30x.bam > cs30x.discordants.unsorted.bam &
nohup samtools sort -@20 -o cs30x.discordants.bam  cs30x.discordants.unsorted.bam &
nohup samtools sort -@20 -o cs30x.splitters.bam  cs30x.splitters.unsorted.bam &

nohup mosdepth -n --fast-mode -T 20  --by 500 cs_30x.discordants cs30x.discordants.bam  &
nohup mosdepth -n --fast-mode -T 20 --by 500 cs_30x.splitters cs30x.splitters.bam  &

paste  cs_30x.regions.bed <(cut -f4  cs_30x.splitters.regions.bed) <(cut -f4 cs_30x.discordants.regions.bed) > cs.depth.bed
