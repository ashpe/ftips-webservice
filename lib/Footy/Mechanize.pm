package Footy::Mechanize;

use Modern::Perl;
use WWW::Mechanize;
use Storable;
use Data::Dumper;

sub footytips {

    my ( $self, $username, $password, $margin, $tips ) = @_;

    my $margin_textfield_name = "Margin";
    my $url                   = 'http://www.footytips.com.au';
    my $m                     = WWW::Mechanize->new();
    my $edit                  = 0;

    $m->get($url);
    my $content = $m->content;

    $m->submit_form(
        form_number => 1,
        fields => { 'userLogin' => $username, 'userPassword' => $password },
    );

    die unless $m->success;
    $url = 'http://www.footytips.com.au/tipping/afl/';
    $m->get($url);

    my @tmp_content = split "\n", $m->content;

    foreach (@tmp_content) {
        if (/href="(.+)" title="edit tips"/i) {
            my $edit_url = $1;
            $edit_url =~ s/amp;//g;
            $m->get( "http://www.footytips.com.au" . $edit_url );
            $edit = 1;
            last if $m->success;
        }
    }

    @tmp_content = [];
    @tmp_content = split "\n", $m->content;

    my @id_for_tips;
    my $tmp;
    foreach (@tmp_content) {
        if (/for=\"(.*)\">($tips)<\/label>/i) {
            $tmp = $1;
            foreach my $c (@tmp_content) {
                if ( $c =~ /id=\"$tmp\"/ ) {
                    $c =~ /name=\"(.+)\" value=\"(.+)\"/i;
                    push @id_for_tips, { name => $1, value => $2 };
                }
            }
        }
    }
    $m->set_fields( $margin_textfield_name => $margin );
    foreach (@id_for_tips) {
        $m->set_fields( $_->{name} => $_->{value} );
    }

    $m->click_button( name => 'saveTips' );
    return 1;
}

sub bigfooty {

    my ( $self, $username, $password, $margin, $tips ) = @_;

    my $login_field = "passname";
    my $pass_field  = "passin";

    my $url = 'http://www.bigfooty.com/tips/';
    my $m   = WWW::Mechanize->new();
    $m->get($url);

    my $content = $m->content;

    $m->set_fields( $login_field => $username );
    $m->set_fields( $pass_field  => $password );
    $m->click_button( name => 'login' );

    die unless $m->success;

    my @tmp_content = $m->content;
    my @id_for_tips;
    my $margin_id;

    foreach (@tmp_content) {
        while (/name="(.+)" value="(.+)"> ($tips) /ig) {
            push @id_for_tips, { name => $1, value => $2 };
        }
        if (/input type="text" name="breaker_(.+)" value/i) {
            $margin_id = "breaker_" . $1;
        }
    }

    $m->set_fields( $margin_id, $margin );

    foreach (@id_for_tips) {
        $m->set_fields( $_->{name} => $_->{value} );
    }

    $m->click_button( name => 'Action' );

}

1;
