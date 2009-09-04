require 'rubygems'
require 'sinatra'
require 'hpricot'
require 'open-uri'
require 'builder'
require 'json'

def read_rss(url, params)
    doc = Hpricot.XML(open(url))
    totalCount = params[:count]  
    feed_data = { 'title' => (doc/:channel/:title).first.inner_html, 'description' => (doc/:channel/:description).first.inner_html,
                   'link'  => (doc/:channel/:link).first.inner_text }
    recent_items = []
    (doc/:channel/:item).each_with_index do |item, index|
      recent_items << { 'item_title'   => (item/:title).inner_html,  'item_description' => (item/:description).inner_html,
                         'item_pubDate' => (item/:pubDate).inner_html,'item_guid'        => (item/:guid).inner_html,
                         'item_link' => (item/:link).inner_text }
      break if totalCount.to_i <= (index + 1)
    end
  return { 'data' => feed_data, 'items' => recent_items }
end

def rss_output(params, results)
    if params[:output] != 'jsonp'
      content_type 'application/xml', :charset => 'utf-8'
      @recent_items = results.fetch('items')
      @feed_data = results.fetch('data')
      builder :rss
    else
      content_type 'text/html', :charset => 'utf-8'
      jsonpStr = 'rssItems({'
    
      jsonpStr += 'feed_data: ' + results.fetch('data').to_json + ', recent_items: ' + results.fetch('items').to_json + '});'
     
    end
end

get '/ui' do
  content_type 'text/html', :charset => 'utf-8'
  htmlStr = "Hello World"
  htmlStr
end

get '/jsonp' do
    url = 'http://calendar.duke.edu/feed/buzz_list/' +  params[:days] + '/jsonp'
    doc = Hpricot.XML(open(url))
    jsonStr =  doc.inner_html # already has 
    content_type 'text/html', :charset => 'utf-8'
    
    jsonStr
end

get '/gen_rss/:output/:count/*' do
  urlSplat = params[:splat]
  url = urlSplat[0]
  results = read_rss(url, params)
  
  rss_output(params, results)
end

get '/cal_rss/:output/:days/:count/(*)/*' do
    urlSplat = params[:splat]
    url = 'http://calendar.duke.edu/feed/list/' +  params[:days] + '/rss/(' + urlSplat[0] + ')/details/' + urlSplat[1] 
    results = read_rss(url, params)

    rss_output(params, results)
end


### NEEDS REFACTORING

get '/cal_xml/:days/:output/(*)/*' do

    urlSplat = params[:splat]
    url = 'http://calendar.duke.edu/feed/list/' +  params[:days] + '/xml/(' + urlSplat[0] + ')/details/' + urlSplat[1]
    doc = Hpricot.XML(open(url))
    @format = params[:output]
    
    @feed_data = { 'title' => 'Duke HTML Events List', 'description' => 'List of events in an unordered list or table format.',
                   'link'  => 'http://calendar.duke.edu' }
    @recent_items = []
    (doc/:event).each do |item|
       if (item/:start/:time).inner_html == (item/:end/:time).inner_html
          eventTime = (item/:start/:time).inner_html
       else
          eventTime = "#{(item/:start/:time).inner_html} to #{(item/:end/:time).inner_html}"
       end
       if (item/:start/:longdate).inner_html == (item/:end/:longdate).inner_html
          eventDate = (item/:start/:longdate).inner_html
       else
          eventDate =  "#{(item/:start/:longdate).inner_html} to #{(item/:end/:longdate).inner_html}"
       end
       event_link = 'http://calendar.duke.edu/cal/event/eventView.do?b=de&amp;subid=' + (item/:subscription/:id).inner_html + '&amp;calPath=' +  (item/:calendar/:encodedPath).inner_html \
                 + '&amp;guid=' + (item/:guid).inner_html + '&amp;recurrenceId=' + (item/:recurrenceId).inner_html
       @recent_items << {  'item_title'   => (item/:summary).inner_html,  'item_description' => (item/"/description").inner_html,
                         'item_date' => eventDate,'item_time'        => eventTime,
                         'item_link' => event_link, 'item_location' => (item/:location/:address).inner_html }      
     end
    
     content_type 'text/html', :charset => 'utf-8'
     
     
     builder :html
    
    
    
    
#    events = "<ul>"
#    if params[:format]
#      events =  "<table><tr><td>Title</td><td>Calendar URL</td><td>Event Date</td><td>Event Time</td><td>Description</td><td>Location</td></tr>"
#    end
#    eventTime = ""
#    eventDate = ""
#  (doc/:event).each do |item|
#    if (item/:start/:time).inner_html == (item/:end/:time).inner_html
#      eventTime = (item/:start/:time).inner_html
#    else
#      eventTime = "#{(item/:start/:time).inner_html} to #{(item/:end/:time).inner_html}"
#    end
#    if (item/:start/:longdate).inner_html == (item/:end/:longdate).inner_html
#      eventDate = (item/:start/:longdate).inner_html
#    else
#      eventDate =  "#{(item/:start/:longdate).inner_html} to #{(item/:end/:longdate).inner_html}"
#    end
#    event_link = 'http://calendar.duke.edu/cal/event/eventView.do?b=de&amp;subid=' + (item/:subscription/:id).inner_html + '&amp;calPath=' +  (item/:calendar/:encodedPath).inner_html \
#               + '&amp;guid=' + (item/:guid).inner_html + '&amp;recurrenceId=' + (item/:recurrenceId).inner_html
#    if params[:format]
#      events += <<-END
#                <tr><td><a href=\"#{event_link}\">#{(item/:summary).inner_html}</a></td><td>#{event_link}</td><td>#{eventTime}<td>#{eventDate}</td>
#                <td>#{(item/:description).inner_html}</td><td>#{(item/:location/:address).inner_html}</td></tr>
#                END
#    else
#      events += <<-END
#                <li><ul><li><a href=\"#{event_link}\">#{(item/:summary).inner_html}</a></li><li>#{event_link}</li><li>#{eventTime}<li>#{eventDate}</li>
#                <li>#{(item/:description).inner_html}</li><li>#{(item/:location/:address).inner_html}</li></ul></li>
#                END
#    end
#    
#  end
#  if params[:format]
#     events += "</table>"
#  else
#     events += "</ul>"
#  end
#     
#  string =  '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">' \
#          + '<html xmlns="http://www.w3.org/1999/xhtml"><head><meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />' \
#          + '<title>Events List HTML Document</title></head><body>'
#  footer =  "</body></html>"
#  string += events
#  string += footer
#  string

end

get '/rss/:days/:count/(*)/*' do ### DEPRICATED
    urlSplat = params[:splat]
    url = 'http://calendar.duke.edu/feed/list/' +  params[:days] + '/rss/(' + urlSplat[0] + ')/details/' + urlSplat[1] 
    doc = Hpricot.XML(open(url))
    totalCount = params[:count]  
    @feed_data = { 'title' => (doc/:channel/:title).first.inner_html, 'description' => (doc/:channel/:description).first.inner_html,
                   'link'  => (doc/:channel/:link).first.inner_text }
    @recent_items = []
    (doc/:channel/:item).each_with_index do |item, index|
     @recent_items << { 'item_title'   => (item/:title).inner_html,  'item_description' => (item/:description).inner_html,
                         'item_pubDate' => (item/:pubDate).inner_html,'item_guid'        => (item/:guid).inner_html,
                         'item_link' => (item/:link).inner_text }
      break if totalCount.to_i <= (index + 1)
    end
    content_type 'application/xml', :charset => 'utf-8'
    builder :rss
#    
#    url = 'http://calendar.duke.edu/feed/list/' +  params[:days] + '/rss/(' + params[:group] + ')' 
#    doc = Hpricot.XML(open(url))
#    totalCount = params[:count]
#    items = "";
#    rssString = '<?xml version="1.0" encoding="UTF-8"?><rss version="2.0"><channel>' + (doc/:channel/:title).first.to_html \
#              + (doc/:channel/:link).first.to_html + (doc/:channel/:description).first.to_html + (doc/:channel/:pubDate).first.to_html + (doc/:channel/:language).first.to_html \
#              + (doc/:channel/:copyright).first.to_html + (doc/:channel/:managingEditor).first.to_html
#    rssFooter = ""
#     (doc/:channel/:item).each_with_index do |item, index|
#        items += (item).to_html
#        break if totalCount.to_i <= (index + 1)
#    end
#    rssFooter += "</channel></rss>"
#    rssString += items
#    rssString += rssFooter
#  
#    rssString
    
end