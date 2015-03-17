/*

*********************************************************
* Class Name  : CheckOptyAccessTest
* Author      : Accenture
* Date        : 09-MAY-2012 
* Description : Test class for the webservice class CheckOptyAccessTest
**********************************************************

*/
@isTest(SeeAllData=true)
public class CheckOptyAccessTest{
 static Opportunity opty;
 static user userTest;
  private static void setupData() {
  //Create a test account
    Account acc = TestingSetupDataUtil.createAccount('testAccount_952PM', 'testAccount_9@mail.com','Customer');
    insert acc;
    
    //generate Random String 
        String randomstr = Math.round(Math.random()*Math.pow(10, 7))+'';
      
      pricebook2 pb=new PriceBook2(name='Products & Services');
    //create a test opportunity
    opty = TestingSetupDataUtil.createOpportunity(acc.Id,'Opty99ZZ_952PM',System.Today()+30);   
    insert opty;
    userTest = TestingSetupDataUtil.createUser('DA_'+randomstr.substring(0,4),randomstr+'userTest@hp.com',randomstr+'userTest@hp.com','UTF-8','Tertlan','en_US','en_US','America/Los_Angeles','saeest@hp.com','55235615',Userinfo.getProfileId());
        insert userTest ;
   }
        
public static testMethod void checkOptyAccessTestMthod() {
Test.startTest();
setupData();
CheckOptyAccess.checkOptyEditAccess(opty.Id);
CheckOptyAccess.checkOptyEditAccess('123');
CheckOptyAccess.checkOptyEditAccessCI(opty.Id);
CheckOptyAccess.checkOptyEditAccessCI('123');
system.runas(userTest){
CheckOptyAccess.checkOptyEditAccessCI(opty.Id);
CheckOptyAccess.checkOptyEditAccessCI('123');
}
Test.stopTest();
}
}