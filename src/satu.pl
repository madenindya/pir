#!/usr/local/bin/perl


# Tugas 1 Perolehan Informasi
# Made Nindyatama N / 1306381622
# Bagian I

sub start_with_number {
	return $sentence =~ /^\d/;
}

open (IN, "Korpus2.txt");
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

	# group section
	if ($line =~ /<SECTION>/) {
		# trim the word 'SECTION' and some character such as: < > \s
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
			chomp($line);

			if ($txt =~ /<\/TEXT>/) {
				last;
			}

			@sentences_raw = split(/[.?!]/, $txt);
			my @sentences;
			$i = 0;
			
			for my $sentence (@sentences_raw) {
				
				$sentence =~ s/[\n]//g;
				$sentence_no_space = $sentence;
				$sentence_no_space =~ s/[\s+]//;  ## check: s/[\s+]//g

				if (length $sentence_no_space > 0) {
					

					if ($sentence =~ /^\d/ && $i != 0) {
						# merge the number with the previous sentence
						$sentences[$i-1] = "$sentences[$i-1].$sentence";
					} else {
						push @sentences, $sentence;
						$sentence_count++;
						$doc_sentences_count++;
						# print OUT "$sentence_count###$sentence---\n";
						$i++;
					}
			
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
