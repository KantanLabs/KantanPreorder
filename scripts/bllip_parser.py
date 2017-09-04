#!/usr/bin/python
# -*- coding: utf-8 -*-

import time
import sys
import os

import re
try:
	from bllipparser import RerankingParser
except:
	sys.path.append(os.path.join([os.path.dirname(__file__), "/bllip-parser/python/bllipparser"]))
	from bllipparser import RerankingParser

#finally:
#	sys.exit(1)

if __name__ == "__main__":
    file = ""
    if len(sys.argv) > 1:
        file = sys.argv[1]
    
    file = os.path.realpath(file)
    
    if not os.path.isfile(file):
        sys.exit(1)
    
    print "Reading file " + file + "..."
    
    script_dir = os.path.dirname(os.path.realpath(__file__))
    parser_model = os.path.join(script_dir, 'bllip-parser-model-2016-08-05')

    rrp = RerankingParser.from_unified_model_dir(parser_model)
    rrp.load_parser_model(parser_model)
    
    rrp.set_parser_options(language='En', case_insensitive=True, nbest=1, small_corpus=False, overparsing=5)
    
    with open(file, "r") as inFile:
        for line in inFile.readlines():
            parseTree = rrp.parse(line, rerank=False)[0].ptb_parse
            print re.sub('^\(S1', '(ROOT', str(parseTree))
