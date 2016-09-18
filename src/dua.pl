#!/usr/local/bin/perl


# Tugas 1 Perolehan Informasi
# Made Nindyatama N / 1306381622
# Bagian I

sub start_with_number {
	return $sentence =~ /^\d/;
}

open (IN, "Korpus2.txt");
open (OUTBTV, ">Korpus-Batavia.txt");
open (OUTIDR, ">Korpus-IDR.txt");

my $count_jakarta;
my $count_rupiah;

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
				#Cth: TransJakarta, Yojakarta
				if ($token =~ /[A-Za-z]+Jakarta|[A-Za-z]+jakarta/ || $token =~ /Jakarta[A-Za-z]+|jakarta[A-Za-z]+/) {
				} else {
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