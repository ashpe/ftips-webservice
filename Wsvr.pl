#!/usr/bin/perl

use Data::Dumper;
use RPC::XML::Server;
use RPC::XML::Method;
use DBD::mysql;
use DBI;
use Moose;
use Modern::Perl;
use Footy::Schema;
use Footy::Mechanize;

my $database = 'test';
my $hostname = 'localhost';
my $user     = 'root';
my $password = 'brodie123';

sub get_schema {
    my $schema =
      Footy::Schema->connect( "DBI:mysql:database=$database;host=$hostname",
        $user, $password );
    return $schema;
}

sub get_login {
    my ( $svr, $usr, $pwd ) = @_;

    my $schema = get_schema();
    my $rs     = $schema->resultset('UserLogin')->search(
        {
            username => $usr,
            password => $pwd,
        }
    );
    my $user = $rs->first;

    if ($user) {
        return 1;
    }
    else {
        return 0;
    }

}

sub new_account {
    my ( $svr, $usr, $pwd, $email ) = @_;

    my $schema = get_schema();
    my $rs   = $schema->resultset('UserLogin')->search( { username => $usr } );
    my $user = $rs->first;

    if ( !$user ) {

        my $new_user = $schema->resultset('UserLogin')->create(
            {
                username => $usr,
                password => $pwd,
                email    => $email,
                status   => 'inactive',
            }
        );

        $new_user->add_to_groups( { group_name => 'default' } );

        return "Account created successfully. You may login now.";

    }
    else {
        return "Username already exists.";
    }
}

sub add_tipping_account {
    my ( $svr, $usr, $web, $website_usr, $website_pwd, $group_name ) = @_;

    my $schema = get_schema();
    
    my $rs = $schema->resultset('UserLogin')->search( { username => $usr, } );
    my $user = $rs->first;

    $rs = $schema->resultset('TippingGroup')->search( { group_name => $group_name } );
    my $group = $rs->first;	

    $rs =
      $schema->resultset('TippingWebsite')->search( { website_name => $web, } );

    my $website = $rs->first;

    my $add_account = $schema->resultset('UserTippingAccount')->create(
        {
            user_id          => $user->user_id,
            group_id         => $group->group_id,
            website_id       => $website->website_id,
            tipping_username => $website_usr,
            tipping_password => $website_pwd,
        }
    );
    
    return $add_account;
}

sub autotip {
    my ( $svr, $group_name, $usr, $margin, $tips ) = @_;

    my $schema = get_schema();
    my $success;
    my $rs = $schema->resultset('UserLogin')->search( { username => $usr } );
    my $user = $rs->first;

    $rs = $schema->resultset('TippingGroup')->search( { group_name => $group_name } );
    my $group = $rs->first;	

    $rs = $schema->resultset('UserTippingAccount')->search(
        {
            user_id  => $user->user_id,
            group_id => $group->group_id,
        }
    );

    while ( my $account = $rs->next ) {
        Footy::Mechanize->footytips( $account->tipping_username,
            $account->tipping_password, $margin, $tips, );
    }

    return $tips;

}

sub get_tipping_accounts {
    my ( $svr, $usr ) = @_;

    my @tipping_accounts;
    my $schema = get_schema();
    my $rs   = $schema->resultset('UserLogin')->search( { username => $usr } );
    my $user = $rs->first;

    $rs =
      $schema->resultset('UserTippingAccount')
      ->search( { user_id => $user->user_id, } );

    while ( my $tipping_account = $rs->next ) {
        my %tmp = ();
        $tmp{website}  = $tipping_account->website->website_name;
        $tmp{username} = $tipping_account->tipping_username;
        $tmp{group}    = $tipping_account->group->group_name;

        push @tipping_accounts, \%tmp;
    }

    return \@tipping_accounts;
}

sub get_groups {
    my ( $svr, $usr ) = @_;

    my $schema = get_schema();
    my $rs   = $schema->resultset('UserLogin')->search( { username => $usr } );
    my $user = $rs->first;
    my @get_groups;		
    $rs = $user->groups;
    
    while (my $group = $rs->next) {
	push @get_groups, $group->group_name;
    }		
    	
    return \@get_groups;

}

sub get_websites {
    my ($svr) = @_;

    my $schema        = get_schema();
    my $rs	      = $schema->resultset('TippingWebsite');
    my @get_websites;

    while (my $website = $rs->next) {
	push @get_websites, $website->website_name;
    }	 	
	 
    return \@get_websites;

}

my $port = 4420;

my $srv = RPC::XML::Server->new( port => $port );

# Several of these, most likely:
$srv->add_method(
    {
        name      => 'autotip',
        signature => ['string string string string string'],
        code      => \&autotip
    }
);

$srv->add_method(
    {
        name      => 'get_groups',
        signature => ['string string'],
        code      => \&get_groups
    }
);

$srv->add_method(
    { name => 'get_websites', signature => ['array'], code => \&get_websites }
);

$srv->add_method(
    {
        name      => 'add_tipping_account',
        signature => ['string string string string string string'],
        code      => \&add_tipping_account
    }
);

$srv->add_method(
    {
        name      => 'get_tipping_accounts',
        signature => ['string string'],
        code      => \&get_tipping_accounts
    }
);

$srv->add_method(
    {
        name      => 'get_login',
        signature => ['string string string'],
        code      => \&get_login
    }
);

$srv->add_method(
    {
        name      => 'new_account',
        signature => ['string string string string'],
        code      => \&new_account
    }
);

print
"Footytips automation XMLRPC server running on port $port.. (ctrl-c to close)\n";

$srv->server_loop;    # Never returns

1;
