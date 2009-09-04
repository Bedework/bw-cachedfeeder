  xml.rss("version" => "2.0", "xmlns:dc" => "http://purl.org/dc/elements/1.1/") do
    xml.channel do
      xml.title(@feed_data.fetch('title'))
      xml.link(@feed_data.fetch('link'))
      xml.description(@feed_data.fetch('description'))
      xml.language "en-us"
      xml.ttl "40"

      for item in @recent_items
        xml.item do
          xml.title(item.fetch('item_title'))
          xml.description(item.fetch('item_description'))
          xml.pubDate(item.fetch('item_pubDate'))
          xml.guid(item.fetch('item_guid'))
          xml.link(item.fetch('item_link'))

       #   xml.tag!("dc:creator", item.author_name) if item_has_creator?(item)
        end
      end
    end
  end
