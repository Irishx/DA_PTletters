#!/usr/bin/perl


# Feb 2017, iris
# script to parse XML of PS letters to extract the discourse parts of the letters
#and writes them to different files.
# this scripts extracts normalized lemma forms 
# Note that it works on <s> elements with a 'formula' attribute.


use strict;
use XML::Twig;  
use utf8;
use open ":encoding(utf8)";
binmode(STDOUT, ":utf8");

# create object
#$xml = new XML::Simple;

# read XML file



#my $file ="CARDS5080.xml";
my $file = $ARGV[0];
my $outdir = $ARGV[1];

open(OUT_PER, ">>$outdir/ps_text_peroration.txt" )|| die "cant open $outdir/ps_text_peroration.txt";
open(OUT_HAR, ">>$outdir/ps_text_harangue.txt" )|| die "cant open $outdir/ps_text_harangue.txt";
open(OUT_NON, ">>$outdir/ps_text_nonnar.txt" )|| die "cant open $outdir/ps_text_nonnar.txt";
open(OUT_BODY, ">>$outdir/ps_text_body.txt" )|| die "cant open $outdir/ps_text_body.txt";
open(OUT_OPEN, ">>$outdir/ps_text_opener.txt" )|| die "cant open $outdir/ps_text_opener.txt";
open(OUT_CLO, ">>$outdir/ps_text_closer.txt" )|| die "cant open $outdir/ps_text_closer.txt";

get_XML_content($file);
     

sub get_XML_content{
    
 my $file = $_[0];

#only take the 's' sentence XML parts that are inside <body>.
 my $twig= new XML::Twig( twig_roots    => { 'body' => 1 },
       		          twig_handlers => { 's'=> \&do_sentence } ); 

 $twig->parsefile( "$file");     
}

#for every sentence in the body
sub do_sentence{ 
 my( $twig, $elem)= @_;                 # handlers params      
 
# get a list of the tokens in the sentence
# and for every token get the lemma.
#however, sometimes the tokens are nested one layer deeper in 'dateLet' or 'salute'.

   my @tokens = $elem->children( 'tok');   # get the children
   if($#tokens >=0){ &print_tokens($twig, $elem, @tokens); }
  
   if($#tokens <0){
       #print "NO direct TOK childeren here\n";
       my @nodes = $elem->children;
       foreach my $node (@nodes)
       {
         @tokens = $node->children( 'tok');   # get the GRANDchildren
	 &print_tokens($twig, $elem, @tokens);  
       }
   } 
}

sub print_tokens{
 my( $twig, $elem, @tokens)= @_;                 # handlers params      
 my ($myattribute, $attribute_value);                  
 my $sentence =();
 foreach my $tok (@tokens)
   {
	  my $lemma = ${$tok->atts}{ 'lemma' }; 
	  my $nform= ${$tok->atts}{ 'nform' }; 
          #if we dont have a lemma, take nform, or otherwise the token itself
          if($lemma eq "")
          {
	      if($nform ne ""){$lemma= $nform;}
              else{ $lemma = $tok->text; }
          }
          # print " lemma= $lemma\n";
	  $sentence .= "$lemma ";
  }
           
      
# Check for each node <s> element which attributes it has.
# this loop over-generates for this purpose
# foreach $myattribute ( keys( %{$elem->atts} ) ) 
# { 
#    $attribute_value = ${$elem->atts}{ $myattribute }; 
#    my $string  = $elem->text;            # get the text of element           
#     print "att= $attribute_value\n";    
# }


# Check for each node <s> element if it has  a 'formula' attribute
 # print nodes with attributes 'openener / peroration/etc' 
 # to different sub files                                                      

 $attribute_value = ${$elem->atts}{ 'formula' }; 

 my $string  = $sentence;
 $string =~ s/\n//g;  #make sure there are no newlines: one string perl line 
# print "== $attribute_value  $string\n";
if($string !~ /^\s*$/)
{
 if($attribute_value eq "peroration" )
 {

    print OUT_PER "$string\n";
           
  }
  elsif($attribute_value eq "opener" )
  {
     print OUT_OPEN "$string\n";

  }
  elsif($attribute_value eq "closer" )
  {
     print OUT_CLO "$string\n";
  }
  elsif($attribute_value eq "harangue" )
  {
      print OUT_HAR "$string\n";
  }
  elsif($attribute_value eq "non-narration" )
  {
	print OUT_NON "$string\n";
  }
  else{
	print OUT_BODY "$string\n";
    }
}     
}


close(OUT_HAR);
close(OUT_NON);
close(OUT_PER);
close(OUT_BODY);
