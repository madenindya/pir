#!/usr/local/bin/perl

# Tugas 3 Perolehan Informasi
# Made Nindyatama N / 1306381622
# Pre-processing

use strict;
use warnings;
use Switch;

open (IN, "corpus-tempo.xml");
open (OUT, ">Corpus.arff");

my $line;
my $detail;
my %topik;

while ($line = <IN>) {

	if ($line =~ /<berita>/) {

		my $hasil = "";
		my $tmp_topik;

		for (my $i = 0; $i < 6; $i++) {
			$detail = <IN>;
			chomp($detail);
			$detail =~ s/^[\s\t]+//;
			$detail =~ s/[\s\t]+$//;

			switch ($i) {
				case 0 {
					$detail =~ s/<judul>//;
					$detail =~ s/<\/judul>//;
					$hasil .= "\"$detail\",";
				}
				case 1 {}
				case 2 {}
				case 3 {
					$detail =~ s/<topik>//;
					$detail =~ s/<\/topik>//;
					$tmp_topik = "$detail";

					$topik{$detail}++;
				}
				case 4 {}
				else {
					$detail =~ s/<isi>//;
					$detail =~ s/<\/isi>//;
					$detail =~ s/"/\\"/g;

					$hasil .= "\"$detail\",";
				}
			}
		}

		print OUT "$hasil$tmp_topik\n";
	}
}

print "Topik dalam dokumen:\n";
for my $t (keys %topik) {
	print "$t 	: $topik{$t}\n";
}

close(IN);
close(OUT);
