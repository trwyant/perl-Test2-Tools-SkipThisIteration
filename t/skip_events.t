package main;

use 5.008001;

use strict;
use warnings;

use Test2::Bundle::Extended;
use Test2::Tools::SkipThisIteration;

like(
    intercept {
        ok(1, 'pass');
        SKIP: for ( 0 .. 1 ) {
	    $_
		or skip_this_iteration 'Iteration 0 skipped', 5;

            ok(1, "Iteration $_: Should only see this on iteration 1");
        }
    },
    array {
        event Ok => { pass => 1 };

        event Skip => sub {
            call pass => 1;
            call reason => 'Iteration 0 skipped';
        } for 1 .. 5;

	event Ok => { pass => 1 };

        end;
    },
    "got skip_this_iteration() events"
);

done_testing;

1;

# ex: set textwidth=72 :
