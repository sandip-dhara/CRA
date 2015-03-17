trigger ODP_Trigger_ORFlightPlanLoad on Offering_Release__c (after insert) {
    if(Trigger.isInsert)
    {
        for(Offering_Release__c orc:trigger.new)
        {
            if(orc.Flight_Plan_ID__c != null){
                //Hunter:before insert flight plan add offering manager roles
                /*Role__c offeringManagerRole = [select Id,Independent_Reviewer__c,Is_Active__c from Role__c where Role_Name__c='Offering Manager Partner'];
                if(offeringManagerRole == null || offeringManagerRole.Id == null)
                {
                    trigger.newMap.get(orc.Id).addError('Offering Manager Role is required. Please contact OLC Administrators.');
                }
                else
                {
                    Release_Role__c newRole = new Release_Role__c(
                        Offering_Release__c = orc.Id,
                        Role_ID__c = offeringManagerRole.Id,
                        Accountable__c = false,
                        Contributor__c = false,
                        Reviewer__c = false
                    );
                    insert newRole;
                }*/
                
                
                //Hunter:add Project manager roles and team members
                Role__c projectManagerRole = [select Id,Independent_Reviewer__c,Is_Active__c from Role__c where Role_Name__c='Business Engagement Partner'];
                Id pMRoleId = null;
                if(projectManagerRole == null || projectManagerRole.Id == null)
                {
                    trigger.newMap.get(orc.Id).addError('Business Engagement Partner Role is required. Please contact OLC Administrators.');
                }
                else
                {
                    Release_Role__c newPMRole = new Release_Role__c(
                        Offering_Release__c = orc.Id,
                        Role_ID__c = projectManagerRole.Id,
                        Accountable__c = true,
                        Contributor__c = true,
                        Reviewer__c = true
                    );
                    insert newPMRole;
                    pMRoleId = newPMRole.Id;
                }
                
                
                ODP_Class_DataLoadUtility.AutoLoadReleaseDeliverable(orc.Flight_Plan_ID__c, orc.Id);
                ODP_Class_DataLoadUtility.AutoLoadReleaseStage(orc.Flight_Plan_ID__c, orc.Id);
                
                //insert new PM after all release role is add.
                Release_Role__c newPMRole = [select Id,Accountable__c,Contributor__c,Reviewer__c from Release_Role__c where Id=:pMRoleId];
                if(newPMRole != null && newPMRole.Id != null){
                    Core_Team_Member__c newPMMember = new Core_Team_Member__c();
                    newPMMember.Accountable__c = newPMRole.Accountable__c;
                    newPMMember.Contributor__c = newPMRole.Contributor__c;
                    newPMMember.Reviewer__c = newPMRole.Reviewer__c;
                    newPMMember.Release_Role__c = newPMRole.Id;
                    //newPMMember.User__c = UserInfo.getUserId();
                    newPMMember.User__c = orc.Facilitator__c;
                    insert newPMMember;
                }
            }
        }
    }
}