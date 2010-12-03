#!/usr/bin/env perl

use strict;
use warnings;

BEGIN {
    $ENV{MT_APP} = 'MT::App::Comments';
}

use lib qw( t/lib lib extlib );

use MT::Test qw( :app :db :data );
use Test::More tests => 4;

use JSON;

require MT::Blog;
my $b = MT::Blog->load(1);
$b->commenter_authenticators('MovableType');
$b->save;

require MT::Entry;
my $e = MT::Entry->load(1);

ok( ( !scalar grep { $_ eq 'testingtag' } $e->tags ),
    "Testing tag is not in the entry" );

require MT::Author;
my $a = MT::Author->load(1);

my $out_app = _run_app(

    'MT::App::Comments',
    {   __test_user => $a,
        __mode      => 'add_tag',
        id          => 1,
        tag         => 'testingtag'
    },
);

# need to clean up the output for now
# until MT::Test is updated to nix the output headers
my $out = $out_app->{__test_output};
$out =~ s!\A.*?Content-Type.*?$!!ms;

my $out_json = from_json($out);
is( $out_json->{result}->{message},
    'Success', "Got a success response from adding a tag" );
is( $out_json->{result}->{tag_added},
    'testingtag', "Got the tag back in the response" );

$e->refresh;
ok( ( scalar grep { $_ eq 'testingtag' } $e->tags ),
    "Testing tag is now in the entry" );
