use 5.008;    # utf8
use strict;
use warnings;
use utf8;

package Pod::Weaver::PluginBundle::Author::KENTNL::Core;

our $VERSION = '0.001000';

# ABSTRACT: Core configuration for Pod::Weaver

our $AUTHORITY = 'cpan:KENTNL'; # AUTHORITY

use Moo qw( with );
with 'Pod::Weaver::PluginBundle::Author::KENTNL::Role::Easy';





sub bundle_prefix { return '@A:KNL:Core' }

sub instance_config {
  my ($self) = @_;
  $self->inhale_bundle('@CorePrep');
  $self->add_entry('-SingleEncoding');
  return;
}

no Moo;

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

Pod::Weaver::PluginBundle::Author::KENTNL::Core - Core configuration for Pod::Weaver

=head1 VERSION

version 0.001000

=head1 SYNOPSIS

  [@Author::KENTNL::Core]

This is presently basically the same as

  [@CorePrep]
  [-SingleEncoding]

=for Pod::Coverage bundle_prefix instance_config

=head1 AUTHOR

Kent Fredric <kentfredric@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2014 by Kent Fredric <kentfredric@gmail.com>.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
