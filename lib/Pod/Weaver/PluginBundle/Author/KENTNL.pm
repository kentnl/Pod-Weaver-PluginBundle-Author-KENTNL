use 5.008;    # utf8
use strict;
use warnings;
use utf8;

package Pod::Weaver::PluginBundle::Author::KENTNL;

our $VERSION = '0.001002';

# ABSTRACT: KENTNL's amazing Pod::Weaver Plugin Bundle.

# AUTHORITY

use Moo qw( has with );
with 'Pod::Weaver::PluginBundle::Author::KENTNL::Role::Easy';

=for Pod::Coverage bundle_prefix mvp_aliases mvp_multivalue_args

=cut

sub bundle_prefix       { return '@A:KNL' }
sub mvp_aliases         { return { command => qw[commands] } }
sub mvp_multivalue_args { return qw( commands ) }

=for Pod::Coverage has_commands

=cut

has 'commands' => (
  is        => ro  =>,
  predicate => 'has_commands',
  lazy      => 1,
  default   => sub { [] },
);

=for Pod::Coverage instance_config

=cut

sub instance_config {
  my ($self) = @_;
  $self->inhale_bundle('@Author::KENTNL::Core');
  $self->inhale_bundle('@Author::KENTNL::Prelude');
  my (@config);
  if ( $self->has_commands ) {
    push @config, { payload => { 'commands' => $self->commands } };
  }
  $self->inhale_bundle( '@Author::KENTNL::Collectors', @config );
  $self->inhale_bundle('@Author::KENTNL::Postlude');
  return;
}

no Moo;

1;

=head1 QUICK REFERENCE

  [@Author::KENTNL]

  -~- Inherited from @Author::KENTNL::Collectors -~-
  ; command[].default = [ required function attr method pfunction pattr pmethod ]
  ; command[].entry_type[0] = KNOWNCOMMANDNAME
  ; command[].entry_type[1] = COMMANDNAME = DESCRIPTION
  ;        KNOWNCOMMANDNAME.enums =
  ;             = required      ; REQUIRED METHODS
  ;             = function      ; FUNCTIONS
  ;             = method        ; METHODS
  ;             = attr          ; ATTRIBUTES
  ;             = cattr         ; ATTRIBUTES / CONSTRUCTOR ARGUMENTS
  ;             = pfuncton      ; PRIVATE FUNCTIONS
  ;             = pmethod       ; PRIVATE METHODS
  ;             = pattr         ; PRIVATE ATTRIBUTES

=head1 SYNOPSIS

  [@Author::KENTNL]

This is basically the same as

  [@Author::KENTNL::Core]

  [@Author::KENTNL::Prelude]

  [@Author::KENTNL::Collectors]

  [@Author::KENTNL::Postlude]

=over 4

=item * C<[@Author::KENTNL::Core]> : L<<
C<Pod::Weaver::PluginBundle::Author::KENTNL::Core>
|Pod::Weaver::PluginBundle::Author::KENTNL::Core
>>

=item * C<[@Author::KENTNL::Prelude]> : L<<
C<Pod::Weaver::PluginBundle::Author::KENTNL::Prelude>
|Pod::Weaver::PluginBundle::Author::KENTNL::Prelude
>>

=item * C<[@Author::KENTNL::Collectors]> : L<<
C<Pod::Weaver::PluginBundle::Author::KENTNL::Collectors>
|Pod::Weaver::PluginBundle::Author::KENTNL::Collectors
>>

=item * C<[@Author::KENTNL::Postlude]> : L<<
C<Pod::Weaver::PluginBundle::Author::KENTNL::Postlude>
|Pod::Weaver::PluginBundle::Author::KENTNL::Postlude
>>

=back

=cut

