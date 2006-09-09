use Module::Build;
# See perldoc Module::Build for details of how this works

Module::Build->new( 
    module_name         => 'File::Marker',
    dist_author         => 'David A. Golden <dagolden@cpan.org>',
    license             => 'perl',
    create_readme       => 1,
    create_makefile_pl  => 'traditional',
    requires        => {
        # module requirements here
    },
    build_requires  => { 
        Test::More => 0.48,
    },
)->create_build_script;
