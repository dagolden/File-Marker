# File::Marker - check module loading and create testing directory

use Test::More tests =>  2 ;

BEGIN { use_ok( 'File::Marker' ); }

my $object = File::Marker->new ();
isa_ok ($object, 'File::Marker');
