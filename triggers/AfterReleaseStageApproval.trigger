trigger AfterReleaseStageApproval on Offering_Release_Stage__c (before update) {    
   /* if(Trigger.isUpdate)    {        
        for(Offering_Release_Stage__c orsc:trigger.new)        
        {   
            try
            {        
                Offering_Release_Stage__c orscOld = [Select Status__c 
                From Offering_Release_Stage__c   Where Name = :orsc.Name];  
                
                if(!orsc.Status__c.equals(orscOld.Status__c)){          
                //if(orsc.Status__c.equals('Complete')&&(!orscOld.Status__c.equals('Complete'))){
                //insert a Risk History
                    List<Risk__c>  riskList = [Select Severity__c ,Occurence__c,Detection__c,Name__c,Name, Status__c, Resolution__c 
                        from Risk__c where Offering_Release_ID__c =: orsc.Offering_Release_ID__c];
                    for(Risk__c tempRisk : riskList ){
                        Risk_History__c rhc = new Risk_History__c();
                        rhc.Status__c = tempRisk.Status__c;
                        rhc.Resolution__c = tempRisk.Resolution__c;
                        rhc.Detection__c = tempRisk.Detection__c;
                        rhc.Severity__c = tempRisk.Severity__c;
                        rhc.Occurrence__c = tempRisk.Occurence__c; 
                        rhc.Offering_Release_Stage_ID__c = orsc.id;
                        rhc.Risk_ID__c = tempRisk.id;                       
                        insert  rhc;  
                    }                    
                } 
            }
            catch(exception e){
                //System.out.println(e.getMessage()); 
            }     
        }    
    }*/
}