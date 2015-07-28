class CreateMembers < ActiveRecord::Migration
  def self.up
    create_table :members do |t|
      t.column :username, :string, :null => false
      t.column :password, :string, :null => false
      
      t.column :first_name, :string, :null => false
      t.column :last_name, :string, :null => false
      t.column :email_address, :string, :null => false
      t.column :gender, :string, :null => false
      
      t.column :number_of_links, :string, :null => false, :default => 0
      
      t.column :avatar, :integer, :null => false, :default => 0
      t.column :biography, :text
      
      t.column :friends, :text
      t.column :enemies, :text
      
      t.column :superuser, :integer, :default => 0, :null => false
      
      t.column :created_on, :datetime, :null => false
      t.column :updated_on, :datetime, :null => false
    end
  end

  def self.down
    drop_table :members
  end
end
