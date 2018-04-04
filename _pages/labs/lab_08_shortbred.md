---
layout: default
title: "Lab #8 - Introduction to ShortBRED"
permalink: /labs/08_shortbred
custom_css: tocbot
custom_js:
    - tocbot.min
    - labs
---

# Introduction to ShortBRED

[ShortBRED](http://huttenhower.sph.harvard.edu/shortbred) (Short, Better
Representative Extract Dataset) is a pipeline to take a set of protein
sequences, cluster them into families, build consensus sequences to
represent the families, and then reduce these consensus sequences to a
set of unique identifying strings ("markers"). The pipeline then
searches for these markers in metagenomic data and determines the
presence and abundance of the protein families of interest.

For additional information, please refer to the manuscript: [Kaminski J,
Gibson MK, Franzosa EA, Segata N, Dantas G, Huttenhower
C.High-specificity targeted functional profiling in microbial
communities with ShortBRED. PLoS Comput Biol. 2015 Dec
18;11(12):e1004557.](http://journals.plos.org/ploscompbiol/article?id=10.1371/journal.pcbi.1004557)

We provide support for ShortBRED users. Please join our [Google
group](http://groups.google.com/forum/#!forum/shortbred-users)
designated specifically for ShortBRED users. Feel free to post any
questions on the google group by posting directly or emailing
[<shortbred-users@googlegroups.com>](mailto:shortbred-users@googlegroups.com)

## Overview

The following figure shows the workflow of ShortBRED.

![image](http://huttenhower.sph.harvard.edu/sites/default/files/webfm/Jim/Figure1.png)


### 1. Install

ShortBRED can be installed with Homebrew or run from a Docker image.
Please note, if you are using bioBakery (Vagrant VM or cloud) you do not
need to install ShortBRED because the tool and its dependencies are
already installed. However, you will need to install the dependency
USEARCH which requires a license. Follow the commands in the
instructions to install [bioBakery dependencies that require
licences](https://bitbucket.org/biobakery/biobakery/wiki/biobakery_basic#rst-header-install-biobakery-dependencies).

Install with Homebrew: `$ brew install biobakery/biobakery/shortbred`

Install with Docker: `$ docker run -it biobakery/shortbred bash`

If you would like to install from source, refer to the [ShortBRED user
manual](http://bitbucket.org/biobakery/shortbred) for the
pre-requisites/dependencies and installation instructions.

### 2. ShortBRED-Identify

ShortBRED-Identify clusters the input protein sequences into families,
builds consensus sequences, and then identifies regions of overlap among
the consensus sequences and between the consensus sequences and a set of
reference proteins. This information is used to construct a set of
representative markers for the families.

![ShortBRED Identify schematic](/img/labs/lab_8_identify.png)

#### 2.1 Input Files

The input files required for the script are the following:

1. Proteins of interest - amino acid sequences of the proteins you are looking for.
2. Reference proteins - a set of amino acid sequnces that might be present in your sample.

For this tutorial, our proteins of interest are a small set of TonB genes from
Proteobacteria. TonB is a siderophore import protein found in the outer membrane
of gram negative bacteria, and the reference proteins are subsampled from the
[integrated microbial genomes (IMG) database](https://img.jgi.doe.gov/).

- [tonB.faa](#)
- [ref_prots.faa](#)

We're trying to identify tonB genes in set of short DNA reads from metagenomic
sequencing. The data we'll use for the tutorial was synthetically generated to
contain 1000 reads from tonB genes, and 10000 reads from other proteins.

- [shortbred_demo_reads.fasta](#)

#### 2.2 Naive search

To show why ShortBRED is useful, we will start by doing a naive BLAST search.
First, make a BLAST database combining our tonB genes, and our reference
database:

```sh
$ cat tonB.faa ref_prots.faa  > allprots.faa
$ makeblastdb -dbtype prot -in allprots.faa -out allprots


Building a new DB
New DB name:   allprots
New DB title:  allprots.faa
Sequence type: Protein
Keep Linkouts: T
Keep MBits: T
Maximum file size: 1000000000B
Adding sequences from FASTA; added 83 sequences in 0.00298595 seconds.
```

Now, we'll BLAST our DNA reads against this protein database using translated
search. The following command searches the database for alignments to our reads
and generates a table with the query (read) ID, the subject (database) ID, the
percent identity and the length of the alignment:

```sh
$ blastx -query shortbred_demo_reads_labeled.fasta -db allprots \
    -out naive_search.tsv -outfmt "6 qseqid sseqid pident length"
```

First, notice how long this takes. Our database is tiny, and we don't have many
reads, but translated search is SLOW. Let's take a look at the results (once
you run this command, press `<space>` to scroll through, and `q` to exit back
to the command prompt):

```sh
$ column -t naive_search.tsv | less

Background_read|00000001|0062|-1|WP_037108668.1  tonB_ACD08273  84.375   32
Background_read|00000001|0062|-1|WP_037108668.1  tonB_ADB98050  84.375   32
Background_read|00000001|0062|-1|WP_037108668.1  tonB_EGT66731  84.375   32
Background_read|00000001|0062|-1|WP_037108668.1  tonB_SAP90706  84.375   32
Background_read|00000001|0062|-1|WP_037108668.1  tonB_CDO13422  87.500   32
Background_read|00000001|0062|-1|WP_037108668.1  tonB_AIE04533  84.375   32
Background_read|00000001|0062|-1|WP_037108668.1  ref_637982072  45.000   20
Background_read|00000001|0062|-1|WP_037108668.1  ref_637982015  40.000   10
Background_read|00000001|0062|-1|WP_037108668.1  ref_637982013  58.333   12
Background_read|00000002|0003|-1|WP_037108668.1  ref_637982016  70.000   10
Background_read|00000002|0003|-1|WP_037108668.1  ref_637982016  50.000   14
Background_read|00000002|0003|-1|WP_037108668.1  ref_637982011  37.500   16
```

Let's check how many hits came from actual TonB genes vs background (searching
here for hits of at least 85% identity and at least 25aa long):

```sh
$ cat naive_search.tsv | grep -E '^TonB' | grep -E 'tonB_' | awk '$3 > 85 && $4 > 25 {print $0}' | wc -l
    3153
$ cat naive_search.tsv | grep -E '^Background' | grep -E 'tonB_' | awk '$3 > 85 && $4 > 25 {print $0}' | wc -l
    1594
```

```
1. What's the maximum length hit we'd expect, if our reads are 100bp long?
2. Why do we get more thank 3000 hits for tonB, when we know that there were only 1000 matching reads in our metagenome?
3. What is our false discovery rate in this analysis?
```

#### 2.2 Running ShortBRED-Identify

Now let's do the same thing with ShortBRED. To create markers for the sample
data, run the following command from the shortbred working directory:

```sh
$ shortbred_identify.py --goi  tonB.faa --ref ref_prots.faa --markers mymarkers.faa --tmp example_identify

Checking dependencies...
Tested usearch. Appears to be working.
Tested blastp. Appears to be working.
Tested muscle returned a nonzero exit code (typically indicates failure). Please check to ensure the program is working. Will continue running.
Path for cdhit appears to be fine. This program returns an error [exit code=1] when tested and working properly, so ShortBRED does not check it.
Tested makeblastdb. Appears to be working.
Checking to make sure that installed version of usearch can make databases...
Usearch appears to be working.

Clustering proteins of interest...
================================================================
Program: CD-HIT, V4.7 (+OpenMP), Jul 11 2017, 08:30:58
Command: cd-hit -i tonB.faa -o
         example_identify/clust/clust.faa -d 0 -c 0.85 -b 10 -g
         1
```

The above command will create a set of markers (`mymarkers.faa`). An
example of the output is below:

```
$ head -20 mymarkers.faa
>tonB_AIE04533_TM_#01
MRLPAFYRWLLLVVGISISGISLAQDAGWPRQIQDSRGVHTLDHKPA
>tonB_AIE04533_TM_#02
DVAKARHVARLYIGEPNAETVAAQMPDLILISATGGDSALALYDQLSAIAPTLVINYDDK
SWQSLLTQLGEITGQEKQAAARIAEFETQLTTVKQRIALPPQPVSALVYTPAAHSANLWT
PESAQGKLLT
>tonB_AIE04533_TM_#03
TLLLNRLAALF
>tonB_CDO13422_TM_#01
MNFFSFCRRGALTGMLLLLGITSA
2018-04-04|12:31:35 sandbox kev$ head -20 mymarkers.faa
>tonB_AIE04533_TM_#01
MRLPAFYRWLLLVVGISISGISLAQDAGWPRQIQDSRGVHTLDHKPA
>tonB_AIE04533_TM_#02
DVAKARHVARLYIGEPNAETVAAQMPDLILISATGGDSALALYDQLSAIAPTLVINYDDK
SWQSLLTQLGEITGQEKQAAARIAEFETQLTTVKQRIALPPQPVSALVYTPAAHSANLWT
PESAQGKLLT
>tonB_AIE04533_TM_#03
TLLLNRLAALF
>tonB_CDO13422_TM_#01
MNFFSFCRRGALTGMLLLLGITSA
>tonB_CDO13422_TM_#02
YGTHTLPSQPL
>tonB_CDO13422_TM_#03
EVAKARKLA
>tonB_CDO13422_TM_#04
KTIAPTLVINYDDKSWQTLLTQLGQITGHEQQASARIADFNKQLVSLKEKM
>tonB_CDO13422_TM_#05
LLVLQRLSSLFG
>tonB_ABS46221_TM_#01
MNKTRTCTTLAPRWLGDISFILAGLLALFFLLSVGDSQAETGAVHTTQANGFPRK
```

The directory `example_identify` (folder name provided with the tmp
flag) should contain the processed data from ShortBRED (including blast
results). Please refer to the documentation for further details.


### 3. ShortBRED-Quantify

ShortBRED-Quantify then searches for the markers in nucleotide data, and
returns a normalized, relative abundance table of the protein families
found in the data. This script takes the FASTA file of markers and
quantifies their relative abundance in a FASTA file of nucleotide
metagenomic reads.

![ShortBRED Quantify schematic](/img/labs/lab_8_quantify.png)


#### 3.1 Input Files

The input files required for the script are the following (Sample input
files for the purpose of this tutorial are provided) :

-   Markers file (generated from Section 1)
-   Short nucleotide reads ([shortbred_demo_reads.fasta](#))

#### 3.2 Running ShortBRED-Quantify

To create markers for the sample data, run the following command from
the shortbred working directory: :

```sh
$ shortbred_quantify.py --markers mymarkers.faa --wgs shortbred_demo_reads.fasta  --results shortbred_results.tsv --tmp example_quantify
```

The above command will create an output file `shortbred_results.tsv`
containing normalized count data of the protein families in the wgs
data. An example of the output is below:

```
$ column -t shortbred_results.tsv
Family         Count               Hits  TotMarkerLength
tonB_ABS46221  12269.938650306749  76    300
tonB_AIE04533  8741.258741258742   58    188
tonB_CAE16995  15289.25619834711   75    279
tonB_CDO13422  5509.641873278237   23    107
tonB_EGT66731  37878.78787878788   92    102
```

```
1. What is the false negative rate with respect to the number of reads in the dataset?
2. What does the "Count" column refer to?
3. What is the false positive rate of ShortBRED in this case?
```

ShortBRED uses BLAST under the hood, and you can explore the results of the
search in the same way as we did above:

```sh
$ cat example_quantify/wgsfull_results.tab | grep -E '^TonB' | grep -E 'tonB_' | awk '$3 > 85 && $4 > 25 {print $0}' | wc -l
     276
2018-04-04|12:46:45 sandbox kev$ cat example_quantify/wgsfull_results.tab | grep -E '^Background' | grep -E 'tonB_' | awk '$3 > 85 && $4 > 25 {print $0}' | wc -l
      15
```

```
1. Why doesn't ShortBRED count the 15 hits from background samples?
```

The directory `example_quantify` (folder name provided with the tmp
flag) should contain the processed data from ShortBRED. Please refer to
the documentation for further details.
