public class SLP_RssWrapper {
    public class channel {
        public String title {get;set;}
        public String link {get;set;}
        public String description {get;set;}
        public String language {get;set;}
        public String category {get;set;}
        public String copyright {get;set;}
        public String pubDate {get;set;}
        public String ttl {get;set;}
        public SLP_RssWrapper.image image {get;set;}
        public list<SLP_RssWrapper.item> items {get;set;}
        public channel() {
            items = new list<SLP_RssWrapper.item>();
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
        public Date getPublishedDate() {
            Date result = (pubDate != null) ? Date.valueOf(pubDate.replace('T', ' ').replace('Z','')) : null;
            return result;
        }
        public DateTime getPublishedDateTime() {
            DateTime result = (pubDate != null) ? DateTime.valueOf(pubDate.replace('T', ' ').replace('Z','')) : null;
            return result;            
        }
    }
     
    public static SLP_RssWrapper.channel getRSSData(string feedURL) {
              system.debug('in getRSSData');
        HttpRequest req = new HttpRequest();
        req.setEndpoint(feedURL);
        req.setMethod('GET');        
        Dom.Document doc = new Dom.Document();
        String xmlDom = '';
        Http h = new Http();
        HttpResponse res; 
        if (!Test.isRunningTest()){ 
            try{
                res = h.send(req);
                   
            }catch(Exception ex){
                return null;
            }
         // Generate the HTTP response as an XML stream          
            if(res.getBody() != null){ 
            string bod = res.getBody().replace('&', EncodingUtil.urlEncode('&','UTF-8')).replace('<![CDATA[','').replace(']]>','');    
             system.debug(feedURL);
        system.debug('bod**' + bod);         
                doc.load(res.getBody().replace('&', EncodingUtil.urlEncode('&','UTF-8')).replace('<![CDATA[','').replace(']]>',''));//res.getBody());
            }            
            
        } else {
            String xmlString = '<?xml version="1.0" encoding="utf-8" ?><rss version="2.0" xmlns:os="http://a9.com/-/spec/opensearch/1.1/"><channel><title>salesforce.com - Bing News</title><link>http://www.bing.com/news</link><description>Search Results for salesforce.com at Bing.com</description><category>News</category><os:totalResults>3370</os:totalResults><os:startIndex>0</os:startIndex><os:itemsPerPage>10</os:itemsPerPage><os:Query role="request" searchTerms="salesforce.com" /><copyright>These XML results may not be used, reproduced or transmitted in any manner or for any purpose other than rendering Bing results within an RSS aggregator for your personal, non-commercial use. Any other use requires written permission from Microsoft Corporation. By using these results in any manner whatsoever, you agree to be bound by the foregoing restrictions.</copyright><image><url>http://www.bing.com/s/a/rsslogo.gif</url><title>Bing</title><link>http://www.bing.com/news</link></image><docs>http://www.rssboard.org/rss-specification</docs><item><title>Salesforce.com Makes Friends With CIOs - Information Week</title><guid>http://informationweek.com/news/cloud-computing/software/232602782</guid><link>http://informationweek.com/news/cloud-computing/software/232602782</link><description>Parade of CIOs at CloudForce shows how social networking inroads are making Salesforce.com a larger part of the IT infrastructure. Salesforce.com isn&apos;t just for sales forces anymore. Its Chatter app has opened a social networking avenue into the enterprise ...</description><pubDate>2012-03-19T15:21:47Z</pubDate><source>Information Week</source></item></channel></rss>';
                  doc.load(xmlString);
        }
        
    
         
        Dom.XMLNode rss = doc.getRootElement();
        //first child element of rss feed is always channel
        Dom.XMLNode channel = rss.getChildElements()[0];
         
        SLP_RssWrapper.channel result = new SLP_RssWrapper.channel();
         
        list<SLP_RssWrapper.item> rssItems = new list<SLP_RssWrapper.item>();
         
        //for each node inside channel        
        for(Dom.XMLNode elements : channel.getChildElements()) {
            if('title' == elements.getName()) {
                result.title = elements.getText();
            }
            if('link' == elements.getName()) {
                result.link = elements.getText();
            }
            if('description' == elements.getName()) {
            system.debug('elements '+ elements.getText());
                result.description = elements.getText();
            }
            if('category' == elements.getName()) {
                result.category = elements.getText();
            }
          if('copyright' == elements.getName()) {
                result.copyright = elements.getText();
            }
            if('ttl' == elements.getName()) {
                result.ttl = elements.getText();
            }
            if('image' == elements.getName()) {
                SLP_RssWrapper.image img = new SLP_RssWrapper.image();
                //for each node inside image
                for(Dom.XMLNode xmlImage : elements.getChildElements()) {
                    if('url' == xmlImage.getName()) {
                        img.url = xmlImage.getText();
                    }
                    if('title' == xmlImage.getName()) {
                        img.title = xmlImage.getText();
                    }
                    if('link' == xmlImage.getName()) {
                        img.link = xmlImage.getText();
                    }
                }
                result.image = img;
            }
             
            if('item' == elements.getName()) {
                SLP_RssWrapper.item rssItem = new SLP_RssWrapper.item();
                //for each node inside item
                for(Dom.XMLNode xmlItem : elements.getChildElements()) {                    
                    if('title' == xmlItem.getName()) {
                        rssItem.title = EncodingUtil.urlDecode(xmlItem.getText(),'UTF-8');
                    }

            if('guid' == xmlItem.getName()) {
                        rssItem.guid = xmlItem.getText();
                    }
                    if('link' == xmlItem.getName()) {
                        rssItem.link = xmlItem.getText();
                    }
                    if('description' == xmlItem.getName()) {
                    system.debug('itemele ' + xmlItem.getText());
                        rssItem.description = EncodingUtil.urlDecode(xmlItem.getText(),'UTF-8');
                    }
                    if('pubDate' == xmlItem.getName()) {
                        rssItem.pubDate = EncodingUtil.urlDecode(xmlItem.getText(),'UTF-8');
                    }
                    if('source' == xmlItem.getName()) {
                        rssItem.source = EncodingUtil.urlDecode(xmlItem.getText(),'UTF-8');
                    }
                }
                //for each item, add to rssItem list
                rssItems.add(rssItem);
            }
        }
        //finish SLP_RssWrapper.channel object by adding the list of all rss items
        result.items = rssItems;        
        return result;
    }
     
     
 
}