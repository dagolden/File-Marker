package File::Marker;

$VERSION = "0.10";
@ISA = qw( IO::File );

use strict;
use warnings;
use Carp;
use IO::File;
use Scalar::Util qw( refaddr );

my %marks_for = ();

#--------------------------------------------------------------------------#
# main pod documentation 
#--------------------------------------------------------------------------#

# Below is the stub of documentation for your module. You better edit it!

=head1 NAME

File::Marker - Put abstract here 

=head1 SYNOPSIS

 use File::Marker;
 blah blah blah

=head1 DESCRIPTION

Description...

=head1 USAGE

Usage...

=head2 new

=cut

sub new {
    my $class = shift;
    
    my $self = IO::File->new();
    bless $self, $class;
    $self->open( @_ ) if @_;
    return $self;
}


#--------------------------------------------------------------------------#
# open()
#--------------------------------------------------------------------------#

=head2 open

 $rv = open();

Description of open...

=cut

sub open {
    my $self = shift;
    $marks_for{ refaddr $self } = {};
    $self->SUPER::open( @_ );
    $marks_for{ refaddr $self }{'LAST'} = $self->getpos;
}


#--------------------------------------------------------------------------#
# set_marker()
#--------------------------------------------------------------------------#

=head2 set_marker

 $rv = set_marker();

Description of set_marker...

=cut

sub set_marker {
    my ($self, $mark) = @_;
    
    croak "Can't set marker on closed filehandle"
        if ! $self->opened;

    croak "Can't set special marker 'LAST'" 
        if $mark eq 'LAST';
        
    my $position = $self->getpos;
    croak "Couldn't set marker '$mark': couldn't locate position in file"
        if ! defined $position;
    
    $marks_for{ refaddr $self }{$mark} = $self->getpos;
    
    return 1;
}

#--------------------------------------------------------------------------#
# goto_marker()
#--------------------------------------------------------------------------#

=head2 goto_marker

 $rv = goto_marker();

Description of goto_marker...

=cut

sub goto_marker {
    my ($self, $mark) = @_;
    
    croak "Can't goto marker on closed filehandle"
        if ! $self->opened;

    croak "Unknown file marker '$mark'"
        if ! exists $marks_for{refaddr $self}{$mark};
    
    my $old_position = $self->getpos; # save for LAST
    
    my $rc = $self->setpos( $marks_for{refaddr $self}{$mark} );
    croak "Couldn't goto marker '$mark': could not seek to location in file"
        if ! defined $rc;
    
    $marks_for{ refaddr $self }{ 'LAST' } = $old_position;

    return 1;
}


#--------------------------------------------------------------------------#
# markers()
#--------------------------------------------------------------------------#

=head2 markers

 $rv = markers();

Description of markers...

=cut

sub markers {
    my $self = shift;
    return keys %{ $marks_for{ refaddr $self } };
}



1; #this line is important and will help the module return a true value
__END__

=head1 BUGS

Please report bugs using the CPAN Request Tracker at L<http://rt.cpan.org/>

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
