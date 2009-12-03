#
#  FeedModel.rb
#
#  Created by Jeremy Bandini on 9/30/08.
#  Copyright (c) 2008 Duke University. All rights reserved.


class FeedModel
  attr_accessor :urlType, :reqParams
  attr_reader :listAction, :gridAction, :categoriesAction, :groupsAction #, :eventAction
  def initialize(urlType, reqParams)
    @urlType, @reqParams = urlType, reqParams 
    @gridAction = 'main/setViewPeriod.do'
    @listAction = 'main/listEvents.do'
    @categoriesAction = 'widget/categories.do'
    @groupsAction = 'widget/groups.do'
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
  
  def joinGroupAndCats(groupStr, catsStr) 
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
      when 'genFeedDays' then getTarget(myGroup, myCats, "gen", "days")
      when 'genFeedRange' then getTarget(myGroup, myCats, "gen", "range")
      when 'genFeedPeriod' then getTarget(myGroup, myCats, "gen", "period")
      when 'icsDays' then getTarget(myGroup, myCats, "ics", "days")
      when 'icsRange' then getTarget(myGroup, myCats, "ics", "range")
      when 'icsPeriod' then getTarget(myGroup, myCats, "ics", "period")
      when 'categories' then getCategories()
      when 'groups' then getGroups()
      # when 'event' then getEventTarget()
      # when 'external' then getExt()
    end
    
    return target
  end
  
  def getTarget(currGroup, currCats, genOrIcs, daysRangeOrPeriod) 
    
    # set Bedework method and construct group and category information
    if daysRangeOrPeriod == 'period'
      action = gridAction
      groupAndCats = "&setappvar(filter:" + currGroup + "~" + currCats + ")"
    else
      action = listAction
      if currCats == 'all'
        ifCats = ''
      else
        ifCats = convertCats(ifCats)
      end
      if currGroup == 'all'
        ifGroup = ''
      else
        ifGroup = "&creator=" + currGroup
      end
      groupAndCats = ifCats + ifGroup
    end
    
    # build the Bedework URL and return it.
    if genOrIcs == 'ics'
      bedeUrl = TARGETSERVER + "/" + action + "?format=text/calendar&setappvar=summaryMode(details)" + groupAndCats  
    else
      currentSkin = getSkin(reqParams[:skin]) 
      bedeUrl = TARGETSERVER + "/" + action + "?skinName=" + currentSkin + "&setappvar=summaryMode(details)" + groupAndCats
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
    bedeUrl = TARGETSERVER + "/" + categoriesAction + "?skinName=" + currSkin + "&setappvar=objName(" + obj + ")"
  end
  
  def getGroups()
    currSkin = getSkin(reqParams[:skin])
     obj = reqParams[:objName]
    bedeUrl = TARGETSERVER + "/" + groupsAction + "?skinName=" + currSkin + "&setappvar=objName(" + obj + ")"
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