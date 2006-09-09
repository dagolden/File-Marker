package File::Marker;
use strict;
use warnings;
use Carp;

BEGIN {
    use Exporter ();
    use vars qw ($VERSION @ISA @EXPORT @EXPORT_OK %EXPORT_TAGS);
    $VERSION     = "0.10";
    @ISA         = qw (Exporter);
    @EXPORT      = qw ();
    @EXPORT_OK   = qw ();
    %EXPORT_TAGS = ();
}

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

=cut

sub new {
    my ($class, $parameters) = @_;
    
    croak "new() can't be invoked on an object"
        if ref($class);
        
    my $self = bless ({ }, $class);
    return $self;
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
