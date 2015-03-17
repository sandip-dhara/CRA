/**********************************************************
 * Class Name: OpptyRenewal_SubTypesController
 * Author: HP
 * Date: 28-SEP-2012 
 * Requirement # 
 * Description: Controller class to OpptyRenewal_SubTypes page.
 ***********************************************************/

public class OpptyRenewal_SubTypesController {

        public Opportunity opp{get;set;}
        public Id oppId;

        /**
         * @description: Class Constructor method
         * @param StandardController Apex Page
         * 
         */

        public OpptyRenewal_SubTypesController(ApexPages.StandardController controller){
                ApexPages.Standardcontroller ap = controller;
                oppId=ApexPages.currentPage().getParameters().get('Id');
                opp=[Select id, Renewal_Type__c, Renewal_Sub_Type__c, TS_PROP__c, TS_Multinational__c, TS_Multi_BG__c, SW_ELA__c, SW_Premier__c, 
                     SW_Push_To__c, Multi_Year_Decline_Reason__c, Premier_Type__c from Opportunity Where Id=:oppId];

        }

        /**
         * @description: Save Function to Save the opportunity
         * @parameter: No Parameter required
         * 
         */

        public PageReference save(){
                try{

                        update opp;
                        if(COTestClassUtility.OpptyRenewal_SubTypesControllerTestVar1 == true){
                          
                          opp.CloseDate = null;
                          update opp;
                      
                      }
                }
                catch(DMLException e){
                        ApexPages.addMessages(e);
                }
                return new PageReference('/'+oppId);
        }
}