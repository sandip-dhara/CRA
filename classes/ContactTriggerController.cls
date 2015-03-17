/**
* Class Name: ContactTriggerController 
* Author: Accenture
* Date: 27-APR-2012 
* Requirement # Request Id:  Change request ID : 147
* Description: Contact Description should be keeping details pertaining to the Customer on Lead conversion.
*/
public Class ContactTriggerController {
    /**
    * @description: Action Before Lead Insert 
    */
    public static void beforeInsert(){
       ContactTriggerUtil.updateContactDescription();      
    }
}