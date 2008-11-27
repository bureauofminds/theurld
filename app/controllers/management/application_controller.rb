class Management::ApplicationController < ApplicationController
  
  before_filter :is_superuser?
  
  layout 'management'
  
end
