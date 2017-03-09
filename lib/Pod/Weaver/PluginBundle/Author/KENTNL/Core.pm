use 5.006;    # our
use strict;
use warnings;

package Pod::Weaver::PluginBundle::Author::KENTNL::Core;

our $VERSION = '0.001004';

# ABSTRACT: Core configuration for Pod::Weaver

# AUTHORITY

use Moo qw( with );
with 'Pod::Weaver::PluginBundle::Author::KENTNL::Role::Easy';

=for Pod::Coverage bundle_prefix instance_config

=cut

sub bundle_prefix { return '@A:KNL:Core' }

sub instance_config {
  my ($self) = @_;
  $self->inhale_bundle('@CorePrep');
  $self->add_entry('-SingleEncoding');
  return;
}

no Moo;

1;

=head1 SYNOPSIS

  [@Author::KENTNL::Core]

This is presently basically the same as

  [@CorePrep]
  [-SingleEncoding]

=cut
