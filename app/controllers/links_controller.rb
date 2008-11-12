class LinksController < ApplicationController
  
  def view
    @link = Link.find_by_code(params[:code])
    redirect_to @link.uri
  end
  
  def new
    case request.method
    when :get
      ###
    
    when :post
      require 'net/http'
      require 'hpricot'
      
      scheme = URI.parse(params[:link][:uri]).scheme
      if !scheme or scheme.downcase != "http"
        flash[:error] = "Sorry, only HTTP URIs are currently supported."
        return redirect_to session[:referrer] || '/'
      end
      params[:link][:uri] = "http://" + params[:link][:uri] if scheme == nil
      uri = URI.parse(params[:link][:uri])
      
      response = Net::HTTP.new(uri.host).request_head((uri.path.length > 0 ? uri.path : "index"))
      
      if response == 404
        flash[:error] = "Looks like that page doesn't exist!"
        return redirect_to session[:referrer] || '/'
      else
        @domain = Domain.find(:first,
                              :conditions => ['scheme = ? and domain = ?', uri.scheme, uri.host])
        add_domain(uri) if !@domain

        @link = Link.new
        @link.member_id = @master_member.id
        @link.domain_id = @domain.id
        @link.category_id = params[:link][:category_id] || nil
        @link.title = ''
        @link.uri = params[:link][:uri]
        @link.path = uri.path.to_s
        @link.code = generate_code
        @link.save
        
        # images won't return a title, so filename is used
        # hopefully we can come up with a better method
        temp_page_location = File.join(TEMP_PAGES_LOCATION, "#{@link.id}.html")
        begin
          system("wget \"#{uri.to_s}\" -O \"#{temp_page_location}\"")
          
          document_html = Hpricot(File.open(temp_page_location).read)
          title = document_html.at("title").inner_html
          
          @link.title = title.length > 0 ? title : File.basename(uri.to_s)
        rescue Exception => e
          log_error(e)
          @link.title = File.basename(uri.to_s)
        end
        File.delete(temp_page_location) if File.exists?(temp_page_location)
        
        @link.category.number_of_links = @link.category.number_of_links + 1 if @link.category
        @link.save
        
        @domain.update_attribute('number_of_links', @domain.number_of_links + 1)
      end
      
      redirect_to :controller => '/'
    end
  end
  
  private
  
  def add_domain(uri)
    @domain = Domain.new
    begin
      document_html = Hpricot(open("#{uri.scheme}://#{uri.host}", "User-Agent" => "theurld"))
      title = document_html.at("title").inner_html
      @domain.title = title.length > 0 ? title : uri.host
    rescue
      @domain.title = uri.host
    end
    @domain.scheme = uri.scheme
    @domain.domain = uri.host
    @domain.save
    
    favicon_location  = File.join(FAVICONS_LOCATION, "#{@domain.id}")
    
    begin
      if Net::HTTP.new(@domain.domain).request_head(("favicon.ico")).to_s != "404"
        require 'RMagick'
        
        # be sure to have wget available
        system("wget \"#{@domain.scheme}://#{@domain.domain}/favicon.ico\" -O \"#{favicon_location}.ico\"")
        
        if File.exists?(favicon_location + ".ico")
          original_file = Magick::Image.read(favicon_location + ".ico").first.resize_to_fit(16,16)
          # this doesn't work apparently
          # transparent GIFs are given a black background
          # 
          # original_file.background_color = 'none'
          original_file.write(favicon_location + ".gif")
  
          @domain.update_attribute('favicon', 1)
        end
      end
    rescue Exception => e
      log_error(e)
      # Angelo Ashmore, 11/10/08: 
      # doesn't really matter if it fails to get the favicon
      # but maybe there should be a way for it to try
      # to get the favicon again when a user submits the same
      # domain again and the favicon has yet to be retrieved
    end
    
    File.delete(favicon_location + ".ico") if File.exists?(favicon_location + ".ico")
  end
  
  def generate_code
    chars = ("a".."z").to_a + ("1".."9").to_a
    code = Array.new(5, '').collect{chars[rand(chars.size)]}.join
    existing_code = Link.find_by_code(code)
    if existing_code or FORBIDDEN_NAMES.include?(code)
      generate_code and return false
    else
      code
    end
  end
  
end
