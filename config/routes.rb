ActionController::Routing::Routes.draw do |map|
  # Routes define all Bedework parameters and feed caching URL segments
  # The priority is based upon order of creation: first created -> highest priority.
  
  # objName in the next three routes are there for the json feeds when 

  # Used for feeds (other than ICS) where the number of days is specified 
  map.connect 'v1.0/genFeedDays/:days/:skin/:group/:categories/:objName:', :controller => 'feed', :action => 'genFeedDays',
  :defaults => { :objName => '_none_'}
  
  # Used for feeds (other than ICS) where the start and end dates are specified.
  map.connect 'v1.0/genFeedRange/:startDate/:endDate/:skin/:group/:categories/:objName', :controller => 'feed', :action => 'genFeedRange',
  :requirements => {:startDate => /\d{8}/, :endDate => /\d{8}/},
  :defaults => { :objName => '_none_'}

  # Used for feeds (other than ICS) where the period (day, week, month, year) are specified
  map.connect 'v1.0/genFeedPeriod/:period/:date/:skin/:group/:categories/:objName', :controller => 'feed', :action => 'genFeedPeriod',
  :requirements => {:date => /\d{8}/},
  :defaults => { :objName => '_none_'}
   
  # Used for ICS feeds where the number of days is specified.
  map.connect 'v1.0/icsDays/:days/:group/:categories', :controller=> 'feed', :action => 'icsDays'
  
  # Used for ICS feeds where the start and end dates are specfied
  map.connect 'v1.0/icsRange/:startDate/:endDate/:group/:categories', :controller=> 'feed', :action => 'icsRange',
 :requirements => {:startDate => /\d{8}/, :endDate => /\d{8}/}
  
  # Used for feeds (other than ICS) where the period (week, month, year) are specified
  map.connect 'v1.0/icsFeedPeriod/:period/:date/:skin/:group/:categories', :controller => 'feed', :action => 'icsPeriod',
  :requirements => {:date => /\d{8}/}
  
  # Used by Feed/Widget Builder to populate category and group lists.
  map.connect 'v1.0/categories/:skin/:objName', :controller=> 'feed', :action => 'categories'
  map.connect 'v1.0/groups/:skin/:objName', :controller=> 'feed', :action => 'groups'
  
  # Used for specific event
  map.connect 'v1.0/event/:skin/:recurrenceId/:guid', :controller => 'feed', :action => 'event',
  :requirements => {:guid => /.*/}  #needed when you have '.' in one of your path elements

    # requires guid extension "@mysite.edu" to have .edu (or other) mime type mapped to html in Apache. otherwise cache is served as plain text
  

  # Allow downloading Web Service WSDL as a file with an extension
  # instead of a file named 'wsdl'
  #map.connect ':controller/service.wsdl', :action => 'wsdl'
  
    # Used for feeds where the start and ends dates are specified.
  # Calendar -- limited to date parameters, skin
  # map.connect 'calendar/:date/:viewType/:skin', :controller => 'feed', :action => 'calendar'
  
  # map.connect 'timeblock/:viewType/:xmlRss/:group/:categories', :controller => 'feed', :action => 'timeBlock',
  # :requirements => {:categories => /.*/, :group => /\({1}.*\){1}/}



# external
#  map.connect 'ext/:feedName', :controller=> 'feed', :action => 'external',
#  :requirements => {:feedName => /.*/}
  
# Feed Parsing
  
#  map.connect 'parse/ext_xml/:xmlRss/:feed/:count', :controller=> 'parse', :action=>'ext_xml',
#  :defaults => {:feed => 'eflyer', :count => 0, :xmlRss => 'rss' }
#  map.connect 'parse/ext_other/:xmlRss/:feed/:count', :controller=> 'parse', :action=>'ext_other',
#   :defaults => {:feed => 'eflyer', :count => 0, :xmlRss => 'jsonp' }
#  map.connect 'parse/list/:suite/:output/:days/:xmlRss/:group/:categories', :controller => 'parse', :action => 'bedework_xml',
#   :requirements => {:categories => /.*/, :group => /\({1}.*\){1}/}, 
#   :defaults => { :days => '7', :xmlRss => 'xml', :group => '(all)', :categories=> 'all', :output => 'list', :suite => 'duke' }
   
end
