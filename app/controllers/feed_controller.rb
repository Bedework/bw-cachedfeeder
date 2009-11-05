require 'rubygems'
require 'httpclient'
# routes.rb determines url parameters and url segment configuration
class FeedController < ApplicationController 
  # Rails caching for each action
  #caches_page :calendar
  caches_page :genFeedRange
  caches_page :genFeedDays
  caches_page :icsRange
  caches_page :icsDays
  caches_page :event
  caches_page :external
  
  #before_filter :inspect
  def addExtension
    if params[:skin]
      ActionController::Base.page_cache_extension = '.' + params[:skin]
      headers["Content-Type"] = APP_CONFIG['content_type'][params[:skin]]  
      return
    end
    
    if params[:action] == 'icsDays' || params[:action] == 'icsRange'
      ActionController::Base.page_cache_extension = '.ics'
      headers["Content-Type"] = APP_CONFIG['content_type']['ics']
      return
    end
    
     #if params[:action] == 'external'
      #  ActionController::Base.page_cache_extension = '.rss'
      #  headers["Content-Type"] = APP_CONFIG['content_type']['rss']
      #  return
      #end
  end
  
  def getFeed(feedUrl) # uses httpclient gem
    target = ARGV.shift || feedUrl
    proxy = ENV['HTTP_PROXY']
    clnt = HTTPClient.new(proxy)
    clnt.reset(target)
   
    return clnt.get_content(target)
  end
  
  def genFeedDays
	  currUrl = FeedModel.new('genFeedDays', params)
	  target = currUrl.buildUrl
	  logger.info("\nFEED: list URL is #{target}\n")
	  @xmlOutput = getFeed(target)
    addExtension()
	end
	
  def icsDays
    currUrl = FeedModel.new('icsDays', params)
    target = currUrl.buildUrl
    logger.info("\nFEED: list URL is #{target}\n")
    @xmlOutput = getFeed(target)
    addExtension()
  end
  
  def genFeedRange
	  currUrl = FeedModel.new('genFeedRange', params)
	  target = currUrl.buildUrl
	  logger.info("\nFEED: list URL is #{target}\n")
	  @xmlOutput = getFeed(target)
    addExtension()
	end
	
  def icsRange
    currUrl = FeedModel.new('icsRange', params)
    target = currUrl.buildUrl
    logger.info("\nFEED: list URL is #{target}\n")
    @xmlOutput = getFeed(target)
    addExtension()
  end
  
  # def calendar # Bedework calendar web client (uses setViewPeriod.do)
  #	 currUrl = FeedModel.new('calendar', params)
  #	 target = currUrl.buildUrl
  #  logger.info("\nFEED: calendar URL is #{target}\n")
  #	 @xmlOutput = getFeed(target)
  #  addExtension()
  #  end
  
  #def event # request specific event 
  #  currUrl = FeedModel.new('event', params)
  #  target = currUrl.buildUrl
  #  @xmlOutput = getFeed(target)
  #  addExtension()
  #end
  
  #def external
  #  currUrl = FeedModel.new('external', params)
  #  target = currUrl.buildUrl
  #  @xmlOutput = getFeed(target)
  #  addExtension()
  #end
  
end
