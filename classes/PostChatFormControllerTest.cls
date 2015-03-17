@isTest(SeeAllData=true)
private class PostChatFormControllerTest{
static PageReference pref;

    static testMethod void LiveChatTest() {
        pref = Page.PostChatForm;
        Test.setCurrentPage(pref);
        ApexPages.currentPage().getParameters().put('requestTime','123456');
        ApexPages.currentPage().getParameters().put('startTime','234567');
        ApexPages.currentPage().getParameters().put('disconnectedBy','error');
        
        test.startTest();
        LiveChatTranscript LiveChat = new LiveChatTranscript();
        ApexPages.StandardController std_controller = new ApexPages.StandardController(LiveChat); 
        PostChatFormController controller = new PostChatFormController(std_controller);
        controller.DisconnectedBy = 'error';
        controller.DisconnectedBy = 'Agent';
        controller.PostChatParam();
        test.stopTest();
    }

}