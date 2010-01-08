function getCacheUrlPrefix() {
  return urlPrefix = "http://localhost:8080/webcache/v1.0/"
}

// use JQuery UI slider widget for number of days
$(function() {
  $("#slider").slider({
    range: "min",
    min: 0,
    max: 31,
    value: 7,
    slide: function(event, ui) {
      $("#numDays").val(ui.value);
      updateUrlDisplay();
    }
  });
  $("#numDays").val($("#slider").slider("value"));
});

// use JQuery UI datepicker widget for start date and end date
$(function() {
  $("#startDate").datepicker({
    dateFormat: 'yymmdd',
    onSelect: function(dateText, inst) {
      updateUrlDisplay();
    }
  });
});

$(function() {
  $("#endDate").datepicker({
    dateFormat: 'yymmdd',
    minDate: $('#startDate').datepicker('getDate'),
    onSelect: function(dateText, inst) {
      updateUrlDisplay();
    }
  });
});

// $("#startDate").click(function() {
//  $("#numDays").find("em").css({color:"#993300", fontWeight:"bold"});
// });

//######### category functions ##########

function sortByFirstColumn(a, b) {
  var x = a[0].toLowerCase();
  var y = b[0].toLowerCase();
  return ((x < y) ? -1 : ((x > y) ? 1 : 0));
}

var cats; // holds category tree returned by script call to the feeder app.

function getCatAndLimitData() {

  cats = catsObj;
  processRegularCatData("#categoriesTableBody","includeCatChecks");
  processOrgCatData("#categoriesTableBody", "includeCatChecks");
  processRegularCatData("#excludeCatTableBody", "excludeCatChecks");
  processOrgCatData("#excludeCatTableBody", "excludeCatChecks");
  processLimitCatData();
}

function sortByValue(a, b) {
  a = a.value;
  b = b.value;
  return a == b ? 0 : (a < b ? -1 : 1)
}

function processOrgCatData(appendToElem, checksObj) {

  //set n to the number of columns
  var n = 3;
  var column = 1;
  var trLine = "<tr><th>Organizations:</th></tr><tr>";
  var tdLine;
  var currentCreator = "";
  $.each(cats.bwCategories.categories.sort(sortByValue), function(i, category) {
    // skip over any system categories
    if ((category.value.substring(0, 4) != 'sys/') && (category.value.substring(0, 4) == 'org/')) {
      catKeyword = category.value;
      catID = category.uid;
      tdLine = "<td><input type=\"checkbox\" name=\"" + checksObj + "\" onclick=\"updateUrlDisplay()\" value=\"" + catID + "\">" + catKeyword + "</td>"
      //arrange the categories -- n checkboxes per line
      if (column != n) {
        trLine += tdLine;
        column++;
      } else {
        trLine = trLine + tdLine + "</tr>";
        $(appendToElem).append(trLine);
        trLine = "<tr>"
        column = 1;
      }
    }
  });
  if (column == 1) {
    lastLine = "</tr>";
  } else {
    lastLine = trLine + "</tr>";
  }
  $(appendToElem).append(lastLine);
}

function processRegularCatData(appendToElem, checksObj) {

  //set n to the number of columns
  var n = 3;
  var column = 1;
  var trLine = "<tr><th>General:</th></tr><tr>";
  var tdLine;
  var currentCreator = "";
  $.each(cats.bwCategories.categories.sort(sortByValue), function(i, category) {
    // skip over any system categories
    if ((category.value.substring(0, 4) != 'sys/') && (category.value.substring(0, 4) != 'org/')) {
      catKeyword = category.value;
      catID = category.uid;
      tdLine = "<td><input type=\"checkbox\" name=\"" + checksObj + "\" onclick=\"updateUrlDisplay()\" value=\"" + catID + "\">" + catKeyword + "</td>"
      //arrange the categories -- n checkboxes per line
      if (column != n) {
        trLine += tdLine;
        column++;
      } else {
        trLine = trLine + tdLine + "</tr>";
        $(appendToElem).append(trLine);
        trLine = "<tr>"
        column = 1;
      }
    }
  });

  if (column == 1) {
    lastLine = "</tr>";
  } else {
    lastLine = trLine + "</tr>";
  }
  $(appendToElem).append(lastLine);
}

function replaceAll(text, strA, strB) {
  while (text.indexOf(strA) != -1) {
    text = text.replace(strA, strB);
  }
  return text;
}

function processLimitCatData() {
//      trLine = "<tr><td><input type=\"radio\" checked\=\"checked\" id=\"no--Limit\" name=\"limitCatCheck\" onclick=\"updateUrlDisplay()\" value=\"all\">No Limit</td></tr>";
//      $("#limitTable").append(trLine);
  $.each(cats.bwCategories.categories.sort(sortByValue), function(i, category) {
    if (category.value.substring(0, 4) == 'org/') {
      trLine = "<tr><td><input type=\"radio\" id=\"Limit" + category.value + "\" name=\"limitCatCheck\" onclick=\"updateUrlDisplay()\" value=\"" + category.uid + "\">" + category.value.substring(4) + "</td></tr>";
      $("#limitTable").append(trLine);
    }
  });
}


function getLimitCatValue() {
if (document.getElementById('noLimit').checked == true) {
    return ""
  } else {
    return "catuid=('" + $("input[name='limitCatCheck']:checked").val() + "')";
  }
}

// construct category parameters
function constructIncludeCategoryList() {
  var categoryIDList = "";
  $("input[name='includeCatChecks']:checked").each(function() {
    if (categoryIDList == "") {
      categoryIDList = "catuid='" + this.value + "'";
    } else {
      categoryIDList = categoryIDList + "|catuid='" + this.value + "'";
    }
  });
  return '(' + categoryIDList + ')';
}

// construct category parameters
function constructExcludeCategoryList() {
  var categoryIDList = "";
  $("input[name='excludeCatChecks']:checked").each(function() {
    if (categoryIDList == "") {
      categoryIDList = "!catuid='" + this.value + "'";
    } else {
      categoryIDList = categoryIDList + "&!catuid='" + this.value + "'";
    }
  });
  return '(' + categoryIDList + ')';
}


//##### end of category/limit functions


function constructURL() {

  // five cases:
  //   (1)  ics with number of days specified.  Other parameters: limitCategory, categories
  //   (2)  ics with date range specified.  Other parameters: limitCategory, categories
  //   (3)  other feed with number of days specified.  Other parameters: skin, limitCategory, categories
  //   (4)  other feed with date range specified.  Other paramters: skin, limitCategory, categories
  //   (5)  other feed for week or month period specified (widget only)

  ics = false;
  byDays = false;
  // weekOrMonth = false;
  jsonObject = false;

  // byDays?  If byDays, get number of days, else get start and end dates.
  if (document.getElementById('startEndDates').checked == true) {
    startDate = document.getElementById('startDate').value;
    if (startDate == "") {
      startDate = '00000000';
    }
    endDate = document.getElementById('endDate').value;
    if (endDate == "") {
      endDate = '00000000';
    }
    dates = startDate + '/' + endDate;
  } else {
    byDays = true;
    numberOfDays = document.getElementById('numDays').value;
  }

  // Feed. ics?  If not, get skin.  ics doesn't need a skin.
  if (document.getElementById('ics').checked == true) {
    ics = true;
  } else {
    skin = $("input[name='dataType']:checked").val();
  }

  // Widget?  set skin.

  if (document.getElementById('widget').checked == true) {
    //widget
    // outputType = $("input[name='output']:checked").val();
    // if (document.getElementById('list').checked == true) {
    //list
    if (outputType == "iframe") {
      // iframe
      skin = "list-html";
    } else {
      // javascript
      skin = "list-json";
      jsonObject = true;
    }
  } // else {
  //week or month grid
  //  weekOrMonth = true;
  //  if (outputType == "iframe") {
  // iframe
  //    skin = "grid-html";
  //  } else {
  // javascript
  //skin = "grid-json";
  //jsonObject = true;
  //}
  //}
  //}

  // if (weekOrMonth) {
  //  if (document.getElementById('week').checked == true) {
  //    constructedURL = getCacheUrlPrefix() + "genFeedPeriod" + "/week/00000000/" + skin + "/";
  //  } else {
  //    constructedURL = getCacheUrlPrefix() + "genFeedPeriod" + "/month/00000000/" + skin + "/";
  //  }
  //} else
  if (ics) {
    if (byDays) {
      constructedURL = getCacheUrlPrefix() + "icsDays" + "/" + numberOfDays + "/";
    } else {
      constructedURL = getCacheUrlPrefix() + "icsRange" + "/" + dates + "/";
    }
  } else {
    if (byDays) {
      constructedURL = getCacheUrlPrefix() + "genFeedDays" + "/" + numberOfDays + "/" + skin + "/";
    } else {
      constructedURL = getCacheUrlPrefix() + "genFeedRange" + "/" + dates + "/" + skin + "/";
    }
  }

  filterExpression = "";
  inCatList = constructIncludeCategoryList();
  exCatList = constructExcludeCategoryList();
  limitCat = getLimitCatValue();
  if ((inCatList != '()') || (exCatList != '()')) {
    if (inCatList == '()') {
      filterExpression = exCatList;
    } else if (exCatList == '()') {
      filterExpression = inCatList;
    } else {
      filterExpression = inCatList + '&' + exCatList;
    }
  }
  if (limitCat != "") {
    if ( filterExpression == "") {
      filterExpression = limitCat;
    } else {
      filterExpression += '&' + limitCat;
    }
  }

  if ( filterExpression == "" ) {
    constructedURL += "-no-filter-";
  } else {
    constructedURL += escape(filterExpression);
  }

  if (jsonObject == true ) {
    constructedURL += '/bwObject';
  }
  return constructedURL;
}

function updateUrlDisplay() {

  if (document.getElementById('widget').checked == true) {
    outputType = $("input[name='output']:checked").val();
    if (outputType == "iframe") {
      code = "<iframe src=\"" + constructURL() + "</iframe>";
      document.getElementById('functions').innerHTML = code;
    } else {
      url = constructURL();
      bwJsLoc = window.location + 'javascript/bedework/'
      jsHtml = '<div id="bwOutput"></div>\n';
      jsHtml += '<';
      // if (skin == "list-json") {
      jsHtml += 'script type="text/javascript" src="' + bwJsLoc + 'listEvents.js"> &lt/script>\n';
      // } else {
      //  jLine3 += 'script type="text/javascript" src="gridEvents.js"> &lt/script>\n';
      // }
      jsHtml += '<';
      jsHtml += 'script type="text/javascript" src="' + url + '"> &lt/script>\n';
      jsHtml += '<';
      jsHtml += 'script>\n'
      jsHtml += '  bwJsListWidgetOptions = {\n'
      jsHtml += "    calendarServer: 'http://localhost:8080',\n"
      jsHtml += "    calSuiteContext: '/cal',\n"
      jsHtml += "    showTitle: " + $("input[name='jsShowTitle']:checked").val() + ",\n"
      jsHtml += "    title: " + $("input[name='jsSetTitleName']:checked").val() + ",\n"
      jsHtml += "    displayLocationInList: " + $("input[name='jsDisplayLocation']:checked").val() + ",\n"
      jsHtml += "    displayStartDateOnlyInList: " + $("input[name='jsDisplayStartDateOnly']:checked").val() + ",\n"
	  jsHtml += "    displayTimeInList: " + $("input[name='jsDisplayTime']:checked").val() + ",\n",
	  jsHtml += "    listMode: " + $("input[name='jsDisplayDateOrTitle']:checked").val() + ", // values: 'byDate' or 'byTitle'\n"    
      jsHtml += "    displayEventDetailsInline: " + $("input[name='jsDisplayInline']:checked").val() + ",\n"
      jsHtml += "    displayContactInDetails: " + $("input[name='jsDisplayContactInDetails']:checked").val() + ",\n"
      jsHtml += "    displayCostInDetails: " + $("input[name='jsDisplayCostInDetails']:checked").val() + ",\n"
      jsHtml += "    displayTagsInDetails: " + $("input[name='jsDisplayTags']:checked").val() + ",\n"
      jsHtml += "    displayTimezoneInDetails: " + $("input[name='jsDisplayTimezone']:checked").val() + ",\n"
      jsHtml += '  }\n'
      jsHtml += '  insertEvents("bwOutput")\n'
      jsHtml += '&lt/script>\n'
      document.getElementById('functions').innerHTML = jsHtml;
    }
  } else {
    document.getElementById('UrlBox').innerHTML = constructURL();
    document.getElementById('UrlBox').href = constructURL();
  }
}

function uncheckAll(checkList) {
$("input[name=$checkList]:checked").each(function() {
    $(this).removeAttr("checked");
  });
  updateUrlDisplay();
}