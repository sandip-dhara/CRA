/**********************************************************
    * Class Name: AddtoCampaignController
    * Author: HP
    * Date: 20-SEP-2012 
    * Requirement # Request Id: 
    * Description: Controller for adding Campaign to Lead
    ***********************************************************/
    
    public with sharing class AddtoCampaignController{
        public Lead leadRec{get;set;}    
        public List<CampaignMember> campaignMemberList = new List<CampaignMember>();
        public List<Lead> leads{get;set;}
        Set<Id> leadId = new Set<Id>();
        
        /*StandardSetController*/
        public AddtoCampaignController(ApexPages.StandardSetController controller) {
            leadRec = (Lead)controller.getRecord();      
            leads = (List<Lead>)controller.getSelected(); 
            if(leads.isEmpty()){
                Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.Select_Lead)); 
            }                         
        }
        
        /**
        * @description: Save method to add Campaigns to Lead
        * @return: Redirects to Lead Page after save
        */
        public PageReference AddToCampaign() {  
            for(Lead led: leads){
                leadId.add(led.Id);
             }
            try {
                for(Lead leadTemp :[Select Id,Name,Campaign__c from Lead where Id IN:leadId]){
                CampaignMember camp = new CampaignMember(leadId = leadTemp.Id, CampaignId = leadRec.Campaign__c);
                campaignMemberList.add(camp);
                }
            insert campaignMemberList;  
            }           
            catch (DMLException dmlEx) {
                CreateApexErrorLog.insertHandledExceptions(dmlEx, null, 'Lead', 'AddtoCampaignController', '');
                for(Integer i =0; i<dmlEx.getNumDml(); ++i) { 
                Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,dmlEx.getDmlMessage(i)));
                }
            return null;
            }          
            PageReference retPage = new  PageReference('/'+'00Q');
            return retPage;              
        }
        
        /**
        * @description: Cancel method 
        * @return: Redirects to Lead Page 
        */
        public PageReference Cancel() {     
            PageReference retPage;
            retPage = new  PageReference('/'+'00Q');
            return retPage;              
        }  
    }