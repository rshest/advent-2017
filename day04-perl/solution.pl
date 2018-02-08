use List::Util qw(sum);
use strict;
use warnings;

open my $file, '<', 'input.txt';
chomp(my @phrases = <$file>);
close $file;

sub is_valid {
    my ($phrase, $sort) = @_;
    my %reg;
    foreach my $word (split ' ', $phrase) {
      if ($sort) {
        $word = join '', sort split(//, $word);
      }
      if (exists $reg{$word}) {
        return 0;
      }
      $reg{$word} = ();
    }
    return 1;
}

printf("Part 1: %d valid phrases.\n", sum(map {is_valid($_, 0)} @phrases));
printf("Part 2: %d valid phrases.\n", sum(map {is_valid($_, 1)} @phrases));
