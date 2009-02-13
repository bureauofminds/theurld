class Link < ActiveRecord::Base
  
  has_and_belongs_to_many :members
  
  belongs_to :domain
  belongs_to :category
  
  order_by :fields => ['latest_on', 'created_on', 'updated_on'], :mode => :desc
  
  def self.per_page
    20
  end
  
end
