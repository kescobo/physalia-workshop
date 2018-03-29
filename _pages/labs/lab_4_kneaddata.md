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

#### Basic Sequence Statistics

Upon loading a sequence file the first data pane we are presented with is one containing 
basic summary statistics: 

<img src="{{ "/assets/img/labs/lab_4_knead_fastqc_base_stats.png" | prepend: site.baseurl }}" alt="FastQC: ERR550644_1 Basic Sequence Stats"/>

Allows us to take a quick glance at our sequences and see if anything is very readily wrong with it.

#### Per-base Sequence Quality

The per base sequence quality pane gives us an overview of the range of quality values across all 
bases at each position in our input sequence file.

<img src="{{ "/assets/img/labs/lab_4_knead_fastqc_per_base_qual.png" | prepend: site.baseurl }}" alt="FastQC: ERR550644_1 Per-base Sequence Quality"/>

A box and whisker plot is drawn for each base-pair position showing the various measures describing the distribution of quality scores.

The graph is divided along the Y into t hree separate areas demarcating <span style="color: green">good</span>, <span style="color: orange">questionable</span> and <span style="color: red">poor</span> quality calls. 

Questionable or poor quality scores are an issue that is readily addressable by KneadData (utilizing Trimmomatic).

#### Per-base Sequence Content

The distribution of each nucleotide is provided in the per base sequence content pane.

<img src="{{ "/assets/img/labs/lab_4_knead_fastqc_per_base_content.png" | prepend: site.baseurl }}" alt="FastQC: ERR550644_1 Per-base Sequence Quality"/>

In an ideal world no bias for any of the bases would exist over others but in the real world it is 
not uncommon to see imbalances here (particularly at the ends of the sequence).

#### Overrepresented Sequence, Adapter Content, and Kmer Content

<!-- Should we generate a dataset that has some adapter contamination here to demonstrate how we chop it off using KneadData? -->

In the case that we are working with a dataset that has some sort of adapter contamination (most of them)we would expect to see FastQC flagging our sequences in one of the Overrepresented Sequence, Adapter Content, and/or Kmer Content panes. 

<img src="{{ "/assets/img/labs/lab_4_knead_fastqc_kmer_content.png" | prepend: site.baseurl }}" alt="FastQC: ERR550644_1 Kmer Content"/>

Generally well known adapters (Illumina, Nextera, TruSEQ) are caught in the Adapter Content pane (*example from Human Microbiome 2 project*):

<img src="{{ "/assets/img/labs/lab_4_knead_fastqc_adapter_content.png" | prepend: site.baseurl }}" alt="FastQC: ERR550644_1 Kmer Content"/>

If any adatper contamination is identified by any of the methods FastQC uses we can use this information to tell KneadData to trim a specific set of adapters. A custom set of adapters can also be provided in more unique situations.

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

KneadData produces at mininimum four primary output files when running a single-ended dataset (this number will increase when dealing with a paired-end dataset).

```console
vagrant@biobakery:~/Documents/labs/lab_4$ cd output/ERR550644/
vagrant@biobakery:~/Documents/labs/lab_4/output/ERR550644$ ls -l
total 341760
-rw-rw-r-- 1 vagrant vagrant         0 Mar 29 13:51 ERR550644_1_kneaddata_demo_db_bowtie2_contam.fastq
-rw-rw-r-- 1 vagrant vagrant 174971618 Mar 29 13:51 ERR550644_1_kneaddata.fastq
-rw-rw-r-- 1 vagrant vagrant      5594 Mar 29 13:51 ERR550644_1_kneaddata.log
-rw-rw-r-- 1 vagrant vagrant 174971618 Mar 29 13:51 ERR550644_1_kneaddata.trimmed.fastq
```
#### KneadData Log File

The KneadData log file provides us with some of the same output information we see printed to the screen
when the software is running in addition to much more logging and debugging information. 

```console
03/29/2018 01:51:06 PM - kneaddata.knead_data - INFO: Running kneaddata v0.6.1
03/29/2018 01:51:06 PM - kneaddata.knead_data - INFO: Output files will be written to: /home/vagrant/Documents/labs/lab_4/output/ERR550644
03/29/2018 01:51:06 PM - kneaddata.knead_data - DEBUG: Running with the following arguments:
verbose = False
bmtagger_path = None
minscore = 50
bowtie2_path = /home/vagrant/.linuxbrew/bin/bowtie2
maxperiod = 500
no_discordant = False
serial = False
fastqc_start = False
bmtagger = False
cat_final_output = False
log_level = DEBUG
log = /home/vagrant/Documents/labs/lab_4/output/ERR550644/ERR550644_1_kneaddata.log
max_memory = 500m
```

The first section of the log file contains the version of KneadData being run and all of the 
options provided to the software. This will include all the default settings so we will see 
many more options than the ones we provided on the command-line here.

```console
03/29/2018 01:51:06 PM - kneaddata.utilities - INFO: Decompressing gzipped file ...
03/29/2018 01:51:09 PM - kneaddata.utilities - INFO: Decompressed file created: /home/vagrant/Documents/labs/lab_4/output/ERR550644/decompressed_OCsbxP_ERR550644_1.fastq
03/29/2018 01:51:09 PM - kneaddata.utilities - INFO: READ COUNT: raw single : Initial number of reads ( /home/vagrant/Documents/labs/lab_4/output/ERR550644/decompressed_OCsbxP_ERR550644_1.fastq ): 500989
03/29/2018 01:51:09 PM - kneaddata.utilities - DEBUG: Checking input file to Trimmomatic : /home/vagrant/Documents/labs/lab_4/output/ERR550644/decompressed_OCsbxP_ERR550644_1.fastq
03/29/2018 01:51:09 PM - kneaddata.utilities - INFO: Running Trimmomatic ...
03/29/2018 01:51:09 PM - kneaddata.utilities - INFO: Execute command: java -Xmx500m -d64 -jar /home/vagrant/.linuxbrew/bin/trimmomatic-0.33.jar SE -threads 1 -phred33 /home/vagrant/Documents/labs/lab_4/output/ERR550644/decompressed_OCsbxP_ERR550644_1.fastq /home/vagrant/Documents/labs/lab_4/output/ERR550644/ERR550644_1_kneaddata.trimmed.fastq SLIDINGWINDOW:4:20 MINLEN:175
03/29/2018 01:51:14 PM - kneaddata.utilities - DEBUG: TrimmomaticSE: Started with arguments: -threads 1 -phred33 /home/vagrant/Documents/labs/lab_4/output/ERR550644/decompressed_OCsbxP_ERR550644_1.fastq /home/vagrant/Documents/labs/lab_4/output/ERR550644/ERR550644_1_kneaddata.trimmed.fastq SLIDINGWINDOW:4:20 MINLEN:175
Input Reads: 500989 Surviving: 328961 (65.66%) Dropped: 172028 (34.34%)
TrimmomaticSE: Completed successfully
```

Each subsequent section will contain information about each step that is run in the KneadData software package (Trimmomatic, bowtie2/BMTagger, etc.).

We see the actual command executed and can copy this command and run it on the command-line for verification purposes. This can be useful when dealing with any issues that may occur when running KneadData.

#### Trimmed Reads

The first set of outputs created during the KneadData run are those produced by Trimmomatic to 
trim off any adapters (i.e. Nextera, TruSEQ, Illumina adapters) as well as to clip off low quality 
sequences. These files will be labeled with the `.trimmed.fastq` file extension (i.e. `ERR550644_1_kneaddata.trimmed.fastq`).

Taking a peek at these sequences in FastQC we should see a very marked improvement in the 
Per base sequence quality pane:

<img src="{{ "/assets/img/labs/lab_4_knead_fastqc_postrun_per_base_qual.png" | prepend: site.baseurl }}" alt="FastQC: ERR550644_1 Kmer Content"/>

If any adapter content was identified in either the Overrepresented sequences, Adapter Content, or Kmer Content panes we would also see passes here (provided we supplied the proper adapter sequence file to KneadData/Trimmomatic).

#### Contaminant Reads

The set of reads filtered out by KneadData (via bowtie2 or BMTagger) are written to the sequence file labeled `<DATABASE NAME>_<MAPPING SOFTWARE>_contam.fastq`. Since we filtered our sequences against our demo database (`demo_db`) using bowtie2 our output file will look like this: `ERR550644_1_kneaddata_demo_db_bowtie2_contam.fastq`.

<!-- I think we'll actually want to take a stab generating a demo DB here that will filter out some reads or finding a dataset that will trigger the same behavior here -->

Contaminate reads have applications ranging from exploring what kind of contaminants may exist in an input dataset to being used to create a more specific contaminant database if a larger proprotion of reads than expected is being filtered out.

#### Final Output

<!-- Can flesh this one out a lot more -->

Our final output file contains the results of are trimmed and filtered reads as well as any optional steps (such as tandem repeat masking) and written to the file `ERR550644_1_kneaddata.fastq`. 

Running this file through FastQC will return a much happier result:

<img src="{{ "/assets/img/labs/lab_4_knead_fastqc_final_report.png" | prepend: site.baseurl }}" alt="FastQC: ERR550644_1 Final Report"/>
