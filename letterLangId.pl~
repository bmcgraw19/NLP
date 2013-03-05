#! /usr/bin/perl
use warnings;
use strict; 

require 'common_functions.pl';

open(EN, "<HW2-english.txt");
open(FR, "<HW2-french.txt");
open(GR, "<HW2-german.txt");
open(IN, "<LangID.test.txt");
#open(IN, "<test.txt");
open(OUT, ">BigramLetterLangId.out");

my @bigram = ( 'aa' .. 'zz' ); #initializes all possible bigrams
my %bigram_eng;
my %bigram_fre;
my %bigram_ger;
my $num_bi_eng = 0;
my $num_bi_fre = 0;
my $num_bi_ger = 0;

my @letter = ( 'a' .. 'z' ) ; #initializes all (supposed) possible letters
my %letter_eng;
my %letter_fre;
my %letter_ger;
my $num_le_eng = 0;
my $num_le_fre = 0;
my $num_le_ger = 0;

foreach my $i (@bigram){  #populates hash of bigrams
    $bigram_eng{$i}=0;
    $bigram_fre{$i}=0;
    $bigram_ger{$i}=0;
}

foreach my $i (@letter){ #populates hash of letters
    $letter_eng{$i}=0;
    $letter_fre{$i}=0;
    $letter_ger{$i}=0;
}

my %start_eng;  #initializes all first letters
my %start_fre;
my %start_ger;
my $sn_eng = 0; #and their counts
my $sn_fre = 0;
my $sn_ger = 0;

my %end_eng;   #initializes all last letters
my %end_fre;
my %end_ger;
my $en_eng = 0; #and their counts
my $en_fre = 0;
my $en_ger = 0;

my @startLetter = ('a' .. 'z'); #initializes all word beginnings and endings
foreach my $i (@startLetter){
    $start_eng{$i} = 0; #to a count of zero
    $start_fre{$i} = 0;
    $start_ger{$i} = 0;
    $end_eng{$i} = 0;
    $end_fre{$i} = 0;
    $end_ger{$i} = 0;
}
my $line = "";
our @lines = (<EN>);
foreach $line (@lines){ #each line
    $line = depunct($line); #removes punctuation
    my (@words) = split /\s+/, $line; #split the line into words
    foreach my $word (@words){ #each word	
	my $len = 0;
	
	$letter_eng{ (substr $word, 0, 1) }++;#adds first letter	
	$start_eng{(substr $word, 0, 1)} ++;
	
	if((substr $word, 0, 1) ne ""){ #prevents blank letters
	    $num_le_eng ++; #increments number of letters
	    $sn_eng ++;
	}
	if(length($word) ne 0) {
	    while($len < (length($word) - 1)){ 
		my $eng_gram = substr $word, $len, 2; #defines the bigram
		
		$letter_eng{ (substr $word, $len+1, 1)}++; #add letter
		if((substr $word, $len+1, 1) ne ""){
		    $num_le_eng ++; #increment total number of letters
		}

		$bigram_eng{$eng_gram}++; #add bigram 
		$num_bi_eng ++; #increment total num of bigrams
		
		$len++;
	    }
	    $end_eng{substr $word, -1, 1} ++; #remembers the last letter
	    $en_eng ++; #and increments the last letter count
	}
	
	
    }
}
#does the same, but for the french corpus
foreach $line (<FR>){
    $line = depunct($line);
    my (@words) = split /\s+/, $line;
    foreach my $word (@words){
	my $len = 0;

	$letter_fre{ (substr $word, 0, 1)}++;
	$start_fre{(substr $word, 0, 1)}++;
	if((substr $word, 0,1) ne ""){
	    $num_le_fre ++;
	    $sn_fre ++;
	}
	while($len < (length($word) - 1)){
	    $letter_fre{ (substr $word, $len+1, 1)}++;
	    if((substr $word, $len+1, 1) ne ""){
		$num_le_fre ++;
	    }
	    
	    my $fre_gram = substr $word, $len, 2;
	    $bigram_fre{$fre_gram}++;
	    $num_bi_fre ++;

	    $len++;
	}
	$end_fre{substr $word, -1, 1}++;
	$en_fre ++;
    }
}

foreach $line (<GR>){
    $line = depunct($line);
    my (@words) = split /\s+/, $line;
    foreach my $word (@words){
	my $len = 0;
	$letter_ger{ (substr $word, 0, 1)}++;
	$start_ger{(substr $word, 0, 1)}++;
	if((substr $word, 0, 1) ne ""){
	    $num_le_ger ++;
	    $sn_ger ++;
	}
	while($len < (length($word) - 1)){
	    $letter_ger{ (substr $word, $len + 1, 1)}++;
	    if((substr $word, $len+1, 1) ne ""){
		$num_le_ger ++;
	    }
	    my $ger_gram = substr $word, $len, 2;
	    $bigram_ger{$ger_gram}++;
	    $num_bi_ger ++;
	    $len++;
	}
	$end_ger{substr $word, -1, 1} ++;
	$en_ger ++;
    }
}
#foreach my $i (sort {($bigram_ger{$b} <=> $bigram_ger{$a}) || ($a cmp $b )} keys %bigram_ger){
 #    print OUT $bigram_ger{$i};
#}


#foreach my $i (sort {($letter_ger{$b} <=> $letter_ger{$a})*0 || ($a cmp $b)} keys %letter_ger){
#}

print OUT "ID LANG\n";
@lines = (<IN>);
while ( my ($index, $line) = each @lines){ 
    print OUT $index+1 . ". ";   #prints the line number
    chomp($line);    
    my $lang = 0;
    
    #splits into words
    my (@words) = split /\s+/, $line;
    foreach my $word (@words){
	#determines what language the word is most likely to be
	my $eng_prob = 0;
	my $fre_prob = 0;
	my $ger_prob = 0;

	my $len = 0;
	#calculates probablility of the first letter p(c_0)
	while($len < (length($word) - 1)){ 
	    my $ngm = substr $word, $len, 2;  #splits word into bigrams
	    
	    #ENGLISH PROBABILITY
	    $ew_prob = ($bigram_eng{$ngm} /$num_bi_eng) ;     # P(n | n-1) = P( n-1 n)
	    $ew_prob /= ($letter_eng{substr $word, $len+1, 1} / $num_le_eng ); #/ P( n-1)
	    $eng_prob += $ew_prob;

	    #FRENCH PROBABILITY
	    $fw_prob = ($bigram_fre{$ngm} / $num_bi_fre);
	    $fw_prob /= ($letter_fre{substr $word, $len+1, 1} / $num_le_fre);
	    $fre_prob += $fw_prob;
	    
	    #GERMAN PROBABLILITY
	    $gw_prob = ($bigram_ger{$ngm}/$num_bi_ger);
	    $gw_prob /= ($letter_ger{substr $word, $len+1, 1} / $num_le_ger);
	    $ger_prob += $gw_prob;
	    $len++;
	}
    }
	#Computes which is the largest
	if( $eng_prob >= $fre_prob){
	    if($eng_prob >= $ger_prob){
		$lang = 1;
	    }
	}
    }
    switch ($lang){
	case 0 {print OUT "ERR\n"}
	case 1 {print OUT "ENG\n"}
	case 2 {print OUT "FRE\n"}
	case 3 {print OUT "GER\n"}
}

close(EN);
close(FR);
close(GR);
close(IN);
close(OUT);
