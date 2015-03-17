@isTest
private class  SLP_RSSFeedReaderTest {

 static testMethod void test1() {
        SLP_RSSFeedReader con = new SLP_RSSFeedReader();
        List<SLP_RSSFeed.channel> channels = new List<SLP_RSSFeed.channel>();
        channels  = con.getRSSFeed();
    }
 }