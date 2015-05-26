use utf8;
use strict;
use warnings;
use open qw( :encoding(UTF-8) :std );
use Test::More tests => 15;
use Unicode::EditDistance;

my $ed = Unicode::EditDistance->new(metric => 'levenshtein');
is_distance('kitten',          'kitten',             1.0000);
is_distance('kitten',          'sitting',            0.5714);
is_distance('martha',          'marhta',             0.6666);
is_distance('jones',           'johnson',            0.4285);
is_distance('abcvwxyz',        'cabvwxyz',           0.7500);
is_distance('dwayne',          'duane',              0.6666);
is_distance('dixon',           'dicksonx',           0.5000);
is_distance('six',             'ten',                0.0000);
is_distance('zac ephron',      'zac efron',          0.8000);
is_distance('zac ephron',      'kai ephron',         0.8000);
is_distance('brittney spears', 'britney spears',     0.9333);
is_distance('brittney spears', 'brittney startzman', 0.6111);
is_distance('',                'kitten',             0.0000);
is_distance('kitten',          '',                   0.0000);
is_distance('',                '',                   1.0000);

sub is_distance {
    my ($str1, $str2, $distance) = @_;
    is(
        sprintf('%.6s', $ed->distance($str1, $str2)),
        $distance,
        qq{distance between "$str1" and "$str2"}
    )
}
