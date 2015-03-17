trigger RelatedContractAfterInsert on Related_Contracts__c (After insert) {

    Global_Config__c globalConfig = Global_Config__c.getInstance(); 
    if(globalConfig!=null){        
         // Do nothing if mute triggers set to true         
        if( globalConfig.Mute_Triggers__c == True ) {
            return; 
        }
    }
    
    
    if(Trigger.isAfter && Trigger.isInsert){
        List<Case> caselisttoupdate=new List<Case>();
        Set<Id> caseid=new Set<Id>();
        for(Related_Contracts__c contract: trigger.new){
            caseid.add(contract.case__c);            
        }
        system.debug('CCCCCCCCCC'+caseid);
        
        List<Case> caselist=[select id, SelectedContracts__c, status from Case where id in: caseid];
        system.debug('%%%%%%%%'+caselist);
        
        for(Case Caserec : caselist){
            if (Caserec.status!='Closed'){
                Caserec.SelectedContracts__c = '';             
                //Caserec.IsCaseStatusClosed__c = False; 
                caselisttoupdate.add(Caserec);
            }
        }
        if (caselisttoupdate.size()>0)
            update caselisttoupdate;
        system.debug('&&&&&'+caselisttoupdate);
    }
    
}