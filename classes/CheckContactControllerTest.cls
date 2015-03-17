/********************************************************** 
* Class Name : CheckContactControllerTest
* Purpose    : Test class for CheckContactController
* ******************************************************* 
*          Date            Remarks 
*         09-May-12       Created - Coverage(84%)
* *********************************************************/

@isTest
private class CheckContactControllerTest{
 
    static PageReference pageRef;
    static Account acc;
    static Lead lead;
    static Contact con;
    static Product_Interest__c prodint;
    static Product2 prod;
    static Note note ;
    static Attachment att;
    static CampaignMember cmpmem;
    static Campaign camp;
    public static List<Campaign> listCampaign;
    public static Campaign newParentCampaign, newCampaign1, newCampaign2;
    public static List<CampaignMember> listCampaignMember;
    public static CampaignMember objCampaignMember1;
    
    private static void setupData() {
    
    String RecordTypeId ='';
        try {
            RecordTypeId = RecordTypeIdHelper.getRecordTypeId('Account','Customer');
        } catch(Exception e) {
            System.debug('>>> Exception: '+e.getMessage());
        }
        
        //Create a test account
        acc = TestingSetupDataUtil.createAccount('testLCAccount','test_22@test.com','Customer');
       
        insert acc;
        
        
        camp = new Campaign(Name ='Test');
        insert camp;
        
        newParentCampaign = new Campaign();
        newParentCampaign = TestingSetupDataUtil.createCampaign(true, 1, 1, 'Campaign1', UserInfo.getUserId(), 'test1', System.today()+1, 1, 1, 1, System.today(), 'InProgress', 'Banner Ads');
        newParentCampaign.Sub_Business_Unit__c = 'test';
        insert newParentCampaign;
        
        listCampaign = new List<Campaign>(); 
        newCampaign1 = new Campaign();
        
        newCampaign1 = TestingSetupDataUtil.createCampaign(true ,1 ,1,'campaign1',UserInfo.getUserId(),'test1',System.today()+1,1,1,1,System.today(),'InProgress','Banner Ads');
        newCampaign1.ParentId = newParentCampaign.Id;
        listCampaign.add(newCampaign1);
        
        newCampaign2 = TestingSetupDataUtil.createCampaign(true ,1 ,1,'campaign1',UserInfo.getUserId(),'test1',System.today()+1,1,1,1,System.today(),'InProgress','Banner Ads');
        newCampaign2.ParentId = newParentCampaign.Id;
        listCampaign.add(newCampaign2);
        
        insert listCampaign;
        
        //Create a test lead
        lead  =TestingSetupDataUtil.createLead('Test123', 'testLCAccount', 'Qualified', 'Accepted', '123456789',null);
        lead.Campaign__c = newCampaign1.id;
        
        insert lead;
        
        //Create a test Contact
        con = TestingSetupDataUtil.createContact(acc.Id,'Test123');
              
        insert con;
        
        listCampaignMember = new List<CampaignMember>();
        
        objCampaignMember1 = TestingSetupDataUtil.createCampaignMember(newCampaign1.Id,con.Id,true,lead.Id);
        listCampaignMember.add(objCampaignMember1);
        
        insert listCampaignMember;
        
        //Create a test product 
        prod = TestingSetupDataUtil.createProduct(true,'testprod','USD','1001');
        insert prod;
        //Create a test product interest
        prodint = new Product_Interest__c(Product__c = prod.id,Lead__c=lead.id,Quantity__c=2);
        insert prodint;
         
        note = new Note (Title='test', ParentId=lead.id, OwnerId=UserInfo.getUserid(), Body='test');
        insert note;
        
        att = new Attachment(ParentId=lead.id, OwnerId=UserInfo.getUserid(), Name='test', Body = Blob.valueOf('Unit Test Attachment Body'),Description='test');
        insert att;
        
 }
 /** This Method is used to validate code coverage of CheckContactController Methods**/
    static testMethod void checkContactControllerTest(){
        setupData();
    
        Test.startTest(); 
        pageRef = Page.CheckContactBeforeConvert;      
        ApexPages.currentPage().getParameters().put('accId',acc.Id);
        ApexPages.currentPage().getParameters().put('leadId',lead.Id);
        ApexPages.currentPage().getParameters().put('ownerId',Userinfo.getUserId());
        ApexPages.currentPage().getParameters().put('oppFlag','false');
        ApexPages.currentPage().getParameters().put('emailFlag','true');
        ApexPages.currentPage().getParameters().put('leadcompany',lead.Company);
        //Test.setCurrentPageReference(pageRef);
        CheckContactController checkContactController = new CheckContactController();
        
        checkContactController.leadid = lead.id;
        checkContactController.getContactOptions();
        checkContactController.contactId = con.Id;
        checkContactController.replaceLeadSource = 'false';
        pageReference leadConvertPage = checkContactController.leadConvert();
        /*To check if Lead is converted successfully*/
        System.assertEquals(leadConvertPage.getURL(),'/'+lead.Id);
        checkContactController.checkForContact();
        pageReference CancelPage = checkContactController.Cancel();
        /*To check that Lead URL is displayed on Cancel*/
        System.assertEquals(CancelPage.getURL(),'/'+lead.Id);
        Test.stopTest(); 
 }
}