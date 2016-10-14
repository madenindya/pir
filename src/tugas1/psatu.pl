#!/usr/local/bin/perl


# Tugas 1 Perolehan Informasi
# Made Nindyatama N / 1306381622
# Bagian I

open (IN, "Korpus.txt");
# open (OUT1, ">hasil_sentence.txt");
# open (OUT2, ">hasil_word.txt");
# open (OUTSLS, ">hasil_slash.txt");

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

my %words;
my %words_char;
my $words_max_char_count;
my @words_max_char;
my $word_char_5_count;

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
	
		# read all line in document
		while ($txt = <IN>) {
			chomp($txt);

			if ($txt =~ /<\/TEXT>/) {
				if ($doc_sentences_count > $doc_sentence_max) {
					$doc_sentence_max = $doc_sentences_count;
					$doc_sentence_max_no = $doc_no_current;
				}
				if (!defined $doc_sentence_min or $doc_sentences_count < $doc_sentence_min) {
					$doc_sentence_min = $doc_sentences_count;
					$doc_sentence_min_no = $doc_no_current;
				}

				last;
			}

			# remove space or tab in the beginning and ending
			$txt =~ s/^[\s\t]+//;
			$txt =~ s/[\s\t]+$//;
			
			# split by space
			@tokens = split(/\s+/, $txt);
			my @sentences;
			my $sentence;

			my $i = 0;
			for my $token (@tokens) {
				if (length $token > 0) {

					# Identify unique word
					identify_word($token);			

					# Identify sentencesn
					if ($i != 0 && $token =~/\.[.]+$/) {
						if ($tokens[$i+1] =~ /^[a-z]/) {
							# Cth: Dangdut Yoo... akan menampilkan ...
							# not a sentence
							$sentence .= " $token";
							$i++;
							next;
						}
						# a sentence
						# save as sentence
						$sentence .= " $token";
						push @sentences, $sentence;
						$sentence_count++;
						$doc_sentences_count++;
						# print OUT1 "S###$sentence\n";
						$sentence = "";
						$i=0;
					}
					elsif ($i != 0 && $token =~ /[.?!]$/) {
						
						if ($token =~ /^Rp/) {
							# Cth: Rp. 500
							# not a sentence
							$token =~ s/[.]//;
							$sentence .= " $token";
							next;
						}
						
						if ($token =~ /^No|Dr|Drs|HM|Ir|OSU|Prof|Prof.drh|S.H|bdk|Ef|Kol|Kor|Wah|Yer|Yes|Yoh/) {
							# Cth: No. 12
							# Check: gelar | nama Alkitab
							# not a sentence
							$sentence .= " $token";
							next;
						}
						
						# save as sentence
						$sentence .= " $token";
						push @sentences, $sentence;
						$sentence_count++;
						$doc_sentences_count++;
						# print OUT1 "S###$sentence\n";
						$sentence = "";
						$i=0;
					}
					elsif ($i != 0 && $token =~ /\."$|\.''$/) {
						# Cth: ... mudah, menuju kepada masyarakat sipil."
						# save as sentence
						$sentence .= " $token";
						push @sentences, $sentence;
						$sentence_count++;
						$doc_sentences_count++;
						# print OUT1 "S###$sentence\n";
						$sentence = "";
						$i=0;
					}
					elsif ($token =~ /\?"$|\?''$|\?'$|\!"$|\!''$|\!'$/) {
						if ($tokens[$i+1] =~ /^[a-z]/) {
							# Cth: ... keamanan di TPA?" kata Amir ...
							# not a sentence
							$sentence .= " $token";
							$i++;
							next;
						}

						# save as sentence
						$sentence .= " $token";
						push @sentences, $sentence;
						$sentence_count++;
						$doc_sentences_count++;
						# print OUT1 "S###$sentence\n";
						$sentence = "";
						$i=0;
					}
					else {
						# concatenate the token
						$sentence .= " $token";
						$i++;
					}
				}
			}

			if (length $sentence > 0) {
				## not count as a sentence
				# print OUT1 "####$sentence\n";
			}

		}
		
	}
}

close(IN);
# close(OUT1);
# close(OUT2);
# close(OUTSLS);

print_result();


sub print_result {
	$avg = $sentence_count / $doc_count;
	$words_unique = keys %words;
	my $words_freq_more_10 = get_word_freq_more_10();
	print "1.  Section terbanyak : $section_max_name dengan $section_max_count dokumen\n";
	print "2.  Jumlah dokumen dalam korpus : $doc_count\n";
	print "3.  Jumlah kalimat dalam korpus : $sentence_count\n";
	print "    Rata-rata jumlah kalimat dalam dokumen : $avg\n";
	print "4.  Dokumen dengan jumlah kalimat terbanyak  : $doc_sentence_max_no dengan $doc_sentence_max kalimat\n";
	print "5.  Dokumen dengan jumlah kalimat tersedikit : $doc_sentence_min_no dengan $doc_sentence_min kalimat\n";
	print "6.  Jumlah kata unik dalam korpus : $words_unique\n";
	print "7.  Jumlah kata dengan frekuensi lebih dari 10 : $words_freq_more_10\n";
	print "8.  10 kata yang paling banyak muncul:\n";
	$j = 0;
	for my $kata (sort { $words{$b} <=> $words{$a} } keys %words) {
	    print "     $kata 	: $words{$kata}\n";
	    if (++$j >= 10) {
	    	last;
	    }
	}
	print "9.  Kata yang memiliki jumlah karakter terbanyak: \n";
	for my $word (@words_max_char) {
	    print "     $word\n";
	}
	print "    dengan $words_max_char_count karakter\n";
	print "10. Jumlah kata yang jumlah karakternya kelipatan 5 : $word_char_5_count\n";
}

sub identify_word {
	my ($word) = @_;

	# Special case: gelar / nama alkitab
	if ($word =~ /^Dr|Drs|HM|Ir|OSU|Prof|Prof.drh|S.H|bdk|Ef|Kol|Kor|Wah|Yer|Yes|Yoh/) {
		++$words{$word};
	} 
	else {
		# to lower case & remove unecessary character
		$word =~ tr/[A-Z]/[a-z]/;
		$word =~ s/[,"'!?()]//g;
	
		# remove (:) if apper in the end of word
		$word =~ s/:$//;
	
		# remove dot (.) if appear in beginning or in the end of word
		$word =~ s/^\.[.]*//;
		$word =~ s/\.[.]*$//;

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
}

sub process_word {
	my ($word) = @_;

	++$words{$word};
	if ($words{$word} == 1) {
		# print OUT2 "$word\n";
	}

	$word_length = length $word;
	check_longest_word($word);
	check_length_mod_5($word_length);
}

sub check_longest_word {
	my ($word) = @_;
	my $word_length = length $word;

	if ($word_length > $words_max_char_count) {
		$words_max_char_count = $word_length;
		@words_max_char = $word;
	} 
	elsif ($word_length == $words_max_char_count) {
		push @words_max_char, $word;
	}
}

sub check_length_mod_5 {
	my ($word_length) = @_;
	if ($word_length % 5 == 0) {
		$word_char_5_count++;
	}
}

sub get_word_freq_more_10 {
	my $count;
	for my $word (keys %words) {
	    if ($words{$word} > 10) {
	    	$count++;
	    }
	}
	return $count;
}