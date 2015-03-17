trigger Collateral_UpdateDescription on Collateral__c(before insert, before update){
    for (Collateral__c objcom : Trigger.new) {
        if(objcom.Description__c != null){
            integer i=objcom.Description__c.length();
            if(i>255)
              i=254;
            objcom.Short_Description__c = objcom.Description__c.substring(0,i);
        }
    }    
}