public class ODP_Class_CommonTools{
    
    public static boolean IsBizEngaPartner(){
        boolean IsBizEngaP = false;
        List<PermissionSetAssignment> PS = [SELECT PermissionSetId FROM PermissionSetAssignment WHERE AssigneeId =:UserInfo.getUserId()  and PermissionSet.Name = 'ESIT_Business_Engagement_Partner'];
        id id1 = userinfo.getProfileId();
        List<Profile> pf = [select id, name from profile where id=:id1 and name='IT Administrator'];
        if(PS.size()>0 || pf.size() >0){
            IsBizEngaP = true;
        }

        return IsBizEngaP;
    }
    
    public static void CopyAttachmentToOtherObject(Id sourceParentId,Id tagetParentId)
    {
        List<Attachment> attList = [select id, name, body from Attachment where ParentId = :sourceParentId];
        Attachment[] insertAttList = new Attachment[]{};
        for(Attachment a: attList)
        {
            Attachment att = new Attachment(name = a.name, body = a.body, parentid = tagetParentId);
            insertAttList.add(att);
        }
        if(insertAttList.size() > 0)
        {
            insert insertAttList;
        }
    }
    
    public static boolean CheckAllPreSWEIsCompleted(Id sweId, Integer StepNo)
    {
        List<Stage_Work_Element_Predecessor__c> PreSWE = [select Include__c,Predecessor_Stage_Work_Element_ID__c,
                 Predecessor_Stage_Work_Element_ID__r.Status__c,
                 Predecessor_Stage_Work_Element_ID__r.Include__c
            from Stage_Work_Element_Predecessor__c
            where Stage_Work_Element__c = :sweId
                    ];
        for(Stage_Work_Element_Predecessor__c swe:PreSWE)
        {
            if(swe.Predecessor_Stage_Work_Element_ID__r.Include__c && swe.Predecessor_Stage_Work_Element_ID__r.Status__c != 'Complete')
            {
                return false;
            }
            if(StepNo < 10)
            {
                if(!CheckAllPreSWEIsCompleted(swe.Predecessor_Stage_Work_Element_ID__c,StepNo + 1))
                {
                    return false;
                }
            }
        }
        return true;
    }
    
    //Hunter: set work element to rework, reset status, inform contributor
    public static String ReworkWorkElment(String SWEId)
    {
        string message = '';
        try{
            Stage_Work_Element__c swe = [select id ,Status__c,Name__C,Release_Stage_ID__c,Stage_Name__c,
                Release_Stage_ID__r.Offering_Release_ID__c,
                Release_Stage_ID__r.Release_Name__c,
                Release_Stage_ID__r.Offering_Release_ID__r.Owner.email,
                Release_Stage_ID__r.Offering_Release_ID__r.Owner.Name,
				Release_Stage_ID__r.Offering_Release_ID__r.Facilitator__r.email,
                Release_Stage_ID__r.Offering_Release_ID__r.Facilitator__r.Name
                from Stage_Work_Element__c where id =: SWEId];
            swe.Status__c = 'In Progress';
            update swe;
            List<Contributor__c>  ContribTempList = [select id,Completed__c, Team_member_name__c,Team_Members__r.User__c,Role_Name__c from Contributor__c where Stage_Work_Element__c =: SWEId];
            for(Contributor__c contribTemp : ContribTempList){
                contribTemp.Completed__c = false; 
                update contribTemp;
            }
            List<Review__c>  ReviewerTempList = [select id,Complete__c,Comment__c from Review__c where Stage_Work_Element__c =: SWEId];
            for(Review__c rewTemp : ReviewerTempList ){
                rewTemp.Complete__c = false;
                rewTemp.Rating__c = '0'; 
                rewTemp.Comment__c = '';
                update rewTemp ;
            }
            
            //send email to inform the reviewer and contributor
             Set<Id> informToSet = new Set<Id>();
            List<Contributor__c> contributors = [
              select Completed__c,Team_Members__r.User__c
                from Contributor__c
                where Stage_Work_Element__c=:SWEId
            ];
            for(Contributor__c contributor:contributors)
            {
                if(!informToSet.contains(contributor.Team_Members__r.User__c))
                {
                    ODP_Class_EmailNotification.SendToPerson(String.valueOf(contributor.Team_Members__r.User__c),
                              'The work element "' + swe.Name__C + '" has been set to rework.',
                              'The work element "' + swe.Name__C + '" has been set to rework by the '+userInfo.getName()+', Please check the detail information as below and start to rework.',  
                              '<a href="{base}/'+swe.Release_Stage_ID__r.Offering_Release_ID__c+'"> ' + swe.Release_Stage_ID__r.Release_Name__c + '</a>',
                              '<a href="{base}/'+swe.Release_Stage_ID__c+'"> ' + swe.Stage_Name__c + '</a>',
                                                             null,
                              '<a href="{base}/'+contributor.Id+'"> ' + swe.Name__C + '</a>',
                              'Business Engageent Partner : <a href="mailto:' + swe.Release_Stage_ID__r.Offering_Release_ID__r.Facilitator__r.email  + '">  ' + swe.Release_Stage_ID__r.Offering_Release_ID__r.Facilitator__r.Name + ' </a>');
                    informToSet.add(contributor.Team_Members__r.User__c);
                }
            }
            message = 'success';
        }
        catch(exception e){
            message = 'error:' + e.getMessage();
        }
        return message;
    }
}