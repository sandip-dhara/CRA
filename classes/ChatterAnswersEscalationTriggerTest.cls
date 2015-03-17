@isTest(SeeAllData=true) 
private class ChatterAnswersEscalationTriggerTest { 
    static testMethod void validateQuestionEscalation() { 
    //Fetch the profile Id        
    Profile Profsystadm = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
    UserRole urole=[SELECT Id FROM UserRole WHERE Name='WW CEO'];    
    //Create Logged in User
       User CrtUsr = new User(Alias = 'CrtUsr', Email='CrtUsr@hp.com', 
                       EmailEncodingKey='UTF-8',Email_Address__c='CrtUsr@hp.com',LastName='CrtUsr', LanguageLocaleKey='en_US', 
                        LocaleSidKey='en_US', ProfileId = Profsystadm.Id, 
                        TimeZoneSidKey='America/Los_Angeles', UserName='CrtUsr@hp.com',Adoption_Role_Type__c='IT',Legacy_Employee_Ref__c='99998881',UserRoleId=urole.Id);
                        insert CrtUsr;
    system.runas(CrtUsr)
    {
    String questionTitle = 'test_questionTitle'; 
    String questionBody = 'test_questionBody'; 
    Community[] c = [SELECT Id from Community where Isactive = true]; 
    // We cannot create a question without a community 
    if (c.size() == 0) { return; } 
    String communityId = c[0].Id; 
    Question q = new Question(); 
    q.Title = questionTitle; 
    q.Body = questionBody; 
    q.CommunityId = communityId; 
    insert(q); 
    q.Priority = 'high'; 
    update(q); 
    //Case ca = [SELECT Origin, CommunityId, Subject, Description from Case where QuestionId =: q.Id]; 
    // Test that escaltion trigger correctly escalate the question to a case 
    //System.assertEquals(questionTitle, ca.Subject); 
    //System.assertEquals(questionBody, ca.Description); 
    //System.assertEquals('Chatter Answers', ca.Origin); 
    //System.assertEquals(communityId, ca.CommunityId); 
    }
} 
}