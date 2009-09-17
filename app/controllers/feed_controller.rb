require 'rubygems'
require 'httpclient'
# routes.rb determines url parameters and url segment configuration
class FeedController < ApplicationController 
  # Rails caching for each action
  caches_page :calendar
  caches_page :eventList
  caches_page :ics
  caches_page :event
  caches_page :external
  
  #before_filter :inspect
  def addExtension
    if params[:xmlRss]
      ActionController::Base.page_cache_extension = '.' + params[:xmlRss]
      headers["Content-Type"] = APP_CONFIG['content_type'][params[:xmlRss]]
      
      return
    end
    
    if params[:action] == 'external'
      ActionController::Base.page_cache_extension = '.rss'
      headers["Content-Type"] = APP_CONFIG['content_type']['rss']
      
      return
    end
    
    if params[:action] == 'ics'
      ActionController::Base.page_cache_extension = '.ics'
      headers["Content-Type"] = APP_CONFIG['content_type']['ics']
      
      return
    end
  end
  
  def getFeed(feedUrl) # uses httpclient gem
    target = ARGV.shift || feedUrl
    proxy = ENV['HTTP_PROXY']
    clnt = HTTPClient.new(proxy)
    clnt.reset(target)
   
    return clnt.get_content(target)
  end

  def calendar # Bedework calendar web client (uses setViewPeriod.do)
	 currUrl = FeedModel.new('calendar', params)
	 target = currUrl.buildUrl
   logger.info("\nFEED: calendar URL is #{target}\n")
	 @xmlOutput = getFeed(target)
   addExtension()
  end
  
  def eventList # Bedework Events List web client (uses setViewPeriod.do)
	  currUrl = FeedModel.new('list', params)
	  target = currUrl.buildUrl
    # brutal but effective ActionController::Base.page_cache_extension        = '.rss'
	  logger.info("\nFEED: list URL is #{target}\n")
	  @xmlOutput = getFeed(target)
    addExtension()
	end
	
  def ics # Bedework ICS interface, accepts ~ seperated list of categories
    currUrl = FeedModel.new('ics', params)
    target = currUrl.buildUrl
    @xmlOutput = getFeed(target)
    addExtension()
  end
  
  def event # request specific event 
    currUrl = FeedModel.new('event', params)
    target = currUrl.buildUrl
    @xmlOutput = getFeed(target)
    addExtension()
  end
  
  def external
    currUrl = FeedModel.new('external', params)
    target = currUrl.buildUrl
    @xmlOutput = getFeed(target)
    addExtension()
  end
  
end
