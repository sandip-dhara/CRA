public class SLP_RssNewsReader { 
       
    public SLP_RssNewsReader() {       
    }
    
     public SLP_RssWrapper.channel getRSSFeed() {
        SLP_RssWrapper.channel rssFeed = SLP_RssWrapper.getRSSData('http://news.yahoo.com/rss/topstories');
        //SLP_RssWrapper.channel rssFeed = SLP_RssWrapper.getRSSData('http://ext.hpnn.hp.com/rss');
        //SLP_RssWrapper.channel rssFeed = SLP_RssWrapper.getRSSData('http://rss.nytimes.com/services/xml/rss/nyt/Business.xml'); 
       // SLP_RssWrapper.channel rssFeed = SLP_RssWrapper.getRSSData('http://www.gartner.com/newsroom/rss');
        return rssFeed;
    } 
}