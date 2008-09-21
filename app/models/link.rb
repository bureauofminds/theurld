class Link < ActiveRecord::Base
  
  belongs_to :member
  belongs_to :domain
  belongs_to :category
  
end
