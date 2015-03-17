trigger ODP_Trigger_ValidateBeforeStageReview on Release_Stage__c (before Update) {
    if(Trigger.isUpdate)
    {
         for(Release_Stage__c rsNew:trigger.new)
         {
             Release_Stage__c rsOld = null;       
             for(Release_Stage__c rs:trigger.old)
             {
                 if(rs.Id == rsNew.Id)
                 {
                     rsOld = rs;
                     break;
                 }
             }
             if(rsNew.Status__c == 'In Review' && rsOld.Status__c != 'In Review')
             {
                 if(rsNew.Predecessor_Release_Stage_ID__c != null)
                 {
                     System.debug('go in review');
                     Release_Stage__c predecessorStage = [select Status__c,Stage_Name__c from Release_Stage__c where Id=:rsNew.Predecessor_Release_Stage_ID__c limit 1];
                     if(predecessorStage.Status__c != 'Failed' && predecessorStage.Status__c != 'Cancelled' && predecessorStage.Status__c != 'Complete')
                     {
                         trigger.newMap.get(rsNew.Id).addError('Cannot Start Review, because the prodecessor stage [' + predecessorStage.Stage_Name__c + '] is in ' + predecessorStage.Status__c);
                     }
                 }
             }
          }
     }
}