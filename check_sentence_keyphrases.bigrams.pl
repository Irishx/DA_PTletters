#!/usr/bin/perl


#Iris, Feb 2017
# script to count the coverage of the typical terms (a list read in from a file)
# in every sentence
# output: percentage of coverage of the terms in the sentences.
#version with bigrams and trigrams

use strict;
use utf8;
use open ":encoding(utf8)";
binmode(STDOUT, ":utf8");
    
#use Text::Match::FastAlternatives;


my $keylist = $ARGV[0]; #file
my $sentencefile = $ARGV[1]; #just a string
my @keywords;
my @bigrams;

#perl Scripts/check_sentence_keyphrases.pl Exp/Train/likelihood_body_harangue.m1l3t3.txt Exp/Dev/Fields/ps_text_harangue.txt 



open(LIST, $keylist) || die "cannot open $keylist\n";
while(<LIST>){

    chomp;
    my ($pattern,$LHOOD,$OCC_0,$FREQ_0,$OCC_1,$FREQ_1) = split /\t+/, $_;
    # only use those patteren with a log0score >20 and 
    # that focus on the strings typical for harangue/peroration
    if(length($pattern)>1 && $LHOOD >20 && $OCC_1>0 )
    {

	if($pattern =~ m/.\s./){ 
	   # print "bigram $pattern\n"; 
	    push @bigrams, $pattern; }
	else{ push @keywords, $pattern;}
    }
}close(LIST);

open(SEN,$sentencefile) || die 'cant open';
while(<SEN>)
{
   my $sentence = $_;
  #print the matching elements 
  # print "+ $sentence";
  # foreach my $el (@keywords)
  # {
   #  if( $sentence =~ /$el/){ print "$el --";}
   #}
   #print "\n";
   my $bool=0;
   my $perc=0;
   my @words= split /\s+/, $sentence;
    my $nbrwords =$#words+1;
  LOOP:  foreach my $el (@bigrams)
  {
       if( $sentence =~ /$el/){$bool++; }
  }
#   LOOP:  foreach my $el (@bigrams)
#   {
#     if( $sentence =~ /$el/){$bool=1;  last LOOP;}
#   }
  if($bool){
	$perc = ( $bool /$nbrwords)*100;
	if($perc >10){
	print "YES $perc = $bool /$nbrwords; - $sentence"; 
   }}
   $bool=0;

#module to do fast mapping: works when you want to know if a match exists and not to count stuff
#my $umatcher = Text::Match::FastAlternatives->new(@bigrams);
#if( $umatcher->match($sentence))
#{   print "yes bigram\n"; }


}close(SEN);
