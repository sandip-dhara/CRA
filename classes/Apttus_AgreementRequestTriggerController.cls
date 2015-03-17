/**
    * Class Name: Apttus_AgreementRequestTriggerController
    * Author: HP (Sreekanth)
    * Date: 21-Feb-2013
    * Description: Update the Support Request whenever the agrrement Status or legal owner is updated and send a E-mail notification to the Requestor od SR.
    */
    public class Apttus_AgreementRequestTriggerController{
      public static void afterUpdate(List<Apttus__APTS_Agreement__c> agreementNewList,Map<id,Apttus__APTS_Agreement__c> agreementOldMap,Map<id,Apttus__APTS_Agreement__c> agreementNewMap){
        if(HPUtils.updateSRFlag== False){
         HPUtils.counter++;
         if(test.isRunningTest()== true && HPUtils.counter==4){
            HPUtils.updateSRFlag= True;
         }
       List<id> agreementIdList=new List<id>();
       List<Support_Request__C> supportRequstList=new List<Support_Request__C>();
       List<Id> SRIdlist=new List<Id>();
       List<Messaging.SingleEmailMessage> mailList =new List<Messaging.SingleEmailMessage>();
// Generating the list of agreement ids.   
      for(Apttus__APTS_Agreement__c agreement:agreementNewList){
           agreementIdList.add(agreement.SR_ID__c);
       }
       List<Support_Request__c> supportList=null;
         try{
         supportList=[select id,Request_Type__c,Contract_Request_Assignee__r.name,Account_Name__c,Agreement_Status__c,Requestor_Name__c,Agreement_Id__c,Opportunity_Name__c,Agreement_Number__c, Requestor_email__c from Support_Request__c where id IN:agreementIdList];
         }catch(Exception e){
          System.debug('Agreement does not have any suport request'+e);
         }
         if(supportList.size()>0){
// Updating the support request status and legal owner.          
          for(Apttus__APTS_Agreement__c agrment: agreementNewList){
             if((null!=agrment.SR_ID__c) && ((agreementNewMap.get(agrment.id).Apttus__Status__c !=agreementOldMap.get(agrment.id).Apttus__Status__c)||(agreementNewMap.get(agrment.id).Legal_Owner__c!=agreementOldMap.get(agrment.id).Legal_Owner__c))){
               for(Support_Request__c supptReqst :supportList){
                  if(supptReqst.Agreement_Id__c==agrment.id){
                    supptReqst.Agreement_Status__c=agrment.Apttus__Status__c;
                    supptReqst.Agreement_number__c=agrment.Apttus__FF_Agreement_Number__c;
                    supptReqst.Contract_Request_Assignee__c=agrment.Legal_Owner__c;
                    supportRequstList.add(supptReqst);
                    }
                }
            }   
         }
            update supportRequstList; 
// Generating the list of support request ids           
           for(Support_Request__c Sr: supportRequstList){
               SRIdlist.add(sr.id);
            }
            List<Support_Request__c>  SRList=[select id,Request_Type__c,Contract_Request_Assignee__r.name,Account_Name__c,Agreement_Status__c,Requestor_Name__c,Agreement_Id__c,Opportunity_Name__c,Agreement_Number__c, Requestor_email__c from Support_Request__c where id IN:SRIdlist];
// Send E-mail notification to the Requester of SR when status is updated.           
           for(Apttus__APTS_Agreement__c agrment: agreementNewList){
                for(Support_Request__c supptReq :SRList){
                    if((agrment.id==supptReq.Agreement_Id__c)&&(agreementNewMap.get(agrment.id).Apttus__Status__c=='Submitted Request' || agreementNewMap.get(agrment.id).Apttus__Status__c=='Assigned' || agreementNewMap.get(agrment.id).Apttus__Status__c=='In Authoring' ||   agreementNewMap.get(agrment.id).Apttus__Status__c=='Fully Signed' || agreementNewMap.get(agrment.id).Apttus__Status__c=='Completed' || agreementNewMap.get(agrment.id).Apttus__Status__c =='Cancelled' || agreementNewMap.get(agrment.id).Apttus__Status__c=='Request Closed') && (agreementNewMap.get(agrment.id).Apttus__Status__c !=agreementOldMap.get(agrment.id).Apttus__Status__c) && (HPUtils.AgreementUpdate==False)){
                        HPUtils.AgreementUpdate=True;
                        String emailBody=bodyFormat(supptReq.Request_Type__c,supptReq.id,supptReq.Opportunity_Name__c,supptReq.Account_Name__c,supptReq.Agreement_Status__c,supptReq.Requestor_Name__c);
                        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage() ; 
                        mail.setSubject('Your request status has been updated.');
                        mail.setPlainTextBody(emailBody);
                        String[] toAddresses = new String[] {supptReq.Requestor_email__c};
                        mail.setToAddresses(toAddresses); 
                        mail.saveAsActivity = false;
                        mail.setCharset('UTF-8');
                        maillist.add(mail);
                       }
//  E-mail notification to the requester when legal owner changes.             
                     if((agreementNewMap.get(agrment.id).Legal_Owner__c!=agreementOldMap.get(agrment.id).Legal_Owner__c) && (HPUtils.AgreementUpdateOwner==False)){
                        HPUtils.AgreementUpdateOwner=True;
                        String emailBody=bodyFormatForOwnerUpdate(supptReq.Request_Type__c,supptReq.id,supptReq.Opportunity_Name__c,supptReq.Account_Name__c,supptReq.Contract_Request_Assignee__r.name,supptReq.Requestor_Name__c);
                        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage(); 
                        mail.setSubject('Your legal owner has been updated.');
                        mail.setPlainTextBody(emailBody);
                        String[] toAddresses = new String[] {supptReq.Requestor_email__c};
                        mail.setToAddresses(toAddresses);  
                        mail.saveAsActivity = false;
                        mail.setCharset('UTF-8');
                        maillist.add(mail);
                       }  
                    }
                  }
               }         
            if(mailList.size()>0){
                 Messaging.sendEmail(mailList);              
            }
         }
     }
    /**
     *  Send E-mail notification to the Requester of SR when status is updated.      
    **/ 
        public static String bodyFormat(String RequestType,id srid,String opptyName,String accName,String status,String RequestorName){
            String str = '' ;
            str+= ' Hello '+RequestorName+','+'\n'+'\n';
            str +='The Status on your Request for Legal Support ID: "'+srid+'" for Account: "'+accName+'" and Opportunity: "'+opptyName+'" asking for "'+RequestType+'" has been updated to "'+status+'".';
            str +='\n'+'\n'+'Thank you'+'\n'+'Legal Support Team.';
            str = str.replace('null' , '') ;
            return str;
            }
    /**
     *  Send E-mail notification to the Requester of SR when Legal owner is updated.     
    **/         
         public static String bodyFormatForOwnerUpdate(String RequestType,id srid,String opptyName,String accName,String owner,String RequestorName){
            String str = '' ;
            str+= ' Hello '+RequestorName+','+'\n'+'\n';
            str +='The Legal Owner on your Request for Legal Support ID: "'+srid+'" for Account: "'+accName+'" and Opportunity: "'+opptyName+'" asking for "'+RequestType+'" has been assigned to "'+owner+'".';
            str +='\n'+'\n'+'Thank you'+'\n'+'Legal Support Team.';
            str = str.replace('null' , '') ;
            return str;
            }
      }