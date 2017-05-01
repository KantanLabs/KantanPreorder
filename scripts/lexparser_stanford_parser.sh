#!/usr/bin/env bash
#
# Runs the English PCFG parser on one or more files, printing trees only

if [ ! $# -ge 1 ]; then
  echo Usage: `basename $0` 'file(s)'
  echo
  exit
fi

scriptdir=`dirname $0`

java -mx4g -cp "$scriptdir/*:$scriptdir/stanford-parser-full-2016-10-31/*:$scriptdir/lib/slf4j-simple.jar:$scriptdir/lib/slf4j-api.jar" \
	edu.stanford.nlp.parser.lexparser.LexicalizedParser \
	-outputFormat "oneline" -sentences newline \
	-model edu/stanford/nlp/models/lexparser/englishPCFG.ser.gz $*