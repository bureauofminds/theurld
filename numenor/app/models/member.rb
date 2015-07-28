class Member < ActiveRecord::Base
  
  has_and_belongs_to_many :links
  
  has_many :link_queues
  
end
