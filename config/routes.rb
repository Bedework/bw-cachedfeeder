ActionController::Routing::Routes.draw do |map|
  # Routes define all Bedework parameters and feed caching URL segments
  # Date support can be toggled for shorter URL's
  # ICS and Specific Event URL support

  # The priority is based upon order of creation: first created -> highest priority.
  
  # Sample of regular route:
  # map.connect 'products/:id', :controller => 'catalog', :action => 'view'
 
  # Allow downloading Web Service WSDL as a file with an extension
  # instead of a file named 'wsdl'
  map.connect ':controller/service.wsdl', :action => 'wsdl'
  
# No date support
  map.connect 'calendar/:viewType/:xmlRss/:groups/:details/:categories', :controller => 'feed', :action => 'calendar',
  :requirements => {:categories => /.*/, :groups => /\({1}.*\){1}/},
  :defaults => { :viewType => 'dayView', :xmlRss => 'rss', :groups => '(all)', :details => 'details', :categories=> 'all' }
  map.connect 'list/:days/:xmlRss/:groups/:details/:categories', :controller => 'feed', :action => 'eventList',
  :requirements => {:categories => /.*/, :groups => /\({1}.*\){1}/}, 
  :defaults => { :days => '7', :xmlRss => 'rss', :groups => '(all)', :details => 'details', :categories=> 'all' }

# full date support
  map.connect 'date/calendar/:date/:viewType/:xmlRss/:groups/:details/:categories', :controller => 'feed', :action => 'calendar',
  :requirements => {:categories => /.*/, :groups => /\({1}.*\){1}/, :date => /\d{8}/},
  :defaults => { :viewType => 'dayView', :xmlRss => 'rss', :groups => '(all)', :details => 'details', :date => Time.now.localtime.strftime("%Y%m%d"), :categories=> 'all' }
  map.connect 'date/list/:startDate/:endDate/:days/:xmlRss/:groups/:details/:categories', :controller => 'feed', :action => 'eventList',
  :requirements => {:categories => /.*/, :groups => /\({1}.*\){1}/, :startDate => /\d{4}-\d{2}-\d{2}/, :endDate => /\d{4}-\d{2}-\d{2}/},
  :defaults => { :days => '0', :xmlRss => 'rss', :groups => '(all)', :details => 'details', :startDate => Time.now.localtime.strftime("%Y-%m-%d"), :endDate => '0000-00-00', :categories=> 'all' }

# Request specific event
  map.connect 'event/:suite/:xmlRss/:subId/:calPath/:recurrenceId/:guid', :controller => 'feed', :action => 'event',
  :requirements => {:guid => /.*/} # assumes root 'public' calPath folder
  # requires guid extension "@mysite.edu" to have .edu (or other) mime type mapped to html in Apache. otherwise cache is served as plain text
  # :defaults => { :recurrenceId => '0' } Route segment ":recurrenceId" cannot be optional because it precedes a required segment. This segment will be required.

# ICS request
  map.connect 'ics/:categories', :controller=> 'feed', :action => 'ics',
  :requirements => {:categories => /.*/}, 
  :defaults => { :categories=> 'all'}
  map.connect 'ext/:feedName', :controller=> 'feed', :action => 'external',
  :requirements => {:feedName => /.*/}
  
# Feed Parsing
  
  map.connect 'parse/ext_xml/:xmlRss/:feed/:count', :controller=> 'parse', :action=>'ext_xml',
   :defaults => {:feed => 'eflyer', :count => 0, :xmlRss => 'rss' }
  map.connect 'parse/ext_other/:xmlRss/:feed/:count', :controller=> 'parse', :action=>'ext_other',
   :defaults => {:feed => 'eflyer', :count => 0, :xmlRss => 'jsonp' }
  map.connect 'parse/list/:suite/:output/:days/:xmlRss/:groups/:details/:categories', :controller => 'parse', :action => 'bedework_xml',
   :requirements => {:categories => /.*/, :groups => /\({1}.*\){1}/}, 
   :defaults => { :days => '7', :xmlRss => 'xml', :groups => '(all)', :details => 'details', :categories=> 'all', :output => 'list', :suite => 'duke' }
   
end
