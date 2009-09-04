/**
 * @author jeremy
 */

function loadData(url){
    var baseurl = url;
    var surl = baseurl + '&callback=?';
    $.getJSON(surl);

}

function rssItems(listData){
    var items = listData.recent_items;
    var responseList = '<ul>';
    var placeSingle = function() {
            for (var k = 0; k < items.length; k++) {
            var rand_no = Math.random();
            rand_no = rand_no * (items.length - 1);
            rand_no = Math.ceil(rand_no);
            
            if(items[rand_no].item_link) {
                responseList +="<li><a href=\"" + items[rand_no].item_link + "\"><img src=\"" + items[rand_no].item_link + "\" /></a></li>";
               // alert(items[rand_no].item_link);
                items.splice(rand_no,1);
                   //alert(items[rand_no].item_link);
                break;
            };
         }
        responseList += "</ul>";
        $("#dida_host").html(responseList);
         
    }
    var placeHidden = function() {
        responseList = '<ul>';
                for (var i = 1; i < items.length; i++) {
        if(items[i].item_link){ //<a href="image1.jpg"><img src="thumb_image1.jpg" width="72" height="72" alt="" /></a>
  
                        responseList += "<li style=\"display:none\" ><a href=\"" + items[i].item_link + "\"><img src=\"\" alt=\"Something\" /></a></li>";           
        }
        };
        responseList += "</ul>";
        $("#hidden_host").html(responseList);
    }
    placeSingle();
    placeHidden();
  
    var dida_array = document.getElementById('dida_host').getElementsByTagName('img');
    for (var j = 0; j < dida_array.length; j++) {
          ResizeImage(dida_array[j], 238, 188);
    };
  
  //  $(function() {
/*
	// Use this example, or...
	$('a[@rel*=lightbox]').lightBox(); // Select all links that contains lightbox in the attribute rel
	// This, or...
	$('#gallery a').lightBox(); // Select all links in object with gallery ID
	// This, or...
	$('a.lightbox').lightBox(); // Select all links with lightbox class
	// This, or...
*/
	$('#dida_container a').lightBox(); 
	// ... The possibility are many. Use your creative or choose one in the examples above
//});

 
    /*
 document.getElementById("trigger").onmouseover = function(){
         //$('#dida_host').remove();
        // var addMore = document.createElement('div');
        //addMore.id = "dida_host";
        // document.body.appendChild(addMore);
        
        if (this.id !== 'none') {
            //alert('I see you');
            loadData('http://cdss1995.oit.duke.edu:4567/gen_rss/jsonp/20/http://eflyer.duke.edu/feed/?');
        }
        
        
        
        
        
        this.id = "none"
    };
*/

}
function ResizeImage(image, maxwidth, maxheight)
{
  
        var w = image.width;
        var h = image.height;
               // alert(h + ' ' + w);
        if( w == 0 || h == 0 )
        {
            image.width = maxwidth;
            image.height = maxheight;
        }
        else if (w > h)
        {
            if (w > maxwidth) {
                image.width = maxwidth
            };
        }
        else
        {
            if (h > maxheight) {
                image.height = maxheight;
            }
        }
                
        //image.className = "ScaledThumbnail";
  
}