/**********************************************************
* Trigger Name: ChangeEloquaLeadEmailAddressTgr
* Author: Accenture
* Date: 06-APR-2012 
* Requirement # Request Id:
* Description: Trigger to update dummy email on lead and contact for ELOQUA
***********************************************************
* Author: HP
* Date: 23-AUG-2012 
* Requirement # CR Id:2643
* Description: 
1.Copy Standard email to Eloqua email if Eloqua sends adummy email.
2.Old and New email send to Eloqua, Eloqua Email set to null
***********************************************************/

trigger ChangeEloquaLeadEmailAddressTgr on Lead (before insert, before update, after insert, after update) {
    
if ( trigger.isAfter) {
    if(trigger.isUpdate){
        map<string,string> emailsToChangeInEloqua = new map<string,string>();
        for ( Lead l : trigger.new ) {
            if (l.Eloqua_Email__c != null && l.Eloqua_Email__c!= '' && l.email != null && l.email !='') 
            {
                emailsToChangeInEloqua.put(l.Eloqua_Email__c, l.email);
            }
            if (l.email != null
            && l.email != ''
            && trigger.oldMap.get( l.id ).email != null
            && trigger.oldMap.get( l.id ).email != ''
            && l.email != trigger.oldMap.get( l.id ).email 
            ) 
            {
                emailsToChangeInEloqua.put(trigger.oldMap.get( l.id ).email, l.email);
            }
        }
        if ( emailsToChangeInEloqua.size() > 0 ) 
        {
            ChangeEloquaEmailAddressCls.ChangeEloquaEmailAddress(emailsToChangeInEloqua);
        }
    }
    if(trigger.isInsert)
    {
        List<Lead> LeadtoUpdate = new List<Lead>();
        String emailSubstr= null;
        for(Lead ld : Trigger.New)
        {
            Lead leadTemp = new Lead(Id = ld.Id);
            if(ld.Email != null && ld.email != '' )
            {
            emailSubstr = ld.email.subString(ld.email.length()-4,ld.email.length());
            if(emailSubstr == '.elq')
            {
                leadTemp.Eloqua_Email__c = ld.email;
                leadTemp.email = '';
            } 
            }  
            else
            {
               // if(ld.Email == null && ld.email == '' )
                leadTemp.Eloqua_Email__c = ld.Id + '@unknown.elq';              
            } 
            LeadtoUpdate.add(leadTemp);
             
        }
        if(LeadtoUpdate.size()>0)
        update LeadtoUpdate;
    }
    
}     
/**
* @description: To populate dummy email address if email field is blank
*/
    if(trigger.isafter && trigger.isUpdate)
    {
        Set<Id> LeadId = new Set<Id>();
        for (Lead ld:Trigger.New) 
        {
            LeadId.add(ld.Id);
        }
        if (LeadId.size() > 0 || LeadId != null) 
        {
            ChangeEloquaEmailAddressCls.NullEloquaEmailAddress(LeadId);
        }
    }
}