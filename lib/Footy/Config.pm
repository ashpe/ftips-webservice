#!/usr/bin/perl

package Footy::Config;

use Config::ZOMG;
use Data::Dumper;

sub load {

    my $config = Config::ZOMG->new(
        name => 'database'
    );

    my $config_hash = $config->load;

    return $config_hash;
}



true;

