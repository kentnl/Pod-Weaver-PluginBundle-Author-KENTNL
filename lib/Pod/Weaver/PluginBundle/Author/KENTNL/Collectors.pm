use 5.008;    # utf8
use strict;
use warnings;
use utf8;

package Pod::Weaver::PluginBundle::Author::KENTNL::Collectors;

# ABSTRACT: Sub/Attribute/Whatever but shorter and with defaults

our $AUTHORITY = 'cpan:KENTNL'; # AUTHORITY

use Moo qw( has with );
use MooX::Lsub qw( lsub );
with 'Pod::Weaver::PluginBundle::Author::KENTNL::Role::Easy';

sub mvp_aliases { { command => qw[commands] } }
sub mvp_multivalue_args { qw( commands ) }

sub bundle_prefix { '@A:KNL:Collectors' }

my $command_aliases = {
  'method'  => "METHODS",
  'attr'    => "ATTRIBUTES",
  'cattr'   => "ATTRIBUTES / CONSTRUCTOR ARGUMENTS",
  'pmethod' => "PRIVATE METHODS",
  'pattr'   => "PRIVATE ATTRIBUTES",
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
        'Collect.' . $command,
        'Collect',
        {
          command => $command,
          header  => $command_aliases->{$command},
        }
      );
      next;
    }
    if ( my ( $short, $long ) = $command =~ /\A\s*([^\s]+)\s*=\s*(.+?)\s*\z/msx ) {
      $self->add_named_entry(
        'Collect.' . $command,
        'Collect',
        {
          command => $short,
          header  => $long,
        }
      );
      next;
    }
    warn "Don't know what to do with command $command";
  }
  $self->add_named_entry( 'Region.post_commands', 'Region', { region_name => 'post_commands' } );
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

=head1 AUTHOR

Kent Fredric <kentfredric@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2014 by Kent Fredric <kentfredric@gmail.com>.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
