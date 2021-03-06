#!/bin/bash

mosesdecoder=~/mosesdecoder
tok_gold_targets=newstest2013.tok.de

decodes_file=$1

cut -d'	' -f1 $decodes_file > $decodes_file.target

# Tokenize.
perl $mosesdecoder/scripts/tokenizer/tokenizer.perl -l de < $decodes_file.target > $decodes_file.tok

# Put compounds in ATAT format (comparable to papers like GNMT, ConvS2S).
# See https://nlp.stanford.edu/projects/nmt/ :
# 'Also, for historical reasons, we split compound words, e.g.,
#    "rich-text format" --> rich ##AT##-##AT## text format."'
perl -ple 's{(\S)-(\S)}{$1 ##AT##-##AT## $2}g' < $tok_gold_targets > $tok_gold_t
argets.atat
perl -ple 's{(\S)-(\S)}{$1 ##AT##-##AT## $2}g' < $decodes_file.tok > $decodes
_file.atat

# Get BLEU.
perl $mosesdecoder/scripts/generic/multi-bleu.perl $tok_gold_targets.atat < $decodes_file.tok.atat
