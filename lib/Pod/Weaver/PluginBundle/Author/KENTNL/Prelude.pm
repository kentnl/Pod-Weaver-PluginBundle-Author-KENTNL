use 5.008;    # utf8
use strict;
use warnings;
use utf8;

package Pod::Weaver::PluginBundle::Author::KENTNL::Prelude;

our $VERSION = '0.001001';

# ABSTRACT: Introductory POD Segments

# AUTHORITY

use Moo qw( with );
with 'Pod::Weaver::PluginBundle::Author::KENTNL::Role::Easy';

=for Pod::Coverage bundle_prefix instance_config

=cut

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

=cut
