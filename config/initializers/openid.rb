# custom requires
gem 'ruby-openid'
require 'openid'
require 'openid/consumer'
require 'openid/extensions/sreg'
require 'openid/extensions/pape'

OpenID::Util.logger = RAILS_DEFAULT_LOGGER 
