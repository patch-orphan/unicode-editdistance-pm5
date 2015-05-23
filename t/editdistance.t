use utf8;
use strict;
use warnings;
use open qw( :encoding(UTF-8) :std );
use Test::More tests => 2;
use EditDistance qw( levenshtein );

is levenshtein('kitten', 'sitting'), 3;
is levenshtein('kitten', 'kitten'),  0;
