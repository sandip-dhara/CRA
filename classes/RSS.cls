public class RSS {

    public RSS(RSSNewsReaders controller) {

    }

     
    
    public class channel {
        public String title {get;set;}
        public String link {get;set;}
        public String description {get;set;}
        public String author {get;set;}
        public String category {get;set;}
        public String copyright {get;set;}
        public String docs {get;set;}
        public RSS.image image {get;set;}
        public list<RSS.item> items {get;set;}
        public channel() {
            items = new list<RSS.item>();
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
        public Datetime getPublishedDateTime() {
           /// DateTime result = (pubDate != null) ? DateTime.valueOf(pubDate.replace('T', ' ').replace('Z','')) : null;
            
            return system.now();
        }
    }
     
    public static  RSS.channel getRSSData(string feedURL) {
         system.debug('feedURL:'+feedURL);
        HttpRequest req = new HttpRequest();
        req.setEndpoint(feedURL);
        req.setMethod('GET');
         
        Dom.Document doc = new Dom.Document();
        Http h = new Http();
        system.debug('req:'+req);
         system.debug('isRunningTest:'+Test.isRunningTest());
        if (!Test.isRunningTest()){ 
            HttpResponse res = h.send(req);
            doc = res.getBodyDocument();
        } else {
            String xmlString = '<?xml version="1.0" encoding="utf-8" ?><rss version="2.0" xmlns:os="http://a9.com/-/spec/opensearch/1.1/"><channel><title>salesforce.com - Bing News</title><link>http://www.bing.com/news</link><description>Search Results for salesforce.com at Bing.com</description><category>News</category><os:totalResults>3370</os:totalResults><os:startIndex>0</os:startIndex><os:itemsPerPage>10</os:itemsPerPage><os:Query role="request" searchTerms="salesforce.com" /><copyright>These XML results may not be used, reproduced or transmitted in any manner or for any purpose other than rendering Bing results within an RSS aggregator for your personal, non-commercial use. Any other use requires written permission from Microsoft Corporation. By using these results in any manner whatsoever, you agree to be bound by the foregoing restrictions.</copyright><image><url>http://www.bing.com/s/a/rsslogo.gif</url><title>Bing</title><link>http://www.bing.com/news</link></image><docs>http://www.rssboard.org/rss-specification</docs><item><title>Salesforce.com Makes Friends With CIOs - Information Week</title><guid>http://informationweek.com/news/cloud-computing/software/232602782</guid><link>http://informationweek.com/news/cloud-computing/software/232602782</link><description>Parade of CIOs at CloudForce shows how social networking inroads are making Salesforce.com a larger part of the IT infrastructure. Salesforce.com isn&apos;t just for sales forces anymore. Its Chatter app has opened a social networking avenue into the enterprise ...</description><pubDate>2012-03-19T15:21:47Z</pubDate><source>Information Week</source></item></channel></rss>';
            doc.load(xmlString);
        }
         
          //  String xmlString = '<?xml version="1.0" encoding="utf-8" ?><rss version="2.0" xmlns:os="http://a9.com/-/spec/opensearch/1.1/"><channel><title>salesforce.com - Bing News</title><link>http://www.bing.com/news</link><description>Search Results for salesforce.com at Bing.com</description><category>News</category><os:totalResults>3370</os:totalResults><os:startIndex>0</os:startIndex><os:itemsPerPage>10</os:itemsPerPage><os:Query role="request" searchTerms="salesforce.com" /><copyright>These XML results may not be used, reproduced or transmitted in any manner or for any purpose other than rendering Bing results within an RSS aggregator for your personal, non-commercial use. Any other use requires written permission from Microsoft Corporation. By using these results in any manner whatsoever, you agree to be bound by the foregoing restrictions.</copyright><image><url>http://www.bing.com/s/a/rsslogo.gif</url><title>Bing</title><link>http://www.bing.com/news</link></image><docs>http://www.rssboard.org/rss-specification</docs><item><title>Salesforce.com Makes Friends With CIOs - Information Week</title><guid>http://informationweek.com/news/cloud-computing/software/232602782</guid><link>http://informationweek.com/news/cloud-computing/software/232602782</link><description>Parade of CIOs at CloudForce shows how social networking inroads are making Salesforce.com a larger part of the IT infrastructure. Salesforce.com isn&apos;t just for sales forces anymore. Its Chatter app has opened a social networking avenue into the enterprise ...</description><pubDate>2012-03-19T15:21:47Z</pubDate><source>Information Week</source></item></channel></rss>';
           // doc.load(xmlString);
         
        Dom.XMLNode rss = doc.getRootElement();
        //first child element of rss feed is always channel
        Dom.XMLNode channel = rss.getChildElements()[0];
         
        RSS.channel result = new RSS.channel();
         
        list<RSS.item> rssItems = new list<RSS.item>();
         
        //for each node inside channel
        for(Dom.XMLNode elements : channel.getChildElements()) {
            if('title' == elements.getName()) {
                result.title = elements.getText();
            }
            if('link' == elements.getName()) {
                result.link = elements.getText();
            }
            if('description' == elements.getName()) {
                result.description = elements.getText();
            }
            if('category' == elements.getName()) {
                result.category = elements.getText();
            }
            if('copyright' == elements.getName()) {
                result.copyright = elements.getText();
            }
            if('docs' == elements.getName()) {
                result.docs = elements.getText();
            }
            if('image' == elements.getName()) {
                RSS.image img = new RSS.image();
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
                RSS.item rssItem = new RSS.item();
                //for each node inside item
                for(Dom.XMLNode xmlItem : elements.getChildElements()) {
                    if('title' == xmlItem.getName()) {
                        rssItem.title = xmlItem.getText();
                    }
                    if('guid' == xmlItem.getName()) {
                        rssItem.guid = xmlItem.getText();
                    }
                    if('link' == xmlItem.getName()) {
                        rssItem.link = xmlItem.getText();
                    }
                    if('description' == xmlItem.getName()) {
                        rssItem.description = xmlItem.getText();
                    }
                    if('pubDate' == xmlItem.getName()) {
                        rssItem.pubDate = xmlItem.getText();
                    }
                    if('source' == xmlItem.getName()) {
                        rssItem.source = xmlItem.getText();
                    }
                }
                //for each item, add to rssItem list
                rssItems.add(rssItem);
            }
             
        }
        //finish RSS.channel object by adding the list of all rss items
        result.items = rssItems;
         
        return result;
         
    }
     
   
 
}