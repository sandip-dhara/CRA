/*
* NAME : AptsCompleteRequestAndCreateDocument
* 
*  NOTE : This class is used when user clicks on "Close(No Document)" button,
*		 Logic will update status/status progress to Request/Request Closed,Record type to Advice Only and Agreement Name to Account Name + Advice Only,
*		 set Close for Advice Date/Time to current Date/Time and Redirect it to Agreement Home Page
* Author : Apttus(Axay Varu)
*/
public with sharing class AptsCompleteRequestAndCreateDocument{
    
    public String action{get;set;}
    public String agreementId{get;set;}
    
    public AptsCompleteRequestAndCreateDocument()
    {
        action = apexpages.currentpage().getparameters().get('action');
        agreementId = apexpages.currentpage().getparameters().get('Id');
    }
    
    //get Abbrivated Account Name
    private String getAbbrAccountName(String acName){
	        if(acName != null && acName.length() > 60){
	            	acName = acName.subString(0,60);
	        }
	       return acName;
    }
    
    public PageReference DoAction() // this is action method called on page load
    {
        if(action == 'CompleteRequest')
        {
            if(agreementId != null && agreementId != '')
            {
                Apttus__APTS_Agreement__c agreement = [SELECT ID,NAME,Apttus__Account__r.NAME,Apttus__Related_Opportunity__r.Account.Name, Apttus__Status_Category__c, Apttus__Status__c,Closed_for_Advice__c 
                                                       FROM Apttus__APTS_Agreement__c WHERE ID = :agreementId];
                
                agreement.Apttus__Status_Category__c = 'Request';
                agreement.Apttus__Status__c = 'Request Closed';
                agreement.Closed_for_Advice__c = System.now();
                System.debug('***Ac Name : '+agreement.Apttus__Account__r.NAME+'****Ac nAMe opp: '+agreement.Apttus__Related_Opportunity__r.Account.Name);
                if(agreement.Apttus__Account__r.NAME != null){
                agreement.NAME = getAbbrAccountName(agreement.Apttus__Account__r.NAME) +' - '+'Advice Only';
                }
                RecordType rt = [SELECT ID, SObjectType, DeveloperName FROM RecordType where Name = 'Advice Only'];
                
                if(rt != null)
                {
                agreement.RecordTypeID = rt.ID;
                }
                update agreement;
                return new PageReference('/apex/AptsAgmtHome');
            }
        }
        
        return null;
    }
}