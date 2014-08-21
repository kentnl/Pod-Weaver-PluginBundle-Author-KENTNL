use 5.008;    # utf8
use strict;
use warnings;
use utf8;

package Pod::Weaver::PluginBundle::Author::KENTNL::Prelude;

our $VERSION = '0.001000';

# ABSTRACT: Introductory POD Segments

our $AUTHORITY = 'cpan:KENTNL'; # AUTHORITY

use Moo qw( with );
with 'Pod::Weaver::PluginBundle::Author::KENTNL::Role::Easy';





sub bundle_prefix { return '@A:KNL:Prelude' }

sub instance_config {
  my ($self) = @_;
  $self->add_entry('Name');
  $self->add_entry('Version');
  $self->add_named_entry( 'Region.pre_prelude'  => 'Region',  { region_name => 'pre_prelude', } );
  $self->add_named_entry( 'QUICKREF'            => 'Generic', { header      => 'QUICK REFERENCE' } );
  $self->add_named_entry( 'SYNOPSIS'            => 'Generic', { header      => 'SYNOPSIS' } );
  $self->add_named_entry( 'DESCRIPTION'         => 'Generic', { header      => 'DESCRIPTION' } );
  $self->add_named_entry( 'OVERVIEW'            => 'Generic', { header      => 'OVERVIEW' } );
  $self->add_named_entry( 'Region.post_prelude' => 'Region',  { region_name => 'post_prelude', } );
  return;
}

no Moo;

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

Pod::Weaver::PluginBundle::Author::KENTNL::Prelude - Introductory POD Segments

=head1 VERSION

version 0.001000

=head1 SYNOPSIS

  [@Author::KENTNL::Prelude]

is pretty much

  [Name]
  [Version]
  [Region / pre_prelude]
  [Generic / QUICK REFERENCE]
  [Generic / SYNOPSIS]
  [Generic / DESCRIPTION]
  [Generic / OVERVIEW]
  [Region / post_prelude]

=for Pod::Coverage bundle_prefix instance_config

=head1 AUTHOR

Kent Fredric <kentfredric@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2014 by Kent Fredric <kentfredric@gmail.com>.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
