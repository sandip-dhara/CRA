public class ExtendedTeamMemberRoleClass {
    
   /* public boolean disbledFiled{get;set;}
    public string myEditStates{get;set;}
    public string CurServiceLineId{get;set;}
    public string CurOfferingId{get;set;}
    public string CurReleaseId{get;set;}
    public string CurTeamMemberId{get;set;}
    public string CurServiceLine{get;set;}
    public string CurOffering{get;set;}
    public string CurRelease{get;set;}
    public string CurTeamMember{get;set;}
    public string RoleName{get;set;} 
    PUblic string MemberName{get;set;}    
    public boolean checkCoreMember{get;set;}   
     
    public  Team_Member_Role__c tmr{get;set;} 
    public boolean coreteammember{get;set;} */
    public ExtendedTeamMemberRoleClass(ApexPages.StandardController controller) {
        /*tmr = (Team_Member_Role__c)controller.getRecord();
        string upId = ApexPages.currentPage().getParameters().get('id');
        String teamMemberId = Apexpages.currentPage().getParameters().get('CF00NZ00000014T57');
        if(string.isNotEmpty(upId)) //update         
        {
            Team_Member_Role__c tempTMR = [select Name,Role_ID__c,Role_Name__c,Core_Member__c,Team_Member_ID__c from Team_Member_Role__c where id=:upId];            
            RoleName = tempTMR.Role_Name__c;
            checkCoreMember = tempTMR.Core_Member__c;            
            CurTeamMemberId = tempTMR.Team_Member_ID__c;
            Core_Team_Member__c ctm = [select User__c from Core_Team_Member__c where id =: CurTeamMemberId limit 1];
            User teammemberUser = [select Name from User where id =: ctm.User__c]; 
            CurTeamMember= teammemberUser.Name; 
            MemberName =  teammemberUser.Name;     
            myEditStates = 'Update';
        }
        else if(string.isNotEmpty(teamMemberId)) //new 
        {
            myEditStates = 'New';
            Core_Team_Member__c ctm = [select User__c,Name,id from Core_Team_Member__c where Name =: teamMemberId limit 1]; 
            if(ctm != null)
            {
                CurTeamMemberId = ctm.id;
                User teammemberUser = [select Name from User where id =: ctm.User__c]; 
                CurTeamMember = teammemberUser.Name;
                MemberName =  teammemberUser.Name;                 
            }
            else
            {
                CurTeamMember = '';
            }
        }
        else // new Risk 
        {
            myEditStates = 'New';
        }
        
        if(string.isNotEmpty(CurTeamMemberId))
        {
            Core_Team_Member__c ctm = [select User__c,Name,Offering_Release_ID__c from Core_Team_Member__c where id =: CurTeamMemberId limit 1]; 
            CurReleaseId = ctm.Offering_Release_ID__c;                    
            Offering_Release__c orc = [select Offering_ID__c,Offering_Name__c,Name__c from Offering_Release__c where id=:CurReleaseId];
             CurRelease =  orc.Name__c;              
            CurOffering = orc.Offering_Name__c;
            CurOfferingId = orc.Offering_ID__c;
            Offering__c oc = [select Service_Line_Name__c,Service_Line__c from Offering__c where id =:CurOfferingId];
            CurServiceLine = oc.Service_Line__c;
            CurServiceLineId = oc.Service_Line_Name__c;
            disbledFiled = true;
        }
        else
        {
            disbledFiled = false;
        }*/
    }
    
    /*public void DynamicRoleName(){
        list<Role__c> rolelist = [select Role_Name__c,Default_Core_Member__c from Role__c where id =:tmr.Role_ID__c];
        if(rolelist.size() > 0)
        {
            RoleName = rolelist[0].Role_Name__c;
            checkCoreMember = rolelist[0].Default_Core_Member__c;
            tmr.Core_Member__c = checkCoreMember ;           
        }
        else
        {
            RoleName = '';
        }
    }
    public PageReference save()
    {
        try{      
            string validateStr = RoleValidate(); 
            if(validateStr == 'success'){
                upsert tmr;
                PageReference OCPage = new PageReference('/'+tmr.Team_Member_ID__c);            
                //PageReference OCPage = new ApexPages.StandardController(tmr).view();
                OCPage.setRedirect(true);
                return OCPage;
            }
             else{
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, validateStr));       
                return null;
            }                       
        }
        catch(exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, e.getMessage()));        
            return null;        
        } 
    }
    
    public PageReference DoSaveNew(){
        try{       
            string validateStr = RoleValidate(); 
            if(validateStr == 'success'){
                upsert tmr;
                string s = '/' + ('' + tmr.get('Id')).subString(0, 3) + '/e?';
                //ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Info, s));
                return new Pagereference(s); 

            }
             else{
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, validateStr));       
                return null;
            }        
        }
        catch(exception e){
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, e.getMessage()));        
            return null;        
        }
    }
    
    public String RoleValidate()
    {
        string result = 'success';
        try{
            Team_Member_Role__c[] tmrList= [select Team_Member_ID__c from Team_Member_Role__c where Role_ID__c =:tmr.Role_ID__c and Team_Member_ID__c =: tmr.Team_Member_ID__c ];
            string upId = ApexPages.currentPage().getParameters().get('id');            
            if(myEditStates == 'new')
            {    //save new         
                if(tmrList.size() > 0)
                {
                    result = 'The Same Team Role for this member already exist, Please confirm your input';
                }
            }else 
            {   //update
                if(tmrList.size() > 0)
                {                
                    Team_Member_Role__c[] tmrCompareList= [select Role_ID__c from Team_Member_Role__c where id =: upId ];
                    if(tmrCompareList[0].Role_ID__c!= tmr.Role_ID__c){                                    
                        result = 'The Same Team Role for this member already exist, Please confirm your input';
                    }               
                }
            }         
        }
        catch(exception e){
            result = 'Validate data occur Exception:' + e.getMessage();
        }
        return result;
    } */   
}