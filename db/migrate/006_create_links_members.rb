class CreateLinksMembers < ActiveRecord::Migration
  def self.up
    create_table :links_members, :id => false do |t|
      t.column :link_id, :integer, :null => false
      t.column :member_id, :integer, :null => false
      
      # I don't think this value can actually be used in the app
      # but it's good for record keeping
      t.column :created_on, :datetime, :null => false
    end
  end

  def self.down
    drop_table :links_members
  end
end
