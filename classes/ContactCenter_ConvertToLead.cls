/**********************************************************
* Class Name: ContactCenter_ConvertToLead
* Author: Deepak Saxena(Hewlett Packard)
* Date: 22-JUL-2013
* Requirement: Lead Conversion to Contact for Contact Center
* Description: This class is used for Lead conversion to Contact Only.
***********************************************************/
global class ContactCenter_ConvertToLead{

    /**
    * @description -  This method is to find whether we have existing contact with the same name, Account name as of the lead that we are going to convert.
    * @param: First Name, Last Name, Account Name of the lead.
    * @Return: Boolean value 
    */
    
    webservice static Boolean IsDuplicate(String FirstName, String LastName, String AccountName){
        
        Integer contactCount = [Select Count() From Contact Where FirstName = :FirstName AND LastName = :LastName AND Account.Name = :AccountName];
        System.debug('??????'+contactCount);
        if(contactCount == 0)
            return false;
        else
            return true;

    }
    
    /**
    * @description -  This method is to convert a lead to contact. This method calls existing LeadConvertController functionality.
    * @param: Lead Id
    * @Return: Id of the contact created. 
    */
    
    webservice static Id convertLead(Id leadId){
        List<Lead> leadList = [Select Id, FirstName, LastName, Title, Account_Name__c, Phone, MobilePhone, Email, Preferred_Method_of_Contact__c, Preferred_Language__c,  Fax, Job_Role__c, Business_Function__c, Industry, Job_Responsibilities__c, Job_Seniority__c, C_Isolation_Status1__c, C_Isolation_Status_Date1__c, Email_Opt_In__c, Email_Opt_In_Change_Date1__c, Fax_Opt_In__c, Fax_Opt_in_Change_Date__c, Mail_Opt_in__c, Mail_Opt_In_Change_Date__c, C_Mobile_Opt_in1__c, Mobile_Opt_in_Change_Date__c, Phone_Opt_in__c, Phone_Opt_in_Change_Date__c, Street, City, State, Country, PostalCode,
        IsConverted,ConvertedAccountId, ConvertedContactId, Status, Closed_Reason__c, LeadSource, Preferred_Subjects__c From Lead Where Id = :leadId];
        
        if(leadList.size()>0){
        
            Savepoint sp = Database.setSavepoint();
            
            leadList[0].Closed_Reason__c = 'Created Contact';
            
            update leadList;
            
            ApexPages.StandardController sc = new ApexPages.StandardController(leadList[0]);
            LeadConvertController lc = new LeadConvertController(sc);
            lc.FromConvertToContact = true;
            lc.doNotCreateOpty = true;
            lc.sendNotificationEmail = false;
            PageReference pg = lc.leadConvert();
            
            if(pg == null){
                Database.rollback(sp);
                return null;
            }
            
            else{ 
                String str = pg.getUrl();
                System.debug(str);
                str = str.substringAfter('/');
                Id id = (ID)str;
    
                return id;
            }
            }
            else
                return null;
    }

}