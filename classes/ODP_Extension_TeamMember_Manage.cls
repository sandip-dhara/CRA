public class ODP_Extension_TeamMember_Manage{
    
    public List<Release_Role__c> relRoleListNoMember{get;set;}
    public boolean beginstartup{get;set;} 
    public String ErrorCategory{get;set;} 
    public boolean disableAddCTMBtn{get;set;} 
    public String para_stgId{get;set;}
    public ODP_Extension_TeamMember_Manage(ApexPages.StandardController controller) {
        testNo = 1;
        beginstartup = true;
        newctm = (Core_Team_Member__c)controller.getRecord();    
        para_OffRelID = ApexPages.currentPage().getParameters().get('OffRelID');
        para_stgId = ApexPages.currentPage().getParameters().get('stgId');
        if(String.isEmpty(para_stgId)){
            para_stgId = 'All';
        }
        refreashTMandRole();
        disableAddCTMBtn = false;
    }
     public void refreashTMandRole(){
        List<Release_Role__c> releaseRoleList = [select Role_Name__c,Release_Name__c,id,Contributor__c,Reviewer__c,Accountable__c,Independent_Reviewer__c,Role_ID__c from Release_Role__c where Offering_Release__c =: para_OffRelID];
        Offering_Release__c orObj = [select Facilitator__c,OwnerId, status__c from Offering_Release__c  where id =: para_OffRelID ];
        if(releaseRoleList.size()> 0){   
            para_OffRelName = releaseRoleList[0].Release_Name__c; 
        }
        
        ctmList = [select Id, Release_Role__r.Offering_Release__r.Status__c, Accountable__c, Name, User__c,Contributor__c,Reviewer__c,Role_Name__c,Independent_Reviewer__c from Core_Team_Member__c where Release_Role__r.Offering_Release__c =: para_OffRelID order by Role_Name__c];        
        
        if(ctmList.size() == 0){
            DisplayIndicator = false;
        }
        else{
            DisplayIndicator = true;
        }
        
        relRoleListNoMember  = new List<Release_Role__c>();
        
         Set<Id> filterIds = null;
         if(para_stgId != 'All')
         {
             filterIds = GetStgProcessRoles();
         }
        for(Release_Role__c relRoleTemp : releaseRoleList ){
            List<Core_Team_Member__c> ctmListTemp = [select Role_Name__c, Id,Contributor__c,Reviewer__c,Accountable__c,Independent_Reviewer__c from Core_Team_Member__c where Release_Role__c =: relRoleTemp.id order by Role_Name__c]; 
            for(Core_Team_Member__c ctmTemp: ctmListTemp ){
                if(ctmTemp.Contributor__c == true){
                    relRoleTemp.Contributor__c = false;
                }
                if(ctmTemp.Reviewer__c == true){
                    relRoleTemp.Reviewer__c = false;
                }
                if(ctmTemp.Accountable__c == true){
                    relRoleTemp.Accountable__c = false;
                }                               
            }
                   
            if(relRoleTemp.Contributor__c  == true || relRoleTemp.Reviewer__c  == true || relRoleTemp.Accountable__c == true){
                if(filterIds!= null){
                    if( filterIds.contains(relRoleTemp.Role_ID__c)){
                        relRoleListNoMember.add(relRoleTemp); 
                    }
                }
                else{
                    relRoleListNoMember.add(relRoleTemp);             
                }
            }  
        }
        ErrorCategory  = '<b>Notification </b>Please make sure the following conditions are validated.</br>';
        if(relRoleListNoMember.size() > 0){
            beginstartup = false; 
            ErrorCategory = ErrorCategory  + ' - You can start up an opportunity only after you assign all required roles to the team. </br>'; 
        }
        if(!(UserInfo.getUserId() == orObj.Facilitator__c || UserInfo.getUserId() ==  orObj.OwnerId )){
            beginstartup = false; 
            ErrorCategory = ErrorCategory  + ' - Only opportunity Owner or PAC Consultant are allowed to begin start up. </br>';
        }
        if(orObj.status__c != 'Not Started'){
            beginstartup = false; 
            ErrorCategory = ErrorCategory  + ' - opportunity must be Not Started (Already Started?). </br>';
        }
        //ErrorCategory = '"' + ErrorCategory + '"';             
        hiddenNote = 'none';
    }

//  used for creating a new team member for this release role on this offering release
    public Core_Team_Member__c newctm{get;set;}
    public Id ctmUserId{get;set;}
    public boolean isContributor{get;set;}
    public boolean isReviewer{get;set;}
    public string Comments{get;set;}
    public boolean isActive{get;set;}    
//  end


//
    public String SelectReleaseRole{get;set;} 
    public List <SelectOption> RoleItems{
        get{           
            List<SelectOption> options = new List<SelectOption>();
            options.add(new SelectOption('',''));                    
            for(Release_Role__c rrc: [select Role_Name__c,Independent_Reviewer__c , Name,Role_ID__c from Release_Role__c where Offering_Release__c =: para_OffRelID order by Role_Name__c]){
                if(para_stgId != 'All')
                {
                    Set<Id> filterIds = GetStgProcessRoles();
                    if(filterIds.contains(rrc.Role_ID__c)){
                        options.add(new SelectOption(rrc.Id,rrc.Role_Name__c));
                    }
                }
                else{
                    options.add(new SelectOption(rrc.Id,rrc.Role_Name__c));        
                }
            }
            
            return options;        
         }        
    }

//
    public string para_OffRelID{get; set;}
    public string para_OffRelName{get; set;}
    public List<Core_Team_Member__c> ctmList{get;set;}
   
    public boolean DisplayIndicator {get;set;}
    public boolean DisplayNewTM {get;set;} 
   
    private String sortDirection = 'ASC';
    public String getSortDirection()
    {
         return (sortDirection == 'ASC')? 'DESC' : 'ASC';
    }
    
    public void setSortDirection(String value)
    {  
         sortDirection = (sortDirection == 'ASC')? 'DESC' : 'ASC';
    }
       
    public void ShowByRoleName(){
        if( sortDirection == 'DESC'){
            ctmList = [select Id, Name, User__c,Contributor__c,Reviewer__c,Role_Name__c,Accountable__c,Independent_Reviewer__c from Core_Team_Member__c where Release_Role__r.Offering_Release__c =: para_OffRelID order by Role_Name__c desc];        
        }else{
            ctmList = [select Id, Name, User__c,Contributor__c,Reviewer__c,Role_Name__c,Accountable__c,Independent_Reviewer__c  from Core_Team_Member__c where Release_Role__r.Offering_Release__c =: para_OffRelID order by Role_Name__c];        
        } 
    }
    
    public PageReference CreateTeamMember(){
        try{
            newctm.Release_Role__c = SelectReleaseRole;
            string validateTeammember = '';
            validateTeammember = CreateTeamMemberValidate();      
            if(validateTeammember  == 'true'){
                insert newctm;           
                PageReference pageRef = new PageReference('/apex/ODP_CustomizedTeamMemberOverView?OffRelID=' + para_OffRelID );
                pageRef.setRedirect(true); 
                return pageRef;    
            }else{
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, validateTeammember));
                return null;
            }                                  
        }
        catch(exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Operation Failed: create team member exception.Please contact IT administrators if any assistance needed.'));
            return null;
        }
        
    }
    
    //check the boxes below to decide to add the new Team Member  as Contributor/Reviewer or not --Tovid
    public boolean manuallySet{get;set;}
    
    public String CreateTeamMemberValidate(){
        string validate = 'false';
        system.debug('/////////' + newctm.user__c);
        if(newctm.user__c == null){
            validate = 'You must enter the name of the team member you want to add.';
            return validate; 
        }
        if( SelectReleaseRole == '' ){
            validate = 'You must select the role you want to assign team members.';
            return validate; 
        }else{
            //judge the role content 
            if(newctm.Contributor__c == false && newctm.Reviewer__c == false && newctm.Accountable__c == false){
                validate = 'You must select the characteristic you want to assign team members.';
                return validate;
            }
            //creating a new Team Member by submitting entries made and Team Member has already been added with the same Role  -- Tovid
            List<Core_Team_Member__c> ctmList = [select id from Core_Team_Member__c where Release_Role__c =: SelectReleaseRole and User__c = : newctm.User__c ];
            if(ctmList.size() > 0){
                validate = 'The member has been assigned to same Role.';
                return validate;     
            }
        }
        //creating a new Team Member as Contributor(Reviewer) for a Role and that Role already has a Team Member as Contributor/Reviewer -- Tovid
        if(newctm.Contributor__c  == true){
            List<Core_Team_Member__c> ctmList = [select id from Core_Team_Member__c where Release_Role__c =: SelectReleaseRole  and Contributor__c  =: true];
            if(ctmList.size() > 0){
                if(manuallySet == true){
                    //validate = 'The Role has already been assigned as Contributor.';
                    //return validate; 
                }    
            }
        }
        if(newctm.Reviewer__c == true){
            List<Core_Team_Member__c> ctmList = [select id from Core_Team_Member__c where Release_Role__c =: SelectReleaseRole  and Reviewer__c =: true];
            if(ctmList.size() > 0){
                if(manuallySet == true){
                    //validate = 'The Role has already been assigned as Reviewer.';
                    //return validate;
                }     
            }
        }
        //Creating a new Team Member as Accountable for a Role and that Role already has a Team Member as Accountable -- Tovid
        if(newctm.Accountable__c == true){
            List<Core_Team_Member__c> ctmList = [select id from Core_Team_Member__c where Release_Role__c =: SelectReleaseRole  and Accountable__c =: true];
            if(ctmList.size() > 0){
                validate = 'Somebody already assigned a team member to this role as accountable.  Only one team member can be assigned as accountable for a role.';
                return validate;     
            }
        }
        validate = 'true';
        return validate;                            
    }
    
    // disable the check box by independentReviewer value --Tovid
    public boolean independentReviewer{get;set;}  
    public string hiddenNote{get;set;}  
    public void RewContActLoad(){
        Release_Role__c srole = [select Role_Name__c,Reviewer__c, Contributor__c, Release_Name__c,id,Accountable__c,Independent_Reviewer__c from Release_Role__c where id =: SelectReleaseRole];
        newctm.Reviewer__c = false;
        newctm.Contributor__c = false;
        newctm.Accountable__c = false;
        independentReviewer = false;
        
        if(srole.Reviewer__c == true){
            newctm.Reviewer__c = true;
        }
        if(srole.Contributor__c == true){
            newctm.Contributor__c = true;
        }
        if(srole.Accountable__c == true){
            newctm.Accountable__c = true;
        }
        if(srole.Independent_Reviewer__c == true){
            independentReviewer = true;
            newctm.Reviewer__c = true;
            newctm.Contributor__c = false;
            newctm.Accountable__c = false;
        }
        
        // show notes -- Tovid
        List<Core_Team_Member__c> ctmConList = [select id from Core_Team_Member__c where Release_Role__c =: SelectReleaseRole  and Contributor__c  =: true];
        List<Core_Team_Member__c> ctmReviewList = [select id from Core_Team_Member__c where Release_Role__c =: SelectReleaseRole  and Reviewer__c =: true];
        if(ctmReviewList.size() > 0 || ctmConList.size() > 0){
            hiddenNote = 'table-row';     
        }else{
            hiddenNote = 'none'; 
        } 
        disableAddCTMBtn  = false;   
    }
    public PageReference BeginStarup(){
        try{
            if(beginstartup == false){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, ErrorCategory ));
                return null;        
            }else{
                Offering_Release__c orc = [select id, Status__c,Flight_Plan_ID__c from Offering_Release__c where id =:para_OffRelID ];
                List<Release_Stage__c> fpsList = [select id,Status__c  from Release_Stage__c where Offering_Release_ID__c =: para_OffRelID and Stage_Name__c like: '%Start-up%'];                

                if(fpsList.size() > 0){
                    fpsList[0].Status__c = 'In Progress';
                    update  fpsList[0];                      
                }
                orc.Status__c = 'Start Up';
                update orc; 
                //Present the screen to Select Flight Plan for Offering Release  -- Tovid - 4.15
                PageReference pageRef = new PageReference('/apex/ODP_Page_OfferingRelease_Upsert?id=' + para_OffRelID );          
                //PageReference pageRef = new PageReference('/' + para_OffRelID );
                pageRef.setRedirect(true); 
                return pageRef;           
            }                           
        }
        catch(exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Operation Failed: begin startup stage exception. Please contact IT administrators if any assistance needed.'));
            return null;
        }
        
    } 
    public string teamMemberId{get;set;} 
    public string errorMsg{get;set;}      
    public PageReference deleteTeamMember(){
        try{
            Core_Team_Member__c ctmcTemp= [SELECT id FROM Core_Team_Member__c WHERE id = :teamMemberId];
            delete ctmcTemp;                
            PageReference pageRef = new PageReference('/apex/ODP_CustomizedTeamMemberOverView?OffRelID=' + para_OffRelID );            
            pageRef.setRedirect(true); 
                            
            return pageRef;                     
        }
        catch(exception e){          
            errorMsg = 'Operation Failed: Delete team member exception. Please contact IT administrators if any assistance needed.';
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Delete team member exception, please contact the IT Administrator'));
            return null;            
        }
    }
    
    public Core_Team_Member__c ctmDetail{get;set;}
    public void findTeamMemberById(){
          try{
              independentReviewer = false;
              ctmDetail = new Core_Team_Member__c();           
              string swePra = Apexpages.currentPage().getParameters().get('teammemberIdPra');
              ctmDetail  = [select Id, Name, User__r.Name,Contributor__c,Reviewer__c,Role_Name__c,Accountable__c,Independent_Reviewer__c,Comment__c from Core_Team_Member__c where id =:swePra  ];      
              if(ctmDetail.Independent_Reviewer__c == true){
                independentReviewer = true;
                ctmDetail.Reviewer__c = true;
                ctmDetail.Contributor__c = false;
                ctmDetail.Accountable__c = false;
            }
          }
          catch(exception e){
              ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'Operation Failed: team member search exception. Please contact IT administrators if any assistance needed.')); 
          }  
    }
    public PageReference updateTeamMember(){
        try{
            update ctmDetail;           
            PageReference pageRef = new PageReference('/apex/ODP_CustomizedTeamMemberOverView?OffRelID=' + para_OffRelID );
            pageRef.setRedirect(true); 
            return pageRef;                                  
        }
        catch(exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Operation Failed: update team member exception. Please contact IT administrators if any assistance needed.'));
            return null;
        }
        
    }
    
    //////////////////////////Stage Filter///////////////////////////////////////////////////
    public Set<Id> GetStgProcessRoles(){
        List <Stage_Work_Element__c> sweObjList = [select Accountable_Role__c
                                                       from stage_work_element__c where Release_Stage_ID__c=:para_stgId];
            Set<Id> returnIds = new Set<Id>();
            for(Stage_Work_Element__c swe: sweObjList ){
                if(!returnIds.contains(swe.Accountable_Role__c)){
                    returnIds.add(swe.Accountable_Role__c);
                }
            }
        
            List <Contributor__c> contList = [select Role__c
                                              from Contributor__c where Stage_Work_Element__r.Release_Stage_ID__c =:para_stgId];
            
            for(Contributor__c ccobj : contList ){
                if(!returnIds.contains(ccobj.Role__c)){
                    returnIds.add(ccobj.Role__c);
                }
            }
                
            
            List <Review__c> rewList = [select Role__c
                                        from Review__c where Stage_Work_Element__r.Release_Stage_ID__c =:para_stgId];
            
            for(Review__c rewobj : rewList ){
                if(!returnIds.contains(rewobj.Role__c)){
                    returnIds.add(rewobj.Role__c);
                }
            }
                
            return returnIds;
    }
    
    public List <SelectOption> Stages{
        get{           
            List<SelectOption> options = new List<SelectOption>();
            
            options.add(new SelectOption('All','All Stage'));
            
            for(Release_Stage__c stg: [select Id,Stage_Name__c from Release_Stage__c where Offering_Release_ID__c=:para_OffRelID]){
                options.add(new SelectOption(stg.Id,stg.Stage_Name__c));
            }        
            return options;        
         }        
    }
    public integer testNo{get;set;}
    public PageReference StgReLoad(){
        testNo = testNo + 1;
        refreashTMandRole();
        return null;
    }
}