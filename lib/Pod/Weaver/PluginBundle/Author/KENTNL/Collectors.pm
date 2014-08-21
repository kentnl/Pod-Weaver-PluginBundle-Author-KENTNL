use 5.008;    # utf8
use strict;
use warnings;
use utf8;

package Pod::Weaver::PluginBundle::Author::KENTNL::Collectors;

our $VERSION = '0.001000';

# ABSTRACT: Sub/Attribute/Whatever but shorter and with defaults

our $AUTHORITY = 'cpan:KENTNL'; # AUTHORITY

use Moo qw( has with );
use MooX::Lsub qw( lsub );
with 'Pod::Weaver::PluginBundle::Author::KENTNL::Role::Easy';

sub mvp_aliases { return { command => qw[commands] } }
sub mvp_multivalue_args { return qw( commands ) }
sub bundle_prefix       { return '@A:KNL:Collectors' }

my $command_aliases = {
  'method'  => 'METHODS',
  'attr'    => 'ATTRIBUTES',
  'cattr'   => 'ATTRIBUTES / CONSTRUCTOR ARGUMENTS',
  'pmethod' => 'PRIVATE METHODS',
  'pattr'   => 'PRIVATE ATTRIBUTES',
};

































lsub commands => sub {
  return [qw( attr method pattr pmethod )];
};

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
    if ( my ( $short, $long ) = $command =~ /\A\s*([^\s]+)\s*=\s*(.+?)\s*\z/msx ) {
      $self->add_named_entry( 'Collect.' . $command => 'Collect', { command => $short, header => $long, } );
      next;
    }
    warn "Don't know what to do with command $command";
  }
  $self->add_named_entry( 'Region.post_commands', 'Region', { region_name => 'post_commands' } );
  return;
}

no Moo;

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

Pod::Weaver::PluginBundle::Author::KENTNL::Collectors - Sub/Attribute/Whatever but shorter and with defaults

=head1 VERSION

version 0.001000

=head1 QUICK REFERENCE

  [@Author::KENTNL::Collectors]
  ; command[].default = [ attr method pattr pmethod ]
  ; command[].entry_type[0] = KNOWNCOMMANDNAME
  ; command[].entry_type[1] = COMMANDNAME = DESCRIPTION
  ;        KNOWNCOMMANDNAME.enums =     
  ;             = method        ; METHODS
  ;             = attr          ; ATTRIBUTES
  ;             = cattr         ; ATTRIBUTES / CONSTRUCTOR ARGUMENTS
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

=head1 ATTRIBUTES

=head2 C<commands>

A C<mvp_multivalue_args> parameter.

  command = method
  command = attr
  command = unknowncommand = HEADING IS THIS

Default value:

  [qw( attr method pattr pmethod )]

=head3 Interpretation

=over 4

=item * C<attr> : ATTRIBUTES command = C<attr>

=item * C<method> : METHODS command = C<method>

=item * C<cattr> : ATTRIBUTES / CONSTRUCTOR ARGUMENTS command = C<cattr>

=item * C<pmethod> : PRIVATE METHODS command = C<pmethod>

=item * C<pattr> : PRIVATE ATTRIBUTES command = C<pattr>

=item * C<([^\s]+) = (.+)> : C<$2> command = C<$1>

=back

=head1 AUTHOR

Kent Fredric <kentfredric@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2014 by Kent Fredric <kentfredric@gmail.com>.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
