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

    my $proxy = 'https://192.168.0.101:443/';

# Environment variables so our SSL URL works with the WebService
    $ENV{HTTPS_PROXY} = $proxy;
    $ENV{HTTPS_DEBUG} = 1;
    $ENV{HTTPS_VERSION} = 3;
    $ENV{HTTPS_CA_DIR}    = '/etc/nginx/'; # location of certs
    $ENV{HTTPS_CA_FILE}    = '/etc/nginx/server.crt';
    $client = RPC::XML::Client->new($proxy);

    return $self;
}

sub __login {
    my ($self, $username, $password) = @_; 

    my $req = RPC::XML::request->new('get_login', RPC::XML::string->new($username), RPC::XML::string->new($password));
    my $resp = $client->send_request($req);
    
    return $resp->value;

}

sub __create_account {
    my ($self, $username, $password, $email) = @_;
    
    my $req = RPC::XML::request->new('new_account',
                                    RPC::XML::string->new($username),
                                    RPC::XML::string->new($password),
                                    RPC::XML::string->new($email));

    my $resp = $client->send_request($req);

    return $resp->value;
}


sub __autotip {
    my ($self, $accounts) = @_;
    
    my @split_accounts = split ":", $accounts;
    my $success;

    my @tips = ('collingwood', 'western bulldogs', 'fremantle', 'hawthorn', 'west coast eagles', 'melbourne', 'geelong', 'essendon');

    foreach (@split_accounts) {
        if (/footytips\.com\.au/) {
            $success = Footy::Mechanize->footytips('ashpe', 'brodie123', 12, \@tips);
        }
    }

    return $success;
}
    

1;

