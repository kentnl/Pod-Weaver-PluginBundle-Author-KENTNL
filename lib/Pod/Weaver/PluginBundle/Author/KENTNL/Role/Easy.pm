use 5.008;    # utf8
use strict;
use warnings;
use utf8;

package Pod::Weaver::PluginBundle::Author::KENTNL::Role::Easy;

our $VERSION = '0.001002';

# ABSTRACT: Moo based instance based sugar syntax for mutable configuration declaration

# AUTHORITY

use Carp qw( carp );
use Moo::Role qw( has requires );
use Try::Tiny qw( try catch );
use Module::Runtime qw( require_module );
use Pod::Weaver::Config::Assembler;

has '_state' => ( init_arg => undef, is => 'ro' =>, lazy => 1, default => sub { [] } );

=required C<bundle_prefix>

Must return a string to prefix on B<ALL> entries.

=cut

requires 'bundle_prefix';

=required C<instance_config>

Will be called for you to mutate state prior to returning the generated state.

=cut

requires 'instance_config';

=pmethod C<_prefixify>

Expands simple aliases into prefixed ones

  ->_prefixify( $oldname, $plugin_package )  >> String

Default implementation is simply

  ->bundle_prefix . q[/] . $oldname

And C<$plugin_package> is passed for overloading convenience if you ever want to do something magical.

=cut

sub _prefixify {
  my ( $self, $oldname, ) = @_;    # called as ->( name, $pluginame ) just in case
  return $self->bundle_prefix . q[/] . $oldname;
}

=pmethod C<_push_state>

Appends a configuration line to the internal array

  ->_push_state( $raw_name, $plugin_package, $config_hash )

=cut

sub _push_state {
  my ( $self, $name, $plugin, $config ) = @_;
  push @{ $self->_state }, [ $name, $plugin, $config ];
  return;
}

=pmethod C<_push_state_prefixed>

Appends a configuration line to the internal array with C<$unprefixed_name> prefixed

  ->_push_state_prefixed( $unprefixed_name, $plugin_package, $config_hash )

=cut

sub _push_state_prefixed {
  my ( $self, $name, $plugin, $config ) = @_;
  $self->_push_state( $self->_prefixify( $name, $plugin ), $plugin, $config );
  return;
}

=method C<add_entry>

Add a simple plugin to this bundle.

  ->add_entry( "Foo" , { a => 1 , b => [ 1, 2 ] } );
  ->add_entry( $name , { $config } );

Roughly corresponds to

  [Foo / SomePrefix/Foo]
  a = 1
  b = 1
  b = 2

For things that need to have unique names for plugins, use C<add_named_entry>

=cut

sub add_entry {
  my ( $self, $name, $config ) = @_;
  $config = {} unless defined $config;
  my $plugin = Pod::Weaver::Config::Assembler->expand_package($name);
  $self->_push_state_prefixed( $name, $plugin, $config );
  return;
}

=method C<add_named_entry>

  ->add_named_entry( "Foo" , "Bar" , { a => 1, b => [1, 2]});
  ->add_entry( $name , { $config } );


Roughly corresponds to

  [Bar / SomePrefix/Foo]
  a = 1
  b = 1
  b = 2

B<NOTE:> C<$name> is subject to prefix expansion. Use C<$config> explicitly to avoid
side effects. That is, this mechanism only serves to create unique identifiers I<within> a bundle.

Bundle prefixing should make sure it stays unique beyond that.

Relying on "name" field to communicate state within a bundle will break as soon as your bundle is C<inhaled>.

So. Use C<$config> ;)

  ->add_named_entry("SYNOPSIS", "Generic"); # Bad, will look for MyPrefix/SYNOPSIS, which won't exist.

  ->add_named_entry("SYNOPSIS", "Generic", { header => 'SYNOPSIS' }); # Resilient code.
    # { name => "MyPrefix/SYNOPIS",
    #   package => "Pod::Weaver::Section::Generic",
    #   payload => { header => 'SYNOPSIS' }
    # }

=cut

sub add_named_entry {
  my ( $self, $alias, $plugin_name, $config ) = @_;
  $config = {} unless defined $config;
  my $plugin = Pod::Weaver::Config::Assembler->expand_package($plugin_name);
  $self->_push_state_prefixed( $alias, $plugin, $config );
  return;
}

=method C<inhale_bundle>

Include another bundle prefixed as a component of your own.

  ->inhale_bundle('@foobundle'); # Beginners mode
  ->inhale_bundle('@foobundle', $confighash ); # EXPERT MODE

Also, be aware that any bundle that has not been designed to be prefix resilient ( see L</add_named_entry> )
will be likely broken if it relies on the "name" element to be meaningful.

You can circumvent this if you wear your expert hat and overload L</_prefixify> and/or do it all yourself with  L</_push_state>

=cut

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

=for Pod::Coverage mvp_bundle_config

=cut

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

=cut
