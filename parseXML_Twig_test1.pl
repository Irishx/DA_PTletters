#!/usr/bin/perl

# use module

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

sub do_sentence{ 
 my( $twig, $elem)= @_;                 # handlers params      
 my ($myattribute, $attribute_value);                  
 
 #check for each node s element which attribute it has.
 # print nodes with attributes to different sub files                                                        
foreach $myattribute ( keys( %{$elem->atts} ) ) 
{ 
    $attribute_value = ${$elem->atts}{ $myattribute }; 
    my $string  = $elem->text;            # get the text of element           
     #print "att= $attribute_value\n";
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
    else
    {

	print OUT_BODY "$string\n";

    }
     
}                                                         
           



}


close(OUT_HAR);
close(OUT_NON);
close(OUT_PER);
close(OUT_BODY);
