/**********************************************************
* Trigger Name: ChangeEloquaContactEmailAddressTgr
* Author: Accenture
* Date: 22-AUG-2012 
* Requirement # Request Id:
* Description: Trigger to update dummy email on contact for ELOQUA
***********************************************************
* Author: HP
* Date: 23-AUG-2012 
* Requirement # CR Id:2643
* Description: 
1.Copy Standard email to Eloqua email if Eloqua sends adummy email.
2.Old and New email send to Eloqua, Eloqua Email set to null
***********************************************************/
trigger ChangeEloquaContactEmailAddressTgr on Contact (before insert, before update, after insert, after update) {
        
        if (trigger.isAfter) {
            if (trigger.isUpdate) {           
                map<string,string> emailsToChangeInEloqua = new map<string,string>();
                for ( Contact c : trigger.new ) {
                    if(c.Eloqua_Email__c != null && c.Eloqua_Email__c!= ''&& c.email != null && c.email !='') 
                    {
                        emailsToChangeInEloqua.put(c.Eloqua_Email__c, c.email);
                    }
                    if (c.email != null && c.email != '' 
                        && trigger.oldMap.get( c.id ).email != null 
                        && trigger.oldMap.get( c.id ).email != ''
                        && c.email != trigger.oldMap.get( c.id ).email ) 
                    {
                        emailsToChangeInEloqua.put(trigger.oldMap.get( c.id ).email, c.email);
                    }
                }
                if( emailsToChangeInEloqua.size() > 0 ) {
                ChangeEloquaEmailAddressCls.ChangeEloquaEmailAddress(emailsToChangeInEloqua);
                }
            }
            if (trigger.isInsert) {
                List<Contact> contactToUpdate = new List<Contact>();
                String str = null;
                for (Contact contact : Trigger.New) {
                    Contact tmpContact = new Contact(id=contact.Id);
                    if(contact.email != null && contact.email != '')
                    {
                        str = contact.email.subString(contact.email.length()-4,contact.email.length());
                        if (contact.Email != null && contact.email != '' && str == '.elq') 
                        {
                            tmpContact.Eloqua_Email__c = contact.Email;
                            tmpContact.Email = '';
                        } 
                    }
                    else 
                    {
                       tmpContact.Eloqua_Email__c = contact.Id + '@unknown.elq';
                    }
                    contactToUpdate.add(tmpContact);
                }
                if(contactToUpdate.size()>0)
                {
                try
                {
                    update contactToUpdate;
                }
                catch(Exception e){}
                }
            }
        }
        
        if (trigger.isafter && trigger.isUpdate) 
        {
            Set<Id> ContId= new Set<Id>();
            for (Contact con:Trigger.New) 
            {
                ContId.add(con.Id);
            }
            if (ContId.size() > 0 || ContId != null) 
            {
                ChangeEloquaEmailAddressCls.NullEloquaEmailAddressContact(ContId);
            }
        }
}