use utf8;
use strict;
use warnings;
use open qw( :encoding(UTF-8) :std );
use Test::More tests => 2;
use EditDistance;

my $ed = EditDistance->new;
is $ed->distance('kitten', 'sitting'), 3;
is $ed->distance('kitten', 'kitten'),  0;
