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

function cacheFeederUrl () { 
  return "http://localhost:3000"
}
function monthView (outputContainerID, groupAndCats) {
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
    output += dayView(day, groupAndCats);
  }
  output += '  </tr>';
  return output;
}

function dayView(day, groupAndCats) {
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
      output += eventView(event);
    }
    output += '  </ul>';
    output += '</td>';
    return output;
  }
}

function eventView(event) {
  output = "";
		
  // catPath = calendar.encodedPath;
  // guid = guid;
  // recurrenceId = recurrenceId;
  // switch (status)
//	   case 'CANCELLED': 
//	      eventClass = "eventCancelled";
//	      break;
//	    case 'TENTATIVE':
//	      eventClass = "eventTentative";
//	      break;
//	    default:
//	      // Special styles for the month grid
//	      if ( position() mod 2 == 1 {
//	        eventClass = "eventLinkA";
//	      } else {
//		    eventClass = "eventLinkB"
//	      }
//	    }
//	  }
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

//	  if (status='CANCELLED') {
//	    output += $bwStr-EvCG-CanceledColon;
//	    output += ' ';
//	  }
//	  if (start/shortdate != ../shortdate) {
//	    output += $bwStr-EvCG-Cont;
//	  } else if (start/allday = 'false') {
//	    output += start/time;
//	  } else 
//	    output += $bwStr-EvCG-AllDayColon;
//	  }
//	  output += summary
//	  if ( $dayPos > 5) {
//	    eventTipClass = eventTipReverse;
//	  } else {
//		eventTipClass = eventTip;
//	  }
//	  if (status='CANCELLED') {
//		output += '<span class="eventTipStatusCancelled">$bwStr-EvCG-CanceledColon</span>';
//	  } else {
//	    output += '<span class=$eventTipClass>$bwStr-EvCG-Tentative</span>';
	    output += '<strong>' + event.summary + '</strong><br/>';
//	    output += '$bwStr-EvCG-Time';
//	    if ( start/allday == "true") {
//	      output += '$bwStr-EvCG-AllDay';
//	    } else {
//	      if (start/shortdate != ../shortdate )
//	        output += '"start/month"/"start/day"';
//	        output += ' ';
//	      }
//	      output += start/time;
//	      if (start/time != end/time) || (start/shortdate != end/shortdate) {
//	        output += '-';
//	        if ( end/shortdate != ../shortdate ) {
//	          output += '"end/month"/"end/day"';
//	          output += ' ';
//	        }
//	        output += end/time;
//	      }
//	    }
//	    output += '<br/>';
//	    if ("location/address" ) {
//	      output += '$bwStr-EvCG-Location';
//	      output += ' ';
//	      output += 'location/address';
//	      output += '<br/>';
//	    }
//	    if ( exists "xproperties/X-BEDEWORK-ALIAS")
//	      ouput += '$bwStr-EvCG-TopicalArea'
//	      for-each select="xproperties/X-BEDEWORK-ALIAS"
//	        <xsl:call-template name="substring-afterLastInstanceOf">
//	          <xsl:with-param name="string" select="values/text"/>
//	          <xsl:with-param name="char">/</xsl:with-param>
//	        </xsl:call-template>
//	       }
//	     }
//	     output += '</span>';
	     output += '</a>';
	     output += '</li>';
//	  }	
  return output;
}
