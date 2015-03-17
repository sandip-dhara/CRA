/**********************************************************
* Class Name: PCLM_FutureInsertACP
* Author: HP 
* Date: 23-Apr-2013 
* Description: Whenever the Partner creates Opportunity Partner account will add on Alliance and Channel Partners related List on Opportunity
***********************************************************/

public class PCLM_FutureInsertACP{
     /**
     * @description - Using Future method to reduce the number of queries when the partner converts the lead
     * 
     */
    @Future
    public static void insertACP(Id AccountId, Id opptyId, Id LocationId){
        Channel_Partner__c channelPartner=new Channel_Partner__c(
        Partner_Type__c='Channel Partner',
        Channel_Partner__c=AccountId,
        Location__c=LocationId,   
        Opportunity__c=opptyId);
        insert channelPartner;
    }
}