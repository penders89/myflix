class CreateInvitations < ActiveRecord::Migration
  def change
    create_table :invitations do |t|
      t.string :friend_name, :friend_email, :inviter_id, :token
      t.text :message
    end
  end
end
