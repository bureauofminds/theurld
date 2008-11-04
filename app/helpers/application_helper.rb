# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def datetime(date)
    date.strftime("%B %e, %Y at %I:%M %p")
  end
  
  def longdate(date)
    date.strftime("%A, %B %e, %Y")
  end
  
  def short_url(code)
    "http://localhost:3020/#{code}"
  end
  
  def label_tag(model, attribute, options = {})
    name = options[:name] || attribute.titleize.capitalize
    "<label for=\"#{model}_#{attribute}\"#{" class=\""+options[:class]+"\"" if options[:class]}>#{name}</label>"
  end
  
  def submit_tag(name)
    "<input name=\"commit\" type=\"submit\" value=\"#{name}\" class=\"submit\" />"
  end
  
end
