#!/usr/bin/perl
use strict;
use warnings;

use Test::More tests => 9;
use File::Spec::Functions;

my $filename = catfile('t', 'testdata.txt');
my $expected_line;

SKIP:
{
    skip "Fork on Win32 not supported before Perl 5.8"
        if $^O eq "MSWin32" && $] < 5.008;

    require_ok( "File::Marker" );

    my $obj = File::Marker->new($filename);
    isa_ok( $obj, "File::Marker" );

    my $line1 = "one\n";

    is( scalar <$obj>, $line1, 
        "line 1 contents correct" 
    );

    ok( $obj->set_marker( "line2" ),
        "marking current position at line 2"
    );

    ok( $expected_line = <$obj>,
        "reading line 2"
    );

    my $child_pid = fork;
    if ( !$child_pid ) { # we're in the child
        ok( $obj->goto_marker( "line2" ),
            "jumping back to the marker for line 2"
        );

        is( scalar <$obj>, $expected_line,
            "reading line 2 again"
        );
        
        exit;
    }

    # wait for child to finish
    waitpid $child_pid, 0;

    # Test counter is off due to the fork
    Test::More->builder->current_test( 7 );

    ok( $obj->goto_marker( "line2" ),
        "jumping back to the marker for line 2"
    );

    is( scalar <$obj>, $expected_line,
        "reading line 2 again"
    );
        
}
