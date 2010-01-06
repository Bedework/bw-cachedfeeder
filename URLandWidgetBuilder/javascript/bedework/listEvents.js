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
function insertEvents(outputContainerID) {
  var outputContainer = document.getElementById(outputContainerID);
  var output = "";
  var eventlist = new Array();
  var eventIndex = 0;
  
  // Include the urlPrefix for links back to events in the calendar. 
  var urlPrefix = bwJsWidgetOptions.calendarServer + bwJsWidgetOptions.calSuiteContext + "/event/eventView.do";

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
    output += "<h3 id=\"bwEventsTitle\">" + bwJsWidgetOptions.title + "</h3>";
    output += "<ul id=\"bwEventList\">";
    
    // Now, iterate over the events:
    for(i in eventlist){
      // provide a shorthand reference to the event:
      var event = bwObject.bwEventList.events[eventlist[i]];
      
      // generate the query string parameters that get us back to the 
      // event in the calendar:
      var eventQueryString = "?subid=" + event.subscriptionId;
      eventQueryString += "&amp;calPath=" + event.calPath;
      eventQueryString += "&amp;guid=" + event.guid;
      eventQueryString += "&amp;recurrenceId=" + event.recurrenceId;
      
      // create the list item:
      output += "<li>";
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
      output += "</strong><br/>";
      
      output += "<a href=\"" + urlPrefix + eventQueryString + "\">" + event.summary + "</a>";
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



function insertEvents(outputContainerID) {
  var outputContainer = document.getElementById(outputContainerID);
  var output = "";
  var eventlist = new Array();
  var eventIndex = 0;
      
  if ((bwObject.bwEventList != undefined) && (bwObject.bwEventList.events != undefined) && 
      (bwObject.bwEventList.events.length > 0)) {
    // get events 
    for (i = 0; i < bwObject.bwEventList.events.length; i++) {
      eventlist[eventIndex] = i;
      eventIndex++;
    }
          
    // The title is included here because you may wish to hide it when 
    // no events are present.
    output += "<h1 id=\"bwEventsTitle\">Upcoming Events</h1>";
    output += "<p>Events for the next seven days:</p>";
    output += "<ul id=\"bwEventList\">";
          
    // Now, iterate over the events:
    for(i in eventlist){
      // provide a shorthand reference to the event:
      var event = bwObject.bwEventList.events[eventlist[i]];
            
      // create the list item:
      output += "<li>";
      output += "<a href=\"javascript:showEvent('" + outputContainerID + "'," + i + ");\">" + event.summary + "</a><br/>";
      output += event.location.address + " - ";
      output += event.calendar.name + "<br/>";
      output += event.start.longdate + " ";
      output += event.start.time;
      if ((event.start.shortdate != event.end.shortdate) && (event.start.time != event.end.time)) {
        output += " - " + event.end.longdate + " ";
        output += event.end.time;
      } else if (event.start.time != event.end.time) {
        output += " - " + event.end.time;
      }           
      output += "</li>";
    }
    output += "</ul>";
          
   // Finally, send the output to the container:
   outputContainer.innerHTML = output;
 }
}
      
      function showEvent(outputContainerID, eventId) {
        var outputContainer = document.getElementById(outputContainerID);
        var output = "";
        // provide a shorthand reference to the event:
        var event = bwObject.bwEventList.events[eventId];
        
        // create the event
        output += "<h1 id=\"bwEventsTitle\">" + event.summary + "</h1>";
        output += "<table id=\"bwEventLogistics\">";
        output += "<tr><th>When:</th><td>" + event.start.longdate + " ";
        output += event.start.time;
        if ((event.start.shortdate != event.end.shortdate) && 
            (event.start.time != event.end.time)) {
          output += " - " + event.end.longdate + " ";
          output += event.end.time;
        } else if (event.start.time != event.end.time) {
          output += " - " + event.end.time;
        }
        output += "</td></tr>";
        if (event.location.link != "") {
          output += "<tr><th>Where:</th><td><a href=\""+ event.location.link + "\">" + event.location.address + "</a></td></tr>";
        } else {
          output += "<tr><th>Where:</th><td>" + event.location.address + "</td></tr>";
        }
        
        output += "<tr><th>Description:</th><td>" + event.description + "</td></tr>";
        output += "<tr><th>Calendar:</th><td>" + event.calendar.name + "</td></tr>";
        if (event.categories != "") {
          output += "<tr><th>Categories:</th><td>" + event.categories + "</td></tr>";
        }
        if (event.link != "") {
          output += "<tr><th>See:</th><td><a href=\"" + event.link + "\">" + event.link + "</a></td></tr>";
        }
        output += "</table>";
        
        // create a link back to the main view
        output += "<p id=\"bwEventsListLink\"><a href=\"javascript:insertEvents('" + outputContainerID + "')\">Return to Event List</a>";

        // Send the output to the container:
        outputContainer.innerHTML = output;
      }