class Link < ActiveRecord::Base
  
  belongs_to :member
  belongs_to :domain
  belongs_to :category
  
  order_by :fields => ['latest_on', 'created_on', 'updated_on'], :mode => :desc
  
  def self.per_page
    20
  end
  
end
