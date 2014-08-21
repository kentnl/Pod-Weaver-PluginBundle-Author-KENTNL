use 5.008;    # utf8
use strict;
use warnings;
use utf8;

package Pod::Weaver::PluginBundle::Author::KENTNL::Role::Easy;

our $VERSION = '0.001000';

# ABSTRACT: Moo based instance based sugar syntax for mutable configuration declaration

our $AUTHORITY = 'cpan:KENTNL'; # AUTHORITY

use Carp qw( carp );
use Moo::Role qw( has requires );
use Try::Tiny qw( try catch );
use Module::Runtime qw( require_module );
use Pod::Weaver::Config::Assembler;

has '_state' => ( init_arg => undef, is => 'ro' =>, lazy => 1, default => sub { [] } );

requires 'bundle_prefix';
requires 'instance_config';

sub _prefixify {
  my ( $self, $oldname, ) = @_;  # called as ->( name, $pluginame ) just in case
  return $self->bundle_prefix . q[/] . $oldname;
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
    carp "Could not inhale $name: $_";
  };
  return;
}

sub mvp_bundle_config {
  my ( $class, $arg ) = @_;
  my @args;
  if ( $arg and 'HASH' eq ref $arg ) {
    push @args, ( 'name'    => $arg->{name} )    if exists $arg->{name};
    push @args, ( 'package' => $arg->{package} ) if exists $arg->{name};
    if ( exists $arg->{payload} ) {
      if ( 'HASH' eq ref $arg->{payload} ) {
        push @args, %{ $arg->{payload} };
      }
      elsif ( 'ARRAY' eq ref $arg->{payload} ) {
        push @args, @{ $arg->{payload} };
      }
      else {
        carp 'Good luck with that payload buddy';
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

Pod::Weaver::PluginBundle::Author::KENTNL::Role::Easy - Moo based instance based sugar syntax for mutable configuration declaration

=head1 VERSION

version 0.001000

=head1 QUICK REFERENCE

  [>] bundle_prefix()                                         # [>] String
  [>] instance_config()                                       # [>] mutator
  ->add_entry( $plugin_name, $confighash )                    # mutator
  ->add_named_entry( $name, $plugin_name, $confighash )       # mutator
  ->inhale_bundle( $name, $arg )                              # mutator

  ->mvp_bundle_config( $arg )                                 # List

  ->_push_state_prefixed( $name, $plugin_name, $confighash )  # mutator
  ->_push_state( $name, $plugin_name, $confighash )           # mutator
  ->_prefixify( $name, $plugin_name )                         # String
  ->_state()                                                  # ArrayRef


  -~- MVP Magic -~-
  [>?] mvp_multivalue_args                                    # [>] List[Str]
  [>?] mvp_aliases                                            # [>] HashRef
  [>?] mvp_bundle_config                                      # [>] List

=head1 SYNOPSIS

  package Foo;
  use Moo qw( with );
  with 'Pod::Weaver::PluginBundle::Author::KENTNL::Role::Easy'; # this is the hardest part ;)

  sub bundle_prefix { 'some_identifier_@foo_is_good' }

  has 'ox_bollocks' => ( is => ro => ..., default => sub { 1 } );
  has 'an_mvp_thinger' => ( is => ro => ..., default => sub { [] } );

  sub mvp_multivalue_args { 'an_mvp_thinger' };

  sub instance_config {
    my ( $self ) = @_;
    $self->add_entry( $pluginname, $config );
    if ( $self->ox_bollocks ) {
      $self->add_named_entry( $alias, $pluginname, $config );
    }
    for my $thing ( @{ $self->an_mvp_thinger } ) {
      ... # more things
    }
    $self->inhale_bundle( '@bundle', $maybeconfig );
  }
  1;

=head1 AUTHOR

Kent Fredric <kentfredric@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2014 by Kent Fredric <kentfredric@gmail.com>.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
