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

    # horizontally
    my @cost;

    for my $pos2 (1 .. @chr2) {
        my @prev = @cost ? @cost : 0 .. @chr1;
        @cost = $pos2;

        for my $pos1 (1 .. @chr1) {
            # minimum of cells:
            # - to the left + 1,
            # - to the top + 1,
            # - diagonally left and up + cost
            $cost[$pos1] = min(
                $cost[$pos1 - 1] + 1,
                $prev[$pos1]     + 1,
                $prev[$pos1 - 1] + ($chr1[$pos1 - 1] ne $chr2[$pos2 - 1]),
            );
        }
    }

    return 1 - $cost[-1] / max scalar @chr1, scalar @chr2;
}

1;
