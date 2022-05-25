#!bin/bash

for i in {1..22}
do
	/share/app/bcftools/1.11/bin/bcftools view --threads 2 -S china1976_G1K2054.sample.txt /jdfssz1/ST_BIGDATA/USER/chenyi/G1K/refpanel/hg38_KG_chinese_af0.05/chr$i.1000G_chinese.af0.05.snps.phase.rmdup.vcf.gz -Oz -o china1976_G1K2054/chr$i.china1976_G1K2054.vcf.gz
	/share/app/bcftools/1.11/bin/bcftools index china1976_G1K2054/chr$i.china1976_G1K2054.vcf.gz
	printf "china1976_G1K2054/chr$i.china1976_G1K2054.vcf.gz\n" >> china1976_G1K2054.merge.list
done
/share/app/bcftools/1.11/bin/bcftools merge --threads 2 -l china1976_G1K2054.merge.list -Oz -o china1976_G1K2054/All.china1976_G1K2054.vcf.gz
/share/app/bcftools/1.11/bin/bcftools index china1976_G1K2054/All.china1976_G1K2054.vcf.gz
/share/app/vcftools-0.1.13/bin/vcftools --gzvcf china1976_G1K2054/All.china1976_G1K2054.vcf.gz --hwe 0.000001 --recode --recode-INFO-all --out china1976_G1K2054/All.china1976_G1K2054.hwe.vcf
/ldfssz1/ST_BIGDATA/USER/huangfei/software/bin/bgzip china1976_G1K2054/All.china1976_G1K2054.hwe.vcf
/share/app/bcftools/1.11/bin/bcftools index china1976_G1K2054/All.china1976_G1K2054.hwe.vcf.gz

### plink prune
/ldfssz1/ST_BIGDATA/USER/huangfei/software/bin/plink --vcf /jdfssz1/ST_BIGDATA/USER/chenyi/G1K/refpanel/hg38_KG_chinese_af0.05/china1976/All.china1976.hwe.vcf.gz --set-missing-var-ids @:# --indep-pairwise 50 10 0.5 --out china1976
### plink pca
/ldfssz1/ST_BIGDATA/USER/huangfei/software/bin/plink --vcf /jdfssz1/ST_BIGDATA/USER/chenyi/G1K/refpanel/hg38_KG_chinese_af0.05/china1976/All.china1976.hwe.vcf.gz --set-missing-var-ids @:# --extract /jdfssz1/ST_BIGDATA/USER/chenyi/G1K/refpanel/hg38_KG_chinese_af0.05/china1976/prune/china1976.prune.in --make-bed --pca --out china1976
### ADMIXTURE
for K in {1..5}; do /jdfssz1/ST_BIGDATA/USER/software/admixture_linux-1.3.0/admixture /jdfssz1/ST_BIGDATA/USER/chenyi/G1K/refpanel/hg38_KG_chinese_af0.05/china1976/pca/china1976.bed $K --cv -j4 | tee log.$K.out; done

