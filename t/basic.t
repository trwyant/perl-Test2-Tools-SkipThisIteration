package main;

use strict;
use warnings;

use Test2::V0;
use Test2::Plugin::BailOnFail;
use Test2::Tools::LoadModule;

load_module_ok 'Test2::Tools::SkipThisIteration';

done_testing;

1;
