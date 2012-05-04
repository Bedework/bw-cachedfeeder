//
//  Licensed to Jasig under one or more contributor license
//  agreements. See the NOTICE file distributed with this work
//  for additional information regarding copyright ownership.
//  Jasig licenses this file to you under the Apache License,
//  Version 2.0 (the "License"); you may not use this file
//  except in compliance with the License. You may obtain a
//  copy of the License at:
//
//  http://www.apache.org/licenses/LICENSE-2.0
// 
//  Unless required by applicable law or agreed to in writing,
//  software distributed under the License is distributed on
//  an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
//  KIND, either express or implied. See the License for the
// specific language governing permissions and limitations
// under the License.
//

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

$(function() {
  $("#limitSlider").slider({
    range: "min",
    min: 0,
    max: 50,
    value: 5,
    slide: function(event, ui) {
      $("#jsLimit").val(ui.value);
      updateUrlDisplay();
    }
  });
  $("#jsLimit").val($("#limitSlider").slider("value"));
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
      // NTFS doesn't like the | character and cache may be stored on NTFS
      categoryIDList = categoryIDList + "-_catuid='" + this.value + "'";
    }
  });
  return '(' + categoryIDList + ')';
}

// construct category parameters
function constructExcludeCategoryList() {
  var categoryIDList = "";
  $("input[name='excludeCatChecks']:checked").each(function() {
    if (categoryIDList == "") {
      categoryIDList = "catuid!='" + this.value + "'";
    } else {
      categoryIDList = categoryIDList + "&catuid!='" + this.value + "'";
    }
  });
  return '(' + categoryIDList + ')';
}


//##### end of category/limit functions


function constructURL() {

  var ics = false;
  var byDays = false;
  // var weekOrMonth = false;
  var jsonObject = false;
  var numberOfDays = 7;
  var outputLang = "";

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
	outputLang = $("input[name='dataType']:checked").val();
    skin = 'list-' + outputLang;
  }

  // Widget?  set skin.

  if (document.getElementById('widget').checked == true) {
    //widget
    // outputType = $("input[name='output']:checked").val();
    // if (document.getElementById('list').checked == true) {
    //list
    if (outputLang == "iframe") {
      // iframe
      skin = "list-html";
      outputLang = "html";
    } else {
      // javascript
      skin = "list-json";
      outputLang = "json";
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
      constructedURL = getCacheUrlPrefix() + outputLang + "Days" + "/" + numberOfDays + "/" + skin + "/";
    } else {
      constructedURL = getCacheUrlPrefix() + outputLang + "Range" + "/" + dates + "/" + skin + "/";
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
    constructedURL += "no--filter";
  } else {
    constructedURL += escape(filterExpression);
  }

  if (outputLang == 'json') {
	if (jsonObject == true ) {
      constructedURL += '/bwObject';
    } else {
      constructedURL += '/no--object';
    }
  }
  if (ics) {
    return constructedURL + '.ics';
  } else {
    return constructedURL + '.' + outputLang;
  }
}

function updateUrlDisplay() {

  if (document.getElementById('widget').checked == true) {
    //outputType = $("input[name='output']:checked").val();
    //if (outputType == "iframe") {
    //  code = "<iframe src=\"" + constructURL() + "</iframe>";
    //  document.getElementById('functions').innerHTML = code;
    //} else {
      url = constructURL();
      bwJsLoc = window.location + 'javascript/bedework/'
      jsHtml = '<textarea name="functions" id="functions" rows="20" cols="78">';
      jsHtml += '<div id="bwOutput"></div>\n';
      // if (skin == "list-json") {
      jsHtml += '<script type="text/javascript" src="' + bwJsLoc + 'listEvents.js"> </script>\n';
      // } else {
      //  jLine3 += 'script type="text/javascript" src="gridEvents.js"> </script>\n';
      // }
      jsHtml += '<script type="text/javascript" src="' + url + '"> </script>\n';
      jsHtml += '<script type="text/javascript">\n'
      jsHtml += '  bwJsWidgetOptions.title = "' + $("input[name='jsTitleName']").val() + '";\n';
      jsHtml += '  bwJsWidgetOptions.showTitle = ' + $("input[name='jsShowTitle']:checked").val() + ';\n';
      jsHtml += '  bwJsWidgetOptions.displayDescription = ' + $("input[name='jsDisplayDescription']:checked").val() + ';\n';
      jsHtml += '  bwJsWidgetOptions.displayEventDetailsInline = ' + $("input[name='jsDisplayInline']:checked").val() + ';\n';
      jsHtml += '  bwJsWidgetOptions.displayStartDateOnlyInList = ' + $("input[name='jsDisplayEndDate']:checked").val() + ';\n';
      jsHtml += '  bwJsWidgetOptions.displayTimeInList = ' + $("input[name='jsDisplayTime']:checked").val() + ';\n';
      jsHtml += '  bwJsWidgetOptions.displayLocationInList = ' + $("input[name='jsDisplayLocation']:checked").val() + ';\n';
      jsHtml += '  bwJsWidgetOptions.limitList = ' + $("input[name='jsLimitList']:checked").val() + ';\n';
      jsHtml += '  bwJsWidgetOptions.limit = ' + jsLimit.value + ';\n';
      jsHtml += '  bwJsWidgetOptions.listMode = "' + $("input[name='jsDisplayDateOrTitle']:checked").val() + '";\n';
      jsHtml += '  bwJsWidgetOptions.displayContactInDetails = ' + $("input[name='jsDisplayContactInDetails']:checked").val() + ';\n';
      jsHtml += '  bwJsWidgetOptions.displayCostInDetails = ' + $("input[name='jsDisplayCostInDetails']:checked").val() + ';\n';
      jsHtml += '  bwJsWidgetOptions.displayTagsInDetails = ' + $("input[name='jsDisplayTags']:checked").val() + ';\n';
      jsHtml += '  bwJsWidgetOptions.displayTimezoneInDetails = ' + $("input[name='jsDisplayTimezone']:checked").val() + ';\n\n';
      jsHtml += '  insertBwEvents("bwOutput");\n'
      jsHtml += '</script>\n';
      jsHtml += '</textarea>';

      document.getElementById('codeBoxOutput').innerHTML = jsHtml;
    //}
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