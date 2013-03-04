#! /usr/bin/perl
use strict;
use warnings;
require 'common_functions.pl';

open (IN, '<test.txt');
open (OUT, '>BigramLetterLangId.out');
my @lines = (<IN>);
my $lane = 0;
foreach $lane (@lines){
    my $derp = "a";
    #print $derp;    
    $derp = depunct($lane);
    print OUT $derp . "\n";
}

close(IN);
