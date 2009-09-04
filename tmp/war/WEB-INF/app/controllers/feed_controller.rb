require 'rubygems'
require 'httpclient'
# routes.rb determines url parameters and url segment configuration
class FeedController < ApplicationController 
  # Rails caching for each action
  caches_page :calendar
  caches_page :eventList
  caches_page :secondary_calendar
  caches_page :secondary_eventList
  caches_page :ics
  caches_page :event
  caches_page :external
  
  #before_filter :inspect
  def inspect
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

  def index # Returns feed URL from this sytem
	 currUrl = FeedModel.new('calendar', params)
	 target = currUrl.buildUrl('primary')
	 @debugInfo, @dukeUrl = target, target
	 @feederUrl =  currUrl.buildUrl('feeder')
	 @xmlOutput = getFeed(target)
  end

  def calendar # Defailt suite Bedework calendar web client (uses setViewPeriod.do)
	 currUrl = FeedModel.new('calendar', params)
	 target = currUrl.buildUrl('primary') # should be either duke or student
  
     
	 @xmlOutput = getFeed(target)
   inspect()
  end
  
  def eventList # Defailt suite Bedework Events List web client (uses setViewPeriod.do)
	  currUrl = FeedModel.new('list', params)
	  target = currUrl.buildUrl('primary') # default suite name
    # brutal but effective ActionController::Base.page_cache_extension        = '.rss'
	  @xmlOutput = getFeed(target)
    inspect()
	end
  
  def secondary_calendar # Student suite Bedework calendar client
   currUrl = FeedModel.new('calendar', params)
   target = currUrl.buildUrl('secondary') # secondary suite name
   @xmlOutput = getFeed(target)
   inspect()
  end
  
  def secondary_eventList # Student suite Bedework calendar client
    currUrl = FeedModel.new('list', params)
    target = currUrl.buildUrl('secondary') #
    @xmlOutput = getFeed(target)
    inspect()
  end
  
  def ics # Bedework ICS interface, accepts ~ seperated list of categories
    currUrl = FeedModel.new('ics', params)
    target = currUrl.buildUrl('primary')
    @xmlOutput = getFeed(target)
    inspect()
  end
  
  def event # request specific event from any suite
    currUrl = FeedModel.new('event', params)
    target = currUrl.buildUrl('primary')
    @xmlOutput = getFeed(target)
    inspect()
  end
  
  def external
    currUrl = FeedModel.new('external', params)
    target = currUrl.buildUrl('primary')
    @xmlOutput = getFeed(target)
    inspect()
  end
  
end
