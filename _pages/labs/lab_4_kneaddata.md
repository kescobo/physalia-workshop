---
layout: default
title: "Lab #4 - KneadData"
permalink: /labs/4_kneaddata
is_lab: true
custom_css: tocbot
custom_js: 
    - tocbot.min
    - labs
---

# KneadData

**The goal of this lab is to become familiar with QC'ing metagenomic data using 
KneadData.** 

### Lab Setup

Before we can start using KneadData we are going to want to grab all the necessary input files
and databases required for the lab.

#### Creating our Workspace
Let's start off by creating a clean space to do our work from. We can create a new folder under the 
`/home/student/labs` directory:

```bash
> cd /home/student/labs
> mkdir lab_4_kneaddata
> cd lab_4_kneaddata
```

#### Downloading Input Files

We can use the `wget` command ([from the Unix lab]({{ 'labs/2_unix#Downloading%20Files' | prepend: site.baseurl}})) to download the input sequence files found at the following locations:

* [https://biobakery.github.io/physalia-workshop/data/lab_4_inputs.tgz](https://biobakery.github.io/physalia-workshop/data/lab_4_inputs.tgz)


```bash
> wget https://biobakery.github.io/physalia-workshop/data/lab_4_inputs.tgz /home/student/labs/lab_4_kneaddata/
```

Once the file has been downloaded we can use the `tar` command to extract it:

```bash
tar xfv lab_4_inputs.tgz
<TAR OUTPUT GOES HERE>
```

### Running KneadData

```bash
> kneaddata --input demo.fastq --output kneaddata_output \
--reference-db database_folder --bowtie2-options="--very-fast" \
--bowtie2-options="-p 2"
```

### KneadData Outputs

#### KneadData Log File

#### Contaminated Sequences

### Visualizing the Outputs using FastQC

