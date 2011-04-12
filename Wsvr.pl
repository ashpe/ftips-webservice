#!/usr/bin/perl

use RPC::XML::Server;
use RPC::XML::Method;
use DBD::mysql;
use DBI;
use Moose;
use Modern::Perl;

my $database = 'footydata';
my $hostname = '192.168.0.103';
my $user = 'root';
my $password = 'brodie123';

sub get_login {
  my ($svr, $usr, $pwd) = @_;
  my $dsn = "DBI:mysql:database=$database;host=$hostname";
  my $dbh = DBI->connect($dsn, $user, $password);
  my $sth = $dbh->prepare("SELECT * FROM users where username=? AND password=?");
  $sth->execute($usr, $pwd);
  my $numRows = $sth->fetchall_hashref('username');
    
  return $numRows;
}

my $port = 4420;

my $srv = RPC::XML::Server->new(port => $port);
# Several of these, most likely:
$srv->add_method({ name => 'get_login', signature => ['string string string'], code => \&get_login});

print "Footytips automation XMLRPC server running on port $port.. (ctrl-c to close)\n";

$srv->server_loop; # Never returns

1;
