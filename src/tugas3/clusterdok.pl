#!/usr/local/bin/perl

# Tugas 3 Perolehan Informasi
# Made Nindyatama N / 1306381622
# Hasil Cluster setiap dokumen

use strict;
use warnings;
use Switch;

open (IN, "hasil2-kmean.arff");
open (IN2, "corpus-tempo.xml");
open (OUT0, ">kluster0.txt");
open (OUT1, ">kluster1.txt");
open (OUT2, ">kluster2.txt");
open (OUT3, ">kluster3.txt");

my $line;
my @clusters;

my $line2 = <IN2>;
$line2 = <IN2>;

while ($line = <IN>) {
	if ($line =~ /cluster([0-3])$/) {
		print $1;
		switch ($1) {
			case 0 {
				  $line2 = <IN2>;
				  $line2 = <IN2>;
				  chomp($line2);
				  $line2 =~ s/^[\s\t]+//;
				  $line2 =~ s/[\s\t]+$//;
				  # $line2 =~ s/<judul>//;
				  # $line2 =~ s/<\/judul>//;
				  print OUT0 "$line2\n";
				  $line2 = <IN2>;
				  $line2 = <IN2>;
				  $line2 = <IN2>;
				  $line2 = <IN2>;
				  $line2 = <IN2>;
				  chomp($line2);
				  $line2 =~ s/^[\s\t]+//;
				  $line2 =~ s/[\s\t]+$//;
				  # $line2 =~ s/<isi>//;
				  # $line2 =~ s/<\/isi>//;
				  print OUT0 "$line2\n";
				  $line2 = <IN2>;
			}
			case 1 {
				  $line2 = <IN2>;
				  $line2 = <IN2>;
				  chomp($line2);
				  $line2 =~ s/^[\s\t]+//;
				  $line2 =~ s/[\s\t]+$//;
				  # $line2 =~ s/<judul>//;
				  # $line2 =~ s/<\/judul>//;
				  print OUT1 "$line2\n";
				  $line2 = <IN2>;
				  $line2 = <IN2>;
				  $line2 = <IN2>;
				  $line2 = <IN2>;
				  $line2 = <IN2>;
				  chomp($line2);
				  $line2 =~ s/^[\s\t]+//;
				  $line2 =~ s/[\s\t]+$//;
				  # $line2 =~ s/<isi>//;
				  # $line2 =~ s/<\/isi>//;
				  print OUT1 "$line2\n";
				  $line2 = <IN2>;
			}
			case 2 {
				  $line2 = <IN2>;
				  $line2 = <IN2>;
				  chomp($line2);
				  $line2 =~ s/^[\s\t]+//;
				  $line2 =~ s/[\s\t]+$//;
				  # $line2 =~ s/<judul>//;
				  # $line2 =~ s/<\/judul>//;
				  print OUT2 "$line2\n";
				  $line2 = <IN2>;
				  $line2 = <IN2>;
				  $line2 = <IN2>;
				  $line2 = <IN2>;
				  $line2 = <IN2>;
				  chomp($line2);
				  $line2 =~ s/^[\s\t]+//;
				  $line2 =~ s/[\s\t]+$//;
				  # $line2 =~ s/<isi>//;
				  # $line2 =~ s/<\/isi>//;
				  print OUT2 "$line2\n";
				  $line2 = <IN2>;
			}
			else {
				  $line2 = <IN2>;
				  $line2 = <IN2>;
				  chomp($line2);
				  $line2 =~ s/^[\s\t]+//;
				  $line2 =~ s/[\s\t]+$//;
				  # $line2 =~ s/<judul>//;
				  # $line2 =~ s/<\/judul>//;
				  print OUT3 "$line2\n";
				  $line2 = <IN2>;
				  $line2 = <IN2>;
				  $line2 = <IN2>;
				  $line2 = <IN2>;
				  $line2 = <IN2>;
				  chomp($line2);
				  $line2 =~ s/^[\s\t]+//;
				  $line2 =~ s/[\s\t]+$//;
				  # $line2 =~ s/<isi>//;
				  # $line2 =~ s/<\/isi>//;
				  print OUT3 "$line2\n";
				  $line2 = <IN2>;
			}
		}
	}
}

close(IN);
close(IN2);
close(OUT0);
close(OUT1);
close(OUT2);
close(OUT3);