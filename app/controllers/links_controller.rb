class LinksController < ApplicationController
  
  def view
    ###
  end
  
  def add
    case request.method
    when :get
      ###
    
    when :post
      require 'uri'
      require 'net/http'
      require 'mechanize'
      
      scheme = URI.parse(params[:link][:uri]).scheme
      if scheme.downcase != "http"
        flash[:error] = "Sorry, only HTTP URIs are currently supported."
        # TODO - Angelo Ashmore, 9/20/08: Make this redirect somewhere
        return redirect_to "/"
      end
      params[:link][:uri] = "http://" + params[:link][:uri] if scheme == nil
      uri = URI.parse(params[:link][:uri])
      
      response = Net::HTTP.new(uri.host).request_head(uri.path)
      
      if response == 404
        flash[:error] = "Looks like that page doesn't exist!"
        # TODO - Angelo Ashmore, 9/20/08: Make this redirect somewhere
        redirect_to "/"
      else
        @domain = Domain.find(:first,
                              :conditions => ['scheme = ? and domain = ?', uri.scheme, uri.host])
        if !@domain
          @domain = Domain.new
          # perhaps there's a way to get the title of the page without having to use mechanize
          # i.e. lots of gems
          @domain.title = WWW::Mechanize.new.get("#{uri.scheme}://#{uri.host}").title
          @domain.scheme = uri.scheme
          @domain.domain = uri.host
          @domain.save
        end

        @link = Link.new
        @link.member_id = @master_member.id
        @link.domain_id = @domain.id
        @link.title = WWW::Mechanize.new.get(uri).title.to_s
        @link.uri = params[:link][:uri]
        @link.path = uri.path.to_s
        @link.save
        @link.update_attribute("code", md5(@link.created_on))
        
        @domain.update_attribute('number_of_links', @domain.number_of_links + 1)
      end
      
      redirect_to :controller => '/'
    end
  end
  
end
