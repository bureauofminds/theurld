class LinksController < ApplicationController
  
  def add
    case request.method
    when :get
      ###
    
    when :post
      require 'uri'
      require 'net/http'
      require 'mechanize'
      
      scheme = URI.parse(params[:link][:uri]).scheme
      if scheme != nil or scheme.downcase != "http"
        flash[:error] = "Sorry, only HTTP URIs are currently supported."
        # TODO - Angelo Ashmore, 9/20/08: Make this redirect somewhere
        return redirect_to "/"
      end
      params[:link][:uri] = "http://" + params[:link][:uri] if scheme == nil
      uri = URI.parse(params[:link][:uri])
      
      response = Net::HTTP.new(uri.host).request_head(uri.path)
      
      if response != 200
        flash[:error] = "Looks like that page doesn't exist!"
        # TODO - Angelo Ashmore, 9/20/08: Make this redirect somewhere
        redirect_to "/"
      else
        @domain = Domain.find(:first,
                              :conditions => ['scheme = ? and domain = ?', uri.scheme, uri.host])
        if !@domain
          @domain = Domain.new
          # perhaps there's a way to get the title
          # of the page without having to use mechanize
          # i.e. lots of gems
          @domain.title = WWW::Mechanize.new.get(uri).title
          @domain.scheme = uri.scheme
          @domain.domain = uri.host
          @domain.save
        end


        # TODO - Angelo Ashmore, 9/20/08 8:42 PM: below is old, needs to be rewritten
        @link = Link.new
        @link.domain_id = @domain.id
        @link.uri = params[:link][:uri]
        @link.path = @link.uri.gsub("http://", '').gsub(@domain.domain, '')
      end
    end
  end
  
end
