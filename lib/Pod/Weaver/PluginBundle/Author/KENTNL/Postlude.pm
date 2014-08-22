use 5.008;    # utf8
use strict;
use warnings;
use utf8;

package Pod::Weaver::PluginBundle::Author::KENTNL::Postlude;

our $VERSION = '0.001002';

# ABSTRACT: End of document stuff

# AUTHORITY

use Moo qw( with );

with 'Pod::Weaver::PluginBundle::Author::KENTNL::Role::Easy';

=for Pod::Coverage bundle_prefix instance_config

=cut

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

=head1 SYNOPSIS

  [@Author::KENTNL::Postlude]

Is pretty much

  [Region / pre_postlude]
  [Leftovers]
  [Authors]
  [Contributors]
  [Legal]
  [Region / post_postlude]

=cut
