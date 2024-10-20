#!/bin/env perl

#/********************************************************************************
# * Deduplicate a file (maintains order and keeps the last occurrence)
# ********************************************************************************/

$inputFile = $ARGV[0];

while (chomp($line = <>)) {
    push(@lines, $line);
}

for ($i = $#lines; $i >= 0; $i--) {
    $iLine = $lines[$i];
    for ($j = $i - 1; $j >= 0; $j--) {
        if ($lines[$j] eq $iLine) {
            splice(@lines, $j, 1);
            $i--;
        }
    }
}

open($outputFile, '>', $inputFile);

print($outputFile join("\n", @lines), "\n");
