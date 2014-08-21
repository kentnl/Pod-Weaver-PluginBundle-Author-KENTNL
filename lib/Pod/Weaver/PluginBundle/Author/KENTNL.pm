use 5.008;    # utf8
use strict;
use warnings;
use utf8;

package Pod::Weaver::PluginBundle::Author::KENTNL;

our $VERSION = '0.001000';

# ABSTRACT: KENTNL's amazing Pod::Weaver Plugin Bundle.

our $AUTHORITY = 'cpan:KENTNL'; # AUTHORITY

use Moo qw( has with );
with 'Pod::Weaver::PluginBundle::Author::KENTNL::Role::Easy';

sub bundle_prefix { '@A:KNL' }
sub mvp_aliases { { command => qw[commands] } }
sub mvp_multivalue_args { qw( commands ) }

has 'commands' => (
  is => ro =>,
  predicate => 'has_commands',
  lazy => 1,
  default => sub { [] },
);

sub instance_config {
  my ( $self ) = @_;
  $self->inhale_bundle('@Author::KENTNL::Core');
  $self->inhale_bundle('@Author::KENTNL::Prelude');
  my (@config);
  if ( $self->has_commands ) {
    push @config, { payload => { 'commands' => $self->commands }};
  }
  $self->inhale_bundle('@Author::KENTNL::Commands',@config);
  $self->inhale_bundle('@Author::KENTNL::Postlude');
  return;
}

no Moo;

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

Pod::Weaver::PluginBundle::Author::KENTNL - KENTNL's amazing Pod::Weaver Plugin Bundle.

=head1 VERSION

version 0.001000

=head1 AUTHOR

Kent Fredric <kentfredric@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2014 by Kent Fredric <kentfredric@gmail.com>.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
