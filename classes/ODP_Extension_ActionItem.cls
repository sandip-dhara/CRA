public class ODP_Extension_ActionItem {
    public Action_Item__c actionItem{get;set;}
    public string UserId {get;set;}
    public String myEditStates{get;set;}
    public List<Core_team_member__c> ctmList{get;set;}
    public List<ODP_PAC_member__c> PACMemberList{get;set;}
    public string retURL {get;set;}
    public string CurObjID{get;set;}
    public string CurOffRelID{get;set;}
    public boolean IsPMorFac{get;set;} 
    public Boolean IsAbletoEdit{get;set;}
    public List<Release_Stage__c> releaseStageList{get;set;}
    public Release_stage__c stagOBJ {get;set;}
    public string STGID{get;set;}
    public ODP_Extension_ActionItem (ApexPages.StandardController controller) {
       actionItem = (Action_Item__c)controller.getRecord();
       CurObjID = ApexPages.currentPage().getParameters().get('id');
       retURL = ApexPages.currentPage().getParameters().get('retURL');
       STGID =  ApexPages.currentPage().getParameters().get('STGID');  
       UserId = UserInfo.getUserId();
       if(CurObjID == null)
        {
            myEditStates = 'Create';
            actionItem.Status__c = 'In Progress'; 
            if(string.isNotEmpty(STGID)){
                //retURL =  ApexPages.currentPage().getParameters().get('retURL').substring(1);
                stagOBJ = [select id, Offering_Release_ID__c, Release_Name__c, PAC_Name__c,Offering_Release_ID__r.Owner.Id,
                                       Offering_Release_ID__r.Facilitator__c, status__c  from Release_Stage__c where id=: STGID];
                
                system.debug('--------------' + STGID + '----' + stagOBJ.id);
                //hunter add stage status
                if(stagOBJ.Status__c == 'In Progress' || stagOBJ.Status__c == 'In Review' || stagOBJ.Status__c == 'Review Complete'){
                    IsAbleToEdit = true;
                }
                else{
                    IsAbleToEdit = false;
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'You are only allowed to create or edit action items when stage is "in progress","in Review","Review Complete".'));
                }
                //PM or Facilitator                                
               if(UserId.equals(stagOBJ.Offering_Release_ID__r.Owner.Id) || UserId.equals(stagOBJ.Offering_Release_ID__r.Facilitator__c)){
                   IsPMorFac = true;
               }
               else{
                   IsPMorFac = false;
               }                       
                ctmList = [select id, Role_Name__c, User__c,User__r.Id,  User__r.Last_First_Name__c, Release_Name__c from Core_team_member__c where Release_Name__c =: stagOBJ.Release_Name__c ];    
                PACMemberList = [select id, PAC_Name__c, User__r.Last_First_Name__c, User__c from ODP_PAC_Member__c where PAC_Name__c =: stagOBJ.PAC_Name__c];
                CurOffRelID = stagOBJ.Offering_Release_ID__c;
                releaseStageList = [select id,Stage_Name__c from Release_Stage__c where Offering_Release_ID__c =: CurOffRelID and (Status__c = 'In Progress' or Status__c = 'In Review' or Status__c = 'Review Complete')];
            	system.debug('--------------' + releaseStageList.size() + '----');
                //releaseStageList = [select id,Stage_Name__c from Release_Stage__c where Offering_Release_ID__c =: CurOffRelID];
            }
        }
        else
        {
            myEditStates = 'Update';
            actionItem = [select id,Action_Owner__c,Description__c,Due_Date__c,Name__c,Notes__c,PAC_Requestor__c,Stage_ID__c,Stage_ID__r.Stage_Name__c,Status__c 
                from Action_Item__c where id =: actionItem.Id];
            stagOBJ = [select id, Release_Name__c,Offering_Release_ID__c, PAC_Name__c,Offering_Release_ID__r.Owner.Id,Status__c,
                                       Offering_Release_ID__r.Facilitator__c from Release_Stage__c where id=: actionItem.Stage_ID__c];
            
            //hunter add stage status
            if(stagOBJ.Status__c == 'In Progress' || stagOBJ.Status__c == 'In Review' || stagOBJ.Status__c == 'Review Complete'){
                IsAbleToEdit = true;
            }
            else{
                IsAbleToEdit = false;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'You are only allowed to create or edit action items when stage is "in progress","in Review","Review Complete".'));
            }
            //PM or Facilitator                                
               if(UserId.equals(stagOBJ.Offering_Release_ID__r.Owner.Id) || UserId.equals(stagOBJ.Offering_Release_ID__r.Facilitator__c)){
                   IsPMorFac = true;
               }
               else{
                   IsPMorFac = false;
               }                           
            ctmList = [select id, Role_Name__c, User__c,User__r.Id,  User__r.Last_First_Name__c, Release_Name__c from Core_team_member__c where Release_Name__c =: stagOBJ.Release_Name__c];       
            PACMemberList = [select id, PAC_Name__c, User__r.Last_First_Name__c, User__c from ODP_PAC_Member__c where PAC_Name__c =: stagOBJ.PAC_Name__c];
            CurOffRelID = stagOBJ.Offering_Release_ID__c;
            releaseStageList = [select id,Stage_Name__c from Release_Stage__c where Offering_Release_ID__c =: CurOffRelID and (Status__c = 'In Progress' or Status__c = 'In Review' or Status__c = 'Review Complete')];
        }
    }
    
    
    public Core_team_member__c currentSelectRole{get;set;} //Add by June 4.30
    public List<SelectOption> CTMName{
      get{
            List<SelectOption> options = new List<SelectOption>();   
            //Add by June 4.30  retURL 
            
            if(CurObjID ==null ){
                currentSelectRole= [select id, Role_Name__c, User__c,User__r.Id,  User__r.Last_First_Name__c, Release_Name__c from Core_team_member__c where Release_Name__c =: stagOBJ.Release_Name__c and Role_Name__c ='Business Engagement Partner'];
                //currentSelectRole= [select id, Role_Name__c, User__c,User__r.Id,  User__r.Last_First_Name__c, Release_Name__c from Core_team_member__c where Release_Name__c =: stagOBJ.Release_Name__c];
                options.add(new SelectOption(currentSelectRole.id,currentSelectRole.User__r.Last_First_Name__c + ' | ' + currentSelectRole.Role_Name__c));
            }else{
                currentSelectRole= [select id, Role_Name__c, User__c,User__r.Id,  User__r.Last_First_Name__c, Release_Name__c from Core_team_member__c where Release_Name__c =: stagOBJ.Release_Name__c and id=:actionItem.Action_Owner__c];
                options.add(new SelectOption(currentSelectRole.id,currentSelectRole.User__r.Last_First_Name__c + ' | ' + currentSelectRole.Role_Name__c));
            }
            
            
            //End
            
            
            for(core_team_member__c ctmobj : ctmList){
              options.add(new SelectOption(ctmobj.id,ctmobj.User__r.Last_First_Name__c + ' | ' + ctmobj.Role_Name__c));                           
            }
            return options;
         }
    }
    public List<SelectOption> StatgInprogress{
      get{
            List<SelectOption> options = new List<SelectOption>();                  
            for(Release_Stage__c rsobj: releaseStageList){
              options.add(new SelectOption(rsobj.id , rsobj.Stage_Name__c));                           
            }
            return options;
         }
    }
    public List<SelectOption> PACRequestor{
      get{
            List<SelectOption> options = new List<SelectOption>();                  
            for(ODP_PAC_Member__c  pacmobj : PACMemberList){
              options.add(new SelectOption(pacmobj.id , pacmobj.User__r.Last_First_Name__c));                           
            }
            return options;
         }
    }
        
    private string saveData(){
        try{
            /*
            if(myEditStates == 'Create')
            {
                List<Action_Item__c> actionItemList = [select id from Action_Item__c where Name__c =: actionItem.Name__c and Stage_ID__c =: actionItem.Stage_ID__c]; 
                if(actionItemList.size() > 0){
                    return 'The same action item  in this Stage already exist, Please confirm your input.';
                }
            }else if(myEditStates == 'Update')
            {
                List<Action_Item__c> actionItemList = [select id from Action_Item__c where Name__c =: actionItem.Name__c and Stage_ID__c =: actionItem.Stage_ID__c]; 
                if(actionItemList.size() > 1){
                    return 'The same action item  in this Stage already exist, Please confirm your input.';
                }
            }
            */
            if(!(stagOBJ.status__c == 'In Progress' || stagOBJ.status__c == 'In Review')){
                return 'Action Items are not allowed to be created and edit, for the current stage status is NOT In Progress or In Review. ';
            }         
            return 'success';
        }
        catch(exception e){
            return 'failed';   
        }                 
    }

    public PageReference SaveActionItem(){
        string saveflag = saveData();
        if(saveflag == 'success')
        {
            if(myEditStates == 'Create'){
                //When action item is added, notify owner 
                Core_team_member__c ownerCTM =[select User__c,User__r.Id from Core_team_member__c where Id =: actionItem.Action_Owner__c];
                Release_Stage__c stagTemp = [select id, Release_Name__c,Offering_Release_ID__c, PAC_Name__c,Offering_Release_ID__r.Owner.Id,Offering_Release_ID__r.Owner.email,
                                           Offering_Release_ID__r.Owner.Name,Status__c,
										   Offering_Release_ID__r.Facilitator__r.name,
										   Offering_Release_ID__r.Facilitator__r.email,
                                           Offering_Release_ID__r.Facilitator__c,Stage_Name__c from Release_Stage__c where id=: actionItem.Stage_ID__c];   
                
                insert actionItem;
                ODP_Class_EmailNotification.SendToPersonForActionItem(String.valueOf(ownerCTM.User__r.Id),
                                      'The Action Item "' + actionItem.Name__c + '" is added.',
                                      'The Action Item "' + actionItem.Name__c + '" is added, Please check the detail information as below.',
                                      '<a href="{base}/'+stagTemp.Offering_Release_ID__c+'"> ' + stagTemp.Release_Name__c+ '</a>',
                                      '<a href="{base}/'+stagTemp.id+'"> ' + stagTemp.Stage_Name__c+ '</a>',
                                      null,
                                      null,
                                      'Business Engagement Partner : <a href="mailto:' + stagTemp.Offering_Release_ID__r.Facilitator__r.email  + '"> ' + stagTemp.Offering_Release_ID__r.Facilitator__r.Name + ' </a>',
                                      '<a href="{base}/'+actionItem.Id+'">' + actionItem.Name__c + '</a>');
                
                
                PageReference STGPage = new PageReference('/'+actionItem.Stage_ID__c);
                STGPage.setRedirect(true);
                return STGPage;
            }else{
                //When the user is the Project Manager or Facilitator and changes the status to Complete and the current Stage status is ‘In Progress’ or ‘Under Review’,
                if(IsPMorFac == true){
                    Release_Stage__c stagTemp = [select id, Release_Name__c,Offering_Release_ID__c, PAC_Name__c,Offering_Release_ID__r.Owner.Id,Offering_Release_ID__r.Owner.email,
                                           Offering_Release_ID__r.Owner.Name, Status__c,
										   Offering_Release_ID__r.Facilitator__r.name,
										   Offering_Release_ID__r.Facilitator__r.email,
                                           Offering_Release_ID__r.Facilitator__c,Stage_Name__c from Release_Stage__c where id=: actionItem.Stage_ID__c];                      
                    if(actionItem.Status__c == 'Complete' && (stagTemp.Status__c.equals('In Progress') || stagTemp.Status__c.equals('In Review'))){
                        //notify the Facilitator and PM that the Action Item is Complete
                        Set<String> userIdSet = new Set<String>();
                        if(!userIdSet.contains(string.valueOf(stagTemp.Offering_Release_ID__r.Owner.Id))){
                            //if(!UserId.equals(stagTemp.Offering_Release_ID__r.Owner.Id)){
                                userIdSet.add(string.valueOf(stagTemp.Offering_Release_ID__r.Owner.Id)); 
                            //}       
                        }
                        if(!userIdSet.contains(string.valueOf(stagTemp.Offering_Release_ID__r.Facilitator__c))){
                            //if(!UserId.equals(stagTemp.Offering_Release_ID__r.Facilitator__c)){
                                userIdSet.add(string.valueOf(stagTemp.Offering_Release_ID__r.Facilitator__c)); 
                            //}       
                        }
                        for(String userid: userIdSet){                                                            
                            ODP_Class_EmailNotification.SendToPersonForActionItem(userid,
                                              'The Action Item "' + actionItem.Name__c + '" is Complete.',
                                              'The Action Item "' + actionItem.Name__c + '" is Complete, Please check the detail information as below.',
                                              '<a href="{base}/'+stagTemp.Offering_Release_ID__c+'"> ' + stagTemp.Release_Name__c+ '</a>',
                                              '<a href="{base}/'+stagTemp.id+'"> ' + stagTemp.Stage_Name__c+ '</a>',
                                              null,
                                              null,
                                              'Business Engagement Partner : <a href="mailto:' + stagTemp.Offering_Release_ID__r.Facilitator__r.email  + '"> ' + stagTemp.Offering_Release_ID__r.Facilitator__r.Name + ' </a>',
                                              '<a href="{base}/'+actionItem.Id+'">' + actionItem.Name__c + '</a>');  
                        }                                                                 
                    }
                    if(actionItem.Status__c == 'Canceled'){
                        //notify the Facilitator and PM that the Action Item is Canceled
                        Set<String> userIdSet = new Set<String>();
                        if(!userIdSet.contains(string.valueOf(stagTemp.Offering_Release_ID__r.Owner.Id))){
                            //if(!UserId.equals(stagTemp.Offering_Release_ID__r.Owner.Id)){
                                userIdSet.add(string.valueOf(stagTemp.Offering_Release_ID__r.Owner.Id)); 
                            //}       
                        }
                        if(!userIdSet.contains(string.valueOf(stagTemp.Offering_Release_ID__r.Facilitator__c))){
                            //if(!UserId.equals(stagTemp.Offering_Release_ID__r.Facilitator__c)){
                                userIdSet.add(string.valueOf(stagTemp.Offering_Release_ID__r.Facilitator__c)); 
                            //}       
                        }
                        for(String userid: userIdSet){                        
                            ODP_Class_EmailNotification.SendToPersonForActionItem(userid,
                                              'The Action Item "' + actionItem.Name__c + '" is canceled.',
                                              'The Action Item "' + actionItem.Name__c + '" is canceled, Please check the detail information as below.',
                                              '<a href="{base}/'+stagTemp.Offering_Release_ID__c+'"> ' + stagTemp.Release_Name__c+ '</a>',
                                              '<a href="{base}/'+stagTemp.id+'"> ' + stagTemp.Stage_Name__c+ '</a>',
                                              null,
                                              null,
                                              'Business Engagement Partner : <a href="mailto:' + stagTemp.Offering_Release_ID__r.Facilitator__r.email  + '"> ' + stagTemp.Offering_Release_ID__r.Facilitator__r.Name + ' </a>',
                                              '<a href="{base}/'+actionItem.Id+'">' + actionItem.Name__c + '</a>');
                        }
                    } 
                    
                    Action_Item__c acOld = [select Status__c from Action_Item__c where id =: actionItem.id ];
                    /* when the user is the Project Manager or Facilitator and changes the status back to ‘In Progress’ from ‘Complete’ for an Action Item 
                    and the current Stage status is ‘In Progress’ or ‘Under Review’ , then - ‘unlocks’ the Action Item 
                    - notify the Owner, Facilitator, and PM that the Action Item is now reopened and is in ‘In Progress’ status
                    */
                    system.debug('//////////////////// actionItem.Status__c: '+ actionItem.Status__c + '///acOld.Status__c:' + acOld.Status__c+ '//stagTemp.Status__c :' + stagTemp.Status__c );
                        
                    if(actionItem.Status__c.equals('In Progress') && acOld.Status__c.equals('Complete')&& (stagTemp.Status__c.equals('In Progress') || stagTemp.Status__c.equals('In Review'))){
                        
                        Set<String> userIdSet = new Set<String>();
                        if(!userIdSet.contains(string.valueOf(stagTemp.Offering_Release_ID__r.Owner.Id))){
                            //if(!UserId.equals(stagTemp.Offering_Release_ID__r.Owner.Id)){
                                userIdSet.add(string.valueOf(stagTemp.Offering_Release_ID__r.Owner.Id)); 
                            //}       
                        }
                        if(!userIdSet.contains(string.valueOf(stagTemp.Offering_Release_ID__r.Facilitator__c))){
                            //if(!UserId.equals(stagTemp.Offering_Release_ID__r.Facilitator__c)){
                                userIdSet.add(string.valueOf(stagTemp.Offering_Release_ID__r.Facilitator__c)); 
                            //}       
                        }
                        Core_team_member__c ownerCTM =[select User__c,User__r.Id from Core_team_member__c where ID =: actionItem.Action_Owner__c]; 
                        if(!userIdSet.contains(string.valueOf(ownerCTM.User__r.Id))){
                            //if(!UserId.equals(ownerCTM.User__r.Id)){
                                userIdSet.add(string.valueOf(ownerCTM.User__r.Id)); 
                            //}       
                        }
                        for(String userid: userIdSet){                                                            
                            ODP_Class_EmailNotification.SendToPersonForActionItem(userid,
                                              'The Action Item "' + actionItem.Name__c + '" is reopened and is in ‘In Progress’ status.',
                                              'The Action Item "' + actionItem.Name__c + '" is reopened and is in ‘In Progress’ status, Please check the detail information as below.',
                                              '<a href="{base}/'+stagTemp.Offering_Release_ID__c+'"> ' + stagTemp.Release_Name__c+ '</a>',
                                              '<a href="{base}/'+stagTemp.id+'"> ' + stagTemp.Stage_Name__c+ '</a>',
                                              null,
                                              null,
                                              'Business Engagement Partner : <a href="mailto:' + stagTemp.Offering_Release_ID__r.Facilitator__r.email  + '"> ' + stagTemp.Offering_Release_ID__r.Facilitator__r.Name + ' </a>',
                                              '<a href="{base}/'+actionItem.Id+'">' + actionItem.Name__c + '</a>');  
                        }    
                        
                    }
                    
                    /*when the user is the Project Manager or Facilitator and the user attempts to change the status back to ‘In Progress’ for an Action Item 
                    and the current Stage status is ‘Complete’ or ‘Hold’ or ‘Cancelled’ or ‘Not Started’, display error
                    */
                    if(actionItem.Status__c.equals('In Progress') && !acOld.Status__c.equals('In Progress') &&(stagTemp.Status__c.equals('Complete') || stagTemp.Status__c.equals('On Hold')|| stagTemp.Status__c.equals('Cancelled')||stagTemp.Status__c.equals('Not Started'))){
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'The action item could not be In Progress When stage status is ‘Complete’ or ‘Hold’ or ‘Cancelled’ or ‘Not Started’.'));
                    }
                              
                    //when the user attempts to change the status back to ‘In Progress’ from ‘Canceled’, display error          
                    if(actionItem.Status__c.equals('In Progress') &&  acOld.Status__c.equals('Canceled')){                       
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'The action item has been canceled.'));
                        return null;
                    } 
                    
                    
                    update actionItem;
                    PageReference STGPage = new PageReference('/'+actionItem.Stage_ID__c);
                    STGPage.setRedirect(true);
                    return STGPage;                
                } else{
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Only Business Engagement Partner can update action items.'));
                    return null;
                }
            }                              
        }
        else
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, saveflag));
            return null;
        }
    }

}