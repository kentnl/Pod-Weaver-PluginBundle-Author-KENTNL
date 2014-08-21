use 5.008;    # utf8
use strict;
use warnings;
use utf8;

package Pod::Weaver::PluginBundle::Author::KENTNL::Postlude;

our $VERSION = '0.001000';

# ABSTRACT: End of document stuff

our $AUTHORITY = 'cpan:KENTNL'; # AUTHORITY

use Moo qw( with );

with 'Pod::Weaver::PluginBundle::Author::KENTNL::Role::Easy';





sub bundle_prefix { return '@A:KNL:Postlude' }

sub instance_config {
  my ($self) = @_;
  $self->add_named_entry( 'Region.pre_postlude' => 'Region', { region_name => 'pre_postlude', } );
  $self->add_entry( 'Leftovers'    => {} );
  $self->add_entry( 'Authors'      => {} );
  $self->add_entry( 'Contributors' => {} );
  $self->add_entry( 'Legal'        => {} );
  $self->add_named_entry( 'Region.post_postlude' => 'Region', { region_name => 'post_postlude', } );
  return;
}

no Moo;

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

Pod::Weaver::PluginBundle::Author::KENTNL::Postlude - End of document stuff

=head1 VERSION

version 0.001000

=head1 SYNOPSIS

  [@Author::KENTNL::Postlude]

Is pretty much

  [Region / pre_postlude]
  [Leftovers]
  [Authors]
  [Contributors]
  [Legal]
  [Region / post_postlude]

=for Pod::Coverage bundle_prefix instance_config

=head1 AUTHOR

Kent Fredric <kentfredric@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2014 by Kent Fredric <kentfredric@gmail.com>.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
