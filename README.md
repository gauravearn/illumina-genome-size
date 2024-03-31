# illumina-genome-size
estimation of the genome size for the illumina reads, only for the pre-screening purposes. if you have multiple illumina reads from the miseq, nextseq, and other illumina platform a short function to estimate the genome size. You can also write using the pillow library in python but i want to write today R. If you want me to write in python then leave a comment. 

You simply have to give the fastq reads directory path and it will output calling a R function with publication ready figures.

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
    image_path[i] <- paste0(getwd(),"/",list.files(path=".", pattern="*.png")[i])
    a <- image_path[1]
    b <- image_path[2]
    c <- image_path[3]
    d <- image_path[4]
    image_write(image_append(c(a,b,c,d), stack=TRUE), "genome_estimation.png")
}
}
```
Gaurav Sablok \
Academic Staff Member \
Bioinformatics \
Institute for Biochemistry and Biology \
University of Potsdam \
Potsdam,Germany 
