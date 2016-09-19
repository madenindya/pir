#!/usr/local/bin/perl


# Tugas 1 Perolehan Informasi
# Made Nindyatama N / 1306381622
# Bagian I

sub start_with_number {
	return $sentence =~ /^\d/;
}

open (IN, "Korpus.txt");
open (OUTBTV, ">Korpus-Batavia.txt");
open (OUTIDR, ">Korpus-IDR.txt");
open (OUTPRT, ">Korpus-Partai.txt");
open (OUTTGL, ">Korpus-Tanggal.txt");

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
	$is_btv = 0;
	$is_idr = 0;

	# contains jakarta
	if ($line =~ /Jakarta|jakarta/) {
		$is_btv = 1;
		$i = 0;
		@tokens = split(/\s+/, $line);
		for my $token (@tokens) {
			if ($token =~ /Jakarta|jakarta/) {
				if ($token =~ /[A-Za-z]+Jakarta|[A-Za-z]+jakarta/ || $token =~ /Jakarta[A-Za-z]+|jakarta[A-Za-z]+/) {
					# TransJakarta, Yojakarta --> tidak termasuk
				} 
				else {
					# (Jakarta) --> termasuk
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
	} 

	# contains Rp
	if ($line =~ /Rp/) {
		$is_idr = 1;
		$i = 0;
		@tokens = split(/\s+/, $line);
		for my $token (@tokens) {
			if ($token =~ /Rp/) {
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
	}

	# contains tanggal
	if ($line =~ /Januari|Februari|Maret|April|Mei|Juni|Juli|Agustus|September|Oktober|November|Desember/) {
		$i = 0;
		@tokens = split(/\s+/, $line);
		for my $token (@tokens) {
			if ($token =~ /Januari|Februari|Maret|April|Mei|Juni|Juli|Agustus|September|Oktober|November|Desember/) {
				if ($i != 0 && ($tokens[$i-1] =~ /^\d\d$|^\d$/) && $tokens[$i+1] =~ /^\d\d\d\d$/) {
					print OUTTGL "$tokens[$i-1] $token $tokens[$i+1]\n";
					$count_tanggal++;
				}
			}
			$i++;
		}
	}

	# contains tahun
	if ($line =~ /tahun|Tahun/) {
		$i = 0;
		@tokens = split(/\s+/, $line);
		for my $token (@tokens) {
			if ($token =~ /[A-Za-z]+Tahun|[A-Za-z]+tahun/ || $token =~ /Tahun[A-Za-z]+|tahun[A-Za-z]+/) {
				# 20 tahunan --> tidak termasuk
			}
			else {
				# ke-32 tahun 1999, lalala.. --> termasuk
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

	# contains Partai 
	if ($line =~ /Partai/) {
		$i = 0;
		@tokens = split(/\s+/, $line);
		for my $token (@tokens) {
			if ($token =~ /Partai$/) {
				if ($tokens[$i+2] =~ /^[A-Z]/ && $tokens[$i+1] =~ /^[A-Z][a-z]+$/){
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
close(OUTTGL);

print "1. Kata Jakarta/jakarta yang ditemukan dan diubah menjadi Batavia: $count_jakarta\n";
print "2. Kata Rp/Rp. yang ditemukan dan diubah menjadi IDR: $count_rupiah\n";
print "3. Jumlah kemunculan tanggal sesuai format: $count_tanggal\n";
print "4. Jumlah dari seluruh angka yang mengikuti kata tahun/Tahun: $sum_tahun\n";
print "5. Jumlah Partai valid dalam korpus: $count_partai\n";