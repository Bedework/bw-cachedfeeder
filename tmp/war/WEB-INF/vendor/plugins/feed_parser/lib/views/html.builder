  xml.instruct! 
  xml.html {
    xml.head {
      xml.title(@feed_data.fetch('title'))
    }
    xml.body {
      if @format == 'list'
        xml.ul {
          for item in @recent_items
            xml.li do
              xml.ul {
                xml.li { xml.p{ xml.a(item.fetch('item_title'), "href" => item.fetch('item_link')) } }
                xml.li { xml.p(item.fetch('item_date'))}
                xml.li { xml.p(item.fetch('item_time'))}
                xml.li { xml.p(item.fetch('item_description'))}
                xml.li { xml.p(item.fetch('item_location'))}
              }     
            end
          end
        }
      else
        xml.table {
          for item in @recent_items
            xml.tr do
              xml.td { xml.p{ xml.a(item.fetch('item_title'), "href" => item.fetch('item_link')) }}
              xml.td { xml.p(item.fetch('item_date'))}
              xml.td { xml.p(item.fetch('item_time'))}
              xml.td { xml.p(item.fetch('item_description'))}
              xml.td { xml.p(item.fetch('item_location'))}
            end
          end 
        }
      end 
    }
  }
  

