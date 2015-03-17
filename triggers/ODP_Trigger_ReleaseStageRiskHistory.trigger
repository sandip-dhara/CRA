trigger ODP_Trigger_ReleaseStageRiskHistory on Release_Stage__c (before update) {
    if(Trigger.isUpdate){
        for(Release_Stage__c rsc : trigger.new){
            try{
                //sql improvement Hunter 2, use trigger old set instead of the query.
                Release_Stage__c rscOld = null;
                for(Release_Stage__c rs:trigger.old)
                {
                    if(rs.Id == rsc.Id)
                    {
                        rscOld = rs;
                        break;
                    }
                }
                
                //Release_Stage__c rscOld = [select Status__c from Release_Stage__c where Name=:rsc.Name];
                //sql improvement Hunter 2
                
                /*if(!rsc.Status__c.equals(rscOld.Status__c)){
                    //create risk history when release stage get updated
                    List<Risk__c> riskList = [Select Severity__c ,Occurence__c,Detection__c,Name__c,Name, Status__c, Resolution__c 
                        from Risk__c where Offering_Release_ID__c =: rsc.Offering_Release_ID__c];
                    List<Risk_History__c> rhcList = new List<Risk_History__c>();                        
                    for(Risk__c tempRisk : riskList){
                        Risk_History__c rhc = new Risk_History__c();
                        rhc.Status__c = tempRisk.Status__c;
                        rhc.Resolution__c = tempRisk.Resolution__c;
                        rhc.Detection__c = tempRisk.Detection__c;
                        rhc.Severity__c = tempRisk.Severity__c;
                        rhc.Occurrence__c = tempRisk.Occurence__c; 
                        rhc.Release_Stage__c = rsc.id;
                        rhc.Risk_ID__c = tempRisk.id;                       
                        rhcList.add(rhc); 
                    }
                    if(rhcList.size() > 0){                    
                        insert rhcList;
                    }                    
                }*/
            }
            catch(exception e){
            
            }
        }
    }
}