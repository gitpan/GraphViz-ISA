package GraphViz::ISA;

require 5.005_62;
use strict;
use warnings;

use Carp;
use GraphViz;

our $AUTOLOAD;
our $VERSION = '0.01';

sub new {
	my $this = shift;
	my $class = ref($this) || $this;
	my $self = {};
	bless $self, $class;
	$self->_init(@_);
	return $self;
}

sub _init {
	my ($self, $that) = @_;
	my $pkg = ref($that) || $that;
	$self->{g} = GraphViz->new();
	my $tree = { $pkg => $self->isatree($pkg) };
	$self->graph($tree);
}

sub isatree {
        my ($self, $pkg) = @_;
	no strict 'refs';
        my $isa = *{"$pkg\::ISA"}{ARRAY};
        return {} unless @$isa;

        my %out;
        for my $base (@$isa) {
                $out{$base} = $self->isatree($base);
        }
        return \%out;
}

sub graph {
	my ($self, $tree) = @_;
	return unless keys %$tree;
	for my $pkg (keys %$tree) {
		$self->{g}->add_node($pkg);
		$self->{g}->add_edge($_, $pkg) for keys %{ $tree->{$pkg} };
		$self->graph($tree->{$pkg});
	}
}

sub AUTOLOAD {
	my $self = shift;
	my $type = ref($self) or croak "$self is not an object";

	(my $name = $AUTOLOAD) =~ s/.*:://;
	return if $name =~ /DESTROY/;

	# hm, maybe GraphViz knows what to do with it...
	$self->{g}->$name(@_);
}

1;
__END__

=head1 NAME

GraphViz::ISA - Graphing @ISA hierarchies at run-time

=head1 SYNOPSIS

  use GraphViz::ISA;
  my $p = Some::Class->new;

  my $g1 = GraphViz::ISA->new($p);
  print $g1->as_png;

  my $g2 = GraphViz::ISA->new('Some::Other::Module');
  print $g2->as_png;

=head1 DESCRIPTION

This class constructs a graph showing the C<@ISA> hierarchy (note:
not object hierarchies) from a package name or a blessed scalar.

=head1 METHODS

The following methods are defined by this class; all other method calls
are passed to the underlying GraphViz object:

=over 4

=item new()

This constructs the object itself and takes a parameter. The parameter
can be either a package name or a scalar blessed into a package. It then
calls C<isatree()> and hands the result to C<graph()>. Then it returns
the newly constructed object.

=item isatree()

Takes a package name as a parameter and traverses the indicated package's
C<@ISA> recursively, constructing a hash of hashes. If a package's C<@ISA>
is empty, it has an empty hashref as the value in the tree.

=item graph()

Takes a tree previously constructed by C<isatree()> and traverses it,
creating nodes and edges as it goes along.

=back

=head1 TODO

=over 4

=item test.pl

=back

=head1 BUGS

None known so far. If you find any bugs or oddities, please do inform the
author.

=head1 AUTHOR

Marcel GrE<uuml>nauer, <marcel@codewerk.com>

=head1 COPYRIGHT

Copyright 2001 Marcel GrE<uuml>nauer. All rights reserved.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

perl(1), GraphViz(3pm).

=cut
