public class ODP_Class_RSSFeedReader {
     
    public String rssQuery {get;set;}
    public String rssURL {get;set;}
     
    public ODP_Class_RSSFeedReader () {  
    }
     
    public SLP_RSSFeed.channel getRSSFeed() {
        rssURL = 'http://ext.hpnn.hp.com/rss';
        if (rssURL != null)
        {
            if(rssQuery == null || rssQuery .trim().equals('')){
                return SLP_RSSFeed.getRSSData(rssURL);
            
            }
            else {
                system.debug('url ' +  rssURL + '?q=' + EncodingUtil.urlEncode(rssQuery,'UTF-8'));
                return SLP_RSSFeed.getRSSData(rssURL + '?q=' + EncodingUtil.urlEncode(rssQuery,'UTF-8'));
            }
            
        }
        else {
            return null;
        }
    }
}