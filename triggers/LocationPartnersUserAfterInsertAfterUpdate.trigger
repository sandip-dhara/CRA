/*
@description : Trigger logic contains for insert,update & delete (only delete logic is added in R5.0)
*/
trigger LocationPartnersUserAfterInsertAfterUpdate on Location_Partner_Users__c(after insert, after Update, after Delete) 
{
    if(Trigger.isInsert && Trigger.isAfter) 
    {
        system.debug('after insert testing territory definitions');
        UserAutomation.createTerritoryBasedOnAdminUser(Trigger.new);
    }    
    if(Trigger.isUpdate && Trigger.isAfter)
    {
        boolean updationLeadDeal = false;
        boolean updationNormal = false;
        List<Location_Partner_Users__c> oldValues = (List<Location_Partner_Users__c>)trigger.old;
        List<Location_Partner_Users__c> newValues = (List<Location_Partner_Users__c>)trigger.new;
        List<Location_Partner_Users__c> tobeUpdatedValue = new List<Location_Partner_Users__c>();
        List<Location_Partner_Users__c> tobeDeletedValue = new List<Location_Partner_Users__c>();
        List<Location_Partner_Users__c> newList = new List<Location_Partner_Users__c>();
        List<Location_Partner_Users__c> oldList = new List<Location_Partner_Users__c>();
        List<String> locationList = new List<String>();
        
        for(Location_Partner_Users__c tempNewValues : trigger.new)
        {
            for(Location_Partner_Users__c tempOldValues : trigger.old)
            {
                if(tempNewValues.id == tempOldValues.id)
                {
                    if(tempNewValues.Territory_Partner_Admin_Role__c != tempOldValues.Territory_Partner_Admin_Role__c )
                    {
                        if(tempNewValues.Territory_Partner_Admin_Role__c == null ||tempNewValues.Territory_Partner_Admin_Role__c == '' )
                        {
                            tobeDeletedValue.add(tempNewValues);
                        }
                        else if(tempNewValues.Territory_Partner_Admin_Role__c == 'Leads Administrator' || tempNewValues.Territory_Partner_Admin_Role__c == 'Deal Administrator' )
                        {
                            tobeUpdatedValue.add(tempNewValues);
                        }
                    }else{
                        if(tempNewValues.Location__c != tempOldValues.Location__c){
                            newList.add(tempNewValues);
                            oldList.add(tempOldValues);
                            locationList.add(tempNewValues.Location__c);
                            locationList.add(tempOldValues.Location__c);
                        }                       
                    }
                }
            }
        }       
        if(tobeDeletedValue != null)
        {
            UserAutomation.afterContactLocationDelete(tobeDeletedValue,false,false,false,false);
        }
        if(tobeUpdatedValue !=null)
        {
            UserAutomation.createTerritoryBasedOnAdminUser(tobeUpdatedValue);
        }
        if(newList !=null){
            LocationUtil.deleteUserfromSalesTeam(newList,oldList,locationList);
        }
    }   
    if(Trigger.isDelete && Trigger.isAfter) 
    {
        UserAutomation.afterContactLocationDelete(Trigger.old,false,false,false,false);
    }
}