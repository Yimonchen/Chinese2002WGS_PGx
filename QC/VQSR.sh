#!/bin/bash

reference=/jdfssz1/ST_BIGDATA/USER/quning/pipeline/genome/fasta/genome.fa
outdir=/jdfssz1/ST_BIGDATA/USER/project/s2002_qc/variant_qc


##$ SNP mode
time /share/app/java/jdk1.8.0_261/bin/java -jar /share/app/gatk/4.1.8.1/gatk-package-4.1.8.1-local.jar VariantRecalibrator \
   -R $reference \
   -V $outdir/HC.vcf.gz \
   -resource:hapmap,known=false,training=true,truth=true,prior=15.0 $outdir/GATK_bundle/hapmap_3.3.hg38.vcf \
   -resource:omni,known=false,training=true,truth=false,prior=12.0 $outdir/GATK_bundle/1000G_omni2.5.hg38.vcf \
   -resource:1000G,known=false,training=true,truth=false,prior=10.0 $outdir/GATK_bundle/1000G_phase1.snps.high_confidence.hg38.vcf \
   #-resource:dbsnp,known=true,training=false,truth=false,prior=2.0 $GATK_bundle/dbsnp_146.hg38.vcf \
   -an DP -an QD -an FS -an SOR -an ReadPosRankSum -an MQRankSum \
   -mode SNP \
   -tranche 99.9 -tranche 99.5 -tranche 99.0 -tranche 98.0 -tranche 95.0 \
   -rscript-file $outdir/HC.snps.plots.R \
   --tranches-file $outdir/HC.snps.tranches \
   -O $outdir/HC.snps.recal && \
time /share/app/java/jdk1.8.0_261/bin/java -jar /share/app/gatk/4.1.8.1/gatk-package-4.1.8.1-local.jar ApplyVQSR \
   -R $reference \
   -V $outdir/HC.vcf.gz \
   --ts_filter_level 99.0 \
   --tranches-file $outdir/HC.snps.tranches \
   -recal-file $outdir/HC.snps.recal \
   -mode SNP \
   -O $outdir/HC.snps.VQSR.vcf.gz && echo "** SNPs VQSR done **"

### Indel mode
time /share/app/java/jdk1.8.0_261/bin/java -jar /share/app/gatk/4.1.8.1/gatk-package-4.1.8.1-local.jar VariantRecalibrator \
   -R $reference \
   -V $outdir/HC.snps.VQSR.vcf.gz \
   -resource:mills,known=true,training=true,truth=true,prior=12.0 $outdir/GATK_bundle/Mills_and_1000G_gold_standard.indels.hg38.vcf \
   #-resource:dbsnp,known=true,training=false,truth=false,prior=2.0 $GATK_bundle/dbsnp_146.hg38.vcf \
   -an DP -an QD -an FS -an SOR -an ReadPosRankSum -an MQRankSum \
   -mode INDEL \
   --max-gaussians 6 \
   -rscript-file $outdir/HC.snps.indels.plots.R \
   --tranches-file $outdir/HC.snps.indels.tranches \
   -O $outdir/HC.snps.indels.recal && \
time /share/app/java/jdk1.8.0_261/bin/java -jar /share/app/gatk/4.1.8.1/gatk-package-4.1.8.1-local.jar ApplyVQSR \
   -R $reference \
   -V $outdir/HC.snps.VQSR.vcf.gz \
   --ts_filter_level 99.0 \
   --tranches-file $outdir/HC.snps.indels.tranches \
   -recal-file $outdir/HC.snps.indels.recal \
   -mode INDEL \
   -O $outdir/HC.VQSR.vcf.gz && echo "** SNPs and Indels VQSR (HC.VQSR.vcf.gz finish) done **"
