#!/usr/local/bin/perl

# Tugas 2 Perolehan Informasi
# Made Nindyatama N / 1306381622
# Preprocessing Korpus

# Format dari korpus harus tetap mengikuti format korpus lama (Anda tidak boleh
# mengkopi yang ada di dalam <TEXT></TEXT> saja). Korpus baru ini yang akan digunakan untuk
# menjawab soal-soal selanjutnya. Proses hanya dilakukan pada teks yang ada di dalam tag
# <TEXT></TEXT> saja. Lakukan preprocessing dengan menghilangkan simbol, angka, dan
# membuat semua kata menjadi lowercase.

open (IN, "korpus-new.txt");
open (OUT, "> 	korpus-tmp.txt");


while ($line = <IN>) {
	chop($line);

	if ($line =~ /<TEXT>/) {
		print OUT "$line\n";

		# read all line in document
		while ($txt = <IN>) {
			chomp($txt);
			
			if ($txt =~ /<\/TEXT>/) {
				print OUT "$line\n";
				last;
			}

			# remove space or tab in the beginning and ending
			$txt =~ s/^[\s\t]+//;
			$txt =~ s/[\s\t]+$//;

			# split by space
			@tokens = split(/\s+/, $txt);

			for my $token (@tokens) {
				if (length $token > 0) {
					identify_word($token);
				}
			}

			print OUT "\n";
		}
	} 
	else {
		print OUT "$line\n";
	}

}

close(IN);
close(OUT);

sub identify_word {
	my ($word) = @_;

	# to lower case & remove unecessary character
	$word =~ tr/[A-Z]/[a-z]/;
	$word =~ s/[.,"'!?():]//g;

	# check if there is slash(/) in between alphabetic characters or digit
	# exclude website url
	if ($word =~ /[A-Za-z]+\/[A-Za-z]+|[A-Za-z]+\/\d+|\d+\/[A-Za-z]+/ && !($word =~ /http|\.com|\.co\.id/)) {
		# print OUTSLS "$word\n";
		@subwords = split(/\//, $word);
		for my $subword (@subwords) {
			process_word($subword);
		}
	} 
	else {
		process_word($word);					
	}
}

sub process_word {
	my ($word) = @_;
	$word =~ s/\///g;

	print OUT "$word ";
}