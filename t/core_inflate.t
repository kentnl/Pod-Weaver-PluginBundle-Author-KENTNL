use strict;
use warnings;

use Test::More;
use Test::Differences qw( eq_or_diff );

# FILENAME: core_inflate.t
# ABSTRACT: Test my core magic

require Pod::Weaver::PluginBundle::Author::KENTNL::Core;

eq_or_diff(
  [ Pod::Weaver::PluginBundle::Author::KENTNL::Core->mvp_bundle_config ],
  [

    [ '@A:KNL:Core/@CorePrep/EnsurePod5', 'Pod::Weaver::Plugin::EnsurePod5',     {} ],
    [ '@A:KNL:Core/@CorePrep/H1Nester',   'Pod::Weaver::Plugin::H1Nester',       {} ],
    [ '@A:KNL:Core/-SingleEncoding',      'Pod::Weaver::Plugin::SingleEncoding', {} ],

  ],
  "Core inflates as intended"
);

done_testing;

