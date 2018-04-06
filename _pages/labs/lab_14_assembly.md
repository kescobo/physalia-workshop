---
layout: default
title: "Lab #14 - Metagenomic Assembly and Gene Calling"
lab_num: 14
permalink: /labs/14_assembly
is_lab: true
custom_css: tocbot
custom_js: 
    - tocbot.min
    - labs
---

# Metagenomic Assembly and Gene Calling

**The goal of this lab will be to learn how to assemble metagenomic data using MEGAHIT, evaluate the assembly quality using QUAST and Bandage, and do genomic binning using MaxBin**

<div class="alert alert-primary" role="alert">
    <div class="row">
        <div class="col-1 alert-icon-col">
            <span class="fa fa-info-circle fa-fw"></span>
        </div>
        <div class="col">
            Many of the examples provided below were graciously provided by Dr. Harriet Alexander, Dr. Phil Brooks and Dr. C. Titus Brown taught via the <a href="https://2017-cicese-metagenomics.readthedocs.io/en/latest/">Environmental Metagenomic Workshop</a> at CICESE.
        </div>
    </div>        
</div>

### Lab Setup


#### Creating our Workspace

Let's start off by creating a clean space to do our work from. We can create a new folder under the 
`/home/vagrant/Document/labs` directory:

```console
vagrant@biobakery:~$ cd /home/vagrant/Documents/labs
vagrant@biobakery:~/Documents/labs$ mkdir -p lab_14/data lab_14/assembly lab_14/bins
vagrant@biobakery:~/Documents/labs$ cd lab_14/
```

#### Download Input Sequence Datasets

We can grab the datasets used in this lab from the workshop github repository:

```console
vagrant@biobakery:~/Documents/labs/lab_14$ curl -O lab_14_examples.tgz https://github.com/biobakery/physalia-workshop/raw/master/data/labs/lab_14_examples.tgz
vagrant@biobakery:~/Documents/labs/lab_14$ tar xfv lab_14_examples.tgz 
data/SRR1976948.abundtrim.subset.pe.fq.gz
data/SRR1977249.abundtrim.subset.pe.fq.gz
```

### Running MEGAHIT

We can jump right into assembling our genomes using MEGAHIT. MEGAHIT was developed to work on "normal" workstations 
in a reasonable amount of time. 

Lets get a detailed list of options that can be supplied to MEGAHIT using the `--help` option:

```console
vagrant@biobakery:~/Documents/labs/lab_14$ megahit --help
MEGAHIT v1.1.3

Copyright (c) The University of Hong Kong & L3 Bioinformatics Limited
contact: Dinghua Li <dhli@cs.hku.hk>

Usage:
  megahit [options] {-1 <pe1> -2 <pe2> | --12 <pe12> | -r <se>} [-o <out_dir>]

  Input options that can be specified for multiple times (supporting plain text and gz/bz2 extensions)
    -1                       <pe1>          comma-separated list of fasta/q paired-end #1 files, paired with files in <pe2>
    -2                       <pe2>          comma-separated list of fasta/q paired-end #2 files, paired with files in <pe1>
    --12                     <pe12>         comma-separated list of interleaved fasta/q paired-end files
    -r/--read                <se>           comma-separated list of fasta/q single-end files

    ...

  Output options:
    -o/--out-dir             <string>       output directory [./megahit_out]
    --out-prefix             <string>       output prefix (the contig file will be OUT_DIR/OUT_PREFIX.contigs.fa)
    --min-contig-len         <int>          minimum length of contigs to output [200]
    --keep-tmp-files                        keep all temporary files
    --tmp-dir                <string>       set temp directory
```

In our case we will want to supply our paired-end sequence file using the `--12` option and provide the `/home/vagrant/labs/lab_14/assembly/combined` directory as
the output directory using the `-o` option.

<div class="alert alert-success" role="alert">
    <div class="row">
        <div class="col-1 alert-icon-col">
            <span class="fa fa-exclamation-triangle fa-fw"></span>
        </div>
        <div class="col">
            <b>Excercise #1</b>: Start a MEGAHIT assembly by providing our paired-end sequence files using the <code>--12</code> option and supply the output directory using the <code>--o</code> option.
        </div>
    </div>        
</div>

**In the essence of time we are going to let this assembly run and move onto some pre-computed contigs for our downstream analysis**

**These finished assemblies can be found under the following directory:**

- `/home/vagrant/Documents/labs/lab_14/assemblies/megahit_finished`

### Assessing Assembly Quality

Assessing the quality of a metagenomic assembly is vastly different in comparisong to a single genome assembly. Just the standard metrics (N50, number of contigs, contig length) may not be enough to give us an accurate picture. We will explore some of the more surface-level statistics available to us and return to this topic later in the lab to discuss more relevant ways to assess assembly quality.

#### MetaQUAST
The log file genreated by MEGAHIT gives us a very quick peek into the quality of our assmebly but we generate even more statistics by making use of the MetaQUAST package.

Let's start out by looking to see what options we can pass to MetaQUAST:

```console
vagrant@biobakery:~/Documents/labs/lab_14$ metaquast.py --help
MetaQUAST: QUality ASsessment Tool for Metagenome Assemblies
Version: 4.6.3

Usage: python /usr/local/bin/metaquast.py [options] <files_with_contigs>

Options:
-o  --output-dir  <dirname>   Directory to store all result files [default: quast_results/results_<datetime>]
-R   <filename,filename,...>  Comma-separated list of reference genomes or directory with reference genomes
--references-list <filename>  Text file with list of reference genomes for downloading from NCBI
-G  --genes       <filename>  File with gene coordinates in the references (GFF, BED, NCBI or TXT)
-O  --operons     <filename>  File with operon coordinates in the reference (GFF, BED, NCBI or TXT)
-m  --min-contig  <int>       Lower threshold for contig length [default: 500]
-t  --threads     <int>       Maximum number of threads [default: 25% of CPUs]
...
```

Since we aren't interested in any reference genomes to generate mapping statistics too we only need to provide the `--output-dir` option and our contig files.

We can create a new directory under the `assembly` directory to hold our QC reports:

```console
vagrant@biobakery:~/Documents/labs/lab_14/assembly$ mkdir qc
```

<div class="alert alert-success" role="alert">
    <div class="row">
        <div class="col-1 alert-icon-col">
            <span class="fa fa-exclamation-triangle fa-fw"></span>
        </div>
        <div class="col">
            <b>Excercise #2</b>: Run MetaQUAST on our assembled contigs to produce summary statistics. Write the output reports to the <code>/home/vagrant/Documents/labs/lab_14/assembly/qc</code> directory. 
        </div>
    </div>        
</div>

QUAST generates both a text based report and a HTML web-based graphical report:

**Text Report**: `/home/vagrant/Documents/labs/lab_14/assembly/qc/megahit-report/combined-report.txt`
**HTML Report** `/home/vagrant/Documents/labs/lab_14/assembly/qc/megahit-report/report.html`

Let's go ahead and open up our HTML report in Firefox:

```console
vagrant@biobakery:~/Documents/labs/lab_14/assembly/qc$ firefox megahit-report/report.html &
```

<img src="{{ "/assets/img/labs/lab_14_quast.png" | prepend: site.baseurl }}" alt="QUAST HTML Report"/>

In absence of supplying any reference genomes to attempt to align our contigs against the SILVA 16S database is used to BLAST and identify any potential genomes. These results are not very exciting but we can play around with some of the functionality to explore the different functionality metaQUAST provides to us.

<div class="alert alert-success" role="alert">
    <div class="row">
        <div class="col-1 alert-icon-col">
            <span class="fa fa-exclamation-triangle fa-fw"></span>
        </div>
        <div class="col">
            <b>Excercise #3</b>: Explore the features availble in the metaQUAST HTML report. Specifically take a look at the KRONA graph and Icarus contig viewer.
        </div>
    </div>        
</div>

#### Comparing Multiple Assemblies

Using a quality report of one assembly by itself does give us some key metrics to know when our assemblies are of the lowest quality but things become harder when
we try to differentiate between good, OK and bad assemblies. In some cases it is helpful to have multiple assemblies (generated using different *k*-mer sizes or using different software) and compare them against each other to see how vast (or small) some of the statistics differ.

We'll take the same assembly but done using metaSPAdes which can be found in our `assembly` folder:

```console
vagrant@biobakery:~/Documents/labs/lab_14/assembly/metaspades$ ls -l
total 12144
-rw-rw-r-- 1 vagrant vagrant 12432359 Apr  4 13:50 metaspades.contig.fa
```
<div class="alert alert-success" role="alert">
    <div class="row">
        <div class="col-1 alert-icon-col">
            <span class="fa fa-exclamation-triangle fa-fw"></span>
        </div>
        <div class="col">
            <b>Excercise #4</b>: Run MetaQUAST on the metaSPAdes assembled contigs to produce another summary report to do comparisons with.
            Write the output reports to the <code>/home/vagrant/Documents/labs/lab_14/assembly/qc</code> directory. 
        </div>
    </div>        
</div>

Take a look at the metaQUAST HTML report for the MetaSPAdes contigs. 

We can concatenate our two assembly reports using the Unix `paste` and `cut` commands like so:

```console
vagrant@biobakery:~/Documents/labs/lab_14/assembly/$ cd qc/
vagrant@biobakery:~/Documents/labs/lab_14/assembly/qc$ paste *report.txt > merged_report.txt
vagrant@biobakery:~/Documents/labs/lab_14/assembly/qc$ less merged_report.txt
```

Take a look at the merged assembly report in `less`. Is one assembly "better" than the other?

### Visualizing Contigs with Bandage

Bandage allows us to examine the de Bruijn graphs created by several of the more popular assemblers (Velvet, SPAdes, MEGAHIT, etc.) and visualizes the paths that were taken in creating the contigs that were produced. We can use this information to again get an idea of how well each assembler my have performed but even more exciting is that by visualizing the paths used in constructing the contigs we can potentially identify loops and dead-ends which could be candidates to be fixed.

To load our MEGAHIT contigs into Bandage we will first need to convert them into FASTG format using the `megahit_toolkit` application:

<!-- Why are we using k99 here instead of any of the others? -->

```console
vagrant@biobakery:~/Documents/labs/lab_14/assembly$ cd combined/intermediate_contigs/
vagrant@biobakery:~/Documents/labs/lab_14/assembly/combined/intermediate_contigs$ megahit_toolkit contig2fastg 99 k99.contigs.fa > k99.fastg
vagrant@biobakery:~/Documents/labs/lab_14/assembly/combined/intermediate_contigs$ cp k99.fastg ../megahit.fastg
```

Simple enough, no? Now we can jump right into Bandage by launching it from the command-line:

```console
vagrant@biobakery:~/Documents/labs/lab_14/assembly/qc$ Bandage &
```

Use the *File* -> *Open* dialog menu to find our contig graph file that we just created at `/home/vagrant/Documents/labs/lab_14/assembly/combined/megahit.fastg`

<img src="{{ "/assets/img/labs/lab_14_bandage_megahit.png" | prepend: site.baseurl }}" alt="Bandage Contig Visualization"/>

<!-- Likely want to go over some of the contigs that look dicey and discuss what we could do to fix them up -->

<div class="alert alert-success" role="alert">
    <div class="row">
        <div class="col-1 alert-icon-col">
            <span class="fa fa-exclamation-triangle fa-fw"></span>
        </div>
        <div class="col">
            <b>Excercise #5</b>: Explore our contigs in de Bruijn graph format and see if you can identify any contigs that could potentially be corrected to account for repeats or sequencing errors.
        </div>
    </div>        
</div>

### Annotating Contigs using PROKKA

PROKKA is a pipeline that goes through the complete process of annotating assembled contigs. Recall the following image from the lecture describing the steps in PROKKA and all its intermediate outputs:

<img src="{{ "/assets/img/labs/lab_14_prokka_overview.png" | prepend: site.baseurl }}" alt="QUAST HTML Report"/>

Let's get started with PROKKA to annotate our contigs. We can begin by looking at all the options that PROKKA presents us with (as usual):

```console
vagrant@biobakery:~/Downloads$ prokka
Name:
  Prokka 1.13 by Torsten Seemann <torsten.seemann@gmail.com>
Synopsis:
  rapid bacterial genome annotation
Usage:
  prokka [options] <contigs.fasta>
General:
  --help            This help
  --version         Print version and exit
  --docs            Show full manual/documentation
  --citation        Print citation for referencing Prokka
  --quiet           No screen output (default OFF)
  --debug           Debug mode: keep all temporary files (default OFF)
Setup:
  --listdb          List all configured databases
  --setupdb         Index all installed databases
  --cleandb         Remove all database indices
  --depends         List all software dependencies
  Outputs:
  --outdir [X]      Output folder [auto] (default '')
  --force           Force overwriting existing output folder (default OFF)
  --prefix [X]      Filename output prefix [auto] (default '')
  --addgenes        Add 'gene' features for each 'CDS' feature (default OFF)
  --addmrna         Add 'mRNA' features for each 'CDS' feature (default OFF)
  --locustag [X]    Locus tag prefix [auto] (default '')
  --increment [N]   Locus tag counter increment (default '1')
  --gffver [N]      GFF version (default '3')
  --compliant       Force Genbank/ENA/DDJB compliance: --addgenes --mincontiglen 200 --centre XXX (default OFF)
  --centre [X]      Sequencing centre ID. (default '')
  --accver [N]      Version to put in Genbank file (default '1')
 ...
 Annotations:
  --kingdom [X]     Annotation mode: Archaea|Bacteria|Mitochondria|Viruses (default 'Bacteria')
  --gcode [N]       Genetic code / Translation table (set if --kingdom is set) (default '0')
  --gram [X]        Gram: -/neg +/pos (default '')
  --usegenus        Use genus-specific BLAST databases (needs --genus) (default OFF)
  --proteins [X]    FASTA or GBK file to use as 1st priority (default '')
  --hmms [X]        Trusted HMM to first annotate from (default '')
  --metagenome      Improve gene predictions for highly fragmented genomes (default OFF)
  --rawproduct      Do not clean up /product annotation (default OFF)
  --cdsrnaolap      Allow [tr]RNA to overlap CDS (default OFF)
```

For our annotation run we'll want to make use of the `--outdir` option (save our annotations to a directory called `prokka`) and the `--prefix` option to prefix all our output files with the prefix `metahit_`. 

Also take note of some of the annotation options availble. We'll want to make use of the `--metagenome` option since we are dealing with metagenomic data.

#### PROKKA Setup
Let's make a separate space to work in by creating an `annotation` folder under our `lab_14` folder:

```console
vagrant@biobakery:~/Documents/labs/lab_14/assembly/$ cd ../
vagrant@biobakery:~/Documents/labs/lab_14$ mkdir annotation
vagrant@biobakery:~/Documents/labs/lab_14$ cd annotation/
```

Since PROKKA is an amalagation of several pieces of analysis software we need to run the `--setupdb` option to prepare all the databases used 
by each analysis piece:

```console
vagrant@biobakery:~/Documents/labs/lab_14/ prokka --setupdb
[15:12:03] Appending to PATH: /home/vagrant/.linuxbrew/Cellar/prokka/1.13/bin
[15:12:03] Cleaning databases in /home/vagrant/.linuxbrew/Cellar/prokka/1.13/bin/../db
[15:12:03] Deleting unwanted file: /home/vagrant/.linuxbrew/Cellar/prokka/1.13/bin/../db/kingdom/Archaea/sprot.phd
[15:12:03] Deleting unwanted file: /home/vagrant/.linuxbrew/Cellar/prokka/1.13/bin/../db/kingdom/Archaea/sprot.phi
[15:12:03] Deleting unwanted file: /home/vagrant/.linuxbrew/Cellar/prokka/1.13/bin/../db/kingdom/Archaea/sprot.phr
...
```

Now running the `--listdb` option we can see the databases that were prepared and available:

```console
vagrant@biobakery:~/Documents/labs/lab_14/$ prokka --listdb
[15:14:09] Looking for databases in: /home/vagrant/.linuxbrew/Cellar/prokka/1.13/bin/../db
[15:14:09] * Kingdoms: Archaea Bacteria Mitochondria Viruses
[15:14:09] * Genera: Enterococcus Escherichia Staphylococcus
[15:14:09] * HMMs: HAMAP
[15:14:09] * CMs: Bacteria Viruses
```

#### Running PROKKA
Let's get a PROKKA annotation run going. Remember to make use of the `--outdir`, <br/>`--metagenome`, and `--prefix` options when annotating our metagenomic contigs.

<div class="alert alert-success" role="alert">
    <div class="row">
        <div class="col-1 alert-icon-col">
            <span class="fa fa-exclamation-triangle fa-fw"></span>
        </div>
        <div class="col">
            <b>Excercise #6</b>: Start a PROKKA annotation run with our assembled contigs. Use the contigs file at: <code>/home/vagrant/Documents/labs/lab_14/assembly/combined/final.contigs.fa</code>
        </div>
    </div>        
</div>

### Genomic Binning

<!-- Pretty much need to add questions to all of these sections that the students can think about. -->