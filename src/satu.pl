#!/usr/local/bin/perl


# Tugas 1 Perolehan Informasi
# Made Nindyatama N / 1306381622
# Bagian I

sub start_with_number {
	return $sentence =~ /^\d/;
}

open (IN, "Korpus.txt");
open (OUT, ">hasil.txt");

my %sections;
my $section_max_name;
my $section_max_count;

my $doc_count;
my $doc_sentence_max;
my $doc_sentence_max_no;
my $doc_sentence_min;
my $doc_sentence_min_no;
my $doc_no_current;

my $sentence_count;

while ($line = <IN>) {
	chop($line);

	# grouping section
	if ($line =~ /<SECTION>/) {
		$line =~ s/SECTION//g;
		$line =~ s/[<>\/\s+]//g;
		$tmp = ++$sections{$line};
		if ($tmp > $section_max_count) {
			$section_max_count = $tmp;
			$section_max_name = $line;
		}
	} 
	# count doc
	elsif ($line =~ /<DOC>/) {
		++$doc_count;
	}
	# get doc no
	elsif ($line =~ /<DOCNO>/) {
		$line =~ s/DOCNO//g;
		$line =~ s/[<>\/\s+]//g;
		$doc_no_current = $line;
	}
	elsif ($line =~ /<TEXT>/) {

		my $doc_sentences_count;
	
		# read all text in document
		while ($txt = <IN>) {
			chomp($txt);

			if ($txt =~ /<\/TEXT>/) {
				last;
			}
			$txt =~ s/^[\s\t]+//;

			#check ordered list --> hilangkan list-nya
			$txt =~ s/^[0-9]+\.//;
			
			@sentences_raw = split(/[.?!]/, $txt);
			my @sentences;
			$i = 0;
			
			for my $sentence (@sentences_raw) {
				
				# check numeral. Cth: 9.000
				if ($sentence =~ /^\d/ && $i != 0 && $sentences[$i-1] =~ /\d$/) {
					$sentences[$i-1] = "$sentences[$i-1].$sentence";
					next;
				}
				
				# check website. Cth: google.com
				if ($sentence =~ /^[a-z]/ && $i != 0 && $sentences[$i-1] =~ /[a-z]$/) {
					$sentences[$i-1] = "$sentences[$i-1].$sentence";
					next;
				}
				
				#check other FL.1 No.3 Rp.2 Rp. 3
				
				$sentence =~ s/^[\s\t]+//;
				if (length $sentence > 0) {					
					push @sentences, $sentence;
					$sentence_count++;
					$doc_sentences_count++;
					# print OUT "$sentence_count###$sentence---\n";
					$i++;
				}

			}

			foreach my $n (@sentences) {
				print OUT "###$n\n";
			}
		}
		
		if ($doc_sentences_count > $doc_sentence_max) {
			$doc_sentence_max = $doc_sentences_count;
			$doc_sentence_max_no = $doc_no_current;
		}
		
		if (!defined $doc_sentence_min or $doc_sentences_count < $doc_sentence_min) {
			$doc_sentence_min = $doc_sentences_count;
			$doc_sentence_min_no = $doc_no_current;
		}
	}
}

close(IN);
close(OUT);

$avg = $sentence_count / $doc_count;
print "1. Section terbanyak : $section_max_name dengan $section_max_count dokumen\n";
print "2. Jumlah dokumen dalam korpus : $doc_count\n";
print "3. Jumlah kalimat dalam korpus : $sentence_count\n";
print "   Rata-rata jumlah kalimat dalam dokumen : $avg\n";
print "4. Dokumen dengan jumlah kalimat terbanyak  : $doc_sentence_max_no dengan $doc_sentence_max kalimat\n";
print "5. Dokumen dengan jumlah kalimat tersedikit : $doc_sentence_min_no dengan $doc_sentence_min kalimat\n";



# for my $sec (keys %section) {
#     print "The color of '$sec' is $section{$sec}\n";
# }
