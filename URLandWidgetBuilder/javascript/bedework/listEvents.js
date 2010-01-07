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
  listMode: 'bySummary', // values: 'byDate' or 'bySummary' - highlights the date or title first (sort is always by date)
  displayContactInDetails: true,
  displayCostInDetails: true,
  displayTagsInDetails: true,
  displayTimezoneInDetails: true
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
        output += formatBwDateTime(event);
        output += "<br/>"
        output += formatBwSummary(event,outputContainerID,i);
      } else {
        output += formatBwSummary(event,outputContainerID,i);
        output += "<br/>"
        output += formatBwDateTime(event);
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

function formatBwDateTime(event) {

  var output = "";
  output += "<span class=\"bwDateTime\">";

  if (bwJsWidgetOptions.listMode == 'byDate') {
    output +="<strong>";
  }

  // would much prefer to pass in a date/time format string, but can't do so
  // in an internationalized way.

  output += event.start.longdate;
  if ((event.start.allday == 'false') && bwJsWidgetOptions.displayTimeInList) {
    output += " " + event.start.time;
  }
  if (!bwJsWidgetOptions.displayStartDateOnlyInList) {
    if (event.start.shortdate != event.end.shortdate) {
      output += " - ";
      output += event.end.longdate;
      if ((event.start.allday == 'false') && bwJsWidgetOptions.displayTimeInList) {
        output += " " + event.end.time;
      }
    } else if ((event.start.allday == 'false') &&
                bwJsWidgetOptions.displayTimeInList &&
                (event.start.time != event.end.time)) {
      // same date, different times
      output += " - " + event.end.time;
    }
  }

  if (bwJsWidgetOptions.listMode == 'byDate') {
    output +="</strong>";
  }
  output += "</span>";

  return output;
}

function formatBwSummary(event,outputContainerID,i) {

  var output = "";
  output += "<span class=\"bwSummary\">";

  if (bwJsWidgetOptions.listMode == 'bySummary') {
    output +="<strong>";
  }

  if (bwJsWidgetOptions.displayEventDetailsInline) {
    // don't link back to the calendar - display event details in the widget

    output += "<a href=\"javascript:showBwEvent('" + outputContainerID + "'," + i + ");\">" + event.summary + "</a>";

  } else {
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

  // output date/time
  output += "<div class=\"bwEventDateTime\">"
  output += event.start.longdate;
  if ((event.start.allday == 'false') && bwJsWidgetOptions.displayTimeInList) {
    output += " " + event.start.time;
    if ((event.start.timezone != event.end.timezone) &&
        bwJsWidgetOptions.displayTimezoneInDetails) {
      output += " " + event.start.timezone;
    }
  }
  if (event.start.shortdate != event.end.shortdate) {
    output += " - ";
    output += event.end.longdate;
    if (event.start.allday == 'false') {
      output += " " + event.end.time;
      if (bwJsWidgetOptions.displayTimezoneInDetails) {
        output += " " + event.end.timezone;
      }
    }
  } else if ((event.start.allday == 'false') &&
             (event.start.time != event.end.time)) {
    // same date, different times
    output += " - " + event.end.time;
    if (bwJsWidgetOptions.displayTimezoneInDetails) {
      output += " " + event.end.timezone;
    }
  }
  output += "</div>";

  // output location
  output += "<div class=\"bwEventLoc\">"
  if (event.location.link != "") {
    output += "<a href=\""+ event.location.link + "\">" + event.location.address + "</a>";
  } else {
    output += event.location.address;
  }
  output += "</div>";

  // output description
  output += "<div class=\"bwEventDesc\">"
  output += event.description;
  output += "</div>";

  // output contact
  if (bwJsWidgetOptions.displayContactInDetails) {
    output += "<div class=\"bwEventContact\">"
    if (event.contact.link != "") {
      output += "Contact: <a href=\"" + event.contact.link + "\">" + event.contact.name + "</a>";
    } else {
      output += "Contact: " + event.contact.name;
    }
    output += "</div>";
  }

  // output cost
  if (event.cost != "" && bwJsWidgetOptions.displayCostInDetails) {
    output += "<div class=\"bwEventCost\">"
    output += "Cost: " + event.cost;
    output += "</div>";
  }

  // output tags (categories)
  if (event.categories != "" && bwJsWidgetOptions.displayTagsInDetails) {
    output += "<div class=\"bwEventCats\">"
    output += "Tags: " + event.categories;
    output += "</div>";
  }

  // output link
  if (event.link != "") {
    output += "<div class=\"bwEventLink\">"
    output += "See: <a href=\"" + event.link + "\">" + event.link + "</a>";
    output += "</div>";
  }
  output += "</div>";

  // create a link back to the main view
  output += "<p id=\"bwEventsListLink\"><a href=\"javascript:insertBwEvents('" + outputContainerID + "')\">Return</a>";

  // Send the output to the container:
  outputContainer.innerHTML = output;
}
