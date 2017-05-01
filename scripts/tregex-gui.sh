#!/bin/sh
scriptdir=`dirname $0`

java -mx100m -cp "$scriptdir/stanford-tregex.jar:$scriptdir/lib/slf4j-api.jar:$scriptdir/lib/slf4j-simple.jar" edu.stanford.nlp.trees.tregex.gui.TregexGUI
