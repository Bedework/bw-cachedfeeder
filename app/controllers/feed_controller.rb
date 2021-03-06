###################################################
#
#  Licensed to Jasig under one or more contributor license
#  agreements. See the NOTICE file distributed with this work
#  for additional information regarding copyright ownership.
#  Jasig licenses this file to you under the Apache License,
#  Version 2.0 (the "License"); you may not use this file
#  except in compliance with the License. You may obtain a
#  copy of the License at:
#
#  http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing,
#  software distributed under the License is distributed on
#  an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
#  KIND, either express or implied. See the License for the
#  specific language governing permissions and limitations
#  under the License.
#
####################################################

require 'rubygems'
require 'httpclient'
# routes.rb determines url parameters and url segment configuration
class FeedController < ApplicationController
  # Rails caching for each action
  #caches_page :calendar, :external
  caches_page :htmlEvent, :categories, :groups, :download, :calendars
  caches_page :jsonDays, :htmlDays, :rssDays, :xmlDays, :icsDays
  caches_page :jsonRange, :htmlRange, :rssRange, :xmlRange, :icsRange

  def addExtension
    if params[:skin]
      # skin names are in the form {list, grid}-{outputType}
      skinNameSplits = params[:skin].split("-")
      outputType = skinNameSplits[1]
      ActionController::Base.page_cache_extension = '.' + outputType
      logger.info("Web page extension is " + outputType + ".\n")
      headers["Content-Type"] = APP_CONFIG['content_type'][outputType]
      return
    end

    if params[:action] == 'download'
       ActionController::Base.page_cache_extension = '.ics'
       headers["Content-Type"] = APP_CONFIG['content_type']['ics']
       return
    end

    if params[:action] == 'icsDays' || params[:action] == 'icsRange' || params[:action] == 'icsPeriod'
      ActionController::Base.page_cache_extension = '.ics'
      headers["Content-Type"] = APP_CONFIG['content_type']['ics']
      return
    end

     #if params[:action] == 'external'
      #  ActionController::Base.page_cache_extension = '.rss'
      #  headers["Content-Type"] = APP_CONFIG['content_type']['rss']
      #  return
      #end
  end

  def getFeed(feedUrl) # uses httpclient gem
    target = ARGV.shift || feedUrl
    target = ARGV.shift || target  # shift again to get by version marker
    # send code for |, since it's an illegal char in NTFS
    clnt = HTTPClient.new
    return clnt.get_content(target.gsub('-_','%7c'))
  end

  def jsonDays
    currUrl = FeedModel.new('jsonDays', params)
    target = currUrl.buildUrl
    #Normalize url. May be server-relative.
    if target.slice(0,1) == '/'
      serverProtocol = request.protocol
      serverHost = request.host
      serverPort = request.port.to_s
      target = serverProtocol + serverHost + ':' + serverPort + target
    end
    logger.info("URL is #{target}\n")
    @xmlOutput = getFeed(target)
    addExtension()
  end

  def xmlDays
    currUrl = FeedModel.new('xmlDays', params)
    target = currUrl.buildUrl
    #Normalize url. May be server-relative.
    if target.slice(0,1) == '/'
      serverProtocol = request.protocol
      serverHost = request.host
      serverPort = request.port.to_s
      target = serverProtocol + serverHost + ':' + serverPort + target
    end
    logger.info("URL is #{target}\n")
    @xmlOutput = getFeed(target)
    addExtension()
  end

  def htmlDays
    currUrl = FeedModel.new('htmlDays', params)
    target = currUrl.buildUrl
    #Normalize url. May be server-relative.
    if target.slice(0,1) == '/'
      serverProtocol = request.protocol
      serverHost = request.host
      serverPort = request.port.to_s
      target = serverProtocol + serverHost + ':' + serverPort + target
    end
    logger.info("URL is #{target}\n")
    @xmlOutput = getFeed(target)
    addExtension()
  end


  def rssDays
    currUrl = FeedModel.new('rssDays', params)
    target = currUrl.buildUrl
    #Normalize url. May be server-relative.
    if target.slice(0,1) == '/'
      serverProtocol = request.protocol
      serverHost = request.host
      serverPort = request.port.to_s
      target = serverProtocol + serverHost + ':' + serverPort + target
    end
    logger.info("URL is #{target}\n")
    @xmlOutput = getFeed(target)
    addExtension()
  end

  def icsDays
    currUrl = FeedModel.new('icsDays', params)
    target = currUrl.buildUrl
    #Normalize url. May be server-relative.
    if target.slice(0,1) == '/'
      serverProtocol = request.protocol
      serverHost = request.host
      serverPort = request.port.to_s
      target = serverProtocol + serverHost + ':' + serverPort + target
    end
    logger.info("URL is #{target}\n")
    @xmlOutput = getFeed(target)
    addExtension()
  end
  
  def jsonRange
    currUrl = FeedModel.new('jsonRange', params)
    target = currUrl.buildUrl
    #Normalize url. May be server-relative.
    if target.slice(0,1) == '/'
      serverProtocol = request.protocol
      serverHost = request.host
      serverPort = request.port.to_s
      target = serverProtocol + serverHost + ':' + serverPort + target
    end
    logger.info("URL is #{target}\n")
    @xmlOutput = getFeed(target)
    addExtension()
  end

  def xmlRange
    currUrl = FeedModel.new('xmlRange', params)
    target = currUrl.buildUrl
    #Normalize url. May be server-relative.
    if target.slice(0,1) == '/'
      serverProtocol = request.protocol
      serverHost = request.host
      serverPort = request.port.to_s
      target = serverProtocol + serverHost + ':' + serverPort + target
    end
    logger.info("URL is #{target}\n")
    @xmlOutput = getFeed(target)
    addExtension()
  end

  def htmlRange
    currUrl = FeedModel.new('htmlRange', params)
    target = currUrl.buildUrl
    #Normalize url. May be server-relative.
    if target.slice(0,1) == '/'
      serverProtocol = request.protocol
      serverHost = request.host
      serverPort = request.port.to_s
      target = serverProtocol + serverHost + ':' + serverPort + target
    end
    logger.info("URL is #{target}\n")
    @xmlOutput = getFeed(target)
    addExtension()
  end

  def rssRange
    currUrl = FeedModel.new('rssRange', params)
    target = currUrl.buildUrl
    #Normalize url. May be server-relative.
    if target.slice(0,1) == '/'
      serverProtocol = request.protocol
      serverHost = request.host
      serverPort = request.port.to_s
      target = serverProtocol + serverHost + ':' + serverPort + target
    end
    logger.info("URL is #{target}\n")
    @xmlOutput = getFeed(target)
    addExtension()
  end
  
  def icsRange
    currUrl = FeedModel.new('icsRange', params)
     target = currUrl.buildUrl
    #Normalize url. May be server-relative.
    if target.slice(0,1) == '/'
      serverProtocol = request.protocol
      serverHost = request.host
      serverPort = request.port.to_s
      target = serverProtocol + serverHost + ':' + serverPort + target
    end
    logger.info("URL is #{target}\n")
    @xmlOutput = getFeed(target)
    addExtension()
  end
  
  def genFeedPeriod
    currUrl = FeedModel.new('genFeedPeriod', params)
    target = currUrl.buildUrl
    #Normalize url. May be server-relative.
    if target.slice(0,1) == '/'
      serverProtocol = request.protocol
      serverHost = request.host
      serverPort = request.port.to_s
      target = serverProtocol + serverHost + ':' + serverPort + target
    end
    logger.info("URL is #{target}\n")
    @xmlOutput = getFeed(target)
    addExtension()
  end

  def htmlEvent
    currUrl = FeedModel.new('htmlEvent', params)
    target = currUrl.buildUrl
    #Normalize url. May be server-relative.
    if target.slice(0,1) == '/'
      serverProtocol = request.protocol
      serverHost = request.host
      serverPort = request.port.to_s
      target = serverProtocol + serverHost + ':' + serverPort + target
    end
    logger.info("URL is #{target}\n")
    @xmlOutput = getFeed(target)
    addExtension()
  end

  def download
    currUrl = FeedModel.new('download', params)
    target = currUrl.buildUrl
    #Normalize url. May be server-relative.
    if target.slice(0,1) == '/'
      serverProtocol = request.protocol
      serverHost = request.host
      serverPort = request.port.to_s
      target = serverProtocol + serverHost + ':' + serverPort + target
    end
    logger.info("URL is #{target}\n")
    @xmlOutput = getFeed(target)
    addExtension()
  end



  def icsPeriod
    currUrl = FeedModel.new('icsPeriod', params)
    target = currUrl.buildUrl
    #Normalize url. May be server-relative.
    if target.slice(0,1) == '/'
      serverProtocol = request.protocol
      serverHost = request.host
      serverPort = request.port.to_s
      target = serverProtocol + serverHost + ':' + serverPort + target
    end
    logger.info("URL is #{target}\n")
    @xmlOutput = getFeed(target)
    addExtension()
  end

  def categories
    currUrl = FeedModel.new('categories', params)
    target = currUrl.buildUrl
    #Normalize url. May be server-relative.
    if target.slice(0,1) == '/'
      serverProtocol = request.protocol
      serverHost = request.host
      serverPort = request.port.to_s
      target = serverProtocol + serverHost + ':' + serverPort + target
    end
    logger.info("URL is #{target}\n")
    @xmlOutput = getFeed(target)
    addExtension()
  end

  def groups
    currUrl = FeedModel.new('groups', params)
    target = currUrl.buildUrl
    #Normalize url. May be server-relative.
    if target.slice(0,1) == '/'
      serverProtocol = request.protocol
      serverHost = request.host
      serverPort = request.port.to_s
      target = serverProtocol + serverHost + ':' + serverPort + target
    end
    logger.info("URL is #{target}\n")
    @xmlOutput = getFeed(target)
    addExtension()
  end
  
  def calendars
    currUrl = FeedModel.new('calendars', params)
    target = currUrl.buildUrl
    #Normalize url. May be server-relative.
    if target.slice(0,1) == '/'
      serverProtocol = request.protocol
      serverHost = request.host
      serverPort = request.port.to_s
      target = serverProtocol + serverHost + ':' + serverPort + target
    end
    logger.info("URL is #{target}\n")
    @xmlOutput = getFeed(target)
    addExtension()
  end

  # def calendar # Bedework calendar web client (uses setViewPeriod.do)
  #     currUrl = FeedModel.new('calendar', params)
  #     target = currUrl.buildUrl
  #  logger.info("\nFEED: calendar URL is #{target}\n")
  #     @xmlOutput = getFeed(target)
  #  addExtension()
  #  end



  #def external
  #  currUrl = FeedModel.new('external', params)
  #  target = currUrl.buildUrl
  #  @xmlOutput = getFeed(target)
  #  addExtension()
  #end

end
