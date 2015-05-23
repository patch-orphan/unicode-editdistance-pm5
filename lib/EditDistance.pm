package EditDistance;

use utf8;
use strict;
use warnings;
use parent 'Exporter';
use List::Util qw( min );

our $VERSION   = '0.00_01';
our @EXPORT_OK = qw( levenshtein );

sub levenshtein {
    my ($str1, $str2) = @_;
    return _levenshtein($str1, length $str1, $str2, length $str2);
}

sub _levenshtein {
    my ($str1, $str1_length, $str2, $str2_length) = @_;

    # base case: empty strings
    return $str2_length unless $str1_length;
    return $str1_length unless $str2_length;

    # test if last characters of the strings match
    my $cost = substr($str1, $str1_length - 1, 1)
            eq substr($str2, $str2_length - 1, 1)
             ? 0 : 1;

    # return minimum of:
    # delete char from $str1, delete char from $str2, and delete char from both
    return min(
        _levenshtein($str1, $str1_length - 1, $str2, $str2_length    ) + 1,
        _levenshtein($str1, $str1_length    , $str2, $str2_length - 1) + 1,
        _levenshtein($str1, $str1_length - 1, $str2, $str2_length - 1) + $cost,
    );
}

1;
