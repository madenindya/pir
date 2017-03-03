#!/usr/local/bin/perl

# Tugas 3 Perolehan Informasi
# Made Nindyatama N / 1306381622
# Labeling

use strict;
use warnings;
use Switch;

open(OUT, ">labeling-hasil.txt");

my %stop_dict;

## MAIN PROGRAM
generate_stop();
label_corpus("kluster0.txt");
label_corpus("kluster1.txt");
label_corpus("kluster2.txt");
label_corpus("kluster3.txt");

sub label_corpus {
	my ($filename) = @_;

	open (IN, $filename);
	my $line;
	my %tf;
	my %df;
	my $count_line = 0;

	while ($line = <IN>) {
		$count_line++;

		# Proses isi dokumen saja
		if ($count_line % 2 == 0) {
			$line =~ s/<isi>//;
			$line =~ s/<\/isi>//;
			$line =~ tr/A-Z/a-z/;
			$line =~ s/[0-9()\-.,"'?!:;\|\/]/ /g;

			my %dok_tf;
			my @words_line = split(/\s/, $line);
			for my $w (@words_line) {
				if (length($w) > 0 && !is_sw($w)) {
					$dok_tf{$w}++;
				}
			}

			# update tf & df
			for my $w (keys %dok_tf) {
				$tf{$w} += $dok_tf{$w};
				$df{$w}++;
			}
		}
	}
	close(IN);

	print OUT "\n\n[Corpus] $filename\n";
	my $dok_count = $count_line/2.0;
	# weight based on tf.idf
	my %tfidf;
	for my $w (keys %tf) {
		my $n = $dok_count/$df{$w};
		my $idf = log($n)/log(10);
		$tfidf{$w} = $tf{$w} * $idf;
	}

	my %lasttry;

	print OUT "Jumlah dokumen: $dok_count\n";
	my $bobot = 20;
	my $count = 0; 
	for my $w (sort {$tf{$b} <=> $tf{$a}} keys %tf) {
		if ($count == 20) {
			last;
		}
		$lasttry{$w} += $bobot;
		$bobot--;
		print OUT "[TF] $w: $tf{$w}\n";
		$count++;
	}
	$count = 0; $bobot = 20;
	for my $w (sort {$df{$b} <=> $df{$a}} keys %df) {
		if ($count == 20) {
			last;
		}
		$lasttry{$w} += $bobot;
		$bobot--;
		print OUT "[DF] $w: $df{$w}\n";
		$count++;
	}
	$count = 0; $bobot = 20;
	for my $w (sort {$tfidf{$b} <=> $tfidf{$a}} keys %tfidf) {
		if ($count == 20) {
			last;
		}
		$lasttry{$w} += $bobot;
		$bobot--;
		print OUT "[TF.IDF] $w: $tfidf{$w}\n";
		$count++;
	}
	$count = 0; 
	for my $w (sort {$lasttry{$b} <=> $lasttry{$a}} keys %lasttry) {
		if ($count == 20) {
			last;
		}
		print OUT "[LAST] $w: $lasttry{$w}\n";
		$count++;
	}

}

close(OUT);

# generate stopword lookup
sub generate_stop {
	open (STOPWORDS, "stopwords_indo_modified.txt");
	my $sw;
	while ($sw = <STOPWORDS>) {
		chomp($sw);
		$sw =~ s/^[\s\t]+//;
		$sw =~ s/[\s\t]+$//;
		$stop_dict{$sw} = 1;
	}
	close (STOPWORDS);
}

# check if is a stopwords
sub is_sw {
	my ($word) = @_;

	if ($stop_dict{$word}) {
		return 1;
	}
	return 0;
}