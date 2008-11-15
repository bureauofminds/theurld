# Be sure to restart your web server when you modify this file.

# Uncomment below to force Rails into production mode when 
# you don't control web/app server and can't set it the proper way
# ENV['RAILS_ENV'] ||= 'production'

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '1.2.3' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  # Get rid of text_field's default size of 30
  # http://www.thought-scope.com/2008/04/rails-input-text-size-redo.html
  module ActionView
    module Helpers
      class InstanceTag
        DEFAULT_FIELD_OPTIONS = { }
      end
    end
  end
end

FAVICONS_LOCATION = File.join(RAILS_ROOT, "public", "images", "favicons")
FORBIDDEN_NAMES = ['index', 'new', 'edit', 'delete']
