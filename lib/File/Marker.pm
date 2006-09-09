package File::Marker;

$VERSION = "0.10";
@ISA = qw( IO::File );

use strict;
use warnings;
use Carp;
use IO::File;
use Scalar::Util qw( refaddr weaken );

#--------------------------------------------------------------------------#
# Inside-out data storage
#--------------------------------------------------------------------------#

my %MARKS = ();

# Track objects for thread-safety

my %REGISTRY = ();

#--------------------------------------------------------------------------#
# new()
#--------------------------------------------------------------------------#

sub new {
    my $class = shift;
    my $self = IO::File->new();
    bless $self, $class;
    weaken( $REGISTRY{ refaddr $self } = $self );
    $self->open( @_ ) if @_;
    return $self;
}

#--------------------------------------------------------------------------#
# open()
#--------------------------------------------------------------------------#

sub open {
    my $self = shift;
    $MARKS{ refaddr $self } = {};
    $self->SUPER::open( @_ );
    $MARKS{ refaddr $self }{ 'LAST' } = $self->getpos;
}

#--------------------------------------------------------------------------#
# set_marker()
#--------------------------------------------------------------------------#

sub set_marker {
    my ($self, $mark) = @_;
    
    croak "Can't set marker on closed filehandle"
        if ! $self->opened;

    croak "Can't set special marker 'LAST'" 
        if $mark eq 'LAST';
        
    my $position = $self->getpos;

    croak "Couldn't set marker '$mark': couldn't locate position in file"
        if ! defined $position;
    
    $MARKS{ refaddr $self }{ $mark } = $self->getpos;
    
    return 1;
}

#--------------------------------------------------------------------------#
# goto_marker()
#--------------------------------------------------------------------------#

sub goto_marker {
    my ($self, $mark) = @_;
    
    croak "Can't goto marker on closed filehandle"
        if ! $self->opened;

    croak "Unknown file marker '$mark'"
        if ! exists $MARKS{refaddr $self}{$mark};
    
    my $old_position = $self->getpos; # save for LAST
    
    my $rc = $self->setpos( $MARKS{ refaddr $self }{ $mark } );
    
    croak "Couldn't goto marker '$mark': could not seek to location in file"
        if ! defined $rc;
    
    $MARKS{ refaddr $self }{ 'LAST' } = $old_position;

    return 1;
}

#--------------------------------------------------------------------------#
# markers()
#--------------------------------------------------------------------------#

sub markers {
    my $self = shift;
    return keys %{ $MARKS{ refaddr $self } };
}

#--------------------------------------------------------------------------#
# DESTROY()
#--------------------------------------------------------------------------#

sub DESTROY {
    my $self = shift;
    delete $MARKS{ refaddr $self };
    delete $REGISTRY{ refaddr $self };

    $self->SUPER::DESTROY;
}

#--------------------------------------------------------------------------#
# CLONE()
#--------------------------------------------------------------------------#

sub CLONE {
    for my $old_id ( keys %REGISTRY ) {  
       
        # look under old_id to find the new, cloned reference
        my $object = $REGISTRY{ $old_id };
        my $new_id = refaddr $object;

        # relocate data
        $MARKS{ $new_id } = $MARKS{ $old_id };
        delete $MARKS{ $old_id };

        # update the weak reference to the new, cloned object
        weaken ( $REGISTRY{ $new_id } = $REGISTRY{ $old_id } );
        delete $REGISTRY{ $old_id };
    }
   
    return;
}

#--------------------------------------------------------------------------#
# _object_count()
#--------------------------------------------------------------------------#

sub _object_count {
    return scalar keys %MARKS;
}

1; #this line is important and will help the module return a true value
__END__

=head1 NAME

File::Marker - Set and jump between named position markers on a filehandle

=head1 SYNOPSIS

 use File::Marker;

 my $fh = File::Marker->new( 'datafile.txt' );
 
 my $first_line = <$fh>;
 
 $fh->set_marker( 'line2' ); # mark the current position
 
 my @rest_of_file = <$fh>;
 
 $fh->goto_marker( 'line2' ); # jump back to the marked position
 
 my $second_line = <$fh>;

=head1 DESCRIPTION

File::Marker allows users to set named markers for the current position in
filehandle and then later jump back to those marked position by name.  A
File::Marker object is a subclass of L<IO::File>, providing full filehandle
object functionality.

File::Marker automatically sets a special marker, 'LAST', when it jumps to a
marker, allowing an easy return to a former position.

This module was written as a demonstration of the inside-out object technique
for the NY Perl Seminar group.  It is intended for teaching purposes not
production code.  It is not currently thread-safe, including pseudo-forks on 
Win32.

=head1 USAGE

=head2 new
 
 my $fh = new();
 my $fh = new( @args );

Creates and returns a File::Marker object.  If arguments are provided, they are
passed to open() before the object is returned.  This mimics the behavior of
IO::File.

=head2 open

 $rv = $fh->open( @args );

Opens... (ref IO::File for details)

=head2 set_marker

 $rv = set_marker();

Description of set_marker...

=head2 goto_marker

 $rv = goto_marker();

Description of goto_marker...

=head2 markers

 @list = $fh->markers();

Returns a list of markers that have been set on the object.  (Including 'LAST'.)

=head1 BUGS

Please report bugs to the author.

=head1 AUTHOR

David A. Golden (DAGOLDEN)

dagolden@cpan.org

http://dagolden.com/

=head1 COPYRIGHT

Copyright (c) 2005 by David A. Golden

This program is free software; you can redistribute
it and/or modify it under the same terms as Perl itself.

The full text of the license can be found in the
LICENSE file included with this module.

=cut
