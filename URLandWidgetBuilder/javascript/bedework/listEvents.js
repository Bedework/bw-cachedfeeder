// Insert Bedework calendar events from a json feed

var bwJsWidgetOptions = {
  title: 'Upcoming Events',
  showTitle: true,
  calendarServer: 'http://localhost:8080',
  calSuiteContext: '/cal',
  displayEventDetailsInline: false,
  displayStartDateOnlyInList: false,
  displayTimeInList: true,
  displayLocationInList: false,
  listMode: 'byDate' // values: 'byDate' or 'byTitle'
};

// Insert Bedework calendar events from a json feed
function insertBwEvents(outputContainerID) {
  var outputContainer = document.getElementById(outputContainerID);
  var output = "";
  var eventlist = new Array();
  var eventIndex = 0;

  if ((bwObject.bwEventList != undefined) &&
      (bwObject.bwEventList.events != undefined) &&
      (bwObject.bwEventList.events.length > 0)) {
    // get events 
    for (i = 0; i < bwObject.bwEventList.events.length; i++) {
      eventlist[eventIndex] = i;
      eventIndex++;
    }
    
    // GENERATE OUTPUT
    // This is where you may wish to customize the output.  To see what  
    // fields are available for events, look at the json source file included
    // by the widget code.  The core formatting is done in formatDateTime()
    // and formatSummary()
    
    // The title is included because you may wish to hide it when 
    // no events are present.
    if (bwJsWidgetOptions.showTitle) {
      output += "<h3 id=\"bwEventsTitle\">" + bwJsWidgetOptions.title + "</h3>";  
    }
    
    // Output the list
    output += "<ul id=\"bwEventList\">";
    
    // Now, iterate over the events:
    for(i in eventlist){
      // provide a shorthand reference to the event:
      var event = bwObject.bwEventList.events[eventlist[i]];
      
      // create the list item:
      output += "<li>";
      
      if (bwJsWidgetOptions.listMode == 'byDate') {
        output += formatDateTime(event);
        output += "<br/>"
        output += formatSummary(event,outputContainerID,i);
      } else {
        output += formatSummary(event,outputContainerID,i);
        output += "<br/>"
        output += formatDateTime(event);
      }
      
      if (bwJsWidgetOptions.displayLocationInList) {
        output += "<br/><span class=\"bwLoc\">" + event.location.address + "</span>";
      }
      
      output += "</li>";
    }
    output += "</ul>";
    
    // Finally, send the output to the container:
    outputContainer.innerHTML = output;
  }
}

function outputBwDateTime(event) {
  var output;
  output += "<span class=\"bwDateTime\">";

  if (bwJsWidgetOptions.listMode == 'byDate') {
    output +="<strong>";
  }
  // the following can likely be simplified
  if ((event.start.shortdate != event.end.shortdate) && 
      (event.start.datetime.substring(0,4) == event.end.datetime.substring(0,4)) && 
      (event.start.allday == 'true' || event.start.time == event.end.datetime.time || !bwJsWidgetOptions.displayTimeInList)) {
    
    // format: December 15-18, 2010
    
    output += event.start.longdate.substring(0,event.start.longdate.indexOf(","));
    output += "-" + event.end.datetime.substring(6,8) + ", ";
    output += event.end.datetime.substring(0,4);
    
  } else if ((event.start.shortdate != event.end.shortdate) && !bwJsWidgetOptions.displayStartDateOnlyInList) {
    
    // format: December 15, 2010 - January 3, 2011
    // or: December 15, 2010 10:00 AM - December 18, 2010 11:00 AM
    
    output += event.start.longdate; 
    if ((event.start.allday == 'false') && 
        (event.start.time != event.end.datetime.time) && 
        bwJsWidgetOptions.displayTimeInList) {
      output += " " + event.start.time;
    }
    output += " - ";
    output += event.end.longdate;
    if ((event.start.allday == 'false') && 
        (event.start.time != event.end.datetime.time) && 
        bwJsWidgetOptions.displayTimeInList) {
      output += " " + event.end.datetime.time;
    }
    
  } else {
    
    // format: December 15, 2010
    // or: December 15, 2010 10:00 AM
    // or: December 15, 2010 10:00 AM - 11:00 AM
    
    output += event.start.longdate;
    if (event.start.allday == 'false' && bwJsWidgetOptions.displayTimeInList) {
      output += " " + event.start.time;
    }
    if ((event.start.allday == 'false') && 
        bwJsWidgetOptions.displayTimeInList && 
        !bwJsWidgetOptions.displayStartDateOnlyInList && 
        (event.start.time != event.end.datetime.time)) {
      output += " - " + event.end.datetime.time;
    }
  }
  if (bwJsWidgetOptions.listMode == 'byDate') {
    output +="</strong>";
  }
  output += "</span>";
  
  return output;
}

function outputBwSummary(event,outputContainerId,i) {
  var output;
  output += "<span class=\"bwSummary\">";
  
  if (bwJsWidgetOptions.listMode == 'bySummary') {
    output +="<strong>";
  }

  if (bwJsWidgetOptions.displayEventDetailsInline = 'false') { 
    // link back to the calendar
    
    // Include the urlPrefix for links back to events in the calendar. 
    var urlPrefix = bwJsWidgetOptions.calendarServer + bwJsWidgetOptions.calSuiteContext + "/event/eventView.do";
    
    // generate the query string parameters that get us back to the 
    // event in the calendar:
    var eventQueryString = "?subid=" + event.subscriptionId;
    eventQueryString += "&amp;calPath=" + event.calPath;
    eventQueryString += "&amp;guid=" + event.guid;
    eventQueryString += "&amp;recurrenceId=" + event.recurrenceId;
    
    output += "<a href=\"" + urlPrefix + eventQueryString + "\">" + event.summary + "</a>";
    
  } else { 
    // don't link back to the calendar - display event details in the widget
    output += "<a href=\"javascript:showEvent('" + outputContainerID + "'," + i + ");\">" + event.summary + "</a>";
      
  }
  if (bwJsWidgetOptions.listMode == 'bySummary') {
    output +="</strong>";
  }
  output += "</span>";
  
  return output;
}
      
function showBwEvent(outputContainerID, eventId) {
  // Style further with CSS
  
  var outputContainer = document.getElementById(outputContainerID);
  var output = "";
  // provide a shorthand reference to the event:
  var event = bwObject.bwEventList.events[eventId];
  
  // create the event
  output += "<h3 id=\"bwEventsTitle\">" + event.summary + "</h3>";
  output += "<div id=\"bwEventLogistics\">";
  
  output += "<div class=\"bwEventDateTime\">"
  output += event.start.longdate + " ";
  output += event.start.time;
  if ((event.start.shortdate != event.end.shortdate) && 
      (event.start.time != event.end.time)) {
    output += " - " + event.end.longdate + " ";
    output += event.end.time;
  } else if (event.start.time != event.end.time) {
    output += " - " + event.end.time;
  }
  output += "</div>";
  
  output += "<div class=\"bwEventLoc\">"
  if (event.location.link != "") {
    output += "<a href=\""+ event.location.link + "\">" + event.location.address + "</a>";
  } else {
    output += event.location.address;
  }
  output += "</div>";
  
  output += "<div class=\"bwEventDesc\">"
  output += event.description;
  output += "</div>";

  if (event.categories != "") {
    output += "<div class=\"bwEventCats\">"
    output += event.categories;
    output += "</div>";
  }
  if (event.link != "") {
    output += "<div class=\"bwEventLink\">"
    output += "See: <a href=\"" + event.link + "\">" + event.link + "</a>";
    output += "</div>";
  }
  output += "</div>";
  
  // create a link back to the main view
  output += "<p id=\"bwEventsListLink\"><a href=\"javascript:insertEvents('" + outputContainerID + "')\">Return</a>";

  // Send the output to the container:
  outputContainer.innerHTML = output;
}