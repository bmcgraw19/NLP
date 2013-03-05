#! /usr/bin/perl
use Switch; 

require 'common_functions.pl';

open(EN, "<HW2-english.txt");
open(FR, "<HW2-french.txt");
open(GR, "<HW2-german.txt");
open(IN, "<LangID.test.txt");
#open(IN, "<test.txt");
open(OUT, ">BigramWordLangId-AO.out");

my %bi_eng; #hash of English bigrams & frequencies
my %wo_eng; #hash of English words & frequencies
my $cb_eng = 0; #number of English bigrams
my $cw_eng = 0; #number of English words seen

my %bi_fre; # "      French    "           "
my %wo_fre;
my $cb_fre = 0;
my $cw_fre = 0;

my %bi_ger; # "    "  German     "        "
my %wo_ger;
my $cb_ger = 0;
my $cw_ger = 0;

our @lines = (<EN>);
foreach $line (@lines){ #each line
    $line = depunct($line); #removes punctuation
    my (@words) = split /\s+/, $line; #split the line into words
    while( my ($index, $word) = each @words){
	%wo_eng{$word}++;
	$cw_eng++;
	if( $index != (@words - 2)){
	    $bi_eng{$words[$index] ." ". $words[$index+1]} ++;
	    $cb_eng ++;
	}#end if (bigram possible)
    } #end while (finished words in line)
}#end while (done english corpus parsing)

#does the same, but for the french corpus
foreach $line (<FR>){
    $line = depunct($line);
    my (@words) = split /\s+/, $line;
    while(my($index, $word) = each @words){
	%wo_fre{$word}++;
	$cw_fre++;
	if ($index != (@words-2)){
	    $bi_fre{$words[$index] ." ". $words[$index+1]} ++;
	    $cb_fre ++;
	}
    }
}

foreach $line (<GR>){
    $line = depunct($line);
    my (@words) = split /\s+/, $line;
    while(my($index, $word) = each @words){
	%wo_ger{$word}++;
	$cw_ger++;
	if( $index != (@words-2)){
	    $bi_ger{$words[$index] . " " . $words[$index+1]} ++;
	    $cb_ger ++;
	}
    }
}
#foreach my $i (sort {($bi_eng{$b} <=> $bi_eng{$a}) || ($a cmp $b )} keys %bi_eng){
 #   print OUT $i . ":   " . $bi_eng{$i}. "\n";
#}


#foreach my $i (sort {($letter_ger{$b} <=> $letter_ger{$a})*0 || ($a cmp $b)} keys %letter_ger){
#}

 print OUT "ID LANG\n";
@lines = (<IN>);
while ( my ($index, $line) = each @lines){ 
#    print OUT $index+1 . ". ";   #prints the line number
    chomp($line);   
    $line = depunct($line);
    if($line =~ m/\w/){
	my $lang = 0;
    
	my $pr_eng = 0; #total probability of the sentence
	my $pr_fre = 0;
	my $pr_ger = 0;

	#splits into words
	my (@words) = split /\s+/, $line;
	while(my ($index, $word) = each @words){
	    $pr_eng += (%wo_eng{$word}/$cw_eng);
	    $pr_fre += (%wo_fre{$word}/$cw_fre);
	    $pr_ger += (%wo_ger{$word}/$cw_ger);
	    if($index < (@words-2)){
		if(%bi_eng{$word." ".$words[$index+1]} == 0){
		   
		}
		$pr_eng *= (%bi_eng{$word . " " . $words[$index+1]});
		$pr_eng /= (%wo_eng{$word}/$cw_eng);
		
		$pr_fre *= (%bi_fre{$word . " " . $words[$index+1]});
		$pr_fre /= (%wo_fre{$word}/$cw_eng);

		$pr_ger *= (%bi_ger{$word . " " . $words[$index+1]});
		$pr_ger /= (%wo_fre{$word}/$cw_eng);
	    }
	}
	#Computes which is the largest
	if($eng_prob > $fre_prob && $eng_prob > $ger_prob){
	    $lang = 1;
	}
	if($fre_prob > $eng_prob && $fre_prob > $ger_prob){
	    $lang = 2;
	}
	if($ger_prob > $eng_prob && $ger_prob > $fre_prob){
	    $lang = 3;
	}
	
	switch ($lang){
	    case 0 {print OUT "ERROR\n"}
	    case 1 {print OUT "EN\n"}
	    case 2 {print OUT "FR\n"}
	    case 3 {print OUT "GR\n"}
	} #end while (done parsing in file) 
    }
}

close(EN);
close(FR);
close(GR);
close(IN);
	close(OUT);
