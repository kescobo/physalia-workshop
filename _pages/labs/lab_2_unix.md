---
layout: default
title: "Lab #2 - Introduction to Command-line Unix"
permalink: /labs/2_unix
custom_css: tocbot
custom_js: 
    - tocbot.min
    - labs
---

# Introduction to Command-line Unix

**The goal of this lab is to become familiar operating in the Unix command-line interface.**

Most bioinformatic tools are written for use in the Unix environment so becoming comfortable with 
navigating the command-line is a useful skill to have and will be necessary to complete the majority 
of upcoming labs.

### Navigating the Directory Structure

The Unix directory structure can be visualized as a tree. Each level of the tree indicates a series 
of folders or files which can have zero or many nested child folders/files.

<img class="mx-auto d-block" src="{{ "/assets/img/labs/lab_2_unix_dir_tree.png" | prepend: site.baseurl }}" alt="Unix Directory Tree Structure"/>

#### Getting the Working Directory
It is important to know where we are when navigating the Unix directory structure. The current directory 
you operate out of is called the **Working Directory** and we can print this out by using the `pwd` command:

```console
vagrant@biobakery:~$ pwd 
/home/vagrant
```

#### Moving Between Directories
Navigation is primarly handled by the **C**hange **D**irectory command `cd`:

```console
vagrant@biobakery:~$ cd Documents/
vagrant@biobakery:~/Documents$ pwd 
/home/vagrant/Documents
```

It is also possible to traverse multiple directories in one `cd` command:

```console
vagrant@biobakery:~$ cd /usr/local/etc/
vagrant@biobakery:/usr/local/etc$ pwd
/usr/local/etc
```

**Note**: You may have noticed that a portion of the terminal text updates while we are moving around directories (`vagrant@biobakery`) --
this is the terminal prompt and displays useful information like our current working directory.

We can navigate backwards up the Unix directory tree by using using the special characters `..` in 
conjunction with `cd`:

```console
vagrant@biobakery:/usr/local/etc$ pwd
/usr/local/etc
vagrant@biobakery:/usr/local/etc$ cd ..
vagrant@biobakery:/usr/local$ pwd 
/usr/local
```

Note that this can be chained multiple times to navigate backwards several levels in the directory tree:

```console
vagrant@biobakery:/usr/local$ cd etc/
vagrant@biobakery:/usr/local/etc$ cd ../..
vagrant@biobakery:/usr$ pwd 
/usr
```

From any location we can return to our home directory by executing the `cd` command alone:

```console
vagrant@biobakery:/usr$ cd
vagrant@biobakery:~$ pwd
/home/vagrant
```

or by changing directory to the `~` character which is short-hand for our home directory:

```console
vagrant@biobakery:~$ cd /usr
vagrant@biobakery:/usr$ cd ~
vagrant@biobakery:~$ pwd
/home/vagrant
```

<div class="alert alert-success" role="alert">
  <b>Excercise #1</b>: Use the <code>cd</code> and <code>pwd</code> commands to navigate around the home directory.
</div>


### Listing Files
Now that we know how to navigate around the Unix file structure we will want to see what files/directories are 
present in our working directory. This is accomplished using the `ls` command:

```console
vagrant@biobakery:~$ cd
vagrant@biobakery:~$ pwd
/home/vagrant
vagrant@biobakery:~$ ls
arepa  Desktop  Documents  Downloads  Music  phylophlan  Pictures  Public  Templates  Videos
```

We can see that there are multiple directories under the `/home/vagrant/` location but not much 
more information is returned. This can be fixed by passing options to the `ls` command that transform
what output is produced

We can use the `-l` option to request a long list of the contents of a directory:

```console
vagrant@biobakery:~$ pwd
/home/vagrant
vagrant@biobakery:~$ ls -l 
total 40
drwxr-xr-x 14 root    root    4096 Aug 31  2017 arepa
drwxr-xr-x  2 vagrant vagrant 4096 Aug 31  2017 Desktop
drwxr-xr-x  2 vagrant vagrant 4096 Aug 31  2017 Documents
drwxr-xr-x  2 vagrant vagrant 4096 Aug 31  2017 Downloads
drwxr-xr-x  2 vagrant vagrant 4096 Aug 31  2017 Music
drwxrwxr-x  9 vagrant vagrant 4096 Aug 31  2017 phylophlan
drwxr-xr-x  2 vagrant vagrant 4096 Aug 31  2017 Pictures
drwxr-xr-x  2 vagrant vagrant 4096 Aug 31  2017 Public
drwxr-xr-x  2 vagrant vagrant 4096 Aug 31  2017 Templates
drwxr-xr-x  2 vagrant vagrant 4096 Aug 31  2017 Videos
```

Several new pieces of information are now provided including file/directory permissions, owner, 
size and date last updated.

The `ls` command does not restrict us to listing files only in our working directory; the location to any file or directory can 
be provided with the same results:

```console
vagrant@biobakery:~$
vagrant@biobakery:~$ ls -l /home/vagrant/phylophlan/
total 60
drwxrwxr-x 5 vagrant vagrant  4096 Aug 31  2017 circlader
drwxrwxr-x 3 vagrant vagrant  4096 Aug 31  2017 data
drwxrwxr-x 4 vagrant vagrant  4096 Aug 31  2017 input
-rw-rw-r-- 1 vagrant vagrant  1082 Aug 31  2017 license.txt
drwxrwxr-x 2 vagrant vagrant  4096 Aug 31  2017 output
-rwxrwxr-x 1 vagrant vagrant 31572 Aug 31  2017 phylophlan.py
drwxrwxr-x 3 vagrant vagrant  4096 Aug 31  2017 pyphlan
drwxrwxr-x 2 vagrant vagrant  4096 Aug 31  2017 taxcuration
```

### Creating Directories
Directory creation can be done with the `mkdir` command:

```console
vagrant@biobakery:~$ cd
vagrant@biobakery:~$ cd Documents/
vagrant@biobakery:~/Documents$ mkdir labs
vagrant@biobakery:~/Documents$ ls -l
total 4
drwxrwxr-x 2 vagrant vagrant 4096 Mar 28 03:31 labs
```

It is also possible to create several levels of directories by passing the `-p` option to `mkdir`:

```console
vagrant@biobakery:~/Documents$ mkdir -p labs/lab_2/data
vagrant@biobakery:~/Documents$ ls labs
lab2
vagrant@biobakery:~/Documents$ ls labs/lab_2
data
```

### Downloading Files


### Viewing Text Files

We can examine the contents of a specific text file using two methods. The `cat` command will print all the contents of a file
to our screen in one stroke:

```console
vagrant@biobakery:~$ cat /home/vagrant/labs/lab_2/data/sequences/seqsA.fasta
> sequence 1
TCTGGCTCGACGCAAGCCATAACACCCCTGTCACATCATAATCGTTTGCAATTCAGGGCTTGATCAACACTGGATTGCCTTTCTCTTAAAGTATTATGCAGGACGGGGTGCGCGTACC
ATGTAAACCTGTTATAACTTACCTGAGACTAGTTGGAAGTGTGGCTAGATCTTAGCTTACGTTTCTAGTCGGTCCACGTTTGGTTTTTAAGATCCAATGATCTTCAAAACGCTGCAAG
> sequence 2
ATTCACAACCTGCTTTACTAAGCGCTGGGTCCTACTGCAGCGGGACTTTTTTTCTAAAGACGTTGAGAGGAGCAGTCGTCAGACCACATAGCTTTCATGTCCTGATCGGAAGGATCGT
TGGCGCCCGACCCTTAGACTCTGTACTGAGTTCTATAAACGAGCCATTGCATACGAGATCGGTAGATTGATAAGGGACACAGAATATCCCCGGACGCAATAGACGGACAGCTTGGTAT
CCTAAGCACAGTCGCGCGTCCGAACCTAGCTCTACTTTAGAGGCCCCGGATTCTGGTGCTCGTAGACCGCAGAACCGATTGGGGGGATGTACAACAATATTTGTTAGTCACCTTTGGG
> sequence 3
TCACGATCTCCCACCTTACTGGAATTTAGTCCCTGCTATAATTTGCCTTGCATATAAGTTGCGTTACTTCAGCGTCCTAACCGCACCCTTAGCACGAAGACAGATTTGTTCATTCCCA
TACTCCGGCGTTGGCAGGGGGTTCGCATGTCCCACGTGAAACGTTGCTAAACCCTCAGGTTTCTGAGCGACAAAAGCTTTAAACGGGAGTTCGCGCTCATAACTTGGTCCGAATGCGG
> sequence 4
GTTCTTGCATCGTTCGACTGAGTTTGTTTCATGTAGAACGGGCGCAAAGTATACTTAGTTCAATCTTCAATACCTCGTATCATTGTACACCTGCCGGTCACCACCCAACGATGTGGGG
ACGGCGTTGCAACTTCGAGGACCTAATCTGACCGACCTAGATTCGGCACTGTGGGC
```

This command is not so useful when dealing with larger text files as the contents of the file will print rapidly down the screen. In these cases the `less` command allows us to move through
multiple "pages" of output in a more controlled fashion:

```console
vagrant@biobakery:~$ less /home/vagrant/data/sequences/seqsB.fasta
```

Once invoked the `less` command takes over the entirety of our terminal window and allows us to scroll down the file using the **Up** and **Down** arrow keys, the **Page Up** or **Page Down** keys, or the **Spacebar** (moves us forward a page at a time). `less` can be exited by pressing the **q** key.

### A Quick Tangent: The Wildcard Character

Before we proceed it is useful to note that the Unix command-line has robust support for pattern matching in almost all of commands using the 
wildcard character `*`.

An example would be using the wildcard character to list all fasta files in a directory:

```console
vagrant@biobakery:~$ cd /home/vagrant/labs/lab_2/data
vagrant@biobakery:~/Documents/labs/lab_2/data$ ls -l *.fasta
-rw-r--r--  1 vagrant  staff   0 Mar 26 17:54 seqsA.fasta
-rw-r--r--  1 vagrant  staff   0 Mar 26 17:54 seqsB.fastq
```

We can insert the wildcard character into to make many combinations of partial matches to pass along to Unix commands. Let's list all 
files that begin wit hthe word `example`:

```console
vagrant@biobakery:~/Documents/labs/lab_2/data$ ls -l example*
drwxr-xr-x  2 vagrant  staff  64 Mar 26 17:54 example_1
drwxr-xr-x  2 vagrant  staff  64 Mar 26 17:54 example_2
```

<div class="alert alert-success" role="alert">
  <b>Excercise #3</b>: Try listing all files that begin with <code>seqs</code> and using the <code>cat</code> command to print out all FASTA files to the screen
</div>

### Moving and Deleting Files/Directories
Moving files is a common operation on the command-line and can be achieved by using the `mv` command.

Let's move the `seqsA.fasta` file from the `sequences/` folder to the `example_1/` folder:

```console
vagrant@biobakery: ~$ cd /home/vagrant/data/sequences
vagrant@biobakery: ~$ mv seqsA.fasta example_1/
vagrant@biobakery: ~$ ls -l example_1/
total 0
drwxr-xr-x  2 vagrant  staff   64 Mar 26 18:07 input
drwxr-xr-x  2 vagrant  staff   64 Mar 26 18:07 output
-rw-r--r--  1 vagrant  staff   0 Mar 26 17:54 seqsA.fasta
```

The `mv` command can also used to rename files/directories by providing a new file/directory name during execution:

```console
vagrant@biobakery: ~$ cd /home/vagrant/data/sequences/example_1
vagrant@biobakery: ~$ mv seqsA.fasta new_sequences.fasta
vagrant@biobakery: ~$ ls -l 
total 0
drwxr-xr-x  2 vagrant  staff   64 Mar 26 18:07 input
drwxr-xr-x  2 vagrant  staff   64 Mar 26 18:07 output
-rw-r--r--  1 vagrant  staff   0 Mar 26 17:54 new_sequences.fasta
```

Deleting files is done using the `rm` command. 

**Caution should be exercised when deleting files on the command-line as no
prompts or warnings will be given to confirm that files are going to be deleted.** 

Let's try deleting the `new_sequences.fasta` file we just renamed:

```console
vagrant@biobakery: ~$ rm /home/vagrant/data/sequences/example_1/new_sequences.fasta
```

When deleting directories we must supply `rm` with the additional `-rf` arguments to ensure that any files found under 
the specified directory are also deleted. Failure to provide the `-rf` argument will result in `rm` returning an error:

```console
vagrant@biobakery: ~$ cd ..
vagrant@biobakery: ~$ pwd
/home/vagrant/data/sequences
vagrant@biobakery: ~$ rm example_1/
rm: js: is a directory
vagrant@biobakery: ~$ rm -rf example_1/
```

<div class="alert alert-success" role="alert">
  <b>Excercise #4</b>: Create a new directory under the <code>sequences</code> folder called <code>to_delete</code> and move all files that end in <code>.fasta</code> to the new directory. Delete this folder using <code>rm</code>
</div>


### Full Text Search With `grep`

Searching the contents of a text file is a useful operation made very easy through the use of the 
`grep` command:

```console
vagrant@biobakery: ~$ cd /home/vagrant/data/sequences
vagrant@biobakery: ~$ grep vagrant@biobakery: ~$ seqsA.fasta
vagrant@biobakery: ~$ sequence_1
vagrant@biobakery: ~$ sequence_2
vagrant@biobakery: ~$ sequence_3
vagrant@biobakery: ~$ sequence_4
```
`grep` will output the lines in the file that match our search term (`ACGT` in the example above).

Options can be passed to `grep` to print out the line number of the match:

```console
vagrant@biobakery: ~$ grep -n ACGT seqsA.fasta
2:ACGTAGGTCATTGACTATATACCA
4:GTCAGACCCACCCCGCACGGGGTAAATATGGCACGCGTCCGACCTGGTTCCTGGCGTTCTACGCTGCCACGTG
TTCATTAACTGTTGTTTGGTAGCACAAAAGTATTACCATGGTCCTAGAAGTTCGGCACAGTTAGTTCGAGCCTAA
TGTCACAAATGACGCAGAACGCCAATGAGTGCCAGACATTAGGTGGAGTTCAGTTCGGTAACGGAGAGACTCTGC
GGCGTACTTAATTATGCATTTGAAACGCGCCCAAGTGACGCTAGGCAAGTCAGAGCAGGTTCCCGTGTTAGCTTG
AGGGTAAACATACAAGCCGATTGAAGATGGGTAGGGGGCTTCAAATCGTCCAGCACTCCACAGTACCTCCGAGAG
CAAGTAGGGCACCCTGTAGTTCGAAGCGGAACTATTTCGAGGGGCGAGCCCACATCGTCTCTTCTGCGGATGACT
TAACACGCTAGGGAGGTGGAGTCGATTCCATCGATGGTTATAAATCAAAAAATCGGAACGCTGTCTGGAGGATGA
ATCTAACGGTGCGTATCTCGATCGCTCAGTCGCTTTTCGTACTGCGCGAAAGTTCGCACCGCTCATACACTTGGT
TCCGAAGCCTGTCCTGATATATGAATCCAAACTAGAGCGGGGCTCTTGACGTTTGGAGTTGTAAATATCTAATAT
TCCAATCGGCTTTTACGTGCACCACCGCGGGCGGCTGACGAGGGACTCACACCGAGAAACTAGACAGTTGCGCGC
TGGAAGTAGCGCCGGCTAAGAAAGACGCCTGGTACAGCAGGACTATGAAACCCGTACAAAGGCAACATCCTCACT
TCGGTGAATCGAAACGCGGCATCAAGGTTACTTTTTGGATACCTGAAACAAAACCCATCGTAGTCCTTAGACTTG
GGACACTTTCACCCCTAGGGCCCATATCTGGAAATAGACGCCAAGTTCAATCCGTACTCCGACGTACGATGGAAC
AGTGTGGATGTGACGAGCTTCATTTAT
```

Or just the name of the file a match was found in:

```console
vagrant@biobakery: ~$ grep -l ACGT seqsA.fasta
seqsA.fasta
```

<div class="alert alert-success" role="alert">
  <b>Excercise #5</b>: Search all FASTA files for the nucleotide sequence <code>GTCAGACC</code> in the 
  sequences folder.
</div>

### Unix Manual Pages

The majority of Unix commands will come with manuals built in that can be accessed using the `man` command:

```console
vagrant@biobakery: ~$ man ls
```
```console
LS(1)                     BSD General Commands Manual                    LS(1)

NAME
     ls -- list directory contents

SYNOPSIS
     ls [-ABCFGHLOPRSTUW@abcdefghiklmnopqrstuwx1] [file ...]

DESCRIPTION
     For each operand that names a file of a type other than directory, ls displays its name as well as any requested, associated informa-
     tion.  For each operand that names a file of type directory, ls displays the names of files contained within that directory, as well
     as any requested, associated information.

     If no operands are given, the contents of the current directory are displayed.  If more than one operand is given, non-directory op-
     erands are displayed first; directory and non-directory operands are sorted separately and in lexicographical order.

     The following options are available:

     -@      Display extended attribute keys and sizes in long (-l) output.

     -1      (The numeric digit ``one''.)  Force output to be one entry per line.  This is the default when output is not to a terminal.

     -A      List all entries except for . and ...  Always set for the super-user.

     -a      Include directory entries whose names begin with a dot (.).
...
```

Manuals for commands are useful to provide the myriad number of options that are availble. These man pages can be navigated using the 
same keys used with `less`: **Up**, **Down**, **Page Up**, **Page Down**, and **Spacebar** to navigate and **q** to exit.

### Misc. Tips and Tricks

Below are a collection of useful tips and tricks to have handy when working in the command-line
environment.

#### Accessing Command History

We can take a look at all the commands that we have executed in the current terminal session
by using the `history` command.

```console
vagrant@biobakery: ~$ history
10823  cd ..
10824  ls
10825  cd ..
10826  ls
10827  ls -ltrh
10828  cd ..
10829  ls
10830  ls -ltrh
10831  mkdir workshop
10832  cd workshop
10833  ls
10834  vi test.fasta
10835  grep ACGT seqsA.fasta
10836  grep -n ACGT seqsA.fasta
10837  grep -l ACGT seqsA.fasta
```

**Note: Closing the terminal window or shutting down/restarting your computer will wipe the command history.**

Also worth noting is that the **Up** and **Down** arrow keys can be used to cycle through the history and bring up any commands previously ran:

#### Auto-completing Commands

The **Tab** key can be used to bring up a list of commands or files/directories in the working directory 
that match whatever we are typing into the terminal.

An example can be seen below when typing `mk` into the termianl and hitting the **Tab** key:

<img src="{{ "/assets/img/labs/lab_2_unix_tab_complete_cmds.png" | prepend: site.baseurl }}"alt="Tab complete to list commands"/vagrant@biobakery: ~$

A list of all commands that start with the characters `mk` are returned.

Similarly we can use auto-complete/tab-complete to bring up a list of files in the working directory. 
Here we are using the `ls` command and the **Tab** key to bring up all files that begin with the characters `seq`:

<img src="{{ "/assets/img/labs/lab_2_unix_tab_complete_files.png" | prepend: site.baseurl }}" alt="Tab complete to list files in working directory"/vagrant@biobakery: ~$
