@isTest
public class conAddmailsIdsTest{
  static DOM.Document doc;
  static Account_Plan__c accountPlan;
  static Account account;
static testMethod void testCallout() 
    {
        List<TibcoSecurity__c> lstTibcoSec = new List<TibcoSecurity__c>();
        TibcoSecurity__c tibcoSec = new TibcoSecurity__c(Name='tibadmin', TargetSystemName__c='ApttusToEd', TibcoPassword__c='tibadmin');
        lstTibcoSec.add(tibcoSec);
        insert lstTibcoSec;
        account = TestingSetupDataUtil.createAccount('testAccount1', 'accountEmail@email.com','Customer');
        insert account ;
        System.assertEquals(account.Name,'testAccount1');
                accountPlan= ABPTestingUtil.createAbpPlan('testAccount1',account.id,'USD');
        insert accountPlan;
        System.assertEquals(accountPlan.Name,'testAccount1');        
        ApexPages.StandardController stdController = new ApexPages.StandardController(accountPlan);
        conAddmailsIds conIds = new conAddmailsIds(stdController);
        conAddmailsIds con = new conAddmailsIds();
        //conAddmailsIds con = new conAddmailsIds('cn','prakash raju somalraju');
        con.getautoRun();
        
        con.selectId = 'cn';
        con.searchText = 'prakash raju somalraju';
        con.getAllEmployees();
        con.searchResults[0].selected =true;
        
        conAddmailsIds con1 = new conAddmailsIds();
        con1.selectId = 'cn';
        con1.searchText = '';
        con1.getAllEmployees();
        
        conAddmailsIds con2 = new conAddmailsIds();
        con2.selectId = 'cn';
        con2.searchText = 'abc1334';
        con2.getAllEmployees();
        
        conAddmailsIds con3 = new conAddmailsIds();
        con3.selectId = 'givenName';
        con3.searchText = 'ab';
        con3.getAllEmployees();
        
        conAddmailsIds con4 = new conAddmailsIds();
        con4.selectId = 'givenName';
        con4.searchText = 'xaqw';
        con4.getAllEmployees();
        
        conAddmailsIds con5 = new conAddmailsIds();
        con5.selectId = 'givenName';
        con5.searchText = 'Prakash';
        con5.getAllEmployees();
        con5.shownext = true;
        con5.getshownext();
        con5.nextpg();
        con5.showprev = true;
        con5.getshowprev();
        con5.Prevpg();                
        con5.getEmployeesDetails();
        
        ApexPages.currentPage().getParameters().put('detName', 'manasa.r@hp.com');
        con1.getEmployeesDetails();
        
        con.getEmpHierarchyData();
        
        
        con.addToList();
        con.addCCList();
        con.addBCCList();
        con.closePopup();
        con.getReqURL();  
        con.getnumberList();
        con.action = 'Send for Review';
        con.toMailIds = 'abc@hp.com';
        con.ccMailIds = 'def@hp.com';
        con.bccMailIds = 'ghi@hp.com';
        con.conAddEmailsIds();        
    }
}