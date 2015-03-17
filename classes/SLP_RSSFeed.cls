public class SLP_RSSFeed {
     
    public class channel {
        public String title {get;set;}
        public String link {get;set;}
        public String description {get;set;}
        public String author {get;set;}
        public String category {get;set;}
        public String copyright {get;set;}
        public String docs {get;set;}
        public SLP_RSSFeed.image image {get;set;}
        public list<SLP_RSSFeed.item> items {get;set;}
        public channel() {
            items = new list<SLP_RSSFeed.item>();
        }
    }
     
    public class image {
        public String url {get;set;}
        public String title {get;set;}
        public String link {get;set;}
    }
     
    public class item {
        public String title {get;set;}
        public String guid {get;set;}
        public String link {get;set;}
        public String description {get;set;}
        public String pubDate {get;set;}
        public String source {get;set;}
        public SLP_RSSFeed.image image {get;set;}
        public String getPublishedDate() {
            String result = (pubDate != null) ? pubDate  : null;
            return result;
        }

    }
    public static boolean isEntry  {get; set;}
   

    public static SLP_RSSFeed.channel getRSSData(string feedURL) {
    isEntry = false;
    string bodyDoc;
    HttpRequest req = new HttpRequest();
    req.setEndpoint(feedURL);
    req.setMethod('GET');

    Http h = new Http();

    if (!Test.isRunningTest()){ 
        HttpResponse res = h.send(req);
        bodyDoc = res.getBody();
    } else {
        bodyDoc = '<?xml version="1.0" encoding="utf-8"?><rss version="2.0"><channel><title><![CDATA[Latest HPNN Articles]]></title><link><![CDATA[http://ext.hpnn.hp.com/rss]]></link><description><![CDATA[Latest articles from HP News Now]]></description><language><![CDATA[en-US]]></language><item> <guid isPermaLink="false">371c94e1-662b-4ed9-bd8c-873d9ac7001a</guid><title><![CDATA[No Wi-Fi? No problem.]]></title> <description><![CDATA[<img alt="No Wi-Fi? No problem." src="http://hpnn.hp.com.edgesuite.net/getmedia/b78649ce-67f9-4314-8a70-61f3bc791638/Phelps-Marquee-2_1.jpg.aspx?ext=.jpg&amp;width=200&amp;height=130" />            <br/>New HP devices have you covered at home, work and play     ]]>  </description>  <pubDate>2014-02-27T00:00:00.000-08:00</pubDate>  <link><![CDATA[http://ext.hpnn.hp.com/Articles/2014/Feb/It-s-go-time.aspx]]></link>     </item> </item></channel></rss>';
     }
    XmlStreamReader reader = new XmlStreamReader(bodyDoc);

    // If you specify it as false, the parser may return text in multiple blocks.
    reader.setCoalescing (true); 
     
    SLP_RSSFeed.channel result = new SLP_RSSFeed.channel();
     
    list<SLP_RSSFeed.item> rssItems = new list<SLP_RSSFeed.item>();
    string lname;   
    try { 
        while(reader.hasNext()) {
            if (reader.getLocalName() != null) {
                lname = reader.getLocalName() ;		// reader.getLocalName() is null if not a START or END gat. Retain the value for processing in CHARS tag
            }
            if (reader.getEventType() == XmlTag.END_ELEMENT) {
                lname = null;
            }
            else if (reader.getEventType() == XmlTag.START_ELEMENT) {
                 lname = reader.getLocalName() ;
                if (lname == 'entry' ) { // ATOM style   
                    isEntry = true;
                } 
                if (lname == 'item' || lname == 'entry') {  // 'item' for RSS 2.0 style    'entry' for YouTube   Atom  
                    SLP_RSSFeed.item rssItem = parseFeedItem(reader);
                    rssItems.add(rssItem);
                }  
            }
             else if(reader.getEventType()==Xmltag.CHARACTERS){
                if (lname == 'title') {
            		result.title = reader.getText(); 
                }
            }
            reader.next();
        }
    } 
    catch (exception parseerror) { 
       system.debug ( 'parse error ' +parseerror); 
    } 
    result.items = rssItems;
     
    return result;
} 
    
    public static  SLP_RSSFeed.item parseFeedItem(XmlStreamReader reader) {
     	SLP_RSSFeed.item rssItem = new SLP_RSSFeed.item();
        string lname;        
        string aname = '';
        string href = '';
        integer icount = 0;

        while(reader.hasNext()) {
          //system.debug('icount ' + icount + ' rname ' +  reader.getLocalName() + ' tag ' + reader.getEventType());
          //  icount++;
           if (reader.getLocalName() != null) {		// reader.getLocalName() is null if not a START or END gat. Retain the value for processing in CHARS tag
           	lname = reader.getLocalName() ;
           }    
           if (reader.getEventType() == XmlTag.END_ELEMENT) {
               if ( lname == 'item'  || lname == 'entry' ) break;
               lname = null;
            }
            else if (reader.getEventType() == XmlTag.START_ELEMENT) {
                if (lname == 'link' && SLP_RSSFeed.isEntry) {
                    aname = reader.getAttributeValue(null, 'rel');
                    href =  reader.getAttributeValue(null, 'href');
                    if (lname == 'link' && aname == 'alternate') {
                        rssItem.link = href;
                    }              
                }
            }
         	else if(reader.getEventType()==Xmltag.CHARACTERS){ 
                if (lname == 'title') {
                    rssItem.title = reader.getText(); 
                }
                if (lname == 'pubDate') {                  
                       rssItem.pubDate =  reader.getText();
                }
            	if (lname == 'description' || lname == 'content') {		// 'content' ATOM         'description' fpr RSS 2.0      		
                     rssItem.description = reader.getText();                  
                }

                if (lname == 'link' && !SLP_RSSFeed.isEntry) {
                    rssItem.link = reader.getText(); 
                }
                
            }
            reader.next();  
        }
        return rssItem;
    }
    
   
    
}