use Module::Build;
# See perldoc Module::Build for details of how this works

Module::Build->new( 
    module_name         => 'File::Marker',
    dist_author         => 'David A. Golden <dagolden@cpan.org>',
    license             => 'perl',
    create_readme       => 1,
    create_makefile_pl  => 'traditional',
    requires        => {
        Scalar::Util => 1.09,
        File::Spec::Functions => 0,
        File::Temp => 0.14, # Object-oriented 
        IO::File => 0,
        Test::More => 0.47,
    },
)->create_build_script;
