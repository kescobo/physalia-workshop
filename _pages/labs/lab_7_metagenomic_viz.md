---
layout: default
title: "Lab #7 - Metagenomic Visualizations"
lab_num: 7
permalink: /labs/7_metagenomic_viz
is_lab: true
custom_css: tocbot
custom_js: 
    - tocbot.min
    - labs
---


# Metagenomic visualizations in R

Start from a clean environment, set your working directory and load the data.

```R
rm(list=ls())
setwd(/path_to_your_directory)
```

```R
load(file="Data/metaphlan_merged_MGX_species_relAb.Rdata")
```

* Inspect the data. 
* How many patients are included in this dataset?
* How many of them have CD, UC and non-IBD?
* How old are patients on average?
* From which cohorts do they come from?



#### Load the packages that we will need for the tutorial. (Install them if necessary.)

```R
library(vegan)
library(ggplot2)
library(grid)
```

## 1. Visualization techniques: PCoAs and Biplots of microbial species data

### Prepare the data

* Extract the metadata

```R
metadata=data.frame(t(data[1:7,]))
metadata$GID = factor(rownames(metadata),levels=unique(rownames(metadata)))
metadata[1:4,] # check the output
```


* Extract species data

```R
species<-t(data[8:nrow(data),])
species=apply(species,c(1,2),function(x) as.numeric(as.character(x)))

species[1:4,1:4] # check the output
```


### Ordination: PCoA with Bray-Curtis distance
```R
data.bray=vegdist(species)
data.b.pcoa=cmdscale(data.bray,k=(nrow(species)-1),eig=TRUE)

str(data.b.pcoa)
```

How do you extract the information for the first two PCs? What if you want to plot the third and forth PC?

```R
pcoa = data.frame(PC1 = data.b.pcoa$points[,1], PC2 = data.b.pcoa$points[,2])
```

Plot the samples!

```R
p = ggplot(pcoa, aes(x=PC1, y=PC2)) + geom_point(size=4) + theme_bw()
p
```

#### Adding additional information to the plot: colours and shapes

Which metadata would be interesting to include in the plot?

```R
pcoa$individual = metadata$Participant_ID

pcoa$diagnosis = metadata$Diagnosis
pcoa$diagnosis = factor(pcoa$diagnosis, levels= c("CD", "UC", "non-IBD"))

pcoa$cohort = metadata$Cohort

pcoa$time_point = gsub("C","",metadata$Time_point)

head(pcoa) # check the data.frame
```

#### Colour by diagnosis

```R
p = ggplot(pcoa, aes(x=PC1, y=PC2, color=diagnosis)) + geom_point(size=4) + theme_bw()
p
```

Use your own colour scheme and add a legend title.

```R
my_col_diagnosis = c('non-IBD'='darkseagreen3','CD'='orangered2','UC'='orange2')
```

```R
p = ggplot(pcoa, aes(x=PC1, y=PC2, color=diagnosis)) + geom_point(size=4) + theme_bw()
p = p + scale_colour_manual(values=my_col_diagnosis) 
p = p + guides(col=guide_legend(title="Diagnosis"))
p
```

#### Exercise: Display diagnosis as a shape instead!

<!-- p = ggplot(pcoa, aes(x=PC1, y=PC2, shape=diagnosis)) + geom_point(size=4) + theme_bw()
p = p + guides(shape=guide_legend(title="Diagnosis"))
p
-->

How can you choose the type of shapes displayed?

```R
p = p + scale_shape_manual(values=c(23,22,19)) 
p
```

#### Highlight inter-individual variation: Colour by individual

How many participants are there and how many time points per participant?

```R
length(pcoa$individual)
occurrence = table(pcoa$individual)
print(occurrence)
```

There are too many participants to assign each one its own colour. Therefore we will only highlight samples from participants with more than 6 time points. For this we will create a new colour variable and add it to the data.frame.

We can do this with a for loop:

```R
longitudinal_colour=NA # set up the variable

# loop through each entry in the pcoa data.frame
for(i in 1:length(pcoa$individual)){
  # if the individual has less than 6 time points, assign the variable the value "Short"
  if(occurrence[pcoa$individual[i]]<6){
    longitudinal_colour[i]="Short"
  }
  else{
    # Otherwise use the participant ID
    longitudinal_colour[i]=as.character(pcoa$individual[i])
  }
}
```

Check the output!

```R
table(longitudinal_colour)
length(table(longitudinal_colour))
```

For loops are not very effective in R. A better way to do this is by using sapply.

```R
?sapply
```

#### Excercise: Create the colour varialbe using sapply. Check that the resulting variable is identical to the one we just created with the for loop.

<!---
longitudinal_colour_v2=NA
longitudinal_colour_v2 = sapply(pcoa$individual, function(x) if(occurrence[x]<6){"Short"}else{longitudinal_colour[i]=as.character(x)})


### check that the result is the same
longitudinal_colour == longitudinal_colour_v2
sum(longitudinal_colour != longitudinal_colour_v2)
--->


Add the colour variable as a new column to the data.frame.

```R
pcoa$longitudinal_colour = longitudinal_colour

pcoa$longitudinal_colour = factor(pcoa$longitudinal_colour, levels=c(unique(pcoa$longitudinal_colour)[grep("Short",unique(pcoa$longitudinal_colour), invert=T)], "Short"))
```


Choose a colour scheme (```my_col_individual = ...```) and update the plot! (Tip: look at http://colorbrewer2.org/). Also add a plot title with formatting.

<!-- my_col_individual = c("#BF4D4D", "#BF864D", "#BFBF4D", "#86BF4D", "#4DBF4D", "#4DBF86", "#4DBFBF", "#4D86BF", "#4D4DBF", "#864DBF", "#BF4DBF", "#BF4D86")
-->
 

```R
p = ggplot(pcoa, aes(x=PC1, y=PC2, color=longitudinal_colour)) + geom_point(aes(shape=pcoa$diagnosis),size=4) + theme_bw()

p = p + scale_colour_manual(values=c(my_col_individual, "grey80"), breaks=c("Short",unique(longitudinal_colour)[grep("CS",unique(longitudinal_colour), invert=T)]))

p = p + guides(col=guide_legend(ncol=3,title="Individual"),shape=guide_legend(title="Diagnosis"))

p = p + ggtitle("PCoA with Bray-Curtis at species level") + theme(axis.title.x=element_blank(),axis.title.y=element_blank(),plot.title = element_text(size = 15, hjust=0.5, face = "bold"))

# adding an x- and y-intercept
p = p + geom_hline(yintercept=0,linetype="dashed", colour="grey") + geom_vline(xintercept=0,linetype="dashed", colour="grey")

p
```

Save your output as a pdf.

```R
pdf(file="Biplot_part1.pdf", colormodel="rgb", width=10, height=7)
p
dev.off()
```


#### Adding time course information for some individuals

Next we will connect all sample from a particular patient and add time point numbers to the plot.

```R
patient1="H4001"

PointsP1=pcoa[pcoa$individual==patient1,]

PointsP1 = PointsP1[order(as.numeric(as.character(PointsP1$time_point))),]

PointsP1$time_point = factor(PointsP1$time_point,levels=unique(PointsP1$time_point))
```

How can you add this information to the plot? Tip: use ``` geom_path()``` and ```geom_text()``` to add an additional layer.

```R
p = p + geom_path(data=PointsP1)

p = p + geom_text(data=PointsP1, mapping=aes(x=PC1, y=PC2, label=time_point), size=3,color='black')

p
```


#### Excercise: Add time courses for 3 more participants!

<!---
patient2="C3001"
PointsP2=pcoa[pcoa$individual==patient2,]
PointsP2 = PointsP2[order(as.numeric(as.character(PointsP2$time_point))),]
PointsP2$time_point = factor(PointsP2$time_point,levels=unique(PointsP2$time_point))

patient3="M2008"
PointsP3=pcoa[pcoa$individual==patient3,]
PointsP3 = PointsP3[order(as.numeric(as.character(PointsP3$time_point))),]
PointsP3$time_point = factor(PointsP3$time_point,levels=unique(PointsP3$time_point))

patient4="C3013"
PointsP4=pcoa[pcoa$individual==patient4,]
PointsP4 = PointsP4[order(as.numeric(as.character(PointsP4$time_point))),]
PointsP4$time_point = factor(PointsP4$time_point,levels=unique(PointsP4$time_point))



p = p + geom_path(data=PointsP2) + geom_path(data=PointsP3) + geom_path(data=PointsP4) 
p = p + geom_text(data=PointsP2, mapping=aes(x=PC1, y=PC2, label=time_point), size=3,color='black')
p = p + geom_text(data=PointsP3, mapping=aes(x=PC1, y=PC2, label=time_point), size=3,color='black')
p = p + geom_text(data=PointsP4, mapping=aes(x=PC1, y=PC2, label=time_point), size=3,color='black')
p
--->

Save your output as a new plot.

```R
pdf(file="Biplot_part2.pdf", width=10, height=7)
p
dev.off()
```



### Biplots: Add species information to the PCoA

Now we want to turn this into a biplot and indicate which species are driving the variation in the taxonomic composition by using the *Weighted Averages Scores for Species*: wascores()


```R
?wascore

data.wa=data.frame(wascores(data.b.pcoa$points[,1:2],species))

head(data.wa)
```

There are too many species to add all of them to the plot.

```R
# Save the PCoA that we previously created, without the time course information
my_col_individual = c("#BF4D4D", "#BF864D", "#BFBF4D", "#86BF4D", "#4DBF4D", "#4DBF86", "#4DBFBF", "#4D86BF", "#4D4DBF", "#864DBF", "#BF4DBF", "#BF4D86")

p = ggplot(pcoa, aes(x=PC1, y=PC2, color=longitudinal_colour)) + geom_point(aes(shape=pcoa$diagnosis),size=4) + theme_bw()

p = p + scale_colour_manual(values=c(my_col_individual, "grey80"), breaks=c("Short",unique(longitudinal_colour)[grep("CS",unique(longitudinal_colour), invert=T)]))

p = p + guides(col=guide_legend(ncol=3,title="Individual"),shape=guide_legend(title="Diagnosis"))

p = p + ggtitle("PCoA with Bray-Curtis at species level") + theme(axis.title.x=element_blank(),axis.title.y=element_blank(),plot.title = element_text(size = 15, hjust=0.5, face = "bold"))

p = p + geom_hline(yintercept=0,linetype="dashed", colour="grey") + geom_vline(xintercept=0,linetype="dashed", colour="grey")

p
```

Only add the species furthest away from the origin to the plot.

```R
data.wa.sub = data.wa[which(abs(data.wa$X1)>0.2 | abs(data.wa$X2)>0.2),]

p_biplot = p

p_biplot = p_biplot + coord_fixed() + geom_text(data=data.wa.sub, aes(x = data.wa.sub$X1, y = data.wa.sub$X2, label = rownames(data.wa.sub)), colour="darkblue", size = 3)

p_biplot
```


#### Adding specific species to the plot

```R
list=c("s__Collinsella_intestinalis",                     
       "s__Eggerthella_lenta",                
       "s__Bacteroides_thetaiotaomicron",      
       "s__Paraprevotella_xylaniphila",       
       "s__Prevotella_copri",                  
       "s__Alistipes_senegalensis",                  
       "s__Enterococcus_faecalis",               
       "s__Clostridium_clostridioforme",       
       "s__Clostridium_hylemonae",             
       "s__Clostridium_scindens",             
       "s__Clostridiales_bacterium_1_7_47FAA", 
       "s__Butyrivibrio_crossotus",            
       "s__Coprococcus_catus",                              
       "s__Ruminococcus_callidus",             
       "s__Catenibacterium_mitsuokai",         
       "s__Eubacterium_dolichum",                       
       "s__Acidaminococcus_fermentans",        
       "s__Megamonas_rupellensis",                            
       "s__Fusobacterium_ulcerans")

data.wa.sub = data.wa[list,]

# formatting the species names
rownames(data.wa.sub)=gsub("_"," ",gsub("s__","",list))

p_biplot = p

p_biplot = p_biplot + coord_fixed() + geom_text(data=data.wa.sub, aes(x = data.wa.sub$X1, y = data.wa.sub$X2, label = rownames(data.wa.sub)), colour="darkblue", size = 3)

p_biplot
```

Save the plot to a pdf:

```R
pdf(file="Biplot_part3.pdf", colormodel="rgb", width=10,height=7)
p_biplot
dev.off()
```




## 2. Visualization techniques: Scatterplots and alpha diversity

We will use a subset of the MetaCyc metabolic pathways (based on HUMAnN2) from the 78 samples that were part of the HMP2 pilot study and compare DNA versus RNA alpha diversity (Gini-Simpson index) from MetaCyc metabolic pathways. We will only consider pathways that were detected in both data types.

Set up the environment and load the packages.

```R
rm(list=ls())

setwd("/Users/melanie/R_tutorial")

library(ggplot2)
library(vegan)
library(ggrepel)
```

Load the data.

```R
# MTX_pwys
load(file="Data/lab_7_MTX_pwys.Rdata")
# MGX_pwys
load(file="Data/lab_7_MGX_pwys.Rdata")
# DNA/RNA ratio of pathways
load(file="Data/lab_7_ratio_pwys.Rdata")
```

Inspect the output. How many microbial organisms contributed to the first pathway in the metagenomic and metatranscriptomic data?

<!---
head(MGX_pwys[,1:2], n=30)
-->

What does the stratification "unclassified" mean?

#### Create a list of all pathways that were detected in the metagenomic and metatranscriptomic data, respectively. How many are there? ```grep``` the pathway totals

#### Metagenomic data

```R
MGX_pwy_lst_all = unique(gsub("\\|.*", "", MGX_pwys$Pathway))

MGX_pwy_lst = MGX_pwy_lst_all[intersect(grep("UNMAPPED", MGX_pwy_lst_all, invert=T), grep("UNINTEGRATED", MGX_pwy_lst_all, invert=T))]

length(MGX_pwy_lst)
```

#### Metatranscriptomic data

```R
MTX_pwy_lst_all = unique(gsub("\\|.*", "", MTX_pwys$Pathway))

MTX_pwy_lst = MTX_pwy_lst_all[intersect(grep("UNMAPPED", MTX_pwy_lst_all, invert=T), grep("UNINTEGRATED", MTX_pwy_lst_all, invert=T))]

length(MTX_pwy_lst)
```


### Compute alpha diversity for each pathway in each sample

We will define a function that we can apply to the metagenomic and metatranscriptomic data:

```R
filtered_alpha_div <- function(p=1, data_pwys = MGX_pwys, data_pwy_lst = MGX_pwy_lst){
  #p=1
  #print(MGX_pwy_lst[p])
  
  ### extract the stratified output for this pathway
  ### take care of special characters in the pathway names
  data_stratified = data_pwys[grep(gsub("\\-","\\.",gsub("\\+", "\\.", gsub("\\[","\\.",gsub("\\]","\\.",gsub("\\(","\\.", gsub("\\)","\\.",data_pwy_lst[p])))))), data_pwys$Pathway),]
  #data_stratified[,1:3]
  
  # save the pathway name
  pwy_name = as.character(data_stratified[1,1])
  
  ### extract the stratified output for this pathway
  rownames(data_stratified) = data_stratified[,1]
  data_stratified = data_stratified[-1,-1]
  
  ### The contribution by unclassified organisms is not considered for the alpha-diversity measurements. Exclude "unclassified".
  data_stratified = data_stratified[grep("unclassified", rownames(data_stratified), invert=T),] 
  
  ### Compute alpha diversity
  
  # Are there other species contributing to this pathway (besides "unclassified")?
  if(nrow(data_stratified)>0){
    ### convert to relative abundances within this pathway
    data_stratified_rel= apply(data_stratified, 2, function(x) x/sum(x))
    data_stratified_rel[is.na(data_stratified_rel)]=0
    
    # if the pwy is contributed by one species: was the pwy present (>0) or not?
    if(nrow(data_stratified)==1){
      my_output = sapply(data_stratified_rel, function(x) if(sum(x)>0){ 0}else{-1})
    }else{
      # if pwy is contributed by multiple species
      my_output = apply(data_stratified_rel, 2, function(x) if(sum(x)>0){ diversity(x, index="simpson")}else{-1})
    }
    
  }else{
    my_output = as.vector(rep(-1, ncol(MGX_pwys)-1))   ## pathway entirely contributed by "unclassified"
  }

  return(my_output)
}  
```


First apply this to the metagenomic data. Create a data matrix: each column is a sample and each row specifies the alpha diversity of a particular pathway.

Set up the matrix:

```R
MGX_a_div=matrix(NA, nrow=length(MGX_pwy_lst) ,ncol=ncol(MGX_pwys)-1)    #Why -1? The first column contains the pwy names.    

rownames(MGX_a_div)=seq(1,length(MGX_pwy_lst))

colnames(MGX_a_div)=colnames(MGX_pwys)[-1]
```

Apply the function:

```R
MGX_a_div = t(sapply(seq(1,length(MGX_pwy_lst)), function(p) filtered_alpha_div(p, data_pwys = MGX_pwys, data_pwy_lst = MGX_pwy_lst)))

rownames(MGX_a_div)= sapply(seq(1,length(MGX_pwy_lst)), function(p) as.character(MGX_pwy_lst[p]))

nrow(MGX_a_div)
```


Remove rows that are all "-1" and are all contributed by "unclassified"

```R
MGX_a_div = MGX_a_div[apply(MGX_a_div, 1, function(x) sum(x==-1)!=ncol(MGX_a_div)),]

nrow(MGX_a_div)
```


Now apply this to the metatranscriptomic data.

Set up the matrix:

```R
MTX_a_div=matrix(NA, nrow=length(MTX_pwy_lst) ,ncol=ncol(MTX_pwys)-1)    #Why -1? The first column contains the pwy names.    

rownames(MTX_a_div)=seq(1,length(MTX_pwy_lst))

colnames(MTX_a_div)=colnames(MTX_pwys)[-1]
```

Apply the function:

```R
MTX_a_div = t(sapply(seq(1,length(MTX_pwy_lst)), function(p) filtered_alpha_div(p, data_pwys = MTX_pwys, data_pwy_lst = MTX_pwy_lst)))

rownames(MTX_a_div)= sapply(seq(1,length(MTX_pwy_lst)), function(p) as.character(MTX_pwy_lst[p]))

nrow(MTX_a_div)
```

#Remove rows that are all "-1" and are all contributed by "unclassified"

```R
MTX_a_div = MTX_a_div[apply(MTX_a_div, 1, function(x) sum(x==-1)!=ncol(MTX_a_div)),]

nrow(MTX_a_div)
```



<!---Pathways, where more than 25% of the pathway was attributed to unclassified organisms in more than 25% of the samples, were excluded. 
-->

Now we will compute the mean alpha-diversity taking all samples into account where the pathway was detected in at least 20% of the samples (i.e. 16 samples).

Set the threshold:
```R
my_presence_threshold = round(0.2 * ncol(MGX_a_div))
``` 

Subset data.frmae and compute alpha diversity for metagenomic data:

```R
MGX_a_div_sub = MGX_a_div[rowSums(!MGX_a_div < 0) > my_presence_threshold,]

#### average alpha diversity computed over all dataset
summary_MGX_a_div = 0
summary_MGX_a_div = apply(MGX_a_div_sub, 1, function(x) mean(x[x>=0]))
```

Subset data.frmae and compute alpha diversity for metatranscriptomic data:

```R
MTX_a_div_sub = MTX_a_div[rowSums(!MTX_a_div < 0) > my_presence_threshold,]

#### average alpha diversity computed over all dataset
summary_MTX_a_div = 0
summary_MTX_a_div = apply(MTX_a_div_sub, 1, function(x) mean(x[x>=0]))
```


### Alpha diversity plots

We will compare the mean alpha-diversity for each pathway on the RNA level (y-axis) and DNA level (x-axis). Each point will represents one pathway and the color will indicates the mean RNA/DNA ratio across all samples on a log scale.


Which pathways are detected on DNA & RNA level?

```R
pwy_detected = intersect(names(summary_MTX_a_div), names(summary_MGX_a_div))

data_all = data.frame(RNA = summary_MTX_a_div[names(summary_MTX_a_div) %in% pwy_detected], DNA = summary_MGX_a_div[names(summary_MGX_a_div) %in% pwy_detected])
```

Now we can start creating the alpha diversity plot:

```R
g = ggplot(data_all, aes(y=RNA, x=DNA)) + geom_point(colour="dodgerblue", size=5) + theme_bw()
```

Add formatting: Intercepts, axis titles, plot title, legends, ...

```R
g = g +  geom_abline(intercept=0, slope=1, colour="grey")

g = g + xlab("DNA\n") + ylab("\nRNA") + ggtitle("Alpha-diversity of pathway stratification") 

g = g + theme(plot.title = element_text(size = 16, face = "bold", hjust=0.5),axis.title.x = element_text(size = 15), axis.title.y = element_text(size = 15))

g = g + guides(size=guide_legend(title="Log mean\nRNA/DNA ratio"), colour=F) 

g
```

Save the plot.

```R
pdf(file="AlphaDiv_DNA_vs_RNA_simple.pdf", width=5, height=5)
g
dev.off()
```

### Now we want to colour the points by the log DNA/RNA ratio of each pathway.

Create variable that reflects the dna/rna ratio

* subset ratio data.frame

```R
ratio_pwys_sub = ratio_pwys[rownames(ratio_pwys) %in% pwy_detected, ]
nrow(ratio_pwys_sub)
```
* Create a new column with the DNA/RNA ration of each pathway.

```R
data_all$mean_ratio = sapply(rownames(data_all), function(x) mean(t(ratio_pwys_sub[which(rownames(ratio_pwys_sub) == x),])))
```

* Take the log of the ratio.

```R
data_all$log_mean_ratio = sapply(data_all$mean_ratio, function(x) log(mean(x)))
```


Add colouring to the previous plot:

```R
g = ggplot(data_all, aes(y=RNA, x=DNA, colour=log_mean_ratio)) + geom_point(size=5) + theme_bw()

g = g +  geom_abline(intercept=0, slope=1, colour="grey")

g = g + xlab("DNA\n") + ylab("\nRNA") + ggtitle("Alpha-diversity of pathway stratification") 

g = g + theme(plot.title = element_text(size = 16, face = "bold", hjust=0.5),axis.title.x = element_text(size = 15), axis.title.y = element_text(size = 15), legend.position=c(0.2,0.75), legend.background=element_rect(colour="grey"), legend.title=element_text(size=12), legend.text=element_text(size=12), legend.text.align=1)

g = g + guides(colour=guide_legend(title="Log mean\nRNA/DNA ratio")) 

g = g + scale_colour_gradient(low="blue",high="red")

g
```

Save the plot:

```R
pdf(file="AlphaDiv_DNA_vs_RNA.pdf", width=5, height=5)
g
dev.off()
```








