@isTest
private class  SLP_RSSFeedTest {

    static testMethod void SLP_RSSTest() {
        SLP_RSSFeed.channel chan = SLP_RSSFeed.getRSSData('test');
        String pDate = chan.items[0].getPublishedDate();
    }
}