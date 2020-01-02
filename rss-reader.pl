#!/usr/bin/perl -w
############################
# Creator: Jeff Israel
#
# Script:	./simple-rss-reader-v3.pl
# Version: 	3.001
#
# Coded for for Wikihowto http://howto.wikia.com
#
# Description: 	This code downloads an RSS feed, 
# 		extracts the <title> lines,
# 		cleans them up lines,
# 		prints the pretty lines
# 		exits on max-lines
# Usage:
# .conkyrc: ${execi [time] /path/to/script/simple-rss-reader-v3.pl}
#
# Usage Example
# ${execi 300 /path/to/script/simple-rss-reader-v3.pl}
##20

use LWP::Simple;
#use utf8;
use Encode;
############################
# Configs
#
#$rssPage = "http://tvrss.net/feed/combined/";
#$rssPage = "http://tvrss.net/feed/eztv/";
$rssPageWilliamlong = "https://www.williamlong.info/rss.xml";
$rssPage36kr = "https://36kr.com/feed";
#$rssPage = "https://xbeta.info/feed";
#$rssPage = "https://feeds.appinn.com/appinns/";
$numLines = 10;
$maxTitleLenght = 35;

###########################
# Code
#
# Downloading RSS feed
my $pageCont = get($rssPageWilliamlong) . get($rssPage36kr);
$pageCont =~ s/\n//g;
$pageCont =~ s/\<title\>/\n\<title\>/g;
$pageCont =~ s/\<\/title\>/\<\/title\>\n/g;
@pageCont = split(/\<\?xml/, $pageCont);

foreach $page (@pageCont) {
# Spliting the page to lines
@pageLines = split(/\n/,$page);

# Parse each line, strip no-fun data, exit on max-lines
#$numLines--; #correcting count for loop
$x = 1;
foreach $line (@pageLines) {
	if($line =~ /\<title\>/){ # Is a good line?
		#print "- $line\n";
		$lineCat = $line;
		$lineCat =~ s/.*\<title\>|\<\/title\>.*|\<\!\[CDATA\[|\]\]\>//g;
		#$lineCat =~ s/\[.{4,25}\]$//; # strip no-fun data ( [from blaaa] )
		$lineCat = substr($lineCat, 0, $maxTitleLenght);
		$lineCat = encode_utf8($lineCat);

		if($x == 1){
			print "\n" . $lineCat . "\n";
		}else{
			print "- $lineCat \n";
		}
		$x++;
	}
	if($x > $numLines) {
		last; #exit on max-lines
	}
}
#print $page;
#print "\nBy Bye\n";
}
