#!/usr/bin/perl
use strict;
use warnings;


if (@ARGV < 1) {
    die " perl rename_vcf_ids.pl input.vcf > output.vcf\n";
}

my $filename = $ARGV[0];
open(my $fh, '<', $filename) or die "无法打开文件: '$filename' $!";

while (my $row = <$fh>) {
    chomp $row;
    

    if ($row =~ /^##/) {
        print "$row\n";
        next;
    }


    if ($row =~ /^#/) {
        print "$row\n";
        next;
    }

    my @columns = split("\t", $row);


    $columns[2] = $columns[0] . "_" . $columns[1];

    print join("\t", @columns), "\n";
}

close($fh);
