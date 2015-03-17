/**
* Class Name: ContactTriggerUtil 
* Author: Accenture
* Date: 27-APR-2012 
* Requirement # Request Id:  Change request ID : 147
* Description: Contact Description should be keeping details pertaining to the Customer on Lead conversion.
*/
public class ContactTriggerUtil {
	/**
    * @description - Set contact description during lead conversion 
    */
    public static void updateContactDescription() {   
         if (LeadConvertController.fromLeadConversion && Trigger.isInsert) {    
             List<Contact > contacts = (List<Contact>)Trigger.new ;
             for (Contact contact : contacts ) {          
                 contact.Description = '';      
             }  
         }
    }
}