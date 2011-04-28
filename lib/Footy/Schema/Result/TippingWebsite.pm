package Footy::Schema::Result::TippingWebsite;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use base 'DBIx::Class::Core';


=head1 NAME

Footy::Schema::Result::TippingWebsite

=cut

__PACKAGE__->table("tipping_websites");

=head1 ACCESSORS

=head2 website_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 website_name

  data_type: 'text'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "website_id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "website_name",
  { data_type => "text", is_nullable => 0 },
);
__PACKAGE__->set_primary_key("website_id");

=head1 RELATIONS

=head2 user_tipping_accounts

Type: has_many

Related object: L<Footy::Schema::Result::UserTippingAccount>

=cut

__PACKAGE__->has_many(
  "user_tipping_accounts",
  "Footy::Schema::Result::UserTippingAccount",
  { "foreign.website_id" => "self.website_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2011-04-27 03:21:01
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:cgpqGGgy4uZ7eBf61Pau2g


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
