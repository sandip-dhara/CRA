trigger ODP_Trigger_FPLoadRelRoleFromCont on Contributor__c (before insert,before Update) {
    //if(Trigger.isInsert )    {        
        for(Contributor__c contc:trigger.new)        
        {         
            try
            {        
                //Stage_Work_Element__c swe = [Select Release_Stage_ID__r.Offering_Release_ID__c, Work_Element_ID__c 
                //    From Stage_Work_Element__c  Where id =: contc.Stage_Work_Element__c];                                    
                List<Release_Role__c> rrcList = [select id 
                    From Release_Role__c where Role_ID__c =: contc.Role__c and Offering_Release__c =: contc.Stage_Work_Element__r.Release_Stage_ID__r.Offering_Release_ID__c];                                                    
                if(rrcList.size() <= 0){
                    Release_Role__c rrc = new Release_Role__c();
                    rrc.Offering_Release__c = contc.Stage_Work_Element__r.Release_Stage_ID__r.Offering_Release_ID__c;
                    rrc.Role_ID__c = contc.Role__c;
                    rrc.Contributor__c = true;
                    insert  rrc;                   
                }
                else{
                    List<Release_Role__c> releaseroleList = new List<Release_Role__c>();
                    for(Release_Role__c tempRrc : rrcList ){
                        tempRrc.Contributor__c = true;                        
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