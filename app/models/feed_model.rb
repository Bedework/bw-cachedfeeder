#
#  FeedModel.rb
#
#  Created by Jeremy Bandini on 9/30/08.  Modified by Barry Leibson during the waning months of 2009.
#  Copyright (c) 2008 Duke University. All rights reserved.


class FeedModel
  attr_accessor :urlType, :reqParams
  attr_reader :listAction, :gridAction, :categoriesAction, :groupsAction, :eventAction, :downloadAction
  def initialize(urlType, reqParams)
    @urlType, @reqParams = urlType, reqParams 
    @gridAction = 'main/setViewPeriod.do'
    @listAction = 'main/listEvents.do'
    @categoriesAction = 'widget/categories.do'
    @groupsAction = 'widget/groups.do'
    @eventAction = 'event/eventView.do'
    @downloadAction = 'misc/export.gdo'
  end
  
  def convertCats(catStr) # Convert ~ seperated string to bedework &cat=category format
    workStringArr = catStr.split(/~/)
    longCats = ''
    workStringArr.each do |workStr|
      longCats += '&catuid=' + workStr
    end   
    return longCats
  end
  
  def addDateDashes (dateStr)
    return dateStr[0,4] + '-' + dateStr[4,2] + '-' + dateStr[6,2] 
  end
  
  def cleanCats(catStr) #strip .html from from request and urlencode spaces
    workString = catStr.gsub('.html', '')
    workString = workString.gsub(' ', '%20')
    return workString
  end
  
  def getSkin(feedType) # determine by feedType
    return APP_CONFIG['skin'][feedType]
  end
  
  def buildUrl() # dispatcher
  
    target = case urlType
      when 'jsonDays' then getTarget2("json", "days")
      when 'icsDays' then getTarget2("ics", "days")
      when 'htmlDays' then getTarget2("html", "days")
      when 'xmlDays' then getTarget2("xml", "days")
      when 'rssDays' then getTarget2("rss", "days")
      when 'jsonRange' then getTarget2("json", "range")
      when 'icsRange' then getTarget2("ics", "range")
      when 'htmlRange' then getTarget2("html", "range")
      when 'xmlRange' then getTarget2("xml", "range")
      when 'rssRange' then getTarget2("rss", "range")       
      #when 'genFeedPeriod' then getTarget(myFilter, "gen", "period", myObjName)
      #when 'icsPeriod' then getTarget(myFilter, "ics", "period", myObjName)
      when 'categories' then getCategories()
      when 'groups' then getGroups()
      when 'htmlEvent' then getEventTarget()
      when 'download' then getDownloadTarget()
      # when 'external' then getExt()
    end
    
    return target
  end
  
  def getTarget(filter, genOrIcs, daysRangeOrPeriod, obj) 
    
    skin = getSkin(reqParams[:skin])
    skinSplits = skin.split(/-/)
    output = skinSplits[1]
    
    if reqParams[:filter]
      filter = reqParams[:filter]
    else
      filter = 'no--filter'
    end
    if reqParams[:objName]
      obj = reqParams[:objName]
    else
      obj = 'no--object'
    end
    
    if filter == 'no--filter'
      filterParam = ''
    else
      encodedFilter = CGI::escape(filter)
      filterParam = "&fexpr=" + encodedFilter
    end
      
    if obj == 'no--object'
      objParam = ''
    else
      objParam = "&setappvar=objName(" + obj + ")"
    end
    
    # set Bedework action
    if daysRangeOrPeriod == 'period'
      action = gridAction
    else
      action = listAction
    end
    
    bedeUrl = TARGETSERVER + "/" + action + "?calPath=/public/cals/MainCal"
    
    # build the Bedework URL and return it.
    if genOrIcs == 'ics'
      bedeUrl += "&format=text/calendar&setappvar=summaryMode(details)" + filterParam + objParam
    else 
      bedeUrl += "&skinName=" + skin + "&setappvar=summaryMode(details)" + filterParam + objParam
    end
    if daysRangeOrPeriod == "range"
      if reqParams[:startDate] and reqParams[:endDate] 
        if reqParams[:startDate] != "00000000"
          startD = addDateDashes(reqParams[:startDate])
          bedeUrl += "&start=" + startD
        end
        if reqParams[:endDate] != "00000000"
          endD = addDateDashes(reqParams[:endDate])
          bedeUrl += "&end=" + endD
        end
      end
    elsif daysRangeOrPeriod == "days"
      if (reqParams[:days] != "0")
        bedeUrl +="&days=" + reqParams[:days]
      end
    else
      if reqParams[:date] != "00000000" 
        bedeUrl += "&date=" + reqParams[:date]
      end
        
      case reqParams[:period]
        when 'day' then bedeUrl +="&viewType=dayView"
        when 'week' then bedeUrl +="&viewType=weekView"
        when 'month' then bedeUrl +="&viewType=monthView"
        when 'year' then bedeUrl +="&viewType=yearView"
      end
    end
    return bedeUrl 
  end
  
  def getTarget2(output, daysRangeOrPeriod) 
    
    if reqParams[:filter] == 'no--filter'
      filterParam = ''
    else
      encodedFilter = CGI::escape(filter)
      filterParam = "&fexpr=" + encodedFilter
    end
    
    if output == "json" 
      obj = reqParams[:objName]
      if obj == 'no--object'
        objParam = ''
      else
        objParam = "&setappvar=objName(" + obj + ")"
      end
    else 
      objParam = ''
    end
    
    # set Bedework action
    #if daysRangeOrPeriod == 'period'
    #  action = gridAction
    #else
      action = listAction
    #end
    
    bedeUrl = TARGETSERVER + "/" + action + "?calPath=/public/cals/MainCal"
    
    # build the Bedework URL and return it.
    if output == 'ics'
      bedeUrl += "&format=text/calendar&setappvar=summaryMode(details)" + filterParam
    else 
      skin = getSkin(reqParams[:skin])
      bedeUrl += "&skinName=" + skin + "&setappvar=summaryMode(details)" + filterParam + objParam
    end
    if daysRangeOrPeriod == "range"
      if reqParams[:startDate] and reqParams[:endDate] 
        if reqParams[:startDate] != "00000000"
          startD = addDateDashes(reqParams[:startDate])
          bedeUrl += "&start=" + startD
        end
        if reqParams[:endDate] != "00000000"
          endD = addDateDashes(reqParams[:endDate])
          bedeUrl += "&end=" + endD
        end
      end
    elsif daysRangeOrPeriod == "days"
      if (reqParams[:days] != "0")
        bedeUrl +="&days=" + reqParams[:days]
      end
    else
      if reqParams[:date] != "00000000" 
        bedeUrl += "&date=" + reqParams[:date]
      end
        
      case reqParams[:period]
        when 'day' then bedeUrl +="&viewType=dayView"
        when 'week' then bedeUrl +="&viewType=weekView"
        when 'month' then bedeUrl +="&viewType=monthView"
        when 'year' then bedeUrl +="&viewType=yearView"
      end
    end
    return bedeUrl 
  end
  
  def getCategories()
    currSkin = getSkin(reqParams[:skin])
    obj = reqParams[:objName]
    bedeUrl = TARGETSERVER + "/" + categoriesAction + "?skinName=" + currSkin + "&setappvar=objName(" + obj + ")&calPath=/public/cals/MainCal"
    return bedeUrl
  end
  
  def getGroups()
    currSkin = getSkin(reqParams[:skin])
    obj = reqParams[:objName]
    bedeUrl = TARGETSERVER + "/" + groupsAction + "?skinName=" + currSkin + "&setappvar=objName(" + obj + ")&calPath=/public/cals/MainCal"
    return bedeUrl
  end
  
  def getDownloadTarget()
    calPathParam = '?calPath=%2Fpublic%2Fcals%2FMainCal'
    guidParam = "&guid=" + reqParams[:guid].gsub('_', '.')
    bedeUrl = TARGETSERVER + "/" + downloadAction + calPathParam + guidParam + '&nocache=no&contentName='
    bedeUrl += reqParams[:fileName] + "&calPath=/public/cals/MainCal"
    
    if reqParams[:recurrenceId] != '0'
      bedeUrl += "&recurrenceId=" + reqParams[:recurrenceId]
    else
      bedeUrl += "&recurrenceId=" # is this necessary?
    end
    return bedeUrl
  end
  
  
  def getEventTarget() # Return a specific event in desired skin
    currSkin = getSkin(reqParams[:skin])
    skinParam = "?skinName=" + currSkin
    guidParam = "&guid=" + reqParams[:guid].gsub('_', '.')
    calPathParam = '&calPath=%2Fpublic%2Fcals%2FMainCal'
    bedeUrl = TARGETSERVER + "/" + eventAction + skinParam + calPathParam + guidParam
    bedeUrl += "&recurrenceId=" + reqParams[:recurrenceId]  
    if reqParams[:date]
      bedeUrl += "&date=" + reqParams[:date]
    end
    return bedeUrl
  end
  
  #def getExt()

  #  return APP_CONFIG['externals'][reqParams[:feedName]]
  #end
  
end