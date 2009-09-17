#
#  FeedModel.rb
#  
#
#  Created by Jeremy Bandini on 9/30/08.
#  Copyright (c) 2008 Duke University. All rights reserved.
#
# reqParams - contains parameters configured in routes.rb
# # urlType - Calendar or list parameter
# # calAction - Bedework calendar Struts action
# # listAction - Bedework list Struts action
# # icsAction - Bedework icsAction
# # eventAction - Bedework specific event request

class FeedModel
  attr_accessor :urlType, :reqParams
  attr_reader :calAction, :listAction, :icsAction, :eventAction
  def initialize(urlType, reqParams)
    @urlType, @reqParams = urlType, reqParams #urlType: list or calendar indicates the type of feed needed for this instance of the object
    @calAction = 'main/setViewPeriod.do'
    @listAction = 'main/listEvents.do'
    @icsAction = 'publish/calendar.do'
    @eventAction = 'event/eventView.do'
  end
  
  def cleanGroups(groupStr) # Replace all slashes with commas to support XSL logic
    workString = groupStr.gsub(/[\(\)]/, '')
    workString = workString.gsub(/\//, ',')
    
    return workString
  end
  
  def convertCats(catStr) # Convert ~ seperated string to bedework &cat=category format
    workStringArr = catStr.split(/~/)
    longCats = ''
    workStringArr.each do |workStr|
      longCats += '&cat=' + workStr
  end
    
    return longCats
  end
  def cleanCats(catStr) #strip .html from from request and urlencode spaces
    workString = catStr.gsub('.html', '')
    workString = workString.gsub(' ', '%20')
    
    return workString
  end
  def getSkin(feedType) # determine XSL skin name restricted by urlType and feedType
    
    return APP_CONFIG['skins'][urlType][feedType]
  end
  
  def getCalTarget(currGroup, currCats)
    currentSkin = getSkin(reqParams[:xmlRss]) # 
 
      bedeUrl = TARGETSERVER + "/" + calAction + "?skinName=" + currentSkin + "&setappvar=group(" + currGroup + ")&viewType=" \
      + reqParams[:viewType] + "&setappvar=category(" + currCats + ")&setappvar=summaryMode(" + reqParams[:details] + ")"
      if reqParams[:date]
        bedeUrl += "&date=" + reqParams[:date]
      end
      return bedeUrl

  end
  
  def getListTarget(currGroup, currCats)
    currentSkin = getSkin(reqParams[:xmlRss])
    ifCats = currCats
    if ifCats == 'all'
      ifCats = ''
    else
      ifCats = convertCats(ifCats)
  end
  
  
    bedeUrl = TARGETSERVER + "/" + listAction + "?skinName=" + currentSkin + "&setappvar=group(" + currGroup + ")&" \
             + "setappvar=summaryMode(" + reqParams[:details] + ")" + ifCats
    if reqParams[:startDate] and reqParams[:endDate] # following params are optional
      if reqParams[:startDate] != "0000-00-00"
        bedeUrl += "&start=" + reqParams[:startDate]
      end
      if reqParams[:endDate] != "0000-00-00"
        bedeUrl += "&end=" + reqParams[:endDate]
      end
    end
    if reqParams[:days] != "0"
      bedeUrl +="&days=" + reqParams[:days]
    end
    return bedeUrl 
  end
  
  def getIcsTarget(currCats) # return Bedework ICS URL
    ifCats = currCats
    if ifCats == 'all'
      ifCats = ''
    else
      ifCats = convertCats(ifCats)
    end
   
      return TARGETSERVER + "/" + icsAction + "?calPath=/public/Public" + ifCats
  
  end
  
  def getEventTarget() # Return a specific event in desired skin
    currentSkin = 'default' #getSkin(reqParams[:xmlRss])
    finalGuid = reqParams[:guid]
    bedeUrl = TARGETSERVER + "/" + eventAction + "?skinName=" + currentSkin + "&subid=" + reqParams[:subId] + "&calPath=/public/" + reqParams[:calPath]  \
    + "&guid=" + finalGuid.gsub('_', '.')
    
    if reqParams[:recurrenceId] != '0'
      bedeUrl += "&recurrenceId=" + reqParams[:recurrenceId]
    else
      bedeUrl += "&recurrenceId=" # is this necessary?
    end
    
    if reqParams[:date]
      bedeUrl += "&date=" + reqParams[:date]
    end
    
    return bedeUrl
  end
  
  def getExt()

    return APP_CONFIG['externals'][reqParams[:feedName]]
  end
  
  def buildUrl # Main URL building action
    target = 'default'
    myGroup = 'none'
    if reqParams[:groups]
      myGroup = cleanGroups(reqParams[:groups])
    end
    if reqParams[:categories]
      myCats = cleanCats(reqParams[:categories])
    end
    
    target = case urlType
      when 'calendar' then getCalTarget(myGroup, myCats)
      when 'list' then getListTarget(myGroup, myCats)
      when 'ics' then getIcsTarget(myCats)
      when 'event' then getEventTarget()
      when 'external' then getExt()
    end
    
    return target
  end
end