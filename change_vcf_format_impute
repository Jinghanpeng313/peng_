#!/usr/bin/perl
use strict;
use warnings;


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
    for (my $i = 9; $i < scalar @columns; $i++) {

        $columns[$i] =~ s/0\|0/0/g;
        $columns[$i] =~ s/0\|1|1\|0/1/g;
        $columns[$i] =~ s/1\|1/2/g;
    }

    print join("\t", @columns), "\n";
}

close($fh);
