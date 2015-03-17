/**********************************************************
* Class Name: RemoveContractAssociation
* Author: HP
* Date: 23-July-2012 
* Requirement # 
* Description: Controller class to remove Contract Association from Renewal Opportunity.
***********************************************************/

global class RemoveContractAssociation {
  
   /**
    * @description: Method to get remove association of contracts from renewal Opportunity
    * */ 
    WebService static String removeassociation(Id[] cid) 
    { 
        String retString = 'Success';
        String OppName;
        Savepoint sp = Database.setSavepoint();
        system.debug('??????contract Ids'+cid);
        list<contract_reference__c> Contract = [Select id,original_opportunity__c,original_opportunity__r.name  from contract_reference__c where id in :cid];
        OppName = String.valueof(Contract[0].original_opportunity__r.name);
        for(Contract_reference__c c : Contract){
           c.original_opportunity__c = null;
           }
        try{
           if(contract != null && contract.size() > 0){
               update contract;
               }
           
        
        list<OpportunityLineitem> OppLineItem = [Select id, OpportunityId,PRICEBOOKENTRYID, CURRENCYISOCODE,QUANTITY,UNITPRICE,SUBTOTAL,LISTPRICE,OPPORTUNITYID__C,CONTRACT__C,ServiceDate, START_DATE__C,END_DATE__C,FIRST_FISCAL_YEAR_VALUE__C,MARGIN_AMOUNT__C from OpportunityLineitem where Contract__c in :cid];
                System.debug('??????Size'+OppLineItem.size());
               if(OppLineItem!= null && OppLineItem.size() > 0){
                   System.debug(COTestClassUtility.RemoveContractAssociationTestVar1);
                   /* Boolean b = COTestClassUtility.RemoveContractAssociationTestVar1;
                   if(b == true){
                       OppLineItem[0].UnitPrice = null;
                       update OppLineItem;
                       
                    
                    } */
                   Delete OppLineItem;
                   
                }
          }
       catch(DmlException dmlEx){
               
                CreateApexErrorLog.insertHandledExceptions(dmlEx, null, 'contract_reference__c', 'RemoveContractAssociation', '');
                retString = dmlEx.getDmlMessage(0); 
                Database.rollback(sp);
                System.debug('?????Error'+retString);
                   }
                   return retString;
               }
               
            
    }