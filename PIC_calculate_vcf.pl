#!/usr/bin/perl
use strict;
use warnings;
use Getopt::Long;

# 定义变量以存储输入和输出文件路径
my $input_file = '';
my $output_file = '';

# 使用Getopt::Long读取命令行参数
GetOptions(
    'input|i=s' => \$input_file,
    'output|o=s' => \$output_file,
) or die "Usage: $0 --input INPUTFILE --output OUTPUTFILE\n";

# 检查是否已提供输入和输出文件
die "Usage: $0 --input INPUTFILE --output OUTPUTFILE\n" unless $input_file && $output_file;

# 打开输入文件
open(my $in_fh, '<', $input_file) or die "Cannot open $input_file: $!";

# 打开输出文件以写入
open(my $out_fh, '>', $output_file) or die "Cannot open $output_file: $!";

while (my $line = <$in_fh>) {
    chomp $line;
    # 跳过VCF文件的头部信息
    next if $line =~ /^##/;
    
    if ($line =~ /^#/) {
        # 这是列头（#CHROM ...），可以在这里处理列头
        next;
    }
    
    # 解析VCF行
    my @fields = split(/\t/, $line);
    my $chrom = $fields[0];
    my $pos = $fields[1];
    my $id = $fields[2];
    my $ref = $fields[3];
    my $alt = $fields[4];
    # 基因型数据从第10列开始
    my @genotypes = @fields[9..$#fields];
    
    # 计算PIC值
    my $pic = calculate_pic(@genotypes);
    print $out_fh "Marker $id at $chrom:$pos PIC = $pic\n";
}

sub calculate_pic {
    my @genotypes = @_;
    
    my $p = 0;  # 频率 of ref allele
    my $q = 0;  # 频率 of alt allele
    
    my $total = 0;  # 总的等位基因计数
    
    foreach my $genotype (@genotypes) {
        if ($genotype =~ /0\/0/) {
            $p += 2;
            $total += 2;
        } elsif ($genotype =~ /1\/1/) {
            $q += 2;
            $total += 2;
        } elsif ($genotype =~ /0\/1|1\/0/) {
            $p += 1;
            $q += 1;
            $total += 2;
        }
    }
    
    if ($total == 0) { # 防止除以零的错误
        return 0;
    }
    
    $p /= $total;
    $q /= $total;
    
    my $pic = 1 - ($p**2 + $q**2 + 2*($p**2)*($q**2));
    return $pic;
}

close($in_fh);
close($out_fh);
