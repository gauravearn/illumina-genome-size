# prescreening_illumina_reads_genome_size
a workflow for the estimation of the genome size for the illumina reads, only for the pre-screening purposes. if you have multiple illumina reads from the miseq, nextseq, and other illumina platform a short function to estimate the genome size. You can also write using the pillow library in python but i want to write today R. If you want me to write in python then leave a comment. 

You simply have to give the fastq reads directory path and it will output calling a R function with publication ready figures.

```
#!/usr/bin/env bash
# -*- coding:  utf-8 -*-
# Author: Gaurav Sablok
# date: 2023-10-23
# estimating the genome size from the illumina reads for the pre-estimation of the genome size
#wrote a custom function in R which will also stack your images and will give you a final publication ready image.

read -r -p "please provide the directory containing the fastq reads:": fastqreads
read -r -p "please provide the path for the jellyfish:": jellyfish
if [[ $jellyfish ]]
then
    read -r -p "please select the option for the jellyfish either histogram or the database:": option
    read -r -p "please provide the overlap for the jellyfish histogram:": overlap
fi
read -r -p "please provide the species name for the jellyfish:": speciesname
read -r -p "please provide the number of threads you want to specify:": threads
read -r -p "please provide the kmer that you want to choose for the species abundance:": kmer
read -r -p "please provide the memory size allocation for the jellyfish estimation:": memory
read -r -p "please provide the coverage if the maximum coverage is not provided then it will add the 100
            using the mathematical expression to the minimum coveage and will estimate:": coverage
if [[ -f "${jellyfish}" ]]
then
    echo "jellyfish is present for the genome size estimation"
else
    conda create -n genomesize -y && conda install -n genomesize python=3.11 -y
    conda activate genomesize
    conda install jellyfish
    pip install KrATER
    conda deactivate
fi 
    echo "finish installing the environment and the dependencies"
if [[ -z $kmer ]] && [[ -z $speciesname ]]
then 
    echo "sorry these parameters are needed for the pipeline and please provide these"
fi
conda activate genomesize
for i in "${fastqreads}"/*gz; 
    do 
        gunzip "${i}"
    done
cat *.R1.fastq >> "${speciesname}".R1.fastq
cat *.R2.fastq >> "${speciesname}".R2.fastq
mkdir "${fastqreads}"/final_reads
mkdir "${fastqreads}"/final_reads/genomeplots
mv *.fastq "${fastqreads}"/final_reads
if [[ $jellyfish = "" ]]
then
cd "${fastqreads}"/final_reads
draw_kmer_distribution_from_fastq.py -m "${kmer}" -t "${threads}" -b -s "${memory}" \
                                    -e png -o "${speciesname}" -i "${speciesname}".R1.fastq, \
                                                            "${speciesname}".R2.fastq -g "${coverage}"
    cp -r *.png "${fastqreads}/final_reads/genomeplots"
elif [[ $jellyfish ]] && [[ $option == "histo" ]]
then
     jellyfish count -m "${overlap}" -s "${memory}" -t "${threads}" \
                     -o "${speciesname}".jf -C "${speciesname}".R1.fastq, "${speciesname}".R2.fastq | \
                                                            "${speciesname}".jf > "${speciesname}".counts.txt
     jellyfish hito -o "{speciesname}".histo -t "${threads}" -l 1 \
                                                -h 100000000 -i 1 "${speciesname}".counts.txt
     draw_kmer_distribution_from_histo.py -o "${speciesname}" \
                                -w "${coverage}" -g "${((${coverage}+100))}" -e png
     cp -r *.png "${fastqreads}/final_reads/genomeplots"
elif [[ $jellyfish ]] && [[ $option == "database" ]]
then
     draw_kmer_distribution_from_jf_db.py -i "${speciesname}".jf  -o "${speciesname}" \
                                                    -w "${coverage}" -g "${((${coverage}+100))}"
     cp -r *.png "${fastqreads}/final_reads/genomeplots"
fi 
    echo "finished making the genome size estimation and the plots are present in the following directory"
    echo "${fastqreads}/final_reads/genomeplots"

# source the R function
#!/usr/bin/R
# -*- coding:  utf-8 -*-
# Author: Gaurav Sablok
# date: 2023-10-23
stacking_option <- function(){
    library(dplyr)
    library(magick)
image_path <- character(length(list.files(path=".", pattern="*.png")))
for (i in seq_along(list(path=".", pattern="*.png"))){
    image_path[i] <- paste0(getwd(),list.files(path=".", pattern="*.png")[i])
    a <- image_path[1]
    b <- image_path[2]
    c <- image_path[3]
    d <- image_path[4]
    image_write(image_append(c(a,b,c,d), stack=TRUE), "genome_estimation.png")
}
}
```

Gaurav Sablok \
ORCID: https://orcid.org/0000-0002-4157-9405 \
WOS: https://www.webofscience.com/wos/author/record/C-5940-2014 \
RubyGems Published: https://rubygems.org/profiles/sablokgaurav \
Python Packages Published : https://pypi.org/user/sablokgaurav/
