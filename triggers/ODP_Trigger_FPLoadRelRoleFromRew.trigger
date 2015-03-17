trigger ODP_Trigger_FPLoadRelRoleFromRew on Review__c (before insert) {
    //if(Trigger.isInsert)    {        
        for(Review__c reviewc:trigger.new)        
        {         
            try
            {        
                //Stage_Work_Element__c swe = [Select Release_Stage_ID__r.Offering_Release_ID__c, Work_Element_ID__c 
                //    From Stage_Work_Element__c  Where id =: reviewc.Stage_Work_Element__c];                                     
                List<Release_Role__c> rrcList = [select id 
                    From Release_Role__c where Role_ID__c =: reviewc.Role__c and Offering_Release__c =: reviewc.Stage_Work_Element__r.Release_Stage_ID__r.Offering_Release_ID__c];                                                   
                if(rrcList.size() <= 0){
                    Release_Role__c rrc = new Release_Role__c();
                    rrc.Offering_Release__c = reviewc.Stage_Work_Element__r.Release_Stage_ID__r.Offering_Release_ID__c;
                    rrc.Role_ID__c = reviewc.Role__c;
                    rrc.Reviewer__c = true;
                    insert  rrc;                   
                }
                else{
                    List<Release_Role__c> releaseroleList = new List<Release_Role__c>();
                    for(Release_Role__c tempRrc : rrcList ){
                        tempRrc.Reviewer__c = true;                        
                        releaseroleList.add(tempRrc);  
                    }
                    if(releaseroleList.size() > 0){
                        update releaseroleList;                    
                    }                                                       
                }               
            }
            catch(exception e){
                System.debug(e.getMessage()); 
            }     
        }    
   // }
}