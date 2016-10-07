#!/usr/local/bin/perl

# Tugas 2 Perolehan Informasi
# Made Nindyatama N / 1306381622
# Stemming & Soundex

use strict;
use warnings;


open (IN, "masukan.txt");
open (OUT, ">tmp.txt");

## MAIN PROGRAM
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
	$word = sisipan($word);
	$word = akhiran($word);

	print OUT "$word\n";
}

# sisipan (, -em-, -in-, -ah-)
## DETEKSI SISIPAN 
sub sisipan {
	my ($word) = @_;
	my $ok = 0;

	($word, $ok) = sisipanEl($word);
	if ($ok) {
		return $word;
	}

	($word, $ok) = sisipanEr($word);
	if ($ok) {
		return $word;
	}

	($word, $ok) = sisipanEm($word);
	if ($ok) {
		return $word;
	}

	($word, $ok) = sisipanIn($word);
	if ($ok) {
		return $word;
	}

	($word, $ok) = sisipanAh($word);
	if ($ok) {
		return $word;
	}

	return $word;
}

sub sisipanEl {
	my ($word) = @_;
	my $ok = 0;
	my $wordtmp = $word;

	if ($word =~ /^.el.+/) {
		$word =~ s/el//;
		$ok = 1;
	}

	my $len = length $word;
	if ($len < 4) {
		# contoh : jelek -> jelek
		$word = $wordtmp;
	}

	return ($word, $ok);

	# keledai -> kedai
}

sub sisipanEr {
	my ($word) = @_;
	my $ok = 0;
	my $wordtmp = $word;

	if ($word =~ /^.er.+/) {
		$word =~ s/er//;
		$ok = 1;
	}

	my $len = length $word;
	if ($len < 4) {
		# contoh: berat -> berat
		$word = $wordtmp;
	}

	return ($word, $ok);

	# tidak dapat handle 
	# Gendang -> genderang
}

sub sisipanEm {
	my ($word) = @_;
	my $ok = 0;
	my $wordtmp = $word;

	if ($word =~ /^.em.+/) {
		$word =~ s/em//;
		$ok = 1;
	}

	my $len = length $word;
	if ($len < 4) {
		# contoh: gemar -> gemar
		$word = $wordtmp;
	}

	return ($word, $ok);

	# gelembung -> gembung
}

sub sisipanIn {
	my ($word) = @_;
	my $ok = 0;
	my $wordtmp = $word;

	if ($word =~ /^.in.+/) {
		$word =~ s/in//;
		$ok = 1;
	}

	my $len = length $word;
	if ($len < 4) {
		# contoh: sinar -> sinar
		$word = $wordtmp;
	}

	return ($word, $ok);
}

sub sisipanAh {
	my ($word) = @_;
	my $ok = 0;
	my $wordtmp = $word;

	if ($word =~ /^.ah.+/) {
		$word =~ s/ah//;
		$ok = 1;
	}

	my $len = length $word;
	if ($len < 4) {
		# contoh: jahit -> jahit
		$word = $wordtmp;
	}

	return ($word, $ok);
}


## DETEKSI AKHIRAN 
sub akhiran {
	my ($word) = @_;
	my $ok = 0;

	# kan an i
	($word, $ok) = akhiranLevel0($word);
	if ($ok) {
		return $word;
	}

	# milik: -ku, -mu, -nya
	($word, $ok) = akhiranLevel1($word);
	if ($ok) {
		return $word;
	}

	# kah tah
	($word, $ok) = akhiranLevel2($word);
	if ($ok) {
		return $word;
	}

	return $word;
}

sub akhiranLevel0 {
	my ($word) = @_;
	my $ok = 0;

	($word, $ok) = akhiranKan($word);
	if ($ok) {
		return ($word, $ok);
	}

	($word, $ok) = akhiranAn($word);
	if ($ok) {
		return ($word, $ok);
	}

	($word, $ok) = akhiranI($word);
	if ($ok) {
		return ($word, $ok);
	}

	return ($word, $ok);
}

sub akhiranLevel1 {
	my ($word) = @_;
	my $ok = 0;

	($word, $ok) = akhiranKu($word);
	if ($ok) {
		return akhiranLevel0($word);
	}

	($word, $ok) = akhiranMu($word);
	if ($ok) {
		return akhiranLevel0($word);
	}

	($word, $ok) = akhiranNya($word);
	if ($ok) {
		return akhiranLevel0($word);
	}

	return ($word, $ok);
}

sub akhiranLevel2 {
	my ($word) = @_;
	my $ok = 0;

	($word, $ok) = akhiranKah($word);
	if ($ok) {
		return akhiranLevel1($word);
	}

	($word, $ok) = akhiranTah($word);
	if ($ok) {
		return akhiranLevel1($word);
	}

	return ($word, $ok);
}

sub akhiranKan {
	my ($word) = @_;
	my $isExist = 0;

	my $wordtmp = $word;
	if ($word =~ /kan$/) {
		$word =~ s/kan$//;
		my $len = length $word;

		# jika word yang dihasilkan kurang length-nya kurang dari 3, dianggap bukan word.
		# Cth: makan -> makan
		if ($len < 3) {
			$word = $wordtmp;
		}
		else {
			$isExist = 1;
		}
	}

	return ($word, $isExist);
}

sub akhiranAn {
	my ($word) = @_;
	my $isExist = 0;

	my $wordtmp = $word;
	if ($word =~ /an$/) {
		$word =~ s/an$//;
		my $len = length $word;

		# jika word yang dihasilkan kurang length-nya kurang dari 4, dianggap bukan word.
		if ($len < 4) {
			$word = $wordtmp;
		}
		else {
			$isExist = 1;
		}
	}

	return ($word, $isExist);
}

sub akhiranI {
	my ($word) = @_;
	my $isExist = 0;

	my $wordtmp = $word;
	if ($word =~ /i$/) {
		$word =~ s/i$//;
		my $len = length $word;

		# jika word yang dihasilkan kurang length-nya kurang dari 5, dianggap bukan word.
		if ($len < 5) {
			$word = $wordtmp;
		}
		else {
			$isExist = 1;
		}
	}

	return ($word, $isExist);
}

sub akhiranKu {
	my ($word) = @_;
	my $isExist = 0;

	my $wordtmp = $word;
	if ($word =~ /ku$/) {
		$word =~ s/ku$//;
		my $len = length $word;

		# jika word yang dihasilkan kurang length-nya kurang dari 4, dianggap bukan word.
		if ($len < 4) {
			$word = $wordtmp;
		}
		else {
			$isExist = 1;
		}
	}

	return ($word, $isExist);
}

sub akhiranMu {
	my ($word) = @_;
	my $isExist = 0;

	my $wordtmp = $word;
	if ($word =~ /mu$/) {
		$word =~ s/mu$//;
		my $len = length $word;

		# jika word yang dihasilkan kurang length-nya kurang dari 4, dianggap bukan word.
		if ($len < 4) {
			$word = $wordtmp;
		}
		else {
			$isExist = 1;
		}
	}

	return ($word, $isExist);
}

sub akhiranNya {
	my ($word) = @_;
	my $isExist = 0;

	my $wordtmp = $word;
	if ($word =~ /nya$/) {
		$word =~ s/nya$//;
		my $len = length $word;

		# jika word yang dihasilkan kurang length-nya kurang dari 3, dianggap bukan word.
		# haknya -> hak; tanya -> tanya
		if ($len < 3) {
			$word = $wordtmp;
		}
		else {
			$isExist = 1;
		}
	}

	return ($word, $isExist);
}

sub akhiranKah {
	my ($word) = @_;
	my $isExist = 0;

	my $wordtmp = $word;
	if ($word =~ /kah$/) {
		$word =~ s/kah$//;
		my $len = length $word;

		# jika word yang dihasilkan kurang length-nya kurang dari 3, dianggap bukan word.
		# apakah -> apa; nikah -> nikah
		if ($len < 3) {
			$word = $wordtmp;
		}
		else {
			$isExist = 1;
		}
	}

	return ($word, $isExist);
}

sub akhiranTah {
	my ($word) = @_;
	my $isExist = 0;

	my $wordtmp = $word;
	if ($word =~ /kah$/) {
		$word =~ s/kah$//;
		my $len = length $word;

		# jika word yang dihasilkan kurang length-nya kurang dari 3, dianggap bukan word.
		# titah -> titah
		if ($len < 3) {
			$word = $wordtmp;
		}
		else {
			$isExist = 1;
		}
	}

	return ($word, $isExist);
}

##
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
		($word, $ok) = awalanBer($word);
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
	my $wordtmp = $word;

	if ($word =~ /^ke[^aeiou]/) {
		$word =~ s/^ke//;
		$isExist = 1;
	}

	my $len = length $word;
	if ($len < 4) {
		return ($wordtmp, 0);
	}

	return ($word, $isExist);
}

sub awalanPe {
	my ($word) = @_;
	my $isExist = 0;
	my $wordtmp = $word;
	my $more = 0;

	if ($word =~ /^pe/) {
		$isExist = 1;
		if ($word =~ /^peng/) {
			$word =~ s/^peng//;
			$more = 1;
		}
		elsif ($word =~ /^peny/) {
			$word =~ s/^peny/s/;
			$more = 1;
		}
		elsif ($word =~ /^pen[aeiou]/) {
			$word =~ s/^pen/t/;
		}
		elsif ($word =~ /^pem[^aeiou]/) {
			$word =~ s/^pem//;
			$more = 1;
		}
		elsif ($word =~ /^pemer/) {
			$word =~ s/^pem/p/;
		}
		else {
			$word =~ s/^pe//;
		}
	}

	my $len = length $word;
	if ($len < 4 - $more) {
		return ($wordtmp, 0);
	}

	return ($word, $isExist);

	# belum bisa handle:
	# pemerhati -> perhati
}

sub awalanBer {
	my ($word) = @_;
	my $isExist = 0;
	my $wordtmp = $word;

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

	my $len = length $word;
	if ($len < 3) {
		return ($wordtmp, 0);
	}

	return ($word, $isExist);
}

sub awalanMe {
	my ($word) = @_;
	my $isExist = 0;
	my $wordtmp = $word;
	my $more = 0;

	if ($word =~ /^meng/) {
		if ($word =~ /^meng[a|e|i|o|u|h|g|kh]/) {
			$word =~ s/^meng//;
			$isExist = 1;
			$more = 1;
		}
	}
	elsif ($word =~ /^meny/) {
		$word =~ s/^meny/s/;
		$isExist = 1;
		$more = 1;
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
			$more = 1;
		}
	} 
	elsif ($word =~ /^me/) {
		$word =~ s/^me//;
		$isExist = 1;
	}

	my $len = length $word;
	if ($len < 4 - $more) {
		return ($wordtmp, 0);
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
	my $wordtmp = $word;

	if ($word =~ /^di/) {
		$word =~ s/^di//;
		$isExist = 1;
	}

	my $len = length $word;
	if ($len < 4) {
		return ($wordtmp, 0);
	}

	return ($word, $isExist);
}

sub awalanTer {
	my ($word) = @_;
	my $isExist = 0;
	my $wordtmp = $word;

	if ($word =~ /^ter/) {
		$word =~ s/^ter//;
		$isExist = 1;
	}

	my $len = length $word;
	if ($len < 3) {
		return ($wordtmp, 0);
	}

	return ($word, $isExist);
}

sub awalanSe {
	my ($word) = @_;
	my $isExist = 0;
	my $wordtmp = $word;

	if ($word =~ /^se/) {
		$word =~ s/^se//;
		$isExist = 1;
	}
	my $len = length $word;
	if ($len < 4) {
		return ($wordtmp, 0);
	}

	return ($word, $isExist);
}

sub awalanPer {
	my ($word) = @_;
	my $isExist = 0;
	my $wordtmp = $word;

	if ($word =~ /^per/) {
		$word =~ s/^per//;
		$isExist = 1;
	} elsif ($word =~ /pelajar/) {
		$word = "ajar";
		$isExist = 1;
	} elsif ($word =~ /^pe[^nm]er/) {
		$word =~ s/^pe//;
		$isExist = 1;
	}

	my $len = length $word;
	if ($len < 3) {
		return ($wordtmp, 0);
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
