#!/usr/bin/env bash
#
# Runs the English PCFG parser on one or more files, printing trees only

if [ ! $# -ge 1 ]; then
  echo Usage: `basename $0` 'file(s)'
  echo
  exit
fi

scriptdir=`dirname $0`
filedir=`dirname $1`

java -mx2g -cp "$scriptdir/stanford-corenlp-full-2016-10-31/*:$scriptdir/lib/slf4j-simple.jar:$scriptdir/lib/slf4j-api.jar" edu.stanford.nlp.pipeline.StanfordCoreNLP -annotators tokenize,ssplit,pos,parse -outputFormat json -outputDirectory "$filedir" -file $1
cat $1.json | jq -r ".sentences[].parse"