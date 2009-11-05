#
#  FeedModel.rb
#
#  Created by Jeremy Bandini on 9/30/08.
#  Copyright (c) 2008 Duke University. All rights reserved.


class FeedModel
  attr_accessor :urlType, :reqParams
  attr_reader :daysAction, :rangeAction  #, :eventAction
  def initialize(urlType, reqParams)
    @urlType, @reqParams = urlType, reqParams 
    @daysAction = 'main/setViewPeriod.do'
    @rangeAction = 'main/listEvents.do'
    #@eventAction = 'event/eventView.do'
  end
  
  def convertCats(catStr) # Convert ~ seperated string to bedework &cat=category format
    workStringArr = catStr.split(/~/)
    longCats = ''
    workStringArr.each do |workStr|
      longCats += '&catuid=' + workStr
    end   
    return longCats
  end
  
  def cleanCats(catStr) #strip .html from from request and urlencode spaces
    workString = catStr.gsub('.html', '')
    workString = workString.gsub(' ', '%20')
    return workString
  end
  
  def restoreSlashes(st) # Replace all tildes with slashes.  I.e., put them back where they belong.
    workString = st.gsub('~', '/')
    return workString
  end
  
  def getSkin(feedType) # determine by feedType
    return APP_CONFIG['skin'][feedType]
  end
  
  def buildUrl() # Main URL building action
    target = 'default'
    myGroup = 'none'
    if reqParams[:group]
      myGroup = restoreSlashes(reqParams[:group])
    end
    if reqParams[:categories]
      myCats = cleanCats(reqParams[:categories])
    end
    
    target = case urlType
      when 'genFeedDays' then getGenFeedTarget(myGroup, myCats, "Days")
      when 'icsDays' then getIcsTarget(myGroup, myCats, "Days")
      when 'genFeedRange' then getGenFeedTarget(myGroup, myCats, "Range")
      when 'icsRange' then getIcsTarget(myGroup, myCats, "Range")
      when 'event' then getEventTarget()
      when 'external' then getExt()
    end
    
    return target
  end
  
  def getIcsTarget(currGroup, currCats, daysOrRange) # return Bedework ICS URL
    ifCats = currCats
    if ifCats == 'all'
      ifCats = ''
    else
      ifCats = convertCats(ifCats)
    end
    if (daysOrRange == "Range")
      action = daysAction
    else
      action = rangeAction
    end
    bedeUrl = TARGETSERVER + "/" + action + "?format=text/calendar&creator=" + currGroup + "&" \
             + "setappvar=summaryMode(details)" + ifCats
    if (daysOrRange == "Range")
      if reqParams[:startDate] and reqParams[:endDate] # following params are optional
        if reqParams[:startDate] != "0000-00-00"
          bedeUrl += "&start=" + reqParams[:startDate]
        end
        if reqParams[:endDate] != "0000-00-00"
         bedeUrl += "&end=" + reqParams[:endDate]
        end
      end
    else 
      if reqParams[:days] != "0"
        bedeUrl +="&days=" + reqParams[:days]
      end
    end
    return bedeUrl 
  end
  
  def getGenFeedTarget(currGroup, currCats, daysOrRange)
    currentSkin = getSkin(reqParams[:skin])  
    ifCats = currCats
    if ifCats == 'all'
      ifCats = ''
    else
      ifCats = convertCats(ifCats)
    end
    if (daysOrRange == "Range")
      action = daysAction
    else
      action = rangeAction
    end
    
    bedeUrl = TARGETSERVER + "/" + action + "?skinName=" + currentSkin + "&creator=" + currGroup + "&" \
           + "setappvar=summaryMode(details)" + ifCats
    if (daysOrRange == "Range")
      if reqParams[:startDate] and reqParams[:endDate] # following params are optional
        if reqParams[:startDate] != "0000-00-00"
          bedeUrl += "&start=" + reqParams[:startDate]
        end
        if reqParams[:endDate] != "0000-00-00"
          bedeUrl += "&end=" + reqParams[:endDate]
        end
      end
    else 
      if reqParams[:days] != "0"
        bedeUrl +="&days=" + reqParams[:days]
      end
    end
    return bedeUrl 
  end
  
  
  # def getEventTarget() # Return a specific event in desired skin
  #  currentSkin = 'default' #getSkin(reqParams[:xmlRss])
  #  finalGuid = reqParams[:guid]
  #  bedeUrl = TARGETSERVER + "/" + eventAction + "?skinName=" + currentSkin + "&subid=" + reqParams[:subId] + "&calPath=/public/" + reqParams[:calPath]  \
  #  + "&guid=" + finalGuid.gsub('_', '.')
    
  #  if reqParams[:recurrenceId] != '0'
  #    bedeUrl += "&recurrenceId=" + reqParams[:recurrenceId]
  #  else
  #    bedeUrl += "&recurrenceId=" # is this necessary?
  #  end
    
  #  if reqParams[:date]
  #    bedeUrl += "&date=" + reqParams[:date]
  #  end
    
  #  return bedeUrl
  #end
  
  #def getExt()

  #  return APP_CONFIG['externals'][reqParams[:feedName]]
  #end
  
end