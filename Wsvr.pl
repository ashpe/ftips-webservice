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

sub get_dbh {

  my $dsn = "DBI:mysql:database=$database;host=$hostname";
  my $dbh = DBI->connect($dsn, $user, $password);
  return $dbh;

}
sub get_login {
  my ($svr, $usr, $pwd) = @_;

  my $dbh = get_dbh();
  my $sth = $dbh->prepare("SELECT * FROM users where username=? AND password=?");
  $sth->execute($usr, $pwd);
  my $return_value = $sth->fetchall_hashref('username');
  if ($return_value->{$usr}) {
    return 1;
  } else {
    return 0;
  }
}

sub new_account {
  my ($svr, $usr, $pwd, $email) = @_;

  my $dbh = get_dbh();

  my $sth = $dbh->prepare("SELECT * from users where username=?");
  $sth->execute($usr);
  
  my $does_user_exist = $sth->fetchall_hashref('username');
  if (!$does_user_exist->{$usr}) {

    my $sth = $dbh->prepare("INSERT INTO users values(?,?,?,'inactive')");
    $sth->execute($usr, $pwd, $email);
    return "Account created successfully. Check your email to confirm..";

  } else {
    return "Username already exists.";
  }
}

my $port = 4420;

my $srv = RPC::XML::Server->new(port => $port);
# Several of these, most likely:
$srv->add_method({ name => 'get_login', signature => ['string string string'], code => \&get_login});
$srv->add_method({ name => 'new_account', signature => ['string string string string'], code => \&new_account});

print "Footytips automation XMLRPC server running on port $port.. (ctrl-c to close)\n";

$srv->server_loop; # Never returns

1;
