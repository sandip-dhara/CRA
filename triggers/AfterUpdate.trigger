/**
* Class Name: AfterUpdate
* Author: HP - Mohit
* Date: 18-Feb-2013
* Description: This trigger will update all the quotes into HP Quote Custom Object for Custom Functionality
*/
trigger AfterUpdate on BigMachines__Quote__c (after update,after insert) {
    String sOperation='';
    
    if(trigger.isInsert)
    {
     sOperation='INSERT';
    }
    else
    {
      sOperation='UPDATE';
    }
    CPQcloneBMIQuoteWithHPQuote.updateBMIQuoteIntoHPQuote(Trigger.NewMap,sOperation);
}