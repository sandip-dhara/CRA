public class RSSNewsReaders
 {
    public String rssQuery {get;set;}
    private String rssURL {get;set;}
     
    public RSSNewsReaders()
     {
        rssURL = 'http://news.google.com/news?pz=1&cf=all&ned=us&hl=en&output=rss';
        //rssQuery = 'salesforce.com'; //default on load   
    }
     
    public RSS.channel getRSSFeed() {
            //return RSS.getRSSData(rssURL + EncodingUtil.urlEncode(rssQuery,'UTF-8'));
            return RSS.getRSSData(rssURL);
           // return null;
    }
     
}