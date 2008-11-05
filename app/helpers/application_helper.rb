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
  
  def format_text(text)
    RedCloth.new((text || ''), [:hard_breaks]).to_html
  end
  
  def label_tag(model, attribute, options = {})
    name = options[:name] || attribute.titleize.capitalize
    "<label for=\"#{model}_#{attribute}\"#{" class=\""+options[:class]+"\"" if options[:class]}>#{name}</label>"
  end
  
  def submit_tag(name)
    "<input name=\"commit\" type=\"submit\" value=\"#{name}\" class=\"submit\" />"
  end
  
  def favicon(domain, options = {})
    image_tag("favicons/#{domain.id}.gif", :size => (options[:size] || "16x16"), :alt => domain.title, :class => 'favicon') if domain.favicon == 1 and File.exists?(File.join(FAVICONS_LOCATION, "#{domain.id}.gif"))
  end
  
  def pronoun(member, type)
    gender = member.gender.downcase
    
    if type == "his_her"
      if gender == "male"
        "his"
      elsif gender == "female"
        "her"
      else
        "its"
      end
    elsif type == "he_she"
      if gender == "male"
        "he"
      elsif gender == "female"
        "she"
      else
        "it"
      end
    end
  end
  
end
