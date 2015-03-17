public class SLP_RSSFeedReader {
     
    public String rssQuery {get;set;}
    public String rssURL {get;set;}
     
    public SLP_RSSFeedReader() {  
    }
     
    public SLP_RSSFeed.channel getRSSFeed() {
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