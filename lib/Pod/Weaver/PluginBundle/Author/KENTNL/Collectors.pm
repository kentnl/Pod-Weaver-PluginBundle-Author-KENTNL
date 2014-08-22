use 5.008;    # utf8
use strict;
use warnings;
use utf8;

package Pod::Weaver::PluginBundle::Author::KENTNL::Collectors;

our $VERSION = '0.001003';

# ABSTRACT: Sub/Attribute/Whatever but shorter and with defaults

# AUTHORITY

use Carp qw( carp croak );
use Moo qw( has with );
use MooX::Lsub qw( lsub );
with 'Pod::Weaver::PluginBundle::Author::KENTNL::Role::Easy';

=for Pod::Coverage mvp_aliases mvp_multivalue_args bundle_prefix

=cut

sub mvp_aliases { return { command => qw[commands] } }
sub mvp_multivalue_args { return qw( commands ) }
sub bundle_prefix       { return '@A:KNL:Collectors' }

my $command_aliases = {
  'required'  => 'REQUIRED METHODS',
  'function'  => 'FUNCTIONS',
  'method'    => 'METHODS',
  'attr'      => 'ATTRIBUTES',
  'cattr'     => 'ATTRIBUTES / CONSTRUCTOR ARGUMENTS',
  'pfunction' => 'PRIVATE FUNCTIONS',
  'pmethod'   => 'PRIVATE METHODS',
  'pattr'     => 'PRIVATE ATTRIBUTES',
};

=attr C<commands>

A C<mvp_multivalue_args> parameter.

  command = method
  command = attr
  command = unknowncommand = HEADING IS THIS

Default value:

  [qw( required attr method pattr pmethod )]

=head3 Interpretation

=over 4

=item * C<required> : REQUIRED METHODS command = C<required>

=item * C<function> : FUNCTIONS command = C<function>

=item * C<attr> : ATTRIBUTES command = C<attr>

=item * C<method> : METHODS command = C<method>

=item * C<cattr> : ATTRIBUTES / CONSTRUCTOR ARGUMENTS command = C<cattr>

=item * C<pfunction> : PRIVATE FUNCTIONS command = C<pfunction>

=item * C<pmethod> : PRIVATE METHODS command = C<pmethod>

=item * C<pattr> : PRIVATE ATTRIBUTES command = C<pattr>

=item * C<([^\s]+) = (.+)> : C<$2> command = C<$1>

=back

=cut

lsub commands => sub {
  return [qw( required function attr method pfunction pattr pmethod )];
};

=for Pod::Coverage instance_config

=cut

sub instance_config {
  my ($self) = @_;
  $self->add_named_entry( 'Region.pre_commands', 'Region', { region_name => 'pre_commands' } );
  for my $command ( @{ $self->commands } ) {
    if ( exists $command_aliases->{$command} ) {
      $self->add_named_entry(
        'Collect.' . $command => 'Collect',
        { command => $command, header => $command_aliases->{$command}, },
      );
      next;
    }
    if ( my ( $short, $long ) = $command =~ /\A\s*(\S+)\s*=\s*(.+?)\s*\z/msx ) {
      $self->add_named_entry( 'Collect.' . $command => 'Collect', { command => $short, header => $long, } );
      next;
    }
    carp "Don't know what to do with command $command";
  }
  $self->add_named_entry( 'Region.post_commands', 'Region', { region_name => 'post_commands' } );
  return;
}

no Moo;

1;

=head1 QUICK REFERENCE

  [@Author::KENTNL::Collectors]
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

  [@Author::KENTNL::Collectors]

This is basically the same as

  [Region / pre_commands]

  ; This stuff repeated a bunch of times
  [Collect / ... ]
  ...

  [Region / post_commands]

But "This stuff repeated here" is a bit complicated and dynamic.

=cut
