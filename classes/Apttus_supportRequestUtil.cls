/**
* Class Name: Apttus_supportRequestUtil
* Author: HP (Sreekanth)
* Date: 21-Feb-2013
* Description: R5---when ever submitting the SR Create an agreement with related opportuntiy,Account and SR data
* Reques Id: 5801
*/
public without sharing class Apttus_supportRequestUtil{
    public Static void afterUpdate(List<Support_Request__c> supportRequestNewList,Map<id,Support_Request__c> supportRequestOldMap,Map<id,Support_Request__c> supportRequestNewMap){
         if(HPUtils.insertAgreementFlag== False){
         if(test.isRunningTest()== true){
            HPUtils.insertAgreementFlag= True;
        }
        List<id> supportReqIdList =new List<id>();
        List<Apttus__APTS_Agreement__c> agreementList=new List<Apttus__APTS_Agreement__c>();
        List<String> accNameList=new List<String>();
        Map<Support_Request__c,opportunity> supportOpptyMap=new Map<Support_Request__c,opportunity>();
        Map<Support_Request__c,id> supportAccountMap=new Map<Support_Request__c,id>();
        Map<id,id> accountOpptyMap=new Map<id,id>();
        List<id> opptyIdList =new List<id>();
        List<id>accIdList=new List<id>();
        Id queueId=[Select id,QueueId from QueueSobject where SobjectType = 'Apttus__APTS_Agreement__c' AND Queue.Name = 'Support Request'].QueueId;                            
// Genrating the list of opportunity ids from SR   
         for(Support_Request__c supp : supportRequestNewList){
          opptyIdList.add(supp.Opportunity__c);
        }
        List<Opportunity> opptyList=[select id,accountid,ownerId from opportunity where id IN:opptyIdList];
// Genrating a Map of support request with opportunity. 
       for(Support_Request__c supp : supportRequestNewList){
            for(Opportunity oppt: opptyList){
                if(supp.Opportunity__c == oppt.Id){
                    supportOpptyMap.put(supp, oppt);      
                }
            }
        }
// genrating the map account with oppty.
         for(Opportunity opp:opptyList){
           accountOpptyMap.put(opp.id,opp.accountid);
           accIdList.add(opp.accountid);
        }
// genrating the map support request with account       
         for(Support_Request__c sReq:supportOpptyMap.keySet()){
          for(id oppid:accountOpptyMap.keySet()){
               if(supportOpptyMap.get(sReq).Id==oppid){
                  supportAccountMap.put(sReq,accountOpptyMap.get(oppid));
               }
           }
        }
// Creating the agreement with support request,opportunity and account deatils      
        for(Support_Request__c supportReqst: supportRequestNewList){
           if(supportRequestNewMap.get(supportReqst.id).isSRUpdate__c && supportRequestNewMap.get(supportReqst.id).isSRUpdate__c !=supportRequestOldMap.get(supportReqst.id).isSRUpdate__c && supportRequestNewMap.get(supportReqst.id).RecordTypeId==Schema.SObjectType.Support_Request__c.getRecordTypeInfosByName().get('FunctionalSupport-Legal').getRecordTypeId()&& supportRequestNewMap.get(supportReqst.id).Support_Sub_Type__c=='Legal' && supportRequestNewMap.get(supportReqst.id).Support_Category__c=='Functional Support'){
        for(Support_Request__c SupportRequest:supportOpptyMap.keyset()){
            for(Support_Request__c SA:supportAccountMap.keyset()){
                if(SupportRequest == SA){
                    Apttus__APTS_Agreement__c agreement = new Apttus__APTS_Agreement__c();
                    agreement.Apttus__Account__c=supportAccountMap.get(SA);
                    agreement.Apttus__Related_Opportunity__c=SupportRequest.opportunity__c;
                    agreement.Apttus__Description__c=SupportRequest.Opportunity_Description__c;
                    agreement.SR_Id__c=SupportRequest.Id;
                    agreement.Opportunity_No__c=SupportRequest.Opportunity_ID__c;
                    agreement.Opportunity_Type__c=SupportRequest.Opportunity_type__c;
                    agreement.Sales_Request_Type__c=SupportRequest.Request_Type__c;
                    agreement.Close_Date__c=SupportRequest.Closed_Date__c;
                    agreement.Customer_Location_Country__c=SupportRequest.Customer_Location_Country__c;
                    agreement.Public_Sector__c=SupportRequest.Public_Sector__c;
                    agreement.Route__c=SupportRequest.Route__c; 
                    agreement.Language_for_Agreement__c = SupportRequest.Language_for_Agreement__c;
                    agreement.Apttus__Primary_Contact__c=SupportRequest.PrimaryContact__c;
                    agreement.Industry_Vertical__c=SupportRequest.Industry_Vertical__c;
                    agreement.Apttus__Total_Contract_Value__c=SupportRequest.Total_Opportunity_Value__c;
                    agreement.Support_Number__c=SupportRequest.Name;
                    agreement.Customer_State_if_US__c=SupportRequest.Customer_Location_State__c;
                    agreement.Opportunity_Owner__c=supportOpptyMap.get(SupportRequest).OwnerId;
                    agreement.Sales_Stage__c=SupportRequest.Sales_Stage__c;
                    agreement.Apttus__Requestor__c=SupportRequest.createdById;
                    agreement.Primary_Partner_Acct__c=SupportRequest.Primary_Channel_Partner__c;
                    agreement.Incumbent_Competitor__c=SupportRequest.Incumbent_Competitor__c;
                    agreement.Primary_Competitor_Acct__c=SupportRequest.Primary_Competitor__c;
                    agreement.Industry_Segment__c=SupportRequest.Industry_Segment__c;
                    agreement.Sales_Coverage_Segment__c=SupportRequest.Sales_Coverage_Segment__c;
                    agreement.Comments__c=SupportRequest.Comments__c;
                    agreement.Lead_BU__c=SupportRequest.Owner_s_BG__c;
                    agreement.Managed_By__c=SupportRequest.Managed_By__c;
                    agreement.Apttus__Primary_Contact__c=SupportRequest.PrimaryContact__c;
                    agreement.Is_Global_Account__c=SupportRequest.Global_Account_Affiliation__c;
                    agreement.Specify_if_others__c=SupportRequest.Requst_Type_Specify_if_others__c;
                    agreement.Will_this_customer_use_standard_HP_terms__c=SupportRequest.Will_this_Opportunity_use_an_HP_standard__c;
                    agreement.ownerId=queueId;
                    agreement.RecordTypeId=Schema.SObjectType.Apttus__APTS_Agreement__c.getRecordTypeInfosByName().get('Not yet selected').getRecordTypeId();
                    agreementList.add(agreement);
                            }
                        }
                    }
                 if(agreementList.size()>0){
                    insert agreementList;
                   }
               }
            }
// Adding the all the Opportunity products to the agreement.            
        Apttus_AgreementRequestCreation.addAllProductsToAgreementLineItem(agreementList);
         /*
           * Date: 29-April
           * Author: Sreekanth
           * Reason: Intermittent solution to Submitting an SR for agreement creation as the API provided by Apttus team is not bulkified.
           * Calling the below webservice looping over the List of records to accommadate for this release till Apttus upgrades the API.
         */

        for(Apttus__APTS_Agreement__c agreement : agreementList){
           try{
            Apttus.AgreementWebService.submitRequestToQueue(agreement.id);
               }catch (Exception e) {
                  System.debug(logginglevel.ERROR,'Failed to Submit to Queue'+e);
              }
         }
      } 
   }
 }