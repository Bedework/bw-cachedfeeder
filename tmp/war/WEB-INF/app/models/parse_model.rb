require 'rubygems'
#require 'hpricot'
require 'open-uri'

class ParseModel
    attr_accessor :reqParams
    def initialize(reqParams)
      @reqParams = reqParams #urlType: list or calendar indicates the type of feed needed for this instance of the object
    end

    def read_rss()
      doc = Hpricot.XML(open(APP_CONFIG['externals'][reqParams[:feed]]))
      
      feed_data = { 'title' => (doc/:channel/:title).first.inner_html, 'description' => (doc/:channel/:description).first.inner_html,
                     'link'  => (doc/:channel/:link).first.inner_text }
      recent_items = []
      (doc/:channel/:item).each_with_index do |item, index|
        recent_items << { 'item_title'   => (item/:title).inner_html,  'item_description' => (item/:description).inner_html,
                           'item_pubDate' => (item/:pubDate).inner_html,'item_guid'        => (item/:guid).inner_html,
                           'item_link' => (item/:link).inner_text }
        break if reqParams[:count].to_i <= (index + 1) unless reqParams[:count].to_i == 0
      end
      
      return { 'data' => feed_data, 'items' => recent_items }
  end
  def read_bedework_xml(url)
      doc = Hpricot.XML(open(url))
      recent_items = []
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
         event_link = TARGETSERVER + '/' + APP_CONFIG['suites'][reqParams[:suite]]['url'] + '/event/eventView.do?b=de&subid=' + (item/:subscription/:id).inner_html + '&calPath=' +  (item/:calendar/:encodedPath).inner_html \
                   + '&guid=' + (item/:guid).inner_html + '&recurrenceId=' + (item/:recurrenceId).inner_html
         recent_items << {  'item_title'   => (item/:summary).inner_html,  'item_description' => (item/"/description").inner_html,
                           'item_date' => eventDate,'item_time'        => eventTime,
                           'item_link' => event_link, 'item_location' => (item/:location/:address).inner_html }      
       end
       
       return recent_items
  end

end