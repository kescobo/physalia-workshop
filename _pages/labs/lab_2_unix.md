---
layout: default
title: "Lab #2 - Introduction to Command-line Unix"
permalink: /labs/2_unix
---

# Lab #2 - Introduction to Command-line Unix

**The goal of this lab is to become familiar operating in the Unix command-line interface.**

Most bioinformatic tools are written for use in the Unix environment so becoming comfortable with 
navigating the command-line is a useful skill to have and will be necessary to complete the majority 
of upcoming labs.

## Navigation in Linux

The Unix directory structure can be visualized as a tree. Each level of the tree indicates a series 
of folders or files which can have zero or many nested child folders/files.

<img class="mx-auto d-block" src="/assets/img/labs/lab_1_unix_dir_tree.png" alt="Unix Directory Tree Structure" />

It is important to know where we are when navigating the Unix directory structure. The current directory 
you operate out of is called the **Working Directory** and we can print this out by using the `pwd` command:

```bash
> pwd 
/home/unix/carze
```

Navigation is primarly handled by the **C**hange **D**irectory command `cd`:

```bash
> cd data/
> pwd 
/home/unix/carze/data
```

It is also possible to traverse multiple directories in one `cd` command:

```bash
> cd data/sequences/example_1/
> pwd
/home/unix/carze/data/sequences/example_1
```

We can navigate backwards up the Unix directory tree by using using the special characters `..` in 
conjunction with `cd`:

```bash
> pwd
/home/unix/carze/data/sequences/example_1
> cd ..
> pwd 
/home/unix/carze/data/sequences
```

**Excercise #1**: *Try changing using the `cd` and `pwd` commands to navigate around your home directory.*

## Listing and Manipulating Files

Now that we know how to navigate around the Unix file structure we will want to see what files/directories are 
present in our working directory. This is accomplished using the `ls` command:

```bash
> pwd
/home/unix/carze/data/sequences
> ls
example_1   example_2   seqsA.fasta seqsB.fastq
```

We can see that there are multiple files/directories under the `/home/unix/carze/data/sequences` location 
we don't know much about each of these files. The `ls` command can be invoked using several arguments
which can transform what is returned to us. Arguments are provided in the following format `ls <ARGUMENT> <FILE|DIRECTORY>`.

We can use the `-l` command to request a long list of the contents of a directory which is much more detailed than what is 
provided by the base `ls` command:

```bash
> pwd
/home/unix/carze/data/sequences
> ls -l 
total 0
drwxr-xr-x  2 carze  staff  64 Mar 26 17:54 example_1
drwxr-xr-x  2 carze  staff  64 Mar 26 17:54 example_2
-rw-r--r--  1 carze  staff   0 Mar 26 17:54 seqsA.fasta
-rw-r--r--  1 carze  staff   0 Mar 26 17:54 seqsB.fastq
```

Here we get several new pieces of information about the content under the current working directory including permissions, owner, 
file size and date last updated.

The `ls` command does not restrict us to listing files only in our working directory; the location to any file or directory can 
be provided with the same results:

```bash
> pwd
/home/unix/carze/data/sequences
> ls -l /home/unix/carze/data
total 0
drwxr-xr-x  2 carze  staff   64 Mar 26 18:07 hmp2
drwxr-xr-x  2 carze  staff   64 Mar 26 18:07 output
drwxr-xr-x  6 carze  staff  192 Mar 26 18:07 sequences

> ls -l /home/unix/carze/data/sequences/example_1
total 0
drwxr-xr-x  2 carze  staff   64 Mar 26 18:07 input
drwxr-xr-x  2 carze  staff   64 Mar 26 18:07 output

> ls -l /home/unix/carze/data/sequences/seqsA.fasta
-rw-r--r--  1 carze  staff   0 Mar 26 17:54 seqsA.fasta
```

