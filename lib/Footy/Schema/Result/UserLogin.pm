package Footy::Schema::Result::UserLogin;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use base 'DBIx::Class::Core';


=head1 NAME

Footy::Schema::Result::UserLogin

=cut

__PACKAGE__->table("user_login");

=head1 ACCESSORS

=head2 user_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 username

  data_type: 'varchar'
  is_nullable: 0
  size: 25

=head2 password

  data_type: 'text'
  is_nullable: 0

=head2 email

  data_type: 'text'
  is_nullable: 0

=head2 status

  data_type: 'text'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "user_id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "username",
  { data_type => "varchar", is_nullable => 0, size => 25 },
  "password",
  { data_type => "text", is_nullable => 0 },
  "email",
  { data_type => "text", is_nullable => 0 },
  "status",
  { data_type => "text", is_nullable => 0 },
);
__PACKAGE__->set_primary_key("user_id");
__PACKAGE__->add_unique_constraint("username", ["username"]);

=head1 RELATIONS

=head2 user_tipping_accounts

Type: has_many

Related object: L<Footy::Schema::Result::UserTippingAccount>

=cut

__PACKAGE__->has_many(
  "user_tipping_accounts",
  "Footy::Schema::Result::UserTippingAccount",
  { "foreign.user_id" => "self.user_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

__PACKAGE__->has_many(
  "groups",
  "Footy::Schema::Result::TippingGroup",
  { "foreign.user_id" => "self.user_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2011-04-27 03:21:01
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:8V/C7JzfR+mqnWcl0r9neQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
