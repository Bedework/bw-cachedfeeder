ActionController::Routing::Routes.draw do |map|
  # Routes define all Bedework parameters and feed caching URL segments
  # The priority is based upon order of creation: first created -> highest priority.
  
  # objName in the next three routes are there for the json feeds.  If set, the json is set to a variable.

  # Used for feeds (other than ICS) where the number of days is specified 
  map.connect 'v1.0/genFeedDays/:days/:skin/:filter/:objName', :controller => 'feed', :action => 'genFeedDays',
    :defaults => { :objName => 'no--object'}
  
  # Used for feeds (other than ICS) where the start and end dates are specified.
  map.connect 'v1.0/genFeedRange/:startDate/:endDate/:skin/:filter/:objName', :controller => 'feed', :action => 'genFeedRange',
    :requirements => {:startDate => /\d{8}/, :endDate => /\d{8}/},
    :defaults => { :objName => 'no--object'}

  # Used for feeds (other than ICS) where the period (day, week, month, year) are specified
  map.connect 'v1.0/genFeedPeriod/:period/:date/:skin/:filter/:objName', :controller => 'feed', :action => 'genFeedPeriod',
   :requirements => {:date => /\d{8}/},
   :defaults => { :objName => 'no--object'}
   
  # Used for ICS feeds where the number of days is specified.
  map.connect 'v1.0/icsDays/:days/:filter', :controller=> 'feed', :action => 'icsDays',
    :defaults => { :filter => 'no--filter'}
  
  # Used for ICS feeds where the start and end dates are specfied
  map.connect 'v1.0/icsRange/:startDate/:endDate/:filter', :controller=> 'feed', :action => 'icsRange',
    :requirements => {:startDate => /\d{8}/, :endDate => /\d{8}/},
    :defaults => { :filter => 'no--filter'}
 
  # Used for feeds (other than ICS) where the period (week, month, year) are specified
  map.connect 'v1.0/icsFeedPeriod/:period/:date/:skin/:filter', :controller => 'feed', :action => 'icsPeriod',
    :requirements => {:date => /\d{8}/},
    :defaults => { :filter => 'no--filter'}
     
  # Used by Feed/Widget Builder to populate category and group lists.
  map.connect 'v1.0/categories/:skin/:objName', :controller=> 'feed', :action => 'categories'
  map.connect 'v1.0/groups/:skin/:objName', :controller=> 'feed', :action => 'groups'
  
  # Used for specific event
  map.connect 'v1.0/event/:skin/:recurrenceId/:guid', :controller => 'feed', :action => 'event',
  :requirements => {:guid => /.*/}  #needed when you have '.' in one of your path elements
  
  # Used for download
  map.connect 'v1.0/download/:recurrenceId/:guid/:fileName', :controller => 'feed', :action => 'download',
  :requirements => {:guid => /.*/, :fileName => /.*/}  #needed when you have '.' in one of your path elements

  
# Feed Parsing
  
#  map.connect 'parse/ext_xml/:xmlRss/:feed/:count', :controller=> 'parse', :action=>'ext_xml',
#  map.connect 'parse/ext_other/:xmlRss/:feed/:count', :controller=> 'parse', :action=>'ext_other',
#  map.connect 'parse/list/:suite/:output/:days/:xmlRss/:filter', :controller => 'parse', :action => 'bedework_xml'

end
