@isTest(SeeAllData=true)
private class LiveDependentCountryTest {
    static testMethod void DependencyTest(){
    
    /*LiveChatTranscript */
    LiveChatVisitor liveVisitor = new LiveChatVisitor();
    insert liveVisitor;
    
    LiveChatTranscript livechat = new LiveChatTranscript (LiveChatVisitorId=liveVisitor.id);
    insert livechat;
    
        test.startTest();
        LiveDependentCountry.CountryTeam('AMS');
        LiveDependentCountry.LiveSubject('eTools');    
        LiveDependentCountry.UserTimeZone('United States-America/New_York');    
        test.stopTest();
    }

}