public class PLMValidationTools{
   /* public static string ValidateCoreTeamMember(Core_Team_Member__c ctm, string selRole)
    {
        string result = 'success';
        try{
            Core_Team_Member__c[] seaCtm = [select name from Core_Team_Member__c where Offering_Release_ID__c=:ctm.Offering_Release_ID__c
                                          and Role_ID__c=:selRole
                                            and User__c=:ctm.User__c];
            if(seaCtm.size() > 0 )
            {
                result = 'The same core team member alredy exist, Please confirm your input';
            } 
        }
        catch(exception e){
            result = 'Validate data occur Exception:' + e.getMessage();
        }
        return result;
    }
    
    public static string ValidateReleaseStage(Offering_Release_Stage__c orsc)
    {
        string result = 'success';
        try{
            Offering_Release_Stage__c[] seaStage = [select name,Id from Offering_Release_Stage__c where Offering_Release_ID__c=:orsc.Offering_Release_ID__c
                                            and Stage_ID__c=:orsc.Stage_ID__c];
            if(seaStage.size() > 0 )
            {
                for(Offering_Release_Stage__c c: seaStage)
                {
                    if(c.id != orsc.id)
                    {
                        result = 'The same stage alredy exist,its number is '+c.Name+', Please confirm your input';
                        break;
                    }
                }
            } 
        }
        catch(exception e){
            result = 'Validate data occur Exception:' + e.getMessage();
        }
        return result;
    }*/
}