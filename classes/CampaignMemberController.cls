/**********************************************************
* Class Name: CampaignMemberController
* Author: HP
* Date: 13-SEP-2012 
* Requirement # Request Id: 
* Description: Customized Campaign Member 
***********************************************************/

public class CampaignMemberController{

    /************Variable Declaration*************/
    public Campaign campaign{set; get;}
    public Lead lead{get; set;}
    public String campId{get;set;}
    public String leadId{get;set;}
    public String testparam{get;set;}
    public Boolean primary{get;set;}
    public CampaignMember campmember{get;set;}
         
    public CampaignMemberController(ApexPages.StandardController controller) {
            leadId = System.currentPageReference().getParameters().get('leadId'); 
            lead = [Select Name,Campaign__c from Lead where Id =: leadId];
            // R6 : Karthik : To avoid displaying Parent Campaign in the lookup field : Start
            lead.Campaign__c = null;
            // R6 : End
    }
    
    public PageReference Cancel(){
    PageReference retPage = new PageReference('/'+leadId);
    return retPage;
    }
    
    public Pagereference Save(){
        System.debug('****************primary***************'+primary);
        PageReference retPage;
        CampaignMember campMember;
        try{
            campMember = [Select Id,CampaignId,LeadId,Campaign.Name from CampaignMember where leadId =:leadId AND campaignId =:lead.Campaign__c];
        }
        catch(Exception e){
            e.getMessage();
        }
        if(campMember == null){
            campmember = new CampaignMember(leadId = lead.Id,campaignId = lead.Campaign__c,Primary__c = primary);
            
            // R6 - start : Do not allow parent campaign to be tagged to a lead. 
            try{ 
                insert campmember;
                retPage = new  PageReference('/'+ lead.Id);
            }
            catch(DmlException de){
                System.debug('**************** This is a Parent Campaign ');                           
                CreateApexErrorLog.insertHandledExceptions(de, null, 'CampaignMember', 'CampaignMemberController', '');
                for(Integer i =0; i<de.getNumDml(); ++i) { 
                    Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,de.getDmlMessage(i)));
                }
               // Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'This is a Parent Campaign. Please enter a child marketing campaign name.'));
                retPage = null; 
            }
            // R6 - end
         }
        else{
            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,lead.Name + ' is already a member of ' +campMember.Campaign.Name));
        }  
        return retPage;              
    }            
}