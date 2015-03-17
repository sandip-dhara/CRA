
      function noenter(e){               
                if(window.event){                    
                    key = window.event.keyCode;     //IE               
                } 
                else{                    
                    key = e.which;     //firefox               
                }               
                if(key == 13) {                    
                hideprevious();               
                    return false;               
                } else{                    
                    return true;               
                }          
            } 
	function hideAccountLink()
    {
        hideAccountLinkAction();
    }	
    function closepopup()
    {
        window.close();
    }
    function popupcase(link)
    {
        var caselink='/'+link;
        var width=(screen.width/10)*7;
        var height=(screen.height/10)*7;
        thiswindow=window.open(caselink,'caselink','resizable=yes,scrollbars=yes,resizable=1,width='+width+',height='+height+',left=0,top=0');
		if (window.focus){ 
			thiswindow.focus() 
		} 
		if (!thiswindow.closed){ 
			thiswindow.focus() 
		}
    }
	function openpopup(link)
    {
        var caselink='/'+link;
        var width=(screen.width/10)*6.9;
        var height=(screen.height/10)*4.1;
        thiswindow=window.open(caselink,'caselink','resizable=yes,scrollbars=yes,scrollbars=yes,resizable=1,width='+width+',height='+height+',left=0,top=0');
		if (window.focus){ 
			thiswindow.focus() 
		} 
		if (!thiswindow.closed){ 
			thiswindow.focus() 
		}		
    }
    function HideTitle()
    {
        document.getElementById('PageID:FormId:searchsection:searchresultsection:searchSection:SearchResultBlock:resulTitletheader').style.display='none';
		 document.getElementById('PageID:FormId:searchsection:searchresultsection:searchSection:SearchResultBlock:NonVerifiedPanelsuccess').style.display='none';
		
    }    
    function showpage()
    {
        document.getElementById('PageID:FormId:searchsection:searchresultsection:searchSection:SearchResultBlock:resulTitletheader').style.display='none';
		document.getElementById('PageID:FormId:searchsection:searchresultsection:searchSection:SearchResultBlock:NonVerifiedPanelsuccess').style.display='none';
        showpagehashtop() ;
    }

    function hideprevious()
    {
       
       if(HP.validate.all()){
           document.getElementById('PageID:FormId:searchsection:searchresultsection:searchSection:OnlySearchResultPanel').style.display='none';
            if(!twistSection(document.getElementById('PageID:FormId:searchsection:searchresultsection').childNodes[0].childNodes[0]))
           {
                twistSection(document.getElementById('PageID:FormId:searchsection:searchresultsection').childNodes[0].childNodes[0]);
            }
            if(twistSection(document.getElementById('PageID:FormId:searchsection:Detailresultsection').childNodes[0].childNodes[0]))
            {
                twistSection(document.getElementById('PageID:FormId:searchsection:Detailresultsection').childNodes[0].childNodes[0])
            }
            if(twistSection(document.getElementById('PageID:FormId:searchsection:searchblocksection').childNodes[0].childNodes[0]))
            {
                twistSection(document.getElementById('PageID:FormId:searchsection:searchblocksection').childNodes[0].childNodes[0])
            }
       searchaction();
       
        }
    }
    function hidepreviousdetail(field,row)
    {
	   //logic to highlight selected record
	   var table=document.getElementById('PageID:FormId:searchsection:searchresultsection:searchSection:SearchResultBlock:j_id17');
	   var rowval;
	   if(field=="Name"){
	    rowval=row/14;
	   }else if(field=="Domestic_DUNS__c"){
	   rowval=(row-9)/14;
	   }else if(field=="Global_DUNS__c"){
	   rowval=(row-10)/14;
	   }
		  for (var r = 0, n = table.rows.length; r < n; r++) {
            for (var c = 0, m = table.rows[r].cells.length; c < m; c++) {
                if(r==rowval+1){
					table.rows[r].cells[c].bgColor = "#87C6F6"; 
                }else{
					table.rows[r].cells[c].bgColor = "#FFFFFF"; 
				}
            }
            
        }
		 //logic to highlight selected record ends  
        document.getElementById('PageID:FormId:searchsection:Detailresultsection:detailpageclock:onlydetailresult').style.display='none';
		document.getElementById('PageID:FormId:searchsection:Detailresultsection:detailpageclock:DetailStatusSection').style.display='none';
		document.getElementById('PageID:FormId:searchsection:Detailresultsection:detailpageclock:DetailStatus').style.display='none';
		//document.getElementById("PageID:FormId:searchsection:Detailresultsection:detailpageclock:DetailResultBlocksection").focus();
       /* if(twistSection(document.getElementById('PageID:FormId:searchsection:searchresultsection').childNodes[0].childNodes[0]))
        {
        //    twistSection(document.getElementById('PageID:FormId:searchsection:searchresultsection').childNodes[0].childNodes[0]);
        }*/
        if(!twistSection(document.getElementById('PageID:FormId:searchsection:Detailresultsection').childNodes[0].childNodes[0]))
        {
            twistSection(document.getElementById('PageID:FormId:searchsection:Detailresultsection').childNodes[0].childNodes[0])
        }
		//Get object
		var SupportDiv = document.getElementById('DetailAnchor');
		window.scroll(0,findPos(SupportDiv));
 
    }
    function hidedetailbackbutton()
    {
        document.getElementById('PageID:FormId:searchsection:searchresultsection:searchSection:OnlySearchResultPanel').style.display='none';
        if(!twistSection(document.getElementById('PageID:FormId:searchsection:searchresultsection').childNodes[0].childNodes[0]))
        {
            twistSection(document.getElementById('PageID:FormId:searchsection:searchresultsection').childNodes[0].childNodes[0]);
        }
        if(twistSection(document.getElementById('PageID:FormId:searchsection:Detailresultsection').childNodes[0].childNodes[0]))
        {
            twistSection(document.getElementById('PageID:FormId:searchsection:Detailresultsection').childNodes[0].childNodes[0])
        }
        if(twistSection(document.getElementById('PageID:FormId:searchsection:searchblocksection').childNodes[0].childNodes[0]))
        {
            twistSection(document.getElementById('PageID:FormId:searchsection:searchblocksection').childNodes[0].childNodes[0])
        }

    }
	//Finds y value of given object
	//Scroll to location of SupportDiv on load
function findPos(obj) {
	var curtop = 0;
	if (obj.offsetParent) {
		do {
			curtop += obj.offsetTop;
		} while (obj = obj.offsetParent);
	return [curtop];
	}
}
// function to ask confirmation before Unverified Account Creation
function confirmUnverifiedAccount(){
  var answer = confirm("This will create an unverified account record. Do you want to continue?");
  if (answer)
  {	
	tooltip.hide();
    CUnveriedAccount();
  }
  	tooltip.hide();
}
// function to ask confirmation before Case Creation
function confirmUnverifiedCase(){
  var answer = confirm("This will create a Case for Subscription. Do you want to continue?");
  if (answer)
  {	
	tooltip.hide();
    CUnveriedCase();
  }
  	tooltip.hide();
}
//function to format Taxid 
function CreateTooltipTail(Taxid){
var Taxidstring= Taxid+'<div id="tail1"></div>'
tooltip.show(Taxidstring);   
}
//function to format Taxid 
function formatTaxId(Taxid){
var Taxidstring= Taxid.replace('|',' : ');
tooltip.show(Taxidstring);   
}
//function to create create 
function DisableCreateAccountbtn(){
tooltip.hide();
document.getElementById("PageID:FormId:searchsection:Detailresultsection:detailpageclock:createUnverifiedAccount").disabled = true;
document.getElementById("PageID:FormId:searchsection:Detailresultsection:detailpageclock:createUnverifiedAccount").style.color = "#c4c4c4";
}
//function build table data for tooltip
function Mesgbulder(rownum){
var tablestring = document.getElementById('PageID:FormId:searchsection:searchresultsection:searchSection:PopupInfo').innerHTML;;
tablestring = tablestring .replace('[','');
var array=tablestring.split("+$");
rownum=rownum/14;
rownum=rownum*3; 
var NName=array[rownum];
var RName=array[rownum+1];
var LName=array[rownum+2];
var table='<table id="tooltiptable"><tr><td><span class="tooltipHeader"><strong>Non-Latin Name</strong></span></td><td ><span class="tooltipInfo">:'+NName+'</span></td></tr><tr><td ><span class="tooltipHeader"><strong>Reporting Name</strong></span></td><td ><span class="tooltipInfo">:'+RName+'</span></td></tr><tr><td ><span class="tooltipHeader"><strong>Legal Name</strong></span></td><td ><span class="tooltipInfo">:'+LName+'</span></td></tr>';
table=table+'</table><div id="tail1"></div>';
tooltip.show(table);          
} 

//Tooltip Script

var tooltip=function(){
    var id = 'tt';
    var top = 3;
    var left = 3;
    var maxw = 400;
    var speed = 10;
    var timer = 20;
    var endalpha = 95;
    var alpha = 0;
    var tt,t,c,b,h;
    var ie = document.all ? true : false;
    return{
        show:function(v,w){
            if(tt == null){
                tt = document.createElement('div');
                tt.setAttribute('id',id);
                t = document.createElement('div');
                t.setAttribute('id',id + 'top');
                c = document.createElement('div');
                c.setAttribute('id',id + 'cont');
                b = document.createElement('div');
                b.setAttribute('id',id + 'bot');
                tt.appendChild(t);
                tt.appendChild(c);
                tt.appendChild(b);
                document.body.appendChild(tt);
                tt.style.opacity = 0;
                tt.style.filter = 'alpha(opacity=0)';
                document.onmousemove = this.pos;
            }
            tt.style.display = 'block';
            c.innerHTML = v;
            tt.style.width = w ? w + 'px' : 'auto';
            if(!w && ie){
                t.style.display = 'none';
                b.style.display = 'none';
                tt.style.width = tt.offsetWidth;
                t.style.display = 'block';
                b.style.display = 'block';
            }
            if(tt.offsetWidth > maxw){tt.style.width = maxw + 'px'}
            h = parseInt(tt.offsetHeight) + top;
            clearInterval(tt.timer);
            tt.timer = setInterval(function(){tooltip.fade(1)},timer);
        },
        pos:function(e){
            var u = ie ? event.clientY + document.documentElement.scrollTop : e.pageY;
            var l = ie ? event.clientX + document.documentElement.scrollLeft : e.pageX;
            tt.style.top = (u - h) + 'px';
            tt.style.left = (l + left) + 'px';
            },
        fade:function(d){
            var a = alpha;
            if((a != endalpha && d == 1) || (a != 0 && d == -1)){
                var i = speed;
                if(endalpha - a < speed && d == 1){
                    i = endalpha - a;
                }else if(alpha < speed && d == -1){
                    i = a;
                }
                alpha = a + (i * d);
                tt.style.opacity = alpha * .01;
                tt.style.filter = 'alpha(opacity=' + alpha + ')';
            }else{
                clearInterval(tt.timer);
                if(d == -1){tt.style.display = 'none'}
            }
        },
        hide:function(){
            clearInterval(tt.timer);
            tt.timer = setInterval(function(){tooltip.fade(-1)},timer);
        }
    };
}();
