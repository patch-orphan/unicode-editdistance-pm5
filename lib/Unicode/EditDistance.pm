package Unicode::EditDistance;

use v5.8.1;
use utf8;
use Carp qw( croak );
use List::Util qw( min max );
use Unicode::Util qw( grapheme_length grapheme_substr );

use Moo;
use namespace::clean;

our $VERSION = '0.00_01';

my %metrics = (
    levenshtein => \&_levenshtein,
);

has metric => (
    is  => 'ro',
    isa => sub {
        croak qq{invalid value "$_[0]"} unless exists $metrics{$_[0]};
    },
    defualt => 'levenshtein',
);

sub distance {
    my ($self, $str1, $str2) = @_;
    return $metrics{$self->metric}($str1, $str2);
}

sub _levenshtein {
    my ($str1, $str2) = @_;
    my @chr1 = $str1 =~ /(\X)/g;
    my @chr2 = $str2 =~ /(\X)/g;

    return @chr1 == @chr2 ? 1 : 0
        unless @chr1 && @chr2;

    # previous cost array, horizontally
    my @prev = 0 .. @chr1;

    for my $pos2 (1 .. @chr2) {
        # cost array, horizontally
        my @cost = $pos2;

        for my $pos1 (1 .. @chr1) {
            # minimum of cell to the left + 1, to the top + 1,
            # diagonally left and up + cost
            $cost[$pos1] = min(
                $cost[$pos1 - 1] + 1,
                $prev[$pos1]     + 1,
                $prev[$pos1 - 1] + ($chr1[$pos1 - 1] ne $chr2[$pos2 - 1]),
            );
        }

        # copy current distance counts to previous row distance counts
        my @tmp = @prev;
        @prev = @cost;
        @cost = @tmp;
    }

    # our last action in the above loop was to switch @cost and @prev,
    # so @prev now actually has the most recent cost counts
    return 1 - $prev[-1] / max scalar @chr1, scalar @chr2;
}

1;
