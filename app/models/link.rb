class Link < ActiveRecord::Base
  
  belongs_to :member
  belongs_to :domain
  belongs_to :category
  
  def self.per_page
    20
  end
  
end
