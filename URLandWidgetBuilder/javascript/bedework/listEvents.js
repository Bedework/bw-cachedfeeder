// Insert Bedework calendar events from a json feed

var bwJsWidgetOptions = {
  title: 'Upcoming Events'; 
  showTitle: true;
  calendarServer: 'http://localhost:8080';
  calSuiteContext: '/cal';
  displayEventDetailsInline: false;
  displayLocationInList: false;
  listMode: 'byDate'; // values: 'byDate' or 'byTitle'
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
    // by the widget code
    
    // The title is included because you may wish to hide it when 
    // no events are present.
    if ()
    output += "<h3 id=\"bwEventsTitle\">" + bwJsWidgetOptions.title + "</h3>";
    output += "<ul id=\"bwEventList\">";
    
    // Now, iterate over the events:
    for(i in eventlist){
      // provide a shorthand reference to the event:
      var event = bwObject.bwEventList.events[eventlist[i]];
      
      // create the list item:
      output += "<li>";
      
      if (bwJsWidgetOptions.listMode = 'byDate') {
        output += formatDateTime(event);
        output += "<br/>"
        output += formatSummary(event,outputContainerID,i);
      } else {
        output += formatSummary(event,outputContainerID,i);
        output += "<br/>"
        output += formatDateTime(event);
      }
      
      if (bwJsWidgetOptions.displayLocationInList = "true") {
        output += "<br/>" + event.location.address;
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
  output += "<strong class=\"dateTime\">";
  // don't include times for now
  if ((event.start.shortdate != event.end.shortdate) && (event.start.datetime.substring(0,4) == event.end.datetime.substring(0,4))) {
    output += event.start.longdate.substring(0,event.start.longdate.indexOf(","));
    output += "-" + event.end.datetime.substring(6,8) + ", ";
    output += event.end.datetime.substring(0,4);
  } else if ((event.start.shortdate != event.end.shortdate) && (event.start.datetime.substring(0,4) != event.end.datetime.substring(0,4))) {
    output += event.start.longdate + " - ";
    output += event.end.longdate + " ";
  }
  else {
    output += event.start.longdate + " ";
  }
  output += "</strong>";
  
  return output;
}

function outputBwSummary(event,outputContainerId,i) {
  var output;

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
    output += "<a href=\"javascript:showEvent('" + outputContainerID + "'," + i + ");\">" + event.summary + "</a><br/>";
      
  }
  
  return output;
}

      
function showBwEvent(outputContainerID, eventId) {
  var outputContainer = document.getElementById(outputContainerID);
  var output = "";
  // provide a shorthand reference to the event:
  var event = bwObject.bwEventList.events[eventId];
  
  // create the event
  output += "<h3 id=\"bwEventsTitle\">" + event.summary + "</h3>";
  output += "<div id=\"bwEventLogistics\">";
  
  output += "<span class=\"bwEventDateTime\">"
  output += event.start.longdate + " ";
  output += event.start.time;
  if ((event.start.shortdate != event.end.shortdate) && 
      (event.start.time != event.end.time)) {
    output += " - " + event.end.longdate + " ";
    output += event.end.time;
  } else if (event.start.time != event.end.time) {
    output += " - " + event.end.time;
  }
  output += "<br/></span>";
  
  output += "<span class=\"bwEventLoc\">"
  if (event.location.link != "") {
    output += "<a href=\""+ event.location.link + "\">" + event.location.address + "</a>";
  } else {
    output += event.location.address;
  }
  output += "<br/></span>";
  
  output += "<span class=\"bwEventDesc\">"
  output += event.description;
  output += "<br/></span>";

  if (event.categories != "") {
    output += "<span class=\"bwEventCats\">"
    output += event.categories;
    output += "<br/></span>";
  }
  if (event.link != "") {
    output += "<span class=\"bwEventLink\">"
    output += "See: <a href=\"" + event.link + "\">" + event.link + "</a>";
    output += "</span>";
  }
  output += "</div>";
  
  // create a link back to the main view
  output += "<p id=\"bwEventsListLink\"><a href=\"javascript:insertEvents('" + outputContainerID + "')\">Return</a>";

  // Send the output to the container:
  outputContainer.innerHTML = output;
}