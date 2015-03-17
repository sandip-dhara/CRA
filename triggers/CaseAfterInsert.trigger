trigger CaseAfterInsert  on Case (After Insert) {

    Global_Config__c globalConfig = Global_Config__c.getInstance(); 
        if(globalConfig!=null){        
        // Do nothing if mute triggers set to true         
             if( globalConfig.Mute_Triggers__c == True ) {
             return; 
             }
        }
    
/**
* Release : HP R5
* Date: 14/02/2013  
* Requirement # Request Id: 5723
* Description: Whenever the an opportunity is cloned, all the partners/competitors of the current opportunity is added the new opportunity.
*/
    //for(Case c : Trigger.New){
    //List<Case> c = new List<Case>();            
    //   ContractOnCaseController.ContractOnCase(Trigger.new);
     //}
    Set<Id>  ParentIds = new Set<Id>(); 
    List<CaseMilestone> ParentCaseUpdate=new List<CaseMilestone>();
    List<Id> caseseligibleforOAE = new List<Id>();
    List<Case> reworkedCaseAssignment = new List<Case>();
    //Id cocaseId = RecordTypeIdHelper.getRecordTypeId('Case','CO Case');
      for(Case c : Trigger.New)
      {
        if(c.ParentId !=null)
        {
         ParentIds.add(c.ParentId);  
        }
      } 
        if(ParentIds.size()>0)
        {
         CaseTriggerUtil.ParentCaseMilestonesUpdate(ParentIds);
        } 
         
    
        If(HPUtils.CaseAfterInsert == False){
        
        HPUtils.CaseAfterInsert = True;
        
        ContractOnCaseController.ContractOnCase(Trigger.new);
       
        List<CaseMilestone> cm = [select MilestoneTypeId,MilestoneType.Name,TargetDate,CaseId From CaseMilestone where caseId in :Trigger.New limit 50000];
        system.debug('cm<<<<'+cm.size());
        List<case> caseList = new List<case>();
        for(Case c : Trigger.New){
          system.debug('debcheckpoint1' + c.Record_Name__c);
            //R5EF:CO:Debmalya:June10,'13:getting OAE eligibility for record types Custom Settings:Start
            OAE_Profile_List__c oae_prof = OAE_Profile_List__c.getInstance(c.Record_Name__c);
            //if(c.RecordTypeId == cocaseId){
            if(oae_prof != null && oae_prof.OAE_Is_Applicable__c != false){
            //R5EF:CO:Debmalya:June10,'13:getting OAE eligibility for record types Custom Settings:End
                System.debug('****************c.SelectedContracts__c'+c.SelectedContracts__c);
                
                system.debug('debcheckpoint2' + c.Assign_to_Team__c);
                if(!c.Case_Origin_is_Interface__c){
                   if(c.Rework_Revision__c == 'N/A'){
                       system.debug('debcheckpoint02');
                       caseseligibleforOAE.add(c.Id);
                   }else{
                       system.debug('debcheckpoint03'); 
                       reworkedCaseAssignment.add(c);
                   }
                }
                /************ OAE Invocation ****************/
                /*OAE_ObjectAssign objAsgn = new OAE_ObjectAssign();
                Map<ID,scoreObj[]> soMap = objAsgn.objectAssign( new List<ID>{c.Id}, 0 );
                System.debug( '>>> OAE RESPONSE: ' + soMap );*/
        
                /************ OAE Invocation ****************/
            }
            if(caseseligibleforOAE != null && caseseligibleforOAE.size() > 0){
               system.debug('debcheckpoint3' + caseseligibleforOAE);
               CaseTriggerController.caseAssignmentthroughOAE(caseseligibleforOAE);
            }
            
            if(reworkedCaseAssignment != null && reworkedCaseAssignment.size() > 0){
               CaseTriggerController.caseAssignmentforReworked(reworkedCaseAssignment);
            }
        }
       
        Update caseList;  
    }
}