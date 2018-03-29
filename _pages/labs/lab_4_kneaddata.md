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

Most of the required files are distributed with the KneadData package and can be copied from the 
install directory. 

#### Creating our Workspace
Let's start off by creating a clean space to do our work from. We can create a new folder under the 
`/home/vagrant/Document/labs` directory:

```console
vagrant@biobakery:~$ cd /home/vagrant/Documents/labs
vagrant@biobakery:~/Documents/labs$ mkdir -p lab_4/db lab_4/input lab_4/output
vagrant@biobakery:~/Documents/labs$ cd lab_4/
```

#### Downloading and Extracting Input Files
All input files and database files that will be used for this lab can be downloaded to our cloud instance 
from the workshop website. 

We can use the `curl` command ([from the Unix lab]({{ 'labs/2_unix#Downloading%20Files' | prepend: site.baseurl}})) to download the input sequence files found at the following locations:

```console
vagrant@biobakery:~/Documents/labs/lab_4$ curl -O lab_4_examples.tgz https://github.com/biobakery/physalia-workshop/raw/master/data/labs/lab_4_examples.tgz
vagrant@biobakery:~/Documents/labs/lab_4$ tar xfv lab_4_examples.tgz
x database/
x database/demo_db.3.bt2
x database/demo_db.2.bt2
x database/demo_db.1.bt2
x database/demo_db.4.bt2
x database/demo_db.rev.1.bt2
x database/demo_db.rev.2.bt2
x input/
x input/demo.fastq
x output/
```

### Baseline Quality Control Statistics

It's a good idea to take a look at the baseline QC statistics for a dataset prior to diving into any more invovled QC. This can give us an idea of the quality of our sequences,
how much sequence we may stand to lose, and can influence the approach taken in downstream QC steps.

(https://www.bioinformatics.babraham.ac.uk/projects/fastqc/)[FastQC] provides us with a quick and easy way to visualize QC statistics for a sequence dataset. Launch FastQC 
by typing the `fastqc` command in the terminal:

```console
vagrant@biobakery:~/Documents/labs/lab_4$ fastqc
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

