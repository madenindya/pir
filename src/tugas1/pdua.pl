#!/usr/local/bin/perl


# Tugas 1 Perolehan Informasi
# Made Nindyatama N / 1306381622
# Bagian II

open (IN, "Korpus.txt");
open (OUTBTV, ">Korpus-Batavia.txt");
open (OUTIDR, ">Korpus-IDR.txt");
open (OUTPRT, ">Korpus-Partai.txt");
# open (OUTTGL, ">Korpus-Tanggal.txt");

my $count_jakarta;
my $count_rupiah;
my $count_tanggal;
my $sum_tahun;
my $count_partai;

while ($line = <IN>) {
	chop($line);

	# remove space or tab in the beginning and ending
	$line =~ s/^[\s\t]+//;
	$line =~ s/[\s\t]+$//;
	
	# contains jakarta
	my $is_btv = check_jakarta($line);

	# contains Rp
	my $is_idr = check_rp($line);

	# contains tanggal
	check_tgl($line);

	# contains tahun
	check_tahun($line);

	# contains Partai 
	check_partai($line);

	if (!$is_btv) {
		print OUTBTV  "$line\n";
	}
	if (!$is_idr) {
		print OUTIDR "$line\n";
	}

}

close(IN);
close(OUTBTV);
close(OUTIDR);
close(OUTPRT);
# close(OUTTGL);

print_result();

sub print_result {
	print "1. Kata Jakarta/jakarta yang ditemukan dan diubah menjadi Batavia: $count_jakarta\n";
	print "2. Kata Rp/Rp. yang ditemukan dan diubah menjadi IDR: $count_rupiah\n";
	print "3. Jumlah kemunculan tanggal sesuai format: $count_tanggal\n";
	print "4. Jumlah dari seluruh angka yang mengikuti kata tahun/Tahun: $sum_tahun\n";
	print "5. Jumlah Partai valid dalam korpus: $count_partai\n";	
}

# check if the line contains jakarta
# input: 	line in Corpus
# output:	is line contains jakarta
sub check_jakarta {
	my ($line) = @_;

	if ($line =~ /Jakarta|jakarta/) {
		my $i = 0;
		my @tokens = split(/\s+/, $line);
		for my $token (@tokens) {
			if ($token =~ /Jakarta|jakarta/) {
				if ($token =~ /[A-Za-z]+Jakarta|[A-Za-z]+jakarta/ || $token =~ /Jakarta[A-Za-z]+|jakarta[A-Za-z]+/) {
					# TransJakarta, Yogjakarta --> tidak termasuk
				} 
				else {
					# (Jakarta) --> termasuk
					# Diubah menjadi Batavia
					$token =~ s/Jakarta|jakarta/Batavia/;
					$count_jakarta++;
				}
			}
			if ($i == 0) {
				print OUTBTV "$token";
			} else {
				print OUTBTV " $token";
			}
			$i++;
		}
		print OUTBTV "\n";

		return 1;
	}

	return 0;
}

# check if the line contains Rp
# input: 	line in Corpus
# output:	is line contains Rp
sub check_rp {
	my ($line) = @_;

	if ($line =~ /Rp/) {
		my $i = 0;
		my @tokens = split(/\s+/, $line);
		for my $token (@tokens) {
			if ($token =~ /Rp/) {
				# check apakah token selanjutnya diawali digit
				if ($tokens[$i+1] =~ /^\d/) {
					$token =~ s/Rp\.|Rp/IDR/;
					$count_rupiah++;
				}
			}
			if ($i == 0) {
				print OUTIDR "$token";
			} else {
				print OUTIDR " $token";
			}
			$i++;
		}
		print OUTIDR "\n";

		return 1;
	}

	return 0;
}

# check if the line contains tanggal (sesuai format)
# input: 	line in Corpus
# output:	- 
sub check_tgl {
	my ($line) = @_;

	if ($line =~ /Januari|Februari|Maret|April|Mei|Juni|Juli|Agustus|September|Oktober|November|Desember/) {
		my $i = 0;
		my @tokens = split(/\s+/, $line);
		for my $token (@tokens) {
			# cek berdasarkan nama bulan dalam Bahasa Indonesia
			if ($token =~ /Januari|Februari|Maret|April|Mei|Juni|Juli|Agustus|September|Oktober|November|Desember/) {
				# cek format token yang mengawali dan mengakhiri 
				if ($i != 0 && ($tokens[$i-1] =~ /^\d\d$|^\d$/) && $tokens[$i+1] =~ /^\d\d\d\d$/) {
					# print OUTTGL "$tokens[$i-1] $token $tokens[$i+1]\n";
					$count_tanggal++;
				}
			}
			$i++;
		}
	}
}

# check if the line contains tahun (sesuai format)
# input: 	line in Corpus
# output:	- 
sub check_tahun {
	my ($line) = @_;

	if ($line =~ /tahun|Tahun/) {
		my $i = 0;
		my @tokens = split(/\s+/, $line);
		for my $token (@tokens) {
			if ($token =~ /[A-Za-z]+Tahun|[A-Za-z]+tahun/ || $token =~ /Tahun[A-Za-z]+|tahun[A-Za-z]+/) {
				# 20 tahunan --> tidak termasuk
			}
			else {
				# ke-32 tahun 1999 --> termasuk
				if ($i != 0) {
					if ($tokens[$i-1] =~ /\d+$/) {
						$sum_tahun += $&;
					}
				}
				if ($tokens[$i+1] =~ /^\d+/) {
					$sum_tahun += $&;
				}
			}
			$i++;
		}
	}
}

# check if the line contains Partai (sesuai format)
# input: 	line in Corpus
# output:	- 
sub check_partai {
	my ($line) = @_;

	if ($line =~ /Partai/) {
		$i = 0;
		@tokens = split(/\s+/, $line);
		for my $token (@tokens) {
			if ($token =~ /Partai$/) {
				if ($tokens[$i+2] =~ /^[A-Z]/ && $tokens[$i+1] =~ /^[A-Z][a-z]+$/){
					# Jika mengandung tiga token, maka akhir token kedua tidak boleh di akhiri karakter selain alphabet
					print OUTPRT "$token $tokens[$i+1] $tokens[$i+2]\n";
					$count_partai++;
				} elsif ($tokens[$i+1] =~ /^[A-Z]/){
					print OUTPRT "$token $tokens[$i+1]\n";
					$count_partai++;
				}
			}
			$i++;
		}
	}
}