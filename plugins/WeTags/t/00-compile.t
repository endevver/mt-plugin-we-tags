#!/usr/bin/env perl

use strict;
use warnings;

use lib qw( t/lib lib extlib );

use MT::Test;
use Test::More tests => 2;

require MT;
ok( MT->component('WeTags'), "We Tags plugin loaded successfully." );
require_ok('WeTags::Comments');

1;
