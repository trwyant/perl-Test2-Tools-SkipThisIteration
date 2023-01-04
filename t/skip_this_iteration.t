package main;

use 5.008001;

use strict;
use warnings;

use Test2::V0;
use Test2::Tools::SkipThisIteration;

SKIP: {
    skip_this_iteration 'If wishes were horses then beggars would ride';
    cmp_ok 2, '==', 3, 'For sufficiently large values of 2';
}

SKIP: for ( 1 .. 10 ) {
    $_ % 2
	or skip_this_iteration 'Not all numbers are odd';
    ok $_ % 2, "$_ is odd";
}

done_testing;

1;

# ex: set textwidth=72 :
