#!/bin/sh

scriptdir=`dirname $0`

java -mx500m -cp "$scriptdir/*:$scriptdir/lib/stanford-tregex-ld.jar:$scriptdir/lib/slf4j-simple.jar:$scriptdir/lib/slf4j-api.jar" edu.stanford.nlp.trees.tregex.tsurgeon.Tsurgeon_limited_depth "$@"
