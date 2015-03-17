/**********************************************************
* Class Name: ContactCenterInteractionLogController
* Author: Deepak Saxena(Hewlett Packard)
* Date: 22-JUL-2013
* Requirement: This is controller for Custom Interaction Log.
* Description: This controller provides data and functionality to ContactCenterInteractionLog VF Page.
***********************************************************/

public with sharing class ContactCenterInteractionLogController {
    public Task t {get;set;}
    public Id objectId{get;set;}
    public List<RecordType> rc;
    
    /**
    * @description -  This is a constructor to initialize some variables.
    * @param: ApexPages.StandardController controller Task standard controller
    */ 
    
    public ContactCenterInteractionLogController(ApexPages.StandardController controller) {
        rc = [Select Id From RecordType Where Name = 'Contact Center Task Record Type' AND SobjectType = 'Task' Limit 1];
        t = new Task();
        t.RecordTypeId = rc[0].Id;

    }

    /**
    * @description -  This method is to Save the Task against the highlighted tab and reset the fields.
    * @param: No Paramater
    * @Return: Void 
    */
   
    
    public void saveAndNew(){
        
        System.debug('????????? In saveAndNew'+objectId);
        if(objectId != null){
            String objectName = objectId.getSObjectType().getDescribe().getName();
            if(objectName == 'Lead' || objectName == 'Contact')
                t.WhoId = objectId;
            if(objectName != 'Lead' && objectName != 'Contact')
                t.WhatId = objectId;
        }
        insert t;
        t = new Task();
        t.RecordTypeId = rc[0].Id;
        t.Type = 'Outbound Call';
        t.Status = 'Not Started';
        objectId = null;
    }

}