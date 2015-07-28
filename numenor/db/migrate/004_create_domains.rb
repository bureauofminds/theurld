class CreateDomains < ActiveRecord::Migration
  def self.up
    create_table :domains do |t|
      t.column :title, :text
      
      t.column :scheme, :string, :null => false
      t.column :domain, :string, :null => false
      
      t.column :favicon, :integer, :default => 0, :null => false
      t.column :number_of_links, :integer, :default => 0, :null => false
      
      t.column :created_on, :datetime, :null => false
      t.column :updated_on, :datetime, :null => false
    end
  end

  def self.down
    drop_table :domains
  end
end
