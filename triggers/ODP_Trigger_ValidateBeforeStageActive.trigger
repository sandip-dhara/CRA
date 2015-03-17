/*
Functional Description
1, If Release Stage.Status changed from 'Not Started' to 'In progress' (Activate release stage), validate if all the contributors
and reviewers assigned specific team members. if no, error information displayed

2, If Release Stage.Status changed from 'Not Started' to 'In progress' (Activate release stage), validate if offering release status
is In Development - TBD

3, Error information display formatted  - TBD

*/

trigger ODP_Trigger_ValidateBeforeStageActive on Release_Stage__c (before Update) {
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
            if(rsNew.Status__c == 'In Progress' && rsOld.Status__c == 'Not Started')
            {
                string error = '';
                
                // added by Ning. accountable team member must be assigned before activate
                List <Stage_Work_Element__c> stgWEList = [
                    select Name, Accountable_Team_Member__c from Stage_Work_Element__c where Release_Stage_ID__c =: rsNew.Id and Optional__C = false
                ];
                for(Stage_Work_Element__c stgWE: stgWEList ){
                    if(stgWE.Accountable_Team_Member__c  == null){
                       error += stgWE.Name + 'did not assign accountable team member.'; 
                    }
                }
                // End
                
                List<Contributor__c> contributors = [
                    select Name,Team_Members__c,Stage_Work_Element_Name__c from Contributor__c
                    where Stage_Work_Element__r.Release_Stage_ID__c = :rsNew.Id and Stage_Work_Element__r.Optional__C = false
                ];
                for(Contributor__c contributor:contributors)
                {
                    if(contributor.Team_Members__c == null)
                    {
                        error += ' work element "'+contributor.Stage_Work_Element_Name__c + ' " contains non-assigned contributions.';
                    }
                }
                
                List<Review__c> reviewers = [
                    select Name,Team_Member__c,Stage_Work_Element_Name__c from Review__c
                    where Stage_Work_Element__r.Release_Stage_ID__c = :rsNew.Id and Stage_Work_Element__r.Optional__C = false
                ];
                for(Review__c reviewer:reviewers)
                {
                    if(reviewer.Team_Member__c == null)
                    {
                        error += ' work element "'+reviewer.Stage_Work_Element_Name__c + ' " contains non-assigned Reviews.';
                    }
                }
                if(!String.isEmpty(error))
                {
                    //trigger.newMap.get(rsNew.Id).addError('Begin Stage Validation Failed: ' + error);
                    trigger.newMap.get(rsNew.Id).addError('Operation Failed : Begin Stage Validation Failed due to unassigned contributions or reviews or accountable member for work elements under current stage');
                }
            }
         }
    }
}