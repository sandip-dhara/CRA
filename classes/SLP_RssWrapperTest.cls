@isTest
private class  SLP_RssWrapperTest {

    static testMethod void RSSTest() {
        SLP_RssWrapper.channel chan = SLP_RssWrapper.getRSSData('test');
        Date pDate = chan.items[0].getPublishedDate();
        DateTime pDateTime = chan.items[0].getPublishedDateTime();
    }
}