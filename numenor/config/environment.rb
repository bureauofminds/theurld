# Be sure to restart your web server when you modify this file.

# Uncomment below to force Rails into production mode when 
# you don't control web/app server and can't set it the proper way
# ENV['RAILS_ENV'] ||= 'production'

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '1.2.3' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  # we're using the database and rails-fast-sessions for sessions
  config.action_controller.session_store = :active_record_store
  
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

# Used to authorize during the developmental builds
# Remove when in production
DEVELOPMENT_AUTHORIZATION_CODE = "f5ba7c8fc348b9e17dbd2a5686ea05f7"

# Directory where avatars are saved
AVATAR_ROOT = File.join(RAILS_ROOT, "public", "images", "avatars")

# Directory where avatars are saved
FAVICONS_ROOT = File.join(RAILS_ROOT, "public", "images", "favicons")

# These usernames will conflict with system actions, so they are not allowed
FORBIDDEN_NAMES = ['index', 'new', 'edit', 'delete']