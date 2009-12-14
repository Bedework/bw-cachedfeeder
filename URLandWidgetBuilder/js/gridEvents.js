// Insert Bedework calendar events from a json feed

// Events in json object are expected this way:
//    bwEventCalendar
//       year
//         value = 20xx
//         month
//           value 
//           shortname
//           longname
//           weeks [
//            value = [1-5]
//            days [
//               filler = {yes,no}
//               value = [1-7]
//               name = {Monday, Tuesday, ...}
//               ...
//               events [
//                  event info

function cacheFeederUrl() { 
  return "http://localhost:3000";
}

function monthView(outputContainerID, groupAndCats) {
  var outputContainer = document.getElementById(outputContainerID);
  var output = "";
  var weekList = new Array();
  var weekIndex = 0;

  if ((bwObject.bwEventCalendar != undefined) && (bwObject.bwEventCalendar.year.month != undefined)) {
    output += '<table id="monthCalendarTable" border="0" cellpadding="0" cellspacing="0">';
    for (i = 0; i < bwObject.bwEventCalendar.year.month.weeks.length; i++) {
	  weekList[weekIndex] = i;
	  weekIndex++;
	}
  }
 
  for (i in weekList) {
    // provide a shorthand reference to the week;
    var week = bwObject.bwEventCalendar.year.month.weeks[weekList[i]];
    output += '  <tr>';
    output += weekView(week, groupAndCats);
    output += '  </tr>';
  }
  output += '</table>';
  outputContainer.innerHTML = output;
}

function weekView(week, groupAndCats) { 
  var output = "";
  var dayList = new Array();
  var dayIndex = 0;
  for (i = 0; i < week.days.length; i++) {
	dayList[dayIndex] = i;
    dayIndex++;
  }

  output += '  <tr>';
  for (i in dayList) {
    var day = week.days[dayList[i]];  
    output += dayView(day, i, groupAndCats);
  }
  output += '  </tr>';
  return output;
}

function dayView(day, dayPos, groupAndCats) {
  var output = "";
  var eventList = new Array();
  var eventIndex = 0; 
  if ( day.filler == "true" ) {
    output += '  <td class="filler">&#160</td>';
  } else {
	output += '  <td>';
    //if ( bedework.now.date == date ) {
      // <xsl:attribute name="class">today</xsl:attribute>
    //}
	output += '<a href="' + cacheFeederUrl() + '/v1.0/genFeedPeriod/day/' + day.date; 
	output += '/grid-html/' + groupAndCats + '" class="dayLink">' + day.value + '</a>';

    for (i = 0; i < day.events.length; i++) {
	  eventList[eventIndex] = i;
	  eventIndex++;
    }
    output += '  <ul>';

    for (i in eventList) {
      var event = day.events[eventList[i]];  
      output += eventView(event, dayPos, day.shortdate);
    }
    output += '  </ul>';
    output += '</td>';  
  }
  return output;
}

function eventView(event, dayPos, dayShortDate) {
  var xpropertiesList = new Array();
  var xpropertiesIndex = 0;
  output = "";

  // catPath = calendar.encodedPath;

  switch (event.status) {
	case 'CANCELLED': 
	  eventClass = "eventCancelled";
	  break;
	case 'TENTATIVE':
	  eventClass = "eventTentative";
	  break;
	default:
	  // Special styles for the month grid
	  // if ( position() mod 2 == 1 {
	  eventClass = "eventLinkA";
	  //} else {
	  //   eventClass = "eventLinkB";
	  //}
  }

  // These are set in the add/modify subscription forms in the admin client;
  // if present, these override the background-color set by eventClass. The
  // subscription styles should not be used for canceled events (tentative is ok).

//	  <xsl:variable name="subscriptionClass">
//	    <xsl:if test="status != 'CANCELLED'">
//	      <xsl:apply-templates select="categories" mode="customEventColor"/>
//	    </xsl:if>
//	  </xsl:variable>
  output += '<li>';
  output += '<a href="' + cacheFeederUrl() + '/v1.0/event/list-html/' + event.recurrenceId + '/' + event.guid + '"';
  // output += ' class="{$eventClass} {$subscriptionClass}'
  output += '>';

  if (status == 'CANCELLED') {
    output += 'Cancelled: ';  // bwStr-EvCG-CanceledColon
    output += ' ';
  }
  if (event.start.shortdate != dayShortDate) {
    output += 'Cont: '; // $bwStr-EvCG-Cont;
  } else if (event.start.allday == 'false') {
    output += event.start.time + ' ';
  } else {
    output += 'All Day: '; // $bwStr-EvCG-AllDayColon
  }
  output += event.summary;

  // Build tool tips that display event information.
  if ( dayPos > 5) {
    eventTipClass = 'eventTipReverse';
  } else {
    eventTipClass = 'eventTip';
  }
  output += '<span class="' + eventTipClass + '">';
  if (status == 'CANCELLED') {
    output += '<span class="eventTipStatusCancelled">Cancelled: </span>';  //'$bwStr-EvCG-CanceledColon</span>';
  }
  if (status == 'TENTATIVE') {
    output += '<span class="' + eventTipClass + '">Tentative: </span>';    //$bwStr-EvCG-Tentative</span>';
  }
  output += '<strong>' + event.summary + '</strong><br/>';
  output += 'Time: ';  //'$bwStr-EvCG-Time';
  if ( event.start.allday == "true") {
    output += 'All Day: '; // $bwStr-EvCG-AllDay';
  } else {
    if (event.start.shortdate != dayShortDate) {
      output += event.start.month + '/' + event.start.day;
      output += ' ';
    }
    output += event.start.time;
    if ((event.start.time != event.end.time) || (event.start.shortdate != event.end.shortdate)) {
      output += '-';
      if (event.end.shortdate != dayShortDate) {
        output += event.end.month + '/' + event.end.day;
        output += ' ';
      }
      output += event.end.time;
    }
  }
  output += '<br/>';
  if (event.location.address != undefined) {
    output += 'Location:'; //'$bwStr-EvCG-Location';
    output += ' ';
    output += event.location.address;
    output += '<br/>';
  }
  for (i = 0; i < event.xproperties.length; i++) {
    xpropertiesList[xpropertiesIndex] = i;
    xpropertiesIndex++;
  }

  firstOne = true; 
  for (i in xpropertiesList) {
    var xproperty = event.xproperties[xpropertiesList[i]];
    if (xproperty["X-BEDEWORK-ALIAS"] != undefined) {
	  stringLoc = xproperty["X-BEDEWORK-ALIAS"].values.text.lastIndexOf('/');
	  topArea = xproperty["X-BEDEWORK-ALIAS"].values.text.slice(stringLoc + 1);
	  if (firstOne) {
        output += 'TopicalArea: ' + topArea;
        firstOne = false;
      } else {
        output +=  ', ' + topArea;
      }
    }
  }
  output += '</span>';
  output += '</a>';
  output += '</li>';
  return output;
}
