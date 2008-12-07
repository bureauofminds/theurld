class LinksWorker < BackgrounDRb::MetaWorker
  set_worker_name :links_worker
  
  require 'rubygems'
  require 'net/http'
  require 'hpricot'
  require 'open-uri'
  
  def create(args = nil)
    # this method is called, when worker is loaded for the first time
  end
  
  def new(args)
    uri = args[:uri]
    master_member_id = args[:master_member_id]
    category_id = args[:category_id]
    number_of_links = args[:number_of_links]
    
    logger.info "Adding link now! #{uri.to_s}"
    
    uri = uri.strip.chomp
    
    if uri.length > 0
      scheme = URI.parse(uri).scheme
      if scheme == nil
        uri = "http://" + uri
        scheme = "http"
      end
      if scheme.downcase != "http"
        flash[:error] = "Sorry, only HTTP URIs are currently supported."
        return redirect_to session[:referrer] || '/'
      end
      uri = URI.parse(uri)

      response = Net::HTTP.new(uri.host).request_head((uri.path.length > 0 ? uri.path : "index"))

      if response == 404
        flash[:error] = "Looks like that page doesn't exist!"
        return redirect_to session[:referrer] || '/'
      else
        @domain = Domain.find(:first,
                              :conditions => ['scheme = ? and domain = ?', uri.scheme, uri.host])
        add_domain(uri) if !@domain

        @link = Link.new
        @link.member_id = master_member_id
        @link.domain_id = @domain.id
        @link.category_id = category_id == nil ? category_id : nil
        # images won't return a title, so filename is used
        # hopefully we can come up with a better method
        begin
          document_html = Hpricot(open(uri, "User-Agent" => "theurld"))
          title = document_html.search("title").html.strip
          @link.title = title.length > 0 ? title : File.basename(uri.to_s)
        rescue
          @link.title = File.basename(uri.to_s)
        end

        @link.title = File.basename(uri.to_s) unless @link.title.length > 0
        @link.uri = uri.to_s
        @link.path = uri.path.to_s
        @link.code = generate_code
        
        if @link.save
          @domain.update_attribute('number_of_links', @domain.number_of_links + 1)
          @link.category.update_attribute('number_of_links', @link.category.number_of_links + 1) unless category_id == nil
          number_of_links += 1
        end
      end
    end
  end
  
  def add_domain(uri)
    @domain = Domain.new
    
    begin
      document_html = Hpricot(open(uri.host, "User-Agent" => "theurld"))
      title = document_html.search("title").html.strip
      @domain.title = title.length > 0 ? title : File.basename(uri.to_s)
    rescue
      @domain.title = File.basename(uri.to_s)
    end
    
    @domain.title = uri.host unless @domain.title.length > 0
    @domain.scheme = uri.scheme
    @domain.domain = uri.host
    @domain.save
    
    favicon_location  = File.join(FAVICONS_LOCATION, "#{@domain.id}")
    
    begin
      if Net::HTTP.new(@domain.domain).request_head(("favicon.ico")).to_s != "404"
        require 'RMagick'
      
        thread = Thread.new do
          Net::HTTP.start(@domain.domain) { |http|
            resp = http.get("/favicon.ico")
            open(favicon_location + ".ico", "w") { |favicon|
              favicon.write(resp.body)
            }
          }
    
          original_file = Magick::Image.read(favicon_location + ".ico").first.resize_to_fit(16,16)
          # this doesn't work apparently
          # transparent GIFs are given a black background
          # 
          # original_file.background_color = 'none'
          original_file.write(favicon_location + ".gif")
    
          @domain.update_attribute('favicon', 1)
        end
        thread.join(2)
      end
    rescue
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
    
    # Loop this method if the generated code matches an already existing one
    existing_code = Link.find_by_code(code)
    if existing_code or FORBIDDEN_NAMES.include?(code)
      generate_code and return false
    else
      code
    end
  end
  
end
