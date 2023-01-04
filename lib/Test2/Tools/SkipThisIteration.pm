package Test2::Tools::SkipThisIteration;

use 5.008001;

use strict;
use warnings;

use Exporter 5.567;	# Comes with Perl 5.8.1.
use Test2::API 1.302096 ();

use base qw{ Exporter };

our $VERSION = '0.000_001';
$VERSION =~ s/ _ //smxg;

our @EXPORT_OK = qw{ skip_this_iteration };
our @EXPORT = @EXPORT_OK;	## no critic (ProhibitAutomaticExportation)

sub skip_this_iteration {	## no critic (RequireFinalReturn)
    my ($why, $num) = @_;
    $num ||= 1;
    my $ctx = Test2::API::context();
    $ctx->skip("skipped test", $why) for 1 .. $num;
    $ctx->release;
    no warnings 'exiting';
    next SKIP;
}

1;

__END__

=head1 NAME

Test2::Tools::SkipThisIteration - Test2 skip() variant that only skips the current iteration.

=head1 SYNOPSIS

The following is verbatim from F<t/skip_this_iteration.t>:

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

=head1 DESCRIPTION

This module provides a re-implementation of the
L<Test2::Tools::Basic|Test2::Tools::Basic> C<skip()> function. It is
identical to the original, except that instead of exiting the C<SKIP:>
block entirely it just passes on to the next iteration. This means you
can label a C<for>, C<foreach>, or C<while> block and skip a single
iteration rather than the whole thing.

The usual use case of C<skip()> is something like

 SKIP: {
   some_sanity_check()
     or skip 'Failed sanity check';
   ...
 }

In this case both C<skip()> and this module's C<skip_next()> exit
the block, which Perl sees as a single-iteration loop. So for sanity's
sake you should use the L<Test2::Tools::Basic|Test2::Tools::Basic>
C<skip()> function rather than this one.

But if the test looks like

 SKIP: for ( 1 .. 10 ) {
   some_sanity_check( $_ )
     or skip "Failed sanity check for $_";
   ...
 }

then the first time C<some_sanity_check()> returns true all subsequent
tests in the iteration are skipped.

On the other hand,

 SKIP: for ( 1 .. 10 ) {
   some_sanity_check( $_ )
     or skip_next "Failed sanity check for $_";
   ...
 }

will only skip the iteration in which C<some_sanity_check()> returns a
false value.

=head1 SUBROUTINES

This module exports the following public subroutines:

=head2 skip_this_iteration

 SKIP:
 for ( ... ) {
   some_sanity_check()
     or skip_this_iteration 'ooops!', 3;
   ... this is skipped
 }

This subroutine skips the rest of the current iteration of the C<SKIP:>
loop in which it is called. Subsequent iterations are unaffected by a
call to C<skip_this_iteration()>,

The first argument is the reason for skipping, and is required.

The second argument is the number of tests skipped, and is optional. If
this argument is omitted or is false (in the Perl sense, i.e. is
C<undef>, C<''>, or C<0>) it defaults to C<1>.

=head1 SEE ALSO

L<Test2::Tools::Basic|Test2::Tools::Basic>, which provides C<skip()>.

=head1 SUPPORT

Support is by the author. Please file bug reports at
L<https://rt.cpan.org/Public/Dist/Display.html?Name=Test2-Tools-SkipThisIteration>,
L<https://github.com/trwyant/perl-Test2-Tools-SkipThisIteration/issues/>, or in
electronic mail to the author.

=head1 AUTHOR

Thomas R. Wyant, III F<wyant at cpan dot org>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2023 by Thomas R. Wyant, III

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl 5.10.0. For more details, see the full text
of the licenses in the directory LICENSES.

This program is distributed in the hope that it will be useful, but
without any warranty; without even the implied warranty of
merchantability or fitness for a particular purpose.

=cut

# ex: set textwidth=72 :
