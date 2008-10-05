# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def datetime(date)
    date.strftime("%B %e, %Y at %I:%M %p")
  end
  
  def longdate(date)
    date.strftime("%A, %B %e, %Y")
  end
  
end
