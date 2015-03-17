@isTest
private class ChatterAnswersAuthProviderRegTest {
static testMethod void testCreateAndUpdateUser() {
    ChatterAnswersAuthProviderRegistration handler = new ChatterAnswersAuthProviderRegistration();
    Profile p = [SELECT Id FROM profile WHERE name='Standard User'];
    User utest = new User(Alias = 'lbdeta', Email='lbdetail@hp.com', 
                          EmailEncodingKey='UTF-8',Email_Address__c='lbdetail@hp.com',LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='lbdetail@hp.com',Adoption_Role_Type__c='IT',Legacy_Employee_Ref__c='99978889');
    insert utest;
    Auth.UserData sampleData = new Auth.UserData('testId', 'testFirst', 'testLast',
        'testFirst testLast', 'testuser@example.org', p.Id, 'testuserlong', 'en_US', 'facebook',
        utest.id, new Map<String, String>{'language' => 'en_US'});
    User u = handler.createUser(utest.id, sampleData);
    system.debug('@@@@@@@@@@@@@'+u);
    insert(u);

    /*System.assertEquals('testuserlong@salesforce.com', u.userName);
    System.assertEquals('testuser@example.org', u.email);
    System.assertEquals('testLast', u.lastName);
    System.assertEquals('testFirst', u.firstName);
    System.assertEquals('testuser', u.alias);
    insert(u);
    String uid = u.id;
    
    sampleData = new Auth.UserData('testNewId', 'testNewFirst', 'testNewLast',
        'testNewFirst testNewLast', 'testnewuser@example.org', null, 'testnewuserlong', 'en_US', 'facebook',
        null, new Map<String, String>{});
    handler.updateUser(uid, null, sampleData);
    
    User updateUser= [SELECT userName, email, firstName, lastName, alias FROM user WHERE id=:uid];
    System.assertEquals('testnewuserlong@salesforce.com', updateUser.userName);
    System.assertEquals('testnewuser@example.org', updateUser.email);
    System.assertEquals('testNewLast', updateUser.lastName);
    System.assertEquals('testNewFirst', updateUser.firstName);
    System.assertEquals('testnewu', updateUser.alias);*/
}
}