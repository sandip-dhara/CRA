@isTest
private class ChatterAnswersRegistrationTest {
    static testMethod void validateAccountCreation() {
        Profile[] p = [SELECT Id FROM Profile WHERE UserType = 'Standard'];
        User[] user = [SELECT Id, Firstname, Lastname from User WHERE IsActive = true and ProfileId =: p[0].Id];
        if (user.size() == 0) { return; }
        String firstName = user[0].FirstName; 
        String lastName = user[0].LastName; 
        String userId = user[0].Id;
        String accountId = new ChatterAnswersRegistration().createAccount(firstName, lastName, userId);
        Account acct = [SELECT name, ownerId from Account where Id =: accountId];
        System.assertEquals(firstName + ' ' + lastName, acct.name);
        System.assertEquals(userId, acct.ownerId);
  }
}