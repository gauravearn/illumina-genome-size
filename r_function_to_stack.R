#!/usr/bin/R
# -*- coding:  utf-8 -*-
# Author: Gaurav Sablok
# date: 2023-10-23
stacking_option <- function(){
    library(dplyr)
    library(magick)
image_path <- character(length(list.files(path=".", pattern="*.png")))
for (i in seq_along(list(path=".", pattern="*.png"))){
    image_path[i] <- paste0(getwd(),"/", list.files(path=".", pattern="*.png")[i])
    a <- image_path[1]
    b <- image_path[2]
    c <- image_path[3]
    d <- image_path[4]
    image_write(image_append(c(a,b,c,d), stack=TRUE), "genome_estimation.png")
}
}
