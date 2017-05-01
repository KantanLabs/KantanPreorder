#!/usr/bin/perl -w
#

#
# This script extract a sentence from parse trees. 
# The sentences are tokenized.
#
# Author: Dimitar Shterionov, Anita Ramm
# Data: 16/09/2016

use strict;
use warnings;

# define packages used
use Getopt::Long;                       # lib for getting command line options
use utf8;

my $input = "";                         # this is the path of the file containing a phrase-table (zip or unzipped)
my $help;                               # check for help

# First, read the input arguments - a file containing trees: one tree per line
my $result = GetOptions("input:s"                       => \$input,
                        "i:s"                           => \$input,
                        "help"                          => \$help,
                        "h"                             => \$help
                        ) or die "\tERROR:\t Illegal arguments or parameters\n" .
				 "\tUsage:\t perl extractfromparsetrees.pl -i [PATH TO FILE CONTAINING TREES]\n";

if ( $help )
{
        help();
        exit 1;
}

# It is required to input at least either a zip or an uncompressed phrase table file.
if (  $input eq "" )
{
        die "\tERROR:\t No input file specified\n".
            "\tUsage:\t perl extractfromparsetrees.pl -i [PATH TO FILE CONTAINING TREES]\n";
}

sub help
{
        print <<HELP
Info:\t Extract tokenized sentences from file with parse trees.
Usage:\t perl extractfromparsetrees.pl -i [PATH TO FILE CONTAINING TREES]\n
        -i / --input\t\t Input file: text file containing trees.
        -h / --help\t\t Displays this
HELP
}

# we need to output in utf8
binmode STDOUT, ":utf8";


if ( -e $input )
{
	open(INPUT, "<:utf8", $input);

	while ( <INPUT> )
	{
		my $tree_segment = $_;
		chomp( $tree_segment );

		#my @reord_segment = $tree_segment =~ /\([A-Z.,;:-`"]+\s([^\)\(]+)\)/g;
		my @reord_segment = $tree_segment =~ /\([^\)\(]+\s([^\)\(]+)\)/g;
		#print "Wie bin ich -> @reord_segment <-\n";
		#print join " " => @reord_segment,"\n";
		foreach (@reord_segment)
		  {
		    s/-LSB-/\[/g;
		    s/-LRB-/\(/g;
		    s/-RSB-/\]/g;
		    s/-RRB-/\)/g;
		    print $_." ";
		  }
		print "\n";

	}
}
