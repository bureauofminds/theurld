class CreateCategories < ActiveRecord::Migration
  def self.up
    create_table :categories do |t|
      t.column :name, :string, :null => false
      t.column :description, :text
      
      t.column :subcategory, :integer, :default => 0, :null => false
      
      t.column :number_of_links, :integer, :default => 0, :null => false
      
      t.column :created_on, :datetime, :null => false
      t.column :updated_on, :datetime, :null => false
    end
  end

  def self.down
    drop_table :categories
  end
end
