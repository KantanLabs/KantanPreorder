#!/bin/bash

RULES=$PWD/scripts/rules/zh/

if [[ -n $ZH_REORDER && $ZH_REORDER == "NPPP" ]];
then
	echo "Using NPPP Reordering rules" > reord.log
	./scripts/tsurgeon_limited_depth.sh -treeFile $1 $RULES/reor_sbarVP $RULES/reor_nppp -s
else
	echo "Using OFPP Reordering rules" > reord.log
	./scripts/tsurgeon_limited_depth.sh -treeFile $1 $RULES/reor_sbarVP $RULES/reor_ofPP -s
fi
