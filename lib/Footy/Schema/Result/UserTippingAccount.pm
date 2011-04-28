package Footy::Schema::Result::UserTippingAccount;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use base 'DBIx::Class::Core';


=head1 NAME

Footy::Schema::Result::UserTippingAccount

=cut

__PACKAGE__->table("user_tipping_accounts");

=head1 ACCESSORS

=head2 tipping_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 group_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 website_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 user_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 tipping_username

  data_type: 'text'
  is_nullable: 0

=head2 tipping_password

  data_type: 'text'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "tipping_id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "group_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "website_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "user_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "tipping_username",
  { data_type => "text", is_nullable => 0 },
  "tipping_password",
  { data_type => "text", is_nullable => 0 },
);
__PACKAGE__->set_primary_key("tipping_id");

=head1 RELATIONS

=head2 group

Type: belongs_to

Related object: L<Footy::Schema::Result::TippingGroup>

=cut

__PACKAGE__->belongs_to(
  "group",
  "Footy::Schema::Result::TippingGroup",
  { group_id => "group_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 website

Type: belongs_to

Related object: L<Footy::Schema::Result::TippingWebsite>

=cut

__PACKAGE__->belongs_to(
  "website",
  "Footy::Schema::Result::TippingWebsite",
  { website_id => "website_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 user

Type: belongs_to

Related object: L<Footy::Schema::Result::UserLogin>

=cut

__PACKAGE__->belongs_to(
  "user",
  "Footy::Schema::Result::UserLogin",
  { user_id => "user_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2011-04-27 03:21:01
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:Q+X7kShLoGt8o2f16DPnRw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
