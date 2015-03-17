trigger Learning_UpdateDescription on Learning__c (before insert, before update) {

 for (Learning__c objL : Trigger.new) 
    {
        if(objL.Description__c != null)
        {
            integer i=objL.Description__c.length();
            if(i>255)
              i=254;
              
            objL.Short_Description__c = objL.Description__c.substring(0,i);
        }
    }
    
}