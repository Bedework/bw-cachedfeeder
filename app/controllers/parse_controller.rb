require 'builder'
require 'json'

# routes.rb determines url parameters and url segment configuration
class ParseController < ApplicationController
  caches_page :ext_xml
  caches_page :ext_other
  caches_page :bedework_xml
  
 # before_filter :inspect
  def inspect
    if params[:xmlRss]
      ActionController::Base.page_cache_extension = '.' + params[:xmlRss]
      headers["Content-Type"] = APP_CONFIG['content_type'][params[:xmlRss]]
      
      return
    end
  end
  def ext_xml
    general_rss = ParseModel.new(params)
    results = general_rss.read_rss()
    @recent_items = results.fetch('items')
    @feed_data = results.fetch('data') 
    inspect()
  end
  
  def ext_other
    general_rss = ParseModel.new(params)
    results = general_rss.read_rss()
    @jsonpStr = 'rssItems({feed_data: ' + results.fetch('data').to_json + ', recent_items: ' + results.fetch('items').to_json + '});'
    inspect()
  end
  
  def bedework_xml
     currUrl = FeedModel.new('list', params)
     target = currUrl.buildUrl(params[:suite])
     bede_xml = ParseModel.new(params)
     bede_items = bede_xml.read_bedework_xml(target)
     #headers["Content-Type"] = "text/html; charset=UTF-8"

     @format = params[:output]
     @feed_data = { 'title' => 'Duke HTML Events List', 'description' => 'List of events in an unordered list or table format.',
                    'link'  => 'http://calendar.duke.edu' }
     @recent_items = bede_items
    # inspect()
    
     ActionController::Base.page_cache_extension = '.html'
     headers["Content-Type"] = APP_CONFIG['content_type']['html']
     
  end

end
