trigger LB_UpdateDescription on Learning_Board__c (before insert, before update){
    for (Learning_Board__c objLB : Trigger.new){
        if(objLB.Description__c != null){
            integer i=objLB.Description__c.length();
            if(i>255)
              i=254;
            objLB.Short_Description__c = objLB.Description__c.substring(0,i);
        }
    }
}