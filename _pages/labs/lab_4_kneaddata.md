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
database/
database/demo_db.3.bt2
database/demo_db.2.bt2
database/demo_db.1.bt2
database/demo_db.4.bt2
database/demo_db.rev.1.bt2
database/demo_db.rev.2.bt2
input/
input/demo.fastq
output/
```

### Baseline Quality Control Statistics

It's a good idea to take a look at the baseline QC statistics for a dataset prior to diving into any more invovled QC. This can give us an idea of the quality of our sequences,
how much sequence we may stand to lose, and can influence the approach taken in downstream QC steps.

(https://www.bioinformatics.babraham.ac.uk/projects/fastqc/)[FastQC] provides us with a quick and easy way to visualize QC statistics for a sequence dataset. Launch FastQC 
by typing the `fastqc` command in the terminal:

```console
vagrant@biobakery:~/Documents/labs/lab_4$ fastqc
```

<img src="{{ "/assets/img/labs/lab_4_knead_fastqc_screen.png" | prepend: site.baseurl }}" alt="FastQC Splash Screen"/>

From here we can use the **File** menu to select the **Open..** option 

<img src="{{ "/assets/img/labs/lab_4_knead_fastqc_open_file.png" | prepend: site.baseurl }}" alt="FastQC Splash Screen"/>

and open our sequence file found at `/home/vagrant/Documents/labs/lab_4/input/sequences.fastq`

### Running KneadData

Our input files and database files are in place so we can go ahead and run KneadData now. We can take a peek at all the available options by invoking KneadData with the `--help` option:

```console
vagrant@biobakery:~/Documents/labs/lab_4$ kneaddata --help
usage: kneaddata [-h] [--version] [-v] -i INPUT -o OUTPUT_DIR
                 [-db REFERENCE_DB] [--bypass-trim]
                 [--output-prefix OUTPUT_PREFIX] [-t <1>] [-p <1>]
                 [-q {phred33,phred64}] [--run-bmtagger] [--run-trf]
                 [--run-fastqc-start] [--run-fastqc-end] [--store-temp-output]
                 [--remove-intermediate-output] [--cat-final-output]
                 [--log-level {DEBUG,INFO,WARNING,ERROR,CRITICAL}] [--log LOG]
                 [--trimmomatic TRIMMOMATIC_PATH] [--max-memory MAX_MEMORY]
                 [--trimmomatic-options TRIMMOMATIC_OPTIONS]
                 [--bowtie2 BOWTIE2_PATH] [--bowtie2-options BOWTIE2_OPTIONS]
                 [--no-discordant] [--cat-pairs] [--reorder] [--serial]
                 [--bmtagger BMTAGGER_PATH] [--trf TRF_PATH] [--match MATCH]
                 [--mismatch MISMATCH] [--delta DELTA] [--pm PM] [--pi PI]
                 [--minscore MINSCORE] [--maxperiod MAXPERIOD]
                 [--fastqc FASTQC_PATH]
...
```

The software allows for a good amount of control over each step but at minimum we need to 
pass it the **input**, **output**, and **reference-db** options. For this example we will also 
be passing some bowtie2 options using the **bowtie2-options** parameter (which can be specified multiple times for passing more than one option to bowtie2):

```console
vagrant@biobakery:~/Documents/labs/lab_4$ kneaddata --input input/ERR550644_1.fastq.gz \
--output output/ERR550644_1 \
--reference-db database/demo_db --bowtie2-options="--very-fast" \
--bowtie2-options="-p 2"
Decompressing gzipped file ...

Initial number of reads ( /home/vagrant/Documents/labs/lab_4/output/ERR550644/decompressed_OCsbxP_ERR550644_1.fastq ): 500989
Running Trimmomatic ...
Total reads after trimming ( /home/vagrant/Documents/labs/lab_4/output/ERR550644/ERR550644_1_kneaddata.trimmed.fastq ): 328961
Decontaminating ...
Running bowtie2 ...
	Total reads after removing those found in reference database ( /home/vagrant/Documents/labs/lab_4/output/ERR550644/ERR550644_1_kneaddata_demo_db_bowtie2_clean.fastq ): 328961
Total reads after merging results from multiple databases ( /home/vagrant/Documents/labs/lab_4/output/ERR550644/ERR550644_1_kneaddata.fastq ): 328961

Final output file created:
/home/vagrant/Documents/labs/lab_4/output/ERR550644/ERR550644_1_kneaddata.fastq
```

KneadData provides us with some very brief summary information during the run indicating the steps completed as well as the number of reads surviving at each point.

Let's explore the outputs from the run to get a better idea of our sequence quality post-KneadData
and some of the sequences removed that may be of interest.

### KneadData Outputs

#### KneadData Log File

#### Contaminated Sequences

### Visualizing the Outputs using FastQC

