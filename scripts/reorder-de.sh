#!/bin/sh

RULES=$PWD/scripts/rules/de/

./scripts/tsurgeon_limited_depth.sh -treeFile $1 $RULES/reor_sbarVP $RULES/reor_mainV $RULES/reor_finVsbar $RULES/reor_finVextr $RULES/reor_presCnt $RULES/reor_neg $RULES/reor_to $RULES/reor_prt $RULES/prune_emptyVP  -s

