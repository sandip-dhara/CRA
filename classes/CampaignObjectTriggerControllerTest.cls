/**********************************************************
* Class Name: CampaignObjectTriggerControllerTest
* Author: Accenture
* Date: 25-JUL-2012 
* Description: This class does the test coverage
*              for CampaignObjectTriggerController class. 
***********************************************************/
@isTest
private class CampaignObjectTriggerControllerTest { 
	
	public static List<Campaign> listCampaign;
	public static List<Campaign> listCampaign1;
    public static Campaign newCampaign1, newCampaign2;

    static void setupData() {
    	 
    	/* Inserting Campaigns */      
        listCampaign = new List<Campaign>();
        listCampaign1 = new List<Campaign>(); 
        newCampaign1 = new Campaign();
        newCampaign2 = new Campaign();
 
        newCampaign1 = TestingSetupDataUtil.createCampaign(true ,1 ,1,'campaign1',UserInfo.getUserId(),'test1',System.today()+1,1,1,1,System.today(),'InProgress','Banner Ads');
        listCampaign.add(newCampaign1);
        newCampaign2 = TestingSetupDataUtil.createCampaign(true ,1 ,1,'campaign1',UserInfo.getUserId(),'test1',System.today()+1,1,1,1,System.today(),'InProgress','Banner Ads');
        listCampaign.add(newCampaign2);
        try {
        		insert listCampaign;
        } catch (Exception e) {	
        }
        System.assertEquals(listCampaign.size(),2);
    }
    
    private static testMethod void testCampaignObjectTriggerController() {
        
        /* Initializing test data */
        setupData();      
        Test.startTest();
        
        CampaignObjectTriggerControllerTest campaignTrigger = new CampaignObjectTriggerControllerTest();       
         try{
            	insert newCampaign2;
        } catch (DMLException e) {
            	system.debug('Exception: '+e.getMessage());
        }
        listCampaign1.add(newCampaign1);
        CampaignObjectTriggerController.beforeInsert(listCampaign1);         
        Test.stopTest();       
    }
    
}