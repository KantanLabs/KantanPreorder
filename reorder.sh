# ---------------------------------------------------------------------
# -------- Preordering Component for MT, based on parse-trees. --------
# This script applies tsurgeon/tregex-based reordering on parse-trees 
# corresponding to a source-langauge sentence. Once the parse-tree is
# modified (i.e. reordered), it is traveresed accordingly, in order to
# generate a sentence the word-order of which is typical for the tar-
# get language. A parse-tree is reordered based on hand-crafted tree-
# modification rules.
# 
# Creation date: 27/02/2016
# Main authors: Anita Ramm, Riccardo Superbo, Dimitar Shterionov
# 
# Version: 1.0
# Version date: 01/05/2017
# Version summary: Cleaning and preparing the code for deployment
# Blame: Dimitar Shterionov
# 
# To run:
# sh reorder.sh data/en.txt de 
# (this will invoke the script for the file 'data/en.txt'
# with the default (first) parser - BLLIP - provided with the code. 
# The output will be saved in 'reordered.txt')
# or:
# sh reorder.sh data/en.txt de 1 reordered_file_de.en
# (this will invoke the script for the file 'data/en.txt'
# with the default (first) parser - BLLIP - provided with the code. 
# The output will be saved in 'reordered_file_de.en')
# or:
# sh reorder.sh data/en.txt de 2
# (this will invoke the script for the file 'data/en.txt'
# with the second option for parser - Stanford Parser - NOT provided 
# with the code. The output will be saved in 'reordered.txt')
# or:
# sh reorder.sh data/en.txt de 3 reordered_file_de.en
# (this will invoke the script for the file 'data/en.txt'
# with the third option for parser - Stanford CoreNLP - NOT provided 
# with the code. The output will be saved in 'reordered_file_de.en')
#
# You may use the NPPP rules for Chinese if you set a global variable:
# export ZH_REORDER=NPPP
#
# NOTE!!!
# In order to run the Stanford CoreNLP or the Stanford Parser they
# need to be downloaded and set-up separately.
# 
# Reference: 
# Integration of a Multilingual Preordering Component Into a Commercial 
# SMT Platform, Anita Ramm, Riccardo Superbo, Dimitar Shterionov, in 
# proceedings of EAMT2017.


#!/bin/bash
export LC_ALL=C

INPUT=$1 # Input file
LANG=$2 # Langugae for which EN trees are to be reordered
WD=$PWD # Working directory
PARSERPATH=$WD/scripts # Path to the parser

if [[ -z $1 && -z $2 ]];
then
	echo "
INFORMATION: 	 -------- Preordering Component for MT, based on parse-trees. --------
		 This script applies tsurgeon/tregex-based reordering on parse-trees
		 corresponding to a source-langauge sentence.
TO RUN:		sh reorder.sh [INPUT] [LANG] [[PARSER]] [[OUTPUT]]
		INPUT: 	the input file
		LANG:	the language code (en, zh-cn, jp)
		PARSER (optional):	1 - bllip (default); 2 - Stanford CoreNLP (SR); 3 - Stanford Parser (PCFG)
		OUTPUT (optional):	the path to a file where the output will be saved (default reordered.txt)
	"
fi

# Set the parser type
PARSERTYPE="_bllip"
if [[ -n $3 && $3 == 2 ]];
then
	PARSERTYPE="_stanford_parser"
elif [[ -n $3 && $3 == 3 ]];
then
	PARSERTYPE="_stanford_corenlp"
fi

OUTPUT_FILE_NAME="reordered.txt"
if [[ -n $4 ]];
then
	OUTPUT_FILE_NAME=$4;
fi

# echo $WD

# Directory for parsing files: new directory 'parsing/' is created
if [ -r $WD/parsing ]; then
    echo "Removed aready existing $PWD/parsing/"
    rm -r $WD/parsing/
fi

mkdir $WD/parsing

# Get number of CPUs, i.e. of parsing/reordeing packages
CPU_COUNT=$(cat /proc/cpuinfo | grep processor | wc -l)

THREADS=5
if [ $THREADS -gt $CPU_COUNT ]; then
    echo "Decreasing the number of parallel jobs to "$CPU_COUNT
    THREADS=$CPU_COUNT
fi

#---------------------------------------------------
# split the files into several parts 
#---------------------------------------------------

split -e -n l/$THREADS --additional-suffix=.txt $INPUT parsing/input

NUMBEROFPACKAGES=$(ls -l parsing/input*.txt | wc -l)
SIZE=$((l/$THREADS))

echo "
Number of packages: $NUMBEROFPACKAGES ; Lines per package: $SIZE
"

#---------------------------------------------------
# parse each part
#---------------------------------------------------

parse () {
    INPUT=$1

    $PARSERPATH/./lexparser$PARSERTYPE.sh $WD/$INPUT > $WD/$INPUT.parsed
}

#---------------------------------------------------
# parse and reorder
#---------------------------------------------------

parseReorder () {
    INFILE=$1
    trg=$2

    $PARSERPATH/./lexparser$PARSERTYPE.sh $INFILE > $INFILE.parsed
	
	echo
	
    if [ "$2" = "de" ] ; then
		echo 'Reorder according the German syntax ...'
		$PARSERPATH/./reorder-de.sh $INFILE.parsed > $INFILE.reordered
	
    elif [ "$2" = "zh" ] ; then                                                                                                                      
        echo 'Reorder according the Chinese syntax ...'                                                                             
        $PARSERPATH/./reorder-zh.sh $INFILE.parsed > $INFILE.reordered
	
    elif [ "$2" = "ja" ] ; then
        echo 'Reorder according the Japanese syntax ...'                                                                                      
        $PARSERPATH/./reorder-ja.sh $INFILE.parsed > $INFILE.reordered
    fi
    
	perl $WD/scripts/extractfromparsetree.pl -i $INFILE.reordered > $INFILE.reordered.txt
}

for FILE in $WD/parsing/input*.txt
do
	echo $FILE
    parseReorder $FILE $LANG &
done

echo "Parsing in progress..... 
"

#---------------------------------------------------
# wait until finished
#---------------------------------------------------

wait

#---------------------------------------------------
# concatenate packages
#---------------------------------------------------

echo "Concatenating temporary files ....
"

cat $WD/parsing/input*.reordered.txt > $OUTPUT_FILE_NAME

echo "Cleaning ...
"
# rm $WD/parsing -r

echo "Done.
"
