trigger Metric_UpdateSearchText on MetricsAction__c (before insert, before update) {

 for (MetricsAction__c objcom : Trigger.new) {
        if(objcom.Text__C != null){
            integer i=objcom.Text__C.length();
            if(i>255)
              i=254;
            objcom.Search_Text__c = objcom.Text__c.substring(0,i);
        }
    }    

}