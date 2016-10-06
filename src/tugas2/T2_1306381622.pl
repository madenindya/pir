#!/usr/local/bin/perl

# Tugas 2 Perolehan Informasi
# Made Nindyatama N / 1306381622
# Stemming & Soundex

use strict;
use warnings;

### STEMMING
## DETEKSI KOMBINASI AWALAN
## DETEKSI KOMBINASI AKHIRAN
## DETEKSI SISIPAN

print soundex("made");
print "\n";
print soundex("nindyatama");
print "\n";
print soundex("nityasya");
print "\n";

### SOUNDEX
sub soundex {
	my ($word) = @_;

	my $fchar = substr $word, 0, 1;
	#  Ubah semua kemunculan dari karakter berikut
	# ini menjadi '0' (nol):
	# 'A', E', 'I', 'O', 'U', 'H', 'W', 'Y'. 
	$word =~ s/a|e|i|o|u|h|w|y/0/g;
	# B, F, P, V -> 1
	$word =~ s/b|f|p|v/1/g;
	# C, G, J, K, Q, S, X, Z -> 2
	$word =~ s/c|g|j|k|q|s|x|z/2/g;
	# D,T -> 3
	$word =~ s/d|t/3/g;
	# L -> 4
	$word =~ s/l/4/g;
	# M, N -> 5
	$word =~ s/m|n/5/g;
	# R -> 6
	$word =~ s/r/6/g;

	# balikin character pertama
	$word =~ s/^./$fchar/;

	#buang semua character double
	$word =~ s/11+/1/g;
	$word =~ s/22+/2/g;
	$word =~ s/33+/3/g;
	$word =~ s/44+/4/g;
	$word =~ s/55+/5/g;
	$word =~ s/66+/6/g;
	$word =~ s/77+/7/g;
	$word =~ s/88+/8/g;
	$word =~ s/99+/9/g;

	# buang semua 0
	$word =~ s/0//g;

	return $word;
}
