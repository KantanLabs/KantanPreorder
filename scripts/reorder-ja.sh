#!/bin/sh

RULES=$PWD/scripts/rules/ja/

./scripts/tsurgeon_limited_depth.sh -treeFile $1 $RULES/reor_insertSubjSimple $RULES/reor_insertSubjChain $RULES/reor_sbarNP $RULES/reor_nppp $RULES/reor_sbarVP $RULES/reor_fullV $RULES/reor_Vpart $RULES/reor_neg $RULES/reor_inPP $RULES/reor_inSBAR $RULES/reor_whSBAR -s
