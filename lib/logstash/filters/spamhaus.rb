# encoding: utf-8
require "logstash/filters/base"
require "logstash/namespace"
require 'charon'

# This filter will populate the 'spamhaus' field in the event
# with information about the IP extracted from the event. The
# IP field can be specified in the configuration of the filter
# by setting 'ip' to the field name. 
class LogStash::Filters::SpamHaus < LogStash::Filters::Base

  config_name "spamhaus"
  
  config :ip, :validate => :string, :default => "clientip"
  config :tag_blacklisted, :validate => :string, :default => "spamhaus_blacklisted"
  config :tag_notfound, :validate => :string, :default => "spamhaus_whitelisted"
  

  public
  def register
    # Add instance variables 
  end # def register

  public
  def filter(event)

    if @ip
      lookupip = event[@ip]
      if lookupip && lookupip =~ /^(\d{1,3}[\.]{0,1}){4}$/
	event['tags'] ||= [] 
	result = Charon.query lookupip
	if result
		event['spamhaus'] = {
			"code" => result[0],
			"blocklist" => result[1]
		}
		event['tags'] << @tag_blacklisted
	else
		event['tags'] << @tag_notfound
	end
      end
    end

    filter_matched(event)
  end # def filter
end # class LogStash::Filters::SpamHaus
