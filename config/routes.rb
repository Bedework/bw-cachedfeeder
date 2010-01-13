ActionController::Routing::Routes.draw do |map|
  # Routes define all Bedework parameters and feed caching URL segments
  # The priority is based upon order of creation: first created -> highest priority.

  # Number of routes needed = 2 * number of outputs.  3 * number of outputs, if setPeriodView style requests are added back
  # One set is for when the number of days is specified; the other is for when a date range is specified.
  map.connect 'v1.0/jsonDays/:days/:skin/:filter/:objName' + '.json', :controller => 'feed', :action => 'jsonDays'
  map.connect 'v1.0/htmlDays/:days/:skin/:filter' + '.html', :controller => 'feed', :action => 'htmlDays'
  map.connect 'v1.0/rssDays/:days/:skin/:filter' + '.rss', :controller => 'feed', :action => 'rssDays'
  map.connect 'v1.0/xmlDays/:days/:skin/:filter' + '.xml', :controller => 'feed', :action => 'xmlDays'
  map.connect 'v1.0/icsDays/:days/:filter' + '.ics', :controller=> 'feed', :action => 'icsDays'

  map.connect 'v1.0/jsonRange/:startDate/:endDate/:skin/:filter/:objName' + '.json', :controller => 'feed', :action => 'jsonRange'
  map.connect 'v1.0/htmlRange/:startDate/:endDate/:skin/:filter' + '.html', :controller => 'feed', :action => 'htmlRange'
  map.connect 'v1.0/rssRange/:startDate/:endDate/:skin/:filter' + '.rss', :controller => 'feed', :action => 'rssRange'
  map.connect 'v1.0/xmlRange/:startDate/:endDate/:skin/:filter' + '.xml', :controller => 'feed', :action => 'xmlRange'
  map.connect 'v1.0/icsRange/:startDate/:endDate/:filter' + '.ics', :controller=> 'feed', :action => 'icsDays'
  
  # Used by Feed/Widget Builder to populate category and group lists.
  map.connect 'v1.0/categories/:skin/:objName' + '.json', :controller=> 'feed', :action => 'categories'
  map.connect 'v1.0/groups/:skin/:objName' + '.json', :controller=> 'feed', :action => 'groups'


  # Used for feeds (other than ICS) where the period (day, week, month, year) are specified
  #map.connect 'v1.0/genFeedPeriod/:period/:date/:skin/:filter/:objName', :controller => 'feed', :action => 'genFeedPeriod',
  # :requirements => {:date => /\d{8}/},
  # :defaults => { :objName => 'no--object'}
  
 
  # Used for feeds (other than ICS) where the period (week, month, year) are specified
  #map.connect 'v1.0/icsFeedPeriod/:period/:date/:skin/:filter', :controller => 'feed', :action => 'icsPeriod',
  #  :requirements => {:date => /\d{8}/},
  # :defaults => { :filter => 'no--filter'}
     
  
  # Used for specific event in html output
  map.connect 'v1.0/htmlEvent/:skin/:recurrenceId/:guid' + '.html', :controller => 'feed', :action => 'event',
  :requirements => {:guid => /.*/}  #needed when you have '.' in one of your path elements
  
  # Used for download
  map.connect 'v1.0/download/:recurrenceId/:guid/:fileName', :controller => 'feed', :action => 'download',
  :requirements => {:guid => /.*/, :fileName => /.*/}  #needed when you have '.' in one of your path elements

  
# Feed Parsing
  
#  map.connect 'parse/ext_xml/:xmlRss/:feed/:count', :controller=> 'parse', :action=>'ext_xml',
#  map.connect 'parse/ext_other/:xmlRss/:feed/:count', :controller=> 'parse', :action=>'ext_other',
#  map.connect 'parse/list/:suite/:output/:days/:xmlRss/:filter', :controller => 'parse', :action => 'bedework_xml'

end
