use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    'NAME'		=> 'GraphViz::ISA',
    'VERSION_FROM'	=> 'ISA.pm', # finds $VERSION
    'PREREQ_PM'		=> { GraphViz => 0.11 }, # e.g., Module::Name => 1.1
    dist                => {
        # don't ask about existing .tar.gz files
        COMPRESS => 'gzip --force --best'
    },
);
