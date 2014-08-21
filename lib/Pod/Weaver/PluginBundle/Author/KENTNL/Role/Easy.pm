use 5.008;    # utf8
use strict;
use warnings;
use utf8;

package Pod::Weaver::PluginBundle::Author::KENTNL::Role::Easy;

# ABSTRACT: Moo based instance based sugar syntax for mutable config declaration

our $AUTHORITY = 'cpan:KENTNL'; # AUTHORITY

use Moo::Role qw( has required );
use Pod::Weaver::Config::Assembler;
use Try::Tiny qw( try catch );
use Module::Runtime qw( require_module );
sub _exp { Pod::Weaver::Config::Assembler->expand_package( $_[0] ) }
has '_state' => ( is => 'ro' =>, lazy => 1, default => sub { [] } );

requires 'bundle_prefix';
requires 'instance_config';

sub _prefixify {
  my ( $self, $oldname, $pluginname ) = @_;
  if ( 'Pod::Weaver::Section::Contributors' eq $pluginname ) {

  }
  return $self->bundle_prefix . '/' . $oldname;
}

sub _push_state {
  my ( $self, $name, $plugin, $config ) = @_;
  push @{ $self->_state }, [ $name, $plugin, $config ];
  return;
}

sub _push_state_prefixed {
  my ( $self, $name, $plugin, $config ) = @_;
  $self->_push_state( $self->_prefixify( $name, $plugin ), $plugin, $config );
  return;
}

sub add_entry {
  my ( $self, $name, $config ) = @_;
  $config = {} unless defined $config;
  my $plugin = Pod::Weaver::Config::Assembler->expand_package($name);
  $self->_push_state_prefixed( $name, $plugin, $config );
  return;
}
sub add_named_entry {
  my ( $self, $alias, $plugin_name, $config ) = @_;
  $config = {} unless defined $config;
  my $plugin = Pod::Weaver::Config::Assembler->expand_package($plugin_name);
  $self->_push_state_prefixed( $alias, $plugin, $config );
  return;
}

sub inhale_bundle {
  my ( $self, $name, @args ) = @_;
  my $plugin = Pod::Weaver::Config::Assembler->expand_package($name);
  try {
    require_module($plugin);
    for my $entry ( $plugin->mvp_bundle_config(@args) ) {
      $self->_push_state_prefixed( @{$entry} );
    }
  }
  catch {
    warn "Could not inhale $name: $_";
  };
  return;
}

use Data::Dump qw(pp);
sub mvp_bundle_config {
  my ($class, $arg ) = @_;
  my @args;
  if ( $arg and 'HASH' eq ref $arg ) {
    push @args, ( 'name' => $arg->{name} ) if exists $arg->{name};
    push @args, ( 'package' => $arg->{package} ) if exists $arg->{name};
    if ( exists $arg->{payload} ) {
      if ( 'HASH' eq ref $arg->{payload} ) {
        push @args, %{ $arg->{payload} };
      } elsif ( 'ARRAY' eq ref $arg->{payload} ) {
        push @args, @{ $arg->{payload} };
      } else {
        warn "Good luck with that payload buddy";
      }
    }
  }
  my $instance = $class->new(@args);
  $instance->instance_config;
  return @{ $instance->_state };
}

no Moo;

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

Pod::Weaver::PluginBundle::Author::KENTNL::Role::Easy - Moo based instance based sugar syntax for mutable config declaration

=head1 VERSION

version 0.001000

=head1 AUTHOR

Kent Fredric <kentfredric@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2014 by Kent Fredric <kentfredric@gmail.com>.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
