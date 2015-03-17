global class ODP_RefreshRiskStatus
{
    @future(callout=true)
    public static void RefreshRiskStatus()
    {   
        List<Risks__c> riskList = [SELECT id, name, Name__c,Description__c,Planned_Resolution_Date__c,
            Business_Impact_ID__r.Potential_Risk_ID__r.Project_ID__c,
            Business_Impact_ID__r.Potential_Risk_ID__r.Project_ID__r.Owner.email,                
            Business_Impact_ID__r.Potential_Risk_ID__r.Project_ID__r.Owner.Name,
            Business_Impact_ID__r.Potential_Risk_ID__r.Project_ID__r.Facilitator__r.Email,
            Business_Impact_ID__r.Potential_Risk_ID__r.Project_ID__r.Facilitator__r.Name,
            Business_Impact_ID__r.Potential_Risk_ID__r.Project_ID__r.Name__c,
            Status__c,Risk_Priority_Number__c,
            Risk_Owner__c,Risk_Owner__r.id,Project_ID__c  
            FROM Risks__c where Status__c = 'Monitor' or Status__c = 'Active'];
        Set<Id> userIdSet = new Set<Id>();    

        set<Id> orIdSet = new  set<Id>();
        for(Risks__c risksObj : riskList){
            if(!orIdSet.contains(risksObj.Business_Impact_ID__r.Potential_Risk_ID__r.Project_ID__c)){
                orIdSet.add(risksObj.Business_Impact_ID__r.Potential_Risk_ID__r.Project_ID__c);
            }
            if(!userIdSet.contains(risksObj.Risk_Owner__c)){
                userIdSet.add(risksObj.Risk_Owner__c);
            }
        }
        List<User> tempUserList = [select id,email, Name from User where id in :userIdSet];     
               
        Map<Id,User> tempUserMap = new Map<Id,User>();   
        for(User u:tempUserList){
            tempUserMap.put(u.Id, u);
        }
        // get all related stage
        List<Release_Stage__c> stageList = [select id,Stage_Name__c,Offering_Release_ID__c,
            Stage_ID__c,Stage_ID__r.Maximum_Allowable_Risk_Priority_Nbr__c 
            from Release_Stage__c where Offering_Release_ID__c in: orIdSet and Status__c = 'In Progress'];
                                  
        Map<string,Release_Stage__c> orIdToStageMap = new Map<string,Release_Stage__c>();
        
        for(Release_Stage__c stageObj : stageList){
            if(!orIdToStageMap.containsKey(stageObj.Offering_Release_ID__c)){
                orIdToStageMap.put(stageObj.Offering_Release_ID__c,stageObj);    
            }
        }
        List<Risks__c> updateRisks = new List<Risks__c>();
       
        ODP_Class_BatchMail batchMail = new ODP_Class_BatchMail();
        for(Risks__c risksTemp : riskList){
            Release_Stage__c stageTemp = orIdToStageMap.get(risksTemp.Business_Impact_ID__r.Potential_Risk_ID__r.Project_ID__c);
                                
            if(stageTemp != null){              
                if(stageTemp.Stage_ID__c != null && stageTemp.Stage_ID__r.Maximum_Allowable_Risk_Priority_Nbr__c > 0){              
                    if(risksTemp.Status__c == 'Monitor' && risksTemp.Risk_Priority_Number__c >= stageTemp.Stage_ID__r.Maximum_Allowable_Risk_Priority_Nbr__c){  
                        risksTemp.Status__c = 'Active';   
                        
                        if(tempUserMap.get(risksTemp.Risk_Owner__r.id) != null){                               
                            batchMail.AddMailForRisk(tempUserMap.get(risksTemp.Risk_Owner__r.id),
                                'The Risk "' + risksTemp.Name__c + '" is active',
                                'The Risk "' + risksTemp.Name__c + '" status has been changed from monitor to active. Please check the detail information as below. And start to create mitigation action plan for this risk.',
                                '<a href="{base}/'+risksTemp.Business_Impact_ID__r.Potential_Risk_ID__r.Project_ID__c+'"> ' + risksTemp.Business_Impact_ID__r.Potential_Risk_ID__r.Project_ID__r.Name__c + '</a>',
                                '<a href="{base}/'+stageTemp.id+'"> ' + stageTemp.Stage_Name__c+ '</a>',
                                '<a href="{base}/apex/ODP_Page_MitigationPlan?id='+risksTemp.Id+'"> ' + risksTemp.Name__c + '</a>',
                                'Business Engagement Partner : <a href="mailto:' + risksTemp.Business_Impact_ID__r.Potential_Risk_ID__r.Project_ID__r.Facilitator__r.email  + '">  ' + risksTemp.Business_Impact_ID__r.Potential_Risk_ID__r.Project_ID__r.Facilitator__r.Name + ' </a>');                
                            
                            updateRisks.add(risksTemp);
                        }
                    }else if(risksTemp.Status__c == 'Active' && risksTemp.Risk_Priority_Number__c < stageTemp.Stage_ID__r.Maximum_Allowable_Risk_Priority_Nbr__c){
                         if(tempUserMap.get(risksTemp.Risk_Owner__r.id) != null){
                             batchMail.AddMailForRisk(tempUserMap.get(risksTemp.Risk_Owner__r.id),
                                'The Risk "' + risksTemp.Name__c + '" RPN  is now less than the current stage\'s Maximum Allowable RPN',
                                'The Risk "' + risksTemp.Name__c + '" Risk Priority Number now is less than the current stage\'s Maximum Allowable Risk Priority Nbr. Please review your risk.',
                                '<a href="{base}/'+risksTemp.Business_Impact_ID__r.Potential_Risk_ID__r.Project_ID__c+'"> ' + risksTemp.Business_Impact_ID__r.Potential_Risk_ID__r.Project_ID__r.Name__c + '</a>',
                                '<a href="{base}/'+stageTemp.id+'"> ' + stageTemp.Stage_Name__c+ '</a>',
                                '<a href="{base}/apex/ODP_Page_MitigationPlan?id='+risksTemp.Id+'"> ' + risksTemp.Name__c + '</a>',
                                'Business Engagement Partner : <a href="mailto:' + risksTemp.Business_Impact_ID__r.Potential_Risk_ID__r.Project_ID__r.Facilitator__r.email  + '">  ' + risksTemp.Business_Impact_ID__r.Potential_Risk_ID__r.Project_ID__r.Facilitator__r.Name + ' </a>');
                        }
                    }
                }
            }    
        }
        update updateRisks;
        Messaging.sendEmail(batchMail.LstMail);                     
   }
}