#!/usr/local/bin/perl

# Tugas 2 Perolehan Informasi
# Made Nindyatama N / 1306381622
# Stemming & Soundex

use strict;
use warnings;

open (IN, "masukan.txt");
open (OUT, ">tmp.txt");

my $line;
while ($line = <IN>) {
	chop($line);

	stemming($line);
}

close(IN);
close(OUT);

### STEMMING
sub stemming {
	my ($word) = @_;

	print OUT "$word ";

	$word = awalan($word);
	## DETEKSI KOMBINASI AKHIRAN
	## DETEKSI SISIPAN

	print OUT "$word \n";	
}

## DETEKSI AWALAN
sub awalan {
	my ($word) = @_;
	my $ok = 0;

	## DETEKSI KOMBINASI AWALAN
	($word, $ok) = awalanPer($word);
	if ($ok) {
		return $word;	
	}

	($word, $ok) = awalanBer($word);
	if ($ok) {
		return $word;	
	}

	($word, $ok) = awalanSe($word);
	if ($ok) {
		return $word;	
	}

	($word, $ok) = awalanTer($word);
	if ($ok) {
		# cth: terpelajar
		($word, $ok) = awalanPer($word);
		if ($ok) {
			return $word;
		}
		return $word;	
	}

	($word, $ok) = awalanKe($word);
	if ($ok) {
		# cth: kepemilikan
		($word, $ok) = awalanPe($word);
		if ($ok) {
			return $word;
		}
		return $word;		
	}

	($word, $ok) = awalanDi($word);
	if ($ok) {
		#cth: dipertahankan, dipelajari
		($word, $ok) = awalanPer($word);
		if ($ok) {
			return $word;	
		}
		return $word;
	}

	($word, $ok) = awalanMe($word);
	if ($ok == 2) {
		return $word;
	}
	elsif ($ok) {
		#cth: memperhatikan
		($word, $ok) = awalanPer($word);
		if ($ok) {
			return $word;	
		}
		return $word;
	}

	($word, $ok) = awalanPe($word);
	if ($ok) {
		return $word;	
	}

	return $word;
}

sub awalanKe {
	my ($word) = @_;
	my $isExist = 0;

	if ($word =~ /^ke[^aeiou]/) {
		$word =~ s/^ke//;
	}

	return ($word, $isExist);
}

sub awalanPe {
	my ($word) = @_;
	my $isExist = 0;

	if ($word =~ /^pe/) {
		$isExist = 1;
		if ($word =~ /^peng/) {
			$word =~ s/^peng//;
		}
		elsif ($word =~ /^peny/) {
			$word =~ s/^peny/s/;
		}
		elsif ($word =~ /^pen[aeiou]/) {
			$word =~ s/^pen/t/;
		}
		elsif ($word =~ /^pem[^aeiou]/) {
			$word =~ s/^pem//;
		}
		else {
			$word =~ s/^pe//;
		}
	}

	return ($word, $isExist);

	# belum bisa handle:
	# pemerhati -> perhati
}

sub awalanBer {
	my ($word) = @_;
	my $isExist = 0;

	if ($word =~ /^ber/) {
		$isExist = 1;
		$word =~ s/^ber//;
	} elsif ($word =~ /belajar/) {
		$isExist = 1;
		$word = "ajar";
	} elsif ($word =~ /^be.er/) {
		$isExist = 1;
		$word =~ s/^be//;
	}

	return ($word, $isExist);
}

sub awalanMe {
	my ($word) = @_;
	my $isExist = 0;

	if ($word =~ /^meng/) {
		if ($word =~ /^meng[a|e|i|o|u|h|g|kh]/) {
			$word =~ s/^meng//;
			$isExist = 1;
		}
	}
	elsif ($word =~ /^meny/) {
		$word =~ s/^meny/s/;
		$isExist = 1;
	}
	elsif ($word =~ /^mem/) {
		if ($word =~ /^mem[pbf]/) {
			$word =~ s/^mem//;
			$isExist = 1;
		}
		else {
			$word =~ s/^mem/p/;
			$isExist = 2;
		}
	}
	elsif ($word =~ /^men/) {
		if ($word =~ /^men[c|d|j|sy]/) {
			$word =~ s/^men//;
			$isExist = 1;
		}
	} 
	elsif ($word =~ /^me/) {
		$word =~ s/^me//;
		$isExist = 1;
	}

	return ($word, $isExist);
	# belum bisa handle: 
	# mengalah -> kalah, mengabarkan -> kabarkan
	# mengebom -> bom
	# menyatakan -> nyatakan
	# menanam -> tanam
	# menganga -> nganga
}

sub awalanDi {
	my ($word) = @_;
	my $isExist = 0;

	if ($word =~ /^di/) {
		$word =~ s/^di//;
		$isExist = 1;
	}

	return ($word, $isExist);
}

sub awalanTer {
	my ($word) = @_;
	my $isExist = 0;

	if ($word =~ /^ter/) {
		$word =~ s/^ter//;
		$isExist = 1;
	}

	return ($word, $isExist);
}

sub awalanSe {
	my ($word) = @_;
	my $isExist = 0;

	if ($word =~ /^se/) {
		$word =~ s/^se//;
		$isExist = 1;
	}

	return ($word, $isExist);
}

sub awalanPer {
	my ($word) = @_;
	my $isExist = 0;

	if ($word =~ /^per/) {
		$word =~ s/^per//;
		$isExist = 1;
	} elsif ($word =~ /pelajar/) {
		$word = "ajar";
		$isExist = 1;
	} elsif ($word =~ /^pe.er/) {
		$word =~ s/^pe//;
		$isExist = 1;
	}

	return ($word, $isExist);
}


### SOUNDEX
sub soundex {
	my ($word) = @_;

	# ambil karakter pertama
	my $fchar = substr $word, 0, 1;
	
	#  Ubah kemunculan karakter
	# A, E, I, O, U, H, W, Y -> 0
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

	# balikin character pertama setelah diubah menjadi huruf besar
	$fchar =~ tr/a-z/A-Z/;
	$word =~ s/^./$fchar/;

	# buang semua angka berurutan
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

	# tambahin 0 kalo length kurang dari 4
	my $tmp = length $word; 
	while ($tmp < 4) {
		$word .= "0";
		$tmp = $tmp + 1;
	}

	# ambil 4 karakter pertama
	$word = substr $word, 0, 4;

	return $word;
}
