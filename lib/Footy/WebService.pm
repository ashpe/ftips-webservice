package Footy::WebService;

use Moose;
use Modern::Perl;
use Data::Dumper;
use Footy::Mechanize;

require RPC::XML;
require RPC::XML::Client;

our $client;

# URL where the WebService is hosted.
sub new_service {
    my ($self) = @_;

    my $proxy = 'http://localhost:4420/';
    #my $proxy = 'http://203.132.88.127:4420/';
    #my $proxy = 'https://192.168.0.101:443/';

    # Environment variables so our SSL URL works with the WebService
    #$ENV{HTTPS_PROXY} = $proxy;
    #$ENV{HTTPS_DEBUG} = 1;
    #$ENV{HTTPS_VERSION} = 3;
    #$ENV{HTTPS_CA_DIR}    = '/etc/nginx/'; # location of certs
    #$ENV{HTTPS_CA_FILE}    = '/etc/nginx/server.crt';
    $client = RPC::XML::Client->new($proxy);

    return $self;
}

sub __login {
    my ( $self, $username, $password ) = @_;

    my $req = RPC::XML::request->new(
        'get_login',
        RPC::XML::string->new($username),
        RPC::XML::string->new($password)
    );
    my $resp = $client->send_request($req);

    return $resp->value;

}

sub __add_tipping_account {

    my ( $self, $username, $website, $website_username, $website_password,
        $group_name )
      = @_;

    my $req = RPC::XML::request->new(
        'add_tipping_account',
        RPC::XML::string->new($username),
        RPC::XML::string->new($website),
        RPC::XML::string->new($website_username),
        RPC::XML::string->new($website_password),
        RPC::XML::string->new($group_name),
    );
    my $resp = $client->send_request($req);
    return $resp->value;

}

sub __get_websites {

    my ($self) = @_;
    
    my $req =
      RPC::XML::request->new( 'get_websites');
    my $resp = $client->send_request($req);
    return $resp->value;
}

sub __get_groups {

    my ($self, $username) = @_;
    
    my $req =
      RPC::XML::request->new( 'get_groups',
        RPC::XML::string->new($username),
      );
    my $resp = $client->send_request($req);

    return $resp->value;
}

sub __user_tipping_accounts {

    my ( $self, $username ) = @_;

    my $req =
      RPC::XML::request->new( 'get_tipping_accounts',
        RPC::XML::string->new($username),
      );
    my $resp = $client->send_request($req);
    return $resp->value;

}

sub __create_account {
    my ( $self, $username, $password, $email ) = @_;

    my $req = RPC::XML::request->new(
        'new_account',                    RPC::XML::string->new($username),
        RPC::XML::string->new($password), RPC::XML::string->new($email)
    );

    my $resp = $client->send_request($req);

    return $resp->value;
}

sub __autotip {
    my ( $self, $group_name, $username, $margin, $tips ) = @_;

    my $req = RPC::XML::request->new(
        'autotip',                        RPC::XML::string->new($group_name),
        RPC::XML::string->new($username), RPC::XML::string->new($margin),
        RPC::XML::string->new($tips)
    );

    my $resp = $client->send_request($req);

    return $resp->value;
}

1;

