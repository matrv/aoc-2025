#!/usr/bin/perl
use warnings;
use strict;
use List::Util qw(sum product);

my $filename = 'input.txt';

open my $info, $filename or die $!;

my @grid;
my @grid2;

while(my $line = <$info>) {
  chop $line;
  my @chars2 = split //, $line;
  $line =~ s/^\s+//g;
  my @chars = split / +/, $line;
  push @grid, [@chars];
  push @grid2, [@chars2];
}

close $info;

my @first_row = @{$grid[0]}; 

my $total = 0;

for my $x (0..$#first_row) {
  my @numbers;
  for my $y (0..$#grid - 1) {
    push @numbers, $grid[$y][$x];
  }

  $total += $grid[$#grid][$x] eq '+' ? sum(@numbers) : product(@numbers);
}

print "Part 1 answer: ", $total, "\n";

$total = 0;
my @first_row2 = @{$grid2[0]};

my @numbers2;
my $isMult = 0;
for my $x (0..$#first_row2) {
  my $number = 0;
  for my $y (0..$#grid2 - 1) {
    my $char = $grid2[$y][$x];
    if ($char ne ' ') {
      $number = $number * 10 + $char;
    }
  }
  if ($grid2[$#grid2][$x] eq '*') {
    $isMult = 1;
  }
  if ($number != 0) {
    push @numbers2, $number;
  }
  if ($number == 0 or $x == $#first_row2) {
    $total += $isMult ? product(@numbers2) : sum(@numbers2);
    $isMult = 0;
    @numbers2 = ();
  } 
}

print "Part 2 answer: ", $total, "\n";

