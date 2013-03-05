#! /usr/bin/perl
use Switch; 

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
    if($line){
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
    $line = depunct($line);
    if($line =~ m/\w/){
	my $lang = 0;
    
	my $eng_prob = 0; #total probability of the sentence
	my $fre_prob = 0;
	my $ger_prob = 0;
	
	my $ew_prob = 0; #probability of the word
	my $fw_prob = 0;
	my $gw_prob = 0;
	
	#splits into words
	my (@words) = split /\s+/, $line;
	foreach my $word (@words){
	    
	    #determines what language the word is most likely to be: 
	    #calculates probablility of the first letter p(c_0)
	    
	    #add-one smoothing to prevent division by zero
	    if($start_eng{substr $word, 0, 1} == 0){
		$start_eng{substr $word, 0, 1} ++;
		$sn_eng ++;
	    }
	    if($start_fre{substr $word, 0, 1} == 0){
		$start_fre{substr $word, 0, 1} ++;
		$sn_fre ++;
	    }
	    if($start_ger{substr $word, 0, 1} == 0){
		$start_ger{substr $word, 0, 1} ++;
		$sn_ger ++;
	    }
	    
	    $ew_prob = ($start_eng{substr $word, 0, 1} / $sn_eng)*1000;
	    $fw_prob = ($start_fre{substr $word, 0, 1} / $sn_fre)*1000;
	    $gw_prob = ($start_ger{substr $word, 0, 1} / $sn_ger)*1000;
	    
	    my $len = 0;
	    while($len < (length($word) - 1)){ 
		my $ngm = substr $word, $len, 2;  #splits word into bigrams
		
		
		#add-one smoothing to prevent divison by zero
		if($bigram_eng{$ngm} == 0){
		    $bigram_eng{$ngm} ++;
		    $num_bi_eng ++;
		}
		if($bigram_fre{$ngm} == 0){
		    $bigram_fre{$ngm}++;
		    $num_bi_fre ++;
		}
		if($bigram_ger{$ngm} == 0){
		    $bigram_ger{$ngm}++;
		    $num_bi_ger ++;
		}
		if($letter_eng{substr $word, $len, 1} == 0){
		    $letter_eng{substr $word, $len, 1} ++;
		    $num_le_eng ++;
		}
		if($letter_fre{substr $word, $len, 1} == 0){
		    $letter_fre{substr $word, $len, 1} ++;
		    $num_le_fre ++;
		}
		if($letter_ger{substr $word, $len, 1} == 0){
		    $letter_ger{substr $word, $len, 1} ++;
		    $num_le_ger ++;
		}
		
		
		#ENGLISH PROBABILITY
		$ew_prob *= 1000;
		$ew_prob *= ($bigram_eng{$ngm} / $num_bi_eng) ;     # P(n | n-1) = P( n-1 n)
		$ew_prob /= ($letter_eng{substr $word, $len, 1} / $num_le_eng ); #/ P( n-1)
		
		
		#FRENCH PROBABILITY
		$fw_prob *= 1000;
		$fw_prob *= ($bigram_fre{$ngm} / $num_bi_fre);
		$fw_prob /= ($letter_fre{substr $word, $len, 1} / $num_le_fre);
		
		
		#GERMAN PROBABLILITY
		$gw_prob *= 1000;
		$gw_prob *= ($bigram_ger{$ngm}/$num_bi_ger);
		$gw_prob /= ($letter_ger{substr $word, $len, 1} / $num_le_ger);
		
		$len++;
	    }#end while (done word)
	    
	    #add-one smoothing to prevent divison by zero
	    if($end_eng{substr $word, -1, 1} == 0){
		$end_eng{substr $word, -1, 1} ++;
		$en_eng ++;
	    }
	    if($end_fre{substr $word, -1, 1} == 0){
		$end_fre{substr $word, -1, 1} ++;
		$en_fre ++;
	    }
	    if($end_ger{substr $word, -1, 1} == 0){
		$end_ger{substr $word, -1, 1} ++;
		$en_ger ++;
	    }
	    
	    
	    
	    #calculates probability of the last letter p(c_n)
	    $ew_prob *= ($end_eng{substr $word, -1, 1} / $en_eng );
	    $fw_prob *= ($end_fre{substr $word, -1, 1} / $en_fre );
	    $gw_prob *= ($end_ger{substr $word, -1, 1} / $en_ger );
	    
	    #now, *_prob is equal to the entire probability of that word
	    $eng_prob += $ew_prob; #so we sum these probabilities
	    $fre_prob += $fw_prob;
	    $ger_prob += $gw_prob;
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
	    case 0 {print OUT "ERRRRRRRRR\n"}
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
