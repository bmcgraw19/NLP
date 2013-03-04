#! /usr/bin/perl

sub depunct($) {
    my ($line) = @_; 
    $line =~ tr/[A-Z]/[a-z]/;
    $line =~ s/[«-»]/ /g;
    $line =~ s/[[:punct:]]/ /g;
    $line =~ s/À/à/g;
    $line =~ s/Â/â/g;
    $line =~ s/Æ/æ/g;
    $line =~ s/Ç/ç/g;
    $line =~ s/É/é/g;
    $line =~ s/È/è/g;
    $line =~ s/Ê/ê/g;
    $line =~ s/Ë/ë/g;
    $line =~ s/Ï/ï/g;
    $line =~ s/Î/î/g;
    $line =~ s/Ô/ô/g;
    $line =~ s/Œ/œ/g;
    $line =~ s/Ä/ä/g;
    $line =~ s/Ö/ö/g;
    $line =~ s/Ü/ü/g;
    $line =~ s/€//g;
    $line =~ s/[\d]/ /g;
    $line =~ s/\"/ /g;
    $line =~ s/[‘«”»‘„–‹‚’›-“]+?/ /g;
    $line =~ s/\s+/ /g;
    $line =~ s/^\s//g;
    $line =~s/\s$//g;
    return $line;
}   
sub prob(%hash, $string, $freq){
   return ($hash{$str}/$freq);
}
 
1;
