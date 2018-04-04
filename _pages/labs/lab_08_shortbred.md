# ShortBRED Tutorial*

[ShortBRED](http://huttenhower.sph.harvard.edu/shortbred) (Short, Better
Representative Extract Dataset) is a pipeline to take a set of protein
sequences, cluster them into families, build consensus sequences to
represent the families, and then reduce these consensus sequences to a
set of unique identifying strings (\"markers\"). The pipeline then
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

------------------------------------------------------------------------

::: {.contents}
:::

------------------------------------------------------------------------

**Overview**
------------

The following figure shows the workflow of ShortBRED.

[![image](http://huttenhower.sph.harvard.edu/sites/default/files/webfm/Jim/Figure1.png){height="40000px"}](http://huttenhower.sph.harvard.edu/sites/default/files/webfm/Jim/Figure1.png)

------------------------------------------------------------------------

**1. Install**
--------------

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

**2. ShortBRED-Identify**
-------------------------

ShortBRED-Identify clusters the input protein sequences into families,
builds consensus sequences, and then identifies regions of overlap among
the consensus sequences and between the consensus sequences and a set of
reference proteins. This information is used to construct a set of
representative markers for the families.

### **2.1 Input Files**

The input files required for the script are the following (Sample input
files for the purpose of this tutorial are provided) :

-   Proteins of interest
    ([input\_prots.faa](https://bitbucket.org/biobakery/shortbred/src/65067596534bdc60776fb06547da740c13d9a70e/example/input_prots.faa?at=default))
-   Reference set of proteins
    ([refprots.faa](https://bitbucket.org/biobakery/shortbred/src/65067596534bdc60776fb06547da740c13d9a70e/example/ref_prots.faa?at=default))

### **2.2 Running ShortBRED-Identify**

To create markers for the sample data, run the following command from
the shortbred working directory: :

    $ shortbred_identify.py --goi  example/input_prots.faa --ref example/ref_prots.faa --markers mytestmarkers.faa --tmp example_identify

The above command will create a set of markers (`mytestmarkers.faa`). An
example of the output is below:

::: {.sourcecode}
text

\>[P23181\_TM]()\#01
MLRSSNDVTQQGSRPKTKLGGSSMGIIRTCRLGPDQVKSMRAALDLFGREFGDVATYSQH
QPDSDYLGNLLRSKTFIALAAFDQEAVVGALAAYVLPKFEQARSEIYIYDLAVSGEHRRQ
GIATALINLLKHEANALGAYVIYVQADYGDDPAVALYTKLGIREEVMHFDIDPSTAT
\>[P13246\_TM]()\#01 IGPVEGGAETVVAALRSAVGPTGTVMGYASWDRSPYEETLNGARLDD
\>[P13246\_TM]()\#02
PFDPATAGTYRGFGLLNQFLVQAPGARRSAHPDASMVAVGPLAETLTEPHELGHALGEGS P
\>[P13246\_TM]()\#03 ERFVRLGGKALLLGAPLNSVTALHYAEAVADIPNKRWVTYEMPM
\>[P13246\_TM]()\#04 GRDGEVAWKTASDYDSNGILDCFAIEGK \>[P13246\_TM]()\#05
DAVETIANAYVKLGRHREGV \>[YP\_884847\_TM]()\#01
SHHGALIAHGAVVQRRLMYRGPDGRGHALRCGYVEAVAVREDRRGDGLGTAVLDALEQVI
RGAYQIGALSASDIARPMYIARGWLSWEGPTSVLTPTEGIVRTPEDDRSLFVLPVDLPDG
LELDTAREITCDWRSGDPW \>[NP\_753952\_TM]()\#01
MQKYISEARLLLALAIPVILAQIAQTAMGFVDTVMAGGYSATDMAAVAIGTSIWLPAILF
GHGLLLALTPVIAQLNGSGRRERIAHQVRQGFWLAGFVSVLIMLVLWNAGYIIRSMQNID
PALADKAVGYLRALLWGAPGYLFFQVARNQCEGLAKTKPGMVMGFIGLLVNIPVNYIFIY
GHFGMPELGGVGCGVATAAV \>[YP\_001848841\_TM]()\#01
HALGGMHALIWHRGAIIAHGAVVQRRLIYRGS \>[Q49157\_TM]()\#01
EGDFSDADWEHALGGMHAFICH \>[Q49157\_TM]()\#02
VEQVLRGAYQLGALSASDTARGMYLSRGWLPWQGPTSVLQPAGVTRTPEDDEGLFVLPVG
LPAGMELDTTAEITCDWRDGDVW \>[NP\_214776\_TM]()\#01
DIRQMVTGAFAGDFTETDWEHTLGGMHALIWHHGAIIAHAAVIQRRLIYRGNALRCGYVE
GVAVRADWRGQRLVSALLDAVEQVMRGAYQLGALSSSAR \>[ZP\_02959935\_TM]()\#01
MGIEYRSLHTSQLTLSEKEALYDLLIEGFEGDFSHDDFAHTLGGMHVMAFDQQKLVGHVA
IIQRHMALDNTPISVGYVEAMVVEQSYRRQGIGRQLMLQTNKIIASCYQLGLLSASDDGQ
KLYHSVGWQIWKGKLFELKQGSYIRSIEEEGGVMGWKADGEVDFTASLYCDFRGGDQW
\>[YP\_001068559\_TM]()\#01
MAGTPRWYNDGVLPQLSSEVRGHGVIHTARLVHTADLDNETREGARRMVSEAFRG
\>[YP\_001068559\_TM]()\#02
CRGQGLGSAVMDACEQVLRGAYQLGALATSTMARPMYRARGWVPWRGPTSVLSPGGRIST P
\>[YP\_001068559\_TM]()\#03 DDGSVFVYPVGSALGSTDLDTTAELTCDWRHGDVW
:::

The directory `example_identify` (folder name provided with the tmp
flag) should contain the processed data from ShortBRED (including blast
results). Please refer to the documentation for further details.

------------------------------------------------------------------------

**3. ShortBRED-Quantify**
-------------------------

ShortBRED-Quantify then searches for the markers in nucleotide data, and
returns a normalized, relative abundance table of the protein families
found in the data. This script takes the FASTA file of markers and
quantifies their relative abundance in a FASTA file of nucleotide
metagenomic reads.

### **3.1 Input Files**

The input files required for the script are the following (Sample input
files for the purpose of this tutorial are provided) :

-   Markers file (generated from Section 1)
-   Short nucleotide reads
    ([wgs.fna](https://bitbucket.org/biobakery/shortbred/src/65067596534bdc60776fb06547da740c13d9a70e/example/wgs.fna?at=default))

### **3.2 Running ShortBRED-Quantify**

To create markers for the sample data, run the following command from
the shortbred working directory: :

    $ shortbred_quantify.py --markers mytestmarkers.faa --wgs example/wgs.fna  --results exampleresults.txt --tmp example_quantify

The above command will create an output file `exampleresults.txt`
containing relative abundance data of the protein families in the wgs
data. An example of the output is below:

::: {.sourcecode}
text

Family Count Hits TotMarkerLength NP\_214776 0.0 0 99 NP\_753952
19569471.6243 1 200 P13246 0.0 0 200 P23181 0.0 0 177 Q49157 0.0 0 105
YP\_001068559 0.0 0 151 YP\_001848841 0.0 0 32 YP\_884847 0.0 0 139
ZP\_02959935 0.0 0 178
:::

The directory `example_quantify` (folder name provided with the tmp
flag) should contain the processed data from ShortBRED. Please refer to
the documentation for further details.

------------------------------------------------------------------------
