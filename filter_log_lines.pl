#!/usr/bin/perl

use strict;
use warnings;

# Define the log file path
my $log_file = 'spring_boot.log';

# Define the input file containing patterns
my $patterns_file = 'patterns.txt';

# Define the number of consecutive lines to include in each group
my $consecutive_lines = 5;

# Define the output file path
my $output_file = 'filtered_results.txt';

# Open the patterns file for reading
open(my $fh_patterns, '<', $patterns_file) or die "Cannot open file '$patterns_file' for reading: $!";

# Read patterns from the file
my @patterns;
while (my $pattern = <$fh_patterns>) {
    chomp($pattern);
    push @patterns, $pattern;
}

# Close the patterns file
close($fh_patterns);

# Open the log file for reading
open(my $fh_in, '<', $log_file) or die "Cannot open file '$log_file' for reading: $!";

# Open the output file for writing
open(my $fh_out, '>', $output_file) or die "Cannot open file '$output_file' for writing: $!";

# Buffer to store consecutive lines
my @buffer;

# Iterate through each line in the log file
while (my $line = <$fh_in>) {
    chomp($line);

    # Add the line to the buffer
    push @buffer, $line;

    # If the buffer has reached the desired number of consecutive lines
    if (@buffer == $consecutive_lines) {
        # Check if the buffer contains all of the patterns
        my $matched_all = 1;
        foreach my $pattern (@patterns) {
            unless (grep /$pattern/, @buffer) {
                $matched_all = 0;
                last; # Stop checking patterns if any pattern is not matched
            }
        }
        
        # If all patterns are matched, print the group of lines to the output file
        if ($matched_all) {
            print $fh_out "Found group of lines:\n";
            foreach my $group_line (@buffer) {
                print $fh_out "$group_line\n";
            }
            print $fh_out "\n";
        }

        # Clear the buffer for the next group of lines
        @buffer = ();
    }
}

# Close the log file
close($fh_in);

# Close the output file
close($fh_out);

print "Filtered results have been written to '$output_file'.\n";
