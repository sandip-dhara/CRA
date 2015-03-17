trigger territoryInactivation on Sales_Territory__c (before update) {            
set<id> ids = new set<id>();
for(Sales_Territory__c ss : trigger.new)   {
    if(ss.IsActive__c == false){
         ids.add(ss.id);
    }
}  
     
     if (system.Trigger.isUpdate){
        Sales_Territory_user_Assignment__c[] sTerr = [select id, Sales_Territory__r.IsActive__c,IsActive__c,sales_territory__c from Sales_Territory_user_Assignment__c where sales_territory__c in :Trigger.newMap.keySet() and isActive__c = true and sales_territory__c in :ids];                                      
        if(sTerr.size()>0){ 
        for (Sales_Territory_User_Assignment__c o : sTerr){           
                       
                Sales_Territory__c actualRecord = Trigger.newMap.get(o.sales_Territory__r.Id);         
                actualRecord.adderror('You cannot inactive this territory as it has one or more users are active');          
                }
            } 
        }
    }