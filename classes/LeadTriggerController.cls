/**
* Class Name: LeadTriggerController
* Author: Accenture
* Date: 4-APR-2012 
* Requirement # Request Id: 323
* Description: Contains support action methods for trigger on lead object
*/
public class LeadTriggerController {
    /**
    * @description: Action Before Lead Insert 
    */
    Public static Boolean isLeadInsert=false;
    public static void beforeInsert(List<Lead> newleads){
        List<Lead> leads = new List<Lead>();
        for (Lead lead : newLeads) {
            if (lead.Lead_State__c == 'New') {
                leads.add(lead);    
            }
            
            /* R6 - Start 
             Author: HP (Rahul)
             Date: 17-July-2013
             Requirement # R 6.0
             //For new R6.0 field (Account assignment date)
            */
        if(lead.Account_Name__c !=null)
            {
                lead.Account_Assignment_Date__c=DateTime.Now();
            }
        // R6 - End     
            
            
        }
        isLeadInsert=true;
        if(leads.size() > 0) {
            LeadTriggerUtil.assignLeadOwnerManagers(leads); 
        } 
        /* To update account name on lead */
        LeadTriggerUtil.updateAccountOnLead(newLeads);
        LeadTriggerUtil.InsertLeadRegion(newLeads);
    }
        
    /**
    * @description: Action Before Lead Update 
    */
    public static void beforeUpdate(Map<Id, Lead> newLeads, Map<Id, Lead> oldLeads) {
        List<Lead> leads = new List<Lead>();
        String Emailstr = null;
        String qualifiedRT;          
        String unqualifiedRT;
        Map<String, Schema.SObjectField> leadFieldMap = Schema.SObjectType.Lead.fields.getMap();
        
    /**
    * @description: To update lead owner manager whenever lead owner is changing. 
    */
        List<Lead> leads1 = new List<Lead>();
        for (ID leadId : newLeads.keyset()) {
            //if (lead.Lead_State__c == 'New') {
                leads1.add(newLeads.get(leadId));    
            //}
        }
        isLeadInsert=true;
        if(leads1.size() > 0) {
            LeadTriggerUtil.assignLeadOwnerManagers(leads1); 
        }
        
     /* To get record type id of the 'Qulified Lead' */
        Schema.DescribeSObjectResult describeResult = Schema.SObjectType.Lead; 
        Map<String,Schema.RecordTypeInfo> rtMapByName = describeResult.getRecordTypeInfosByName();
        Schema.RecordTypeInfo rtQByName =  rtMapByName.get('Qualified Lead');
        Schema.RecordTypeInfo rtUQByName =  rtMapByName.get('Unqualified Lead');
        
        Emailstr= [Select id ,email from user where id =:userinfo.getUserId()].email; 

        /* Storing record type id in class property */
        if (rtQByName != null) {
            qualifiedRT = rtQByName.getRecordTypeId();
        }
        if (rtUQByName != null) {
            unqualifiedRT = rtUQByName.getRecordTypeId();
        }

        /* To get Record Type Id */
        
        
       /* RecordType recordtype = [Select Id, Name From RecordType 
                                Where RecordType.SobjectType = 'Lead' 
                                And RecordType.Name = 'Qualified Lead' ];*/
         
        for (Lead lead : newLeads.values()) {
            /* Validation rule to check Lead Acceptance before update */
            for (String leadFName: leadFieldMap.keySet()) {
                // Check if any field value on Lead is getting modified by user. If yes- then throw an error message.
                if (lead.get(leadFName) != Trigger.oldMap.get(lead.Id).get(leadFName)) {
                    if (leadFName.equalsIgnoreCase('OwnerId')) {
                        break;
                    } else if ( !isLeadInsert &&  
                                oldLeads.get(lead.Id).Lead_State__c != 'Accepted' && lead.Lead_State__c != 'Accepted') {
                        //lead.addError('Please Accept the lead before edit.');
                    }
                } 
            }
            //Checks if lead's status is changed to assigned or its owner is updated
            Lead oldLead = oldLeads.get(lead.Id);
            if ((oldLead != null && lead.Lead_State__c == 'New') &&
                (oldLead.Lead_State__c != lead.Lead_State__c ||
                lead.OwnerId != oldLead.OwnerId )) {             
                    leads.add(lead);
            }
            
            /*
            * Author: HP
            * Date: 7-JUL-2012  
            * Requirement # Request Id: 1850
            * Modification: Added logic to update User Closing Lead for Reporting
            */ 
            if ((lead.Status!= oldLeads.get(lead.Id).Status && lead.Status == 'Closed') || (lead.Lead_State__c!= oldLeads.get(lead.Id).Lead_State__c && lead.Lead_State__c== 'Wrong Assignment')) {
                lead.User_Closing_Lead__c = UserInfo.getUserId(); 
            }
            
             /*
            * Author: HP
            * Date: 23-Aug-2012  
            * CR ID: 2114
            * Modification: Added logic to update Lead rejector field for Reporting
            */ 
            if (lead.Lead_State__c== 'Wrong Assignment') {
                lead.Lead_Rejector__c = UserInfo.getUserId(); 
            }
         /**    
         * @Date: 13-DEC-2012    
         * @R4.0- Req No 4331
         * @Author: HP    
         * @description: Updating Lead Qualifier Email    
         */ 
            //String Emailstr= [Select id ,email from user where id =:userinfo.getUserId()].email;          
            if(lead.RecordTypeId == qualifiedRT  &&             
            oldLeads.get(lead.Id).RecordTypeId == unqualifiedRT &&            
            oldLeads.get(lead.Id).RecordTypeId !=lead.RecordTypeId)            
            {             
              lead.Lead_Qualifier__c = Emailstr;              
            }            
            System.debug('*************************oldLeads.get(lead.Id).OwnerId*********'+oldLeads.get(lead.Id).OwnerId);        
            
        /* R6 - START
             Author: HP (Rahul)
             Date: 17-July-2013
         //For new R6.0 field (Account assignment date)*/
        
        if(lead.Account_Name__c !=null)
                if(lead.Account_Name__c != oldLead.Account_Name__c && oldLead.Account_Name__c == null && lead.Account_Assignment_Date__c == null)
                {
                        lead.Account_Assignment_Date__c=DateTime.now();
                }   
            
        
        

        /*
        @Date: Aug-2013
        R6 requirement 5096
        Description: If owner is being changed from a queue to a user (by clicking on the Accept button on the Lead List view,
        change the Lead State as Accepted.  
        */
        
           // Lead oldLead = oldLeads.get(lead.id);
            System.debug('****oldLead*****'+oldLead);
            String id = oldLead.OwnerId ;
            String prefix = id.left(3);
            System.debug('******* Owner Id prefix: '+prefix);
            if((prefix =='00G') &&(lead.ownerId==UserInfo.getUserId())){
              //  System.debug('******** Owner was a queue *********');
             //   System.debug('********** New owner: '+lead.ownerId);
                System.debug('********** Lead status before: '+oldLead.Lead_State__c);
                System.debug('********** Lead status after: '+lead.Lead_State__c);
                
                if(oldLead.Lead_State__c !='Accepted')
                    lead.Lead_State__c = 'Accepted' ; 
            }
            
            
            /* R6 Requirement # 
            One-time email notification to be sent when a lead is created / updated with the following field values: 
            lead.One_Lead__c == true && lead.Email_Sent_to_OneLead_Submitter__c == false 
            
            Once sent, the field lead.Email_Sent_to_OneLead_Submitter__c should be set to true. 
            
           
            if (lead.One_Lead__c == true && lead.Email_Sent_to_OneLead_Submitter__c == false && lead.Referred_by_Email_address__c!=null ){
                
                System.debug('********** One_Lead__c : '+lead.One_Lead__c);
                System.debug(' ********* Email_Sent_to_OneLead_Submitter__c: '+lead.Email_Sent_to_OneLead_Submitter__c); 
                
                Id leadId = lead.Id;          
                String toEmail = lead.Referred_by_Email_address__c; 
                
                try{
                
                    system.debug('@@@@@@@@@2 HPUtils.LeadEmailNotifyFlag:'+HPUtils.LeadEmailNotifyFlag);
                    if(HPUtils.LeadEmailNotifyFlag ==true)
                    {
                    
                        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                        String[] toAddresses = new String[]{toEmail};
                        mail.setToAddresses( toAddresses );
                    
                        mail.setSubject('Lead Email notification for Lead '+lead.Id );
                        mail.setBccSender(false);
                        mail.setUseSignature(false);
//                      mail.setPlainTextBody('You are receiving this reffered by email from lead GRM ID: '+lead.GRM_ID__c   );
                        mail.setPlainTextBody('The lead submitted through webform has been created in salesforce and for future reference use this GRM ID:'+lead.GRM_ID__c   );
                        mail.setHtmlBody('');
                    //if(et!=null){
                    //mail.setTemplateId(et.Id);
                    //mail.setTargetObjectId(UserInfo.getUserId());
                    //mail.setTargetObjectId(lead.id);
                        mail.setSaveAsActivity(false);
                        System.debug('********** Lead.Id : '+lead.id);
                        //mail.setwhatId(lead.Id);
                    //}
                        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                    }
                        lead.Email_Sent_to_OneLead_Submitter__c = true;
                        HPUtils.LeadEmailNotifyFlag =false;
                    //update lead; 
                }
                catch(Exception e) {
                    System.debug('Error during send email: '+e.getMessage());
                }
                
                
            }*/
            

        // R6 - END
        
            
            
        }  
        if (leads.size() > 0) {
            LeadTriggerUtil.assignLeadOwnerManagers(leads); 
        }
        /*
        * Author: Accenture 
        * To update BU and GBU on lead 
        */  
        LeadTriggerUtil.updateLeadBUandGBU(newLeads, oldLeads);
        LeadTriggerUtil.updateLeadRegion(newLeads);

        //LeadTriggerUtil.updateAccountOnLead(newLeads, oldLeads);  
        /*
        * Author: Accenture
        * Date: 24-JUL-2012
        * Modification: Added logic to handle partner collab functionalities
        */ 
        PartnerCollabLeadUtil.leadUpdate(newLeads, oldLeads);  
    }
    
     /**
    * @description: Update Touch Allowed Checkbox Based on the Privacy Fields on Lead
    * Author: HP (Sreedhar Jagannath)
    * Date: 15-JUL-2013 
    */
 
    public static void ContactCenterBeforeUpdateLead(Map<Id, Lead> newLeads) {
    List<Lead> lstLead = new List<Lead> ();
    Set<Id> leadIds = new Set<Id> ();
    datetime myDateTime = datetime.now();
    Id LeadRecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Unqualified Lead').getRecordTypeId();

        for (Lead newlead: newLeads.values()) {                      
                    if ((newlead.C_Mobile_Opt_in1__c == 'N' && newlead.RecordTypeId == LeadRecordTypeId && newlead.Phone_Opt_in__c == 'Y') && newLead.LeadSource== 'List Import' && newlead.Last_Successful_Call__c == NULL && (newlead.CreatedDate.Date().daysBetween(myDateTime.Date())>7)){
                        newlead.Touch_Allowed__c= false;
                        newlead.Status = 'Closed';
                        newlead.Closed_Reason__c = 'Lead Expired';
                    }
                    else if ((newlead.C_Mobile_Opt_in1__c == 'N' && newlead.RecordTypeId == LeadRecordTypeId && newlead.Phone_Opt_in__c == 'Y') && newLead.LeadSource== 'List Import' && newlead.Last_Successful_Call__c <> NULL){
                        newlead.Touch_Allowed__c= true;
                    }
                    else if ((newlead.C_Mobile_Opt_in1__c == 'N' && newlead.RecordTypeId == LeadRecordTypeId && newlead.Phone_Opt_in__c == 'Y') && newLead.LeadSource== 'List Import' && newlead.Last_Successful_Call__c == NULL && (newlead.CreatedDate.Date().daysBetween(myDateTime.Date())<=7)){
                        newlead.Touch_Allowed__c= true;
                    }
                    else if ((newlead.C_Mobile_Opt_in1__c == 'Y' && newlead.RecordTypeId == LeadRecordTypeId && newlead.Phone_Opt_in__c == 'N') && newLead.LeadSource== 'List Import' && newlead.Last_Successful_Call__c == NULL && (newlead.CreatedDate.Date().daysBetween(myDateTime.Date())>7)){
                        newlead.Touch_Allowed__c= false;
                        newlead.Status = 'Closed';
                        newlead.Closed_Reason__c = 'Lead Expired';
                    }
                    else if ((newlead.C_Mobile_Opt_in1__c == 'Y' && newlead.RecordTypeId == LeadRecordTypeId && newlead.Phone_Opt_in__c == 'N') && newLead.LeadSource== 'List Import' && newlead.Last_Successful_Call__c <> NULL){
                        newlead.Touch_Allowed__c= true;
                    }
                    else if ((newlead.C_Mobile_Opt_in1__c == 'Y' && newlead.RecordTypeId == LeadRecordTypeId && newlead.Phone_Opt_in__c == 'N') && newLead.LeadSource== 'List Import' && newlead.Last_Successful_Call__c == NULL && (newlead.CreatedDate.Date().daysBetween(myDateTime.Date())<=7)){
                        newlead.Touch_Allowed__c= true;
                    }
                    else if ((newlead.C_Mobile_Opt_in1__c == 'N' && newlead.RecordTypeId == LeadRecordTypeId && newlead.Phone_Opt_in__c == 'N')&& newLead.LeadSource== 'List Import'){
                        newlead.Touch_Allowed__c= false;
                        newlead.Status = 'Closed';
                        newlead.Closed_Reason__c = 'Lead Expired';
                    }
                    else if ((newlead.C_Mobile_Opt_in1__c == 'Y' && newlead.RecordTypeId == LeadRecordTypeId && newlead.Phone_Opt_in__c == 'Y') && newLead.LeadSource== 'List Import' && newlead.Last_Successful_Call__c == NULL && (newlead.CreatedDate.Date().daysBetween(myDateTime.Date())>7)){
                        newlead.Touch_Allowed__c= false;
                        newlead.Status = 'Closed';
                        newlead.Closed_Reason__c = 'Lead Expired';
                    }
                    else if ((newlead.C_Mobile_Opt_in1__c == 'Y' && newlead.RecordTypeId == LeadRecordTypeId && newlead.Phone_Opt_in__c == 'Y') && newLead.LeadSource== 'List Import' && newlead.Last_Successful_Call__c <> NULL){
                        newlead.Touch_Allowed__c= true;
                    }
                    else if ((newlead.C_Mobile_Opt_in1__c == 'Y' && newlead.RecordTypeId == LeadRecordTypeId && newlead.Phone_Opt_in__c == 'Y') && newlead.Last_Successful_Call__c == NULL && (newlead.CreatedDate.Date().daysBetween(myDateTime.Date())<=7)){
                        newlead.Touch_Allowed__c= true;
                    }
                    
            
        }    
    }
    
    /**
    * @description: Action After Lead Insert 
    */
    public static void afterInsert(Map<Id, Lead> newLeads, Map<Id, Lead> oldLeads) {
        List<Lead> qualifiedLeads = new List<Lead>();
        List<Lead> leadsWithProductLines = new List<Lead>();
        Set<String> productLines = new Set<String>(); 
        List<Lead> leadstoupdate = new List<Lead>();
        Boolean productFlag = false;
        for (Lead lead : newLeads.values()) {
            productFlag = false;
            if(lead.Campaign__c <> NULL){
                Lead leadupdate = new Lead (Id=lead.id);
                leadupdate.Campaign__c =NULL;
                leadstoupdate.add(leadupdate);
            }
            if ((lead.Response_Product_Line_1__c != '' && lead.Response_Product_Line_1__c != null)) {
                productLines.add(lead.Response_Product_Line_1__c);
                productFlag = true;
            }
            if ((lead.Response_Product_Line_2__c != '' && lead.Response_Product_Line_2__c != null)) {
                productLines.add(lead.Response_Product_Line_2__c);
                productFlag = true;
            }
            if ((lead.Response_Product_Line_3__c != '' && lead.Response_Product_Line_3__c != null)) {
                productLines.add(lead.Response_Product_Line_3__c);
                productFlag = true;
            }
            if ((lead.Response_Product_Line_4__c != '' && lead.Response_Product_Line_4__c != null)) {
                productLines.add(lead.Response_Product_Line_4__c);
                productFlag = true;
            }
            if ((lead.Response_Product_Line_5__c != '' && lead.Response_Product_Line_5__c != null)) {
                productLines.add(lead.Response_Product_Line_5__c);
                productFlag = true;
            }
            if (productFlag) {
                leadsWithProductLines.add(lead);
            }
        }
        if(leadstoupdate.size() > 0){
        Database.update(leadstoupdate,false);
        }
        /* To add lead products */
        if (leadsWithProductLines.size() > 0) {
            LeadTriggerUtil.addLeadProducts(leadsWithProductLines, productLines); 
        }
    }
    
    /**
    * @description: Action After Lead Update
    */
    public static void afterUpdate(Map<Id, Lead> newLeadMap, Map<Id, Lead> oldLeadMap) {
        PartnerCollabLeadUtil.insertSharingForISR(newLeadMap,oldLeadMap);
        
    }    
}