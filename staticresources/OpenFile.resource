function OpenPopUp(url)
{
debugger;
   
    document.getElementById('frameFileUrl').setAttribute('src', '');
    var sDomain = getDomainName(url);
    var endpoint = '';
    var start = url.lastIndexOf("/");
    var finish =  nth_occurrence (url, ":", 2);
    
    var parentDoc = url.substring(start+1, finish);
    parentDoc=parentDoc.replace('=','%3d');
    if (sDomain == window.domainWWS) {
if(nth_occurrence (url, ":", 2) > -1){
        endpoint = "https://it-services-gw-itg.external.hp.com/gw/esit/sfdc/idol.dev/action=query%26text=*%26databasematch=slp%26totalresults=true%26fieldtext=STRING%7B"+parentDoc+"%7D:drereference%26printfields=drefilename";
}
else if(url.indexOf('?')!=-1)
{
endpoint="https://it-services-gw-itg.external.hp.com/gw/esit/sfdc/idol.dev/?action=query&text=*&databasematch=slp&totalresults=true&printfields=drefilename&matchreference="+encodeURIComponent(url);
}
else
{
endpoint = "https://it-services-gw-itg.external.hp.com/gw/esit/sfdc/idol.dev/a=query&text=*&printfields=drefilename&databasematch=SLP&IgnoreCache=true&IgnoreCache=true&matchreference=" + url;
}
         $("#lnkDownloadFile").removeAttr('href');
        $.ajax({
            url: endpoint,
            dataType:'xml',
            type: 'GET',
            async:false,
            crossDomain: true,
            xhrFields: {
                withCredentials: true
            },
            success: function(xml) {
                
                $(xml).find('autnresponse').each(function(){
                    $(this).find("responsedata").each(function(){
			var links = [];
                        $(this).find("hit").each(function(){
                            $(this).find("content").each(function(){
                                var link = $(this).text();
				links.push(link);
                                GetResponseURFLForDomainWWS(links);
                            });
                        });
                    });
                });
            }
        });
DownloadDoc();
    
    }
    else if ((sDomain == window.domainSP) ||(sDomain == window.ESIntranet))
    {
        if(url.indexOf('.txt')!=-1 || url.indexOf('.pdf')!=-1 || url.indexOf('.TXT')!=-1 || url.indexOf('.PDF')!=-1)
        {
        $('#lnkDownloadFile').attr('href','https://it-services-gw-itg.external.hp.com/gw/esit/sfdc/idol.dev/action=View&NoACI=true&OutputType=raw&EmbedImages=true&reference='+url);
                $('#lnkDownloadFile')[0].click();
                return true;
        }
        else
        {
                window.location = "https://it-services-gw-itg.external.hp.com/gw/esit/sfdc/idol.dev/action=View&NoACI=true&OutputType=raw&EmbedImages=true&IgnoreCache=true&reference=" + url;
                return;
        }
    }
    else if (sDomain == window.domainEXO)
    {
if(url.indexOf('.txt')!=-1 || url.indexOf('.pdf')!=-1 || url.indexOf('.TXT')!=-1 || url.indexOf('.PDF')!=-1)
{
$('#lnkDownloadFile').attr('href',url);
        $('#lnkDownloadFile')[0].click();
        return true;
}
else
{
       window.location=url;
       return;
    }
}
    else
    {
        
        $('#lnkDownloadFile').attr('href',url);
        $('#lnkDownloadFile')[0].click();
        return true;
    }
}

function DownloadDoc()
      {
debugger;
     
      var aDocURL=$("#lnkDownloadFile").attr('href');
      var url='';
      var arrDocURL ='';
      if(aDocURL!=null || aDocURL!='')
	  {
      if(aDocURL.indexOf(',')!=-1)
      { 
      arrDocURL=aDocURL.split(",");
             //var urlToUse="";
	if(arrDocURL.length == 1)
	{
	window.open("https://it-services-gw-itg.external.hp.com/gw/esit/sfdc/idol.dev/action=View&NoACI=true&OutputType=raw&EmbedImages=true&IgnoreCache=true&reference=" + arrDocURL[0],'_blank');
	window.focus();
	return;
	}

             for (i = 0; i < arrDocURL.length; i++) { 
				if(arrDocURL[i].indexOf('javascript:void(0)')!=-1)
				{
				return false;
				}
				else
				{
							 url=arrDocURL[i];
							 url=url.replace(/ /g,"%20");
							 //urlToUse = "https://it-services-gw-itg.external.hp.com/gw/esit/sfdc/idol.dev/action=View&NoACI=true&OutputType=raw&EmbedImages=true&IgnoreCache=true&reference=" + url ;             
					   
							 DoSetTimeout(i, url)
				}
       
			}// end of for
        }
        else
        {
			if(aDocURL.indexOf('javascript:void(0)')!=-1)
			{
			return false;
			}
			else
			{
					window.open("https://it-services-gw-itg.external.hp.com/gw/esit/sfdc/idol.dev/action=View&NoACI=true&OutputType=raw&EmbedImages=true&IgnoreCache=true&reference="+aDocURL,'_blank');
window.focus();
					}                
      }
	  }
}
      
         function DoSetTimeout(i, documentTitle) {
         setTimeout(function() {  
             window.location= "https://it-services-gw-itg.external.hp.com/gw/esit/sfdc/idol.dev/action=View&NoACI=true&OutputType=raw&EmbedImages=true&IgnoreCache=true&reference=" + documentTitle; 
         }, i*1000);
         }

function getDomainName(url) {
    var r = /:\/\/(.[^/]+)/;
    return url.match(r)[1];
}

$( document ).ready(function() {
    window.domainSP = 'prime31.sharepoint.hp.com';
    window.domainWWS = 'ensv.hp.com';
    window.domainEXO = 'it-services-gw-itg.external.hp.com';
	window.ESIntranet= 'intranet.hp.com/enterpriseservices/ww';
});
  
function GetResponseURL(result)
{
   
if(result[0].indexOf('.txt')!=-1 || result[0].indexOf('.TXT')!=-1 || result[0].indexOf('.PDF')!=-1 || result[0].indexOf('.pdf')!=-1)
{
$('#lnkDownloadFile').attr('href','https://it-services-gw-itg.external.hp.com/gw/esit/sfdc/idol.dev/action=View&NoACI=true&OutputType=raw&EmbedImages=true&reference='+result);
        $('#lnkDownloadFile')[0].click();
$('#lnkDownloadFile').attr('href','javascript:void(0)');
        return true;
}
else
{
    $("#lnkDownloadFile").removeAttr('href');
    //var url='https://it-services-gw-itg.external.hp.com/gw/esit/sfdc/idol.dev/action=View&NoACI=true&OutputType=raw&EmbedImages=true&reference='+result;
    //var url=result.replace(/amp;/g,"");
    //url=url.replace(/ /g,"%20");
  
    $("#lnkDownloadFile").attr('href',result);
}
return;

}

function GetResponseURFLForDomainWWS(result)
{
debugger;
    
    $("#lnkDownloadFile").removeAttr('href');
    $("#lnkDownloadFile").attr('href',result);

}

function nth_occurrence (string, char, nth) {
    var first_index = string.indexOf(char);
    var length_up_to_first_index = first_index + 1;

    if (nth == 1) {
        return first_index;
    } else {
        var string_after_first_occurrence = string.slice(length_up_to_first_index);
        var next_occurrence = nth_occurrence(string_after_first_occurrence, char, nth - 1);

        if (next_occurrence === -1) {
            return -1;
        } else {
            return length_up_to_first_index + next_occurrence;  
        }
    }
} 