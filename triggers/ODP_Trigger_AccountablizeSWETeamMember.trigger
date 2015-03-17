trigger ODP_Trigger_AccountablizeSWETeamMember  on Core_Team_Member__c (after insert,after update) {
 
        for(Core_Team_Member__c ctmcTemp : Trigger.new)
        {
            try        
            {
                Release_Role__c rrc = [select Offering_Release__c,Role_ID__c from Release_Role__c where id =: ctmcTemp.Release_Role__c ];                        
                List<Stage_Work_Element__c> sweList = [select id,Accountable_Role__c,Accountable_Team_Member__c
                    from Stage_Work_Element__c where Release_Stage_ID__r.Offering_Release_ID__c =: rrc.Offering_Release__c ];                                    
                system.debug('//////////////////////////////////');
                for(Stage_Work_Element__c sweTemp : sweList ){
                    if(rrc.Role_ID__c.equals(sweTemp.Accountable_Role__c) && (sweTemp.Accountable_Team_Member__c == '' || sweTemp.Accountable_Team_Member__c == null)){
                        sweTemp.Accountable_Team_Member__c = ctmcTemp.id;
                        update  sweTemp;                       
                    }
                }
             }
            catch(exception e)
            {                
                System.debug(e.getMessage());             
            }              
        }    
}