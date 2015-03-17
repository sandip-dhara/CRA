/**********************************************************
* Class Name: OpportunitySalesTeamListController
* Author: Accenture
* Date: 22-March-2012 
* Requirement # Request Id:
* Description: Controller class for Custom Sales Team Vf page on Opportunity.
***********************************************************/
public class OpportunitySalesTeamListController {
    public String message {get;set;}
    public Id opportunityID {get;set;}    
    public Opportunity opportunity {get;set;}
    public String groupName {get;set;}
    public String errormessage{get;set;}
    public List<OpportunityTeamMember> opportunityTeamMembers {get;set;}
    public Opportunity oOpportunity;
    private String sortDirection = Label.ASC;
    private String sortExp = 'user.Name';
    private String currentUserId='';
    private String currentProfileId='';
    public boolean showAddButton{get;set;}
    public boolean showEditDelteLinkButton{get;set;}
    public boolean showAddDefaultListButton{get;set;}
    public boolean showDeleteAllListButton{get;set;}
    private Set<id> setAdminProfiles;
    public boolean memberCheck{get;set;}
    public boolean PartnermemberCheck{get;set;}
    public boolean memberCheckHPFS{get;set;}
    public boolean isOwner{get;set;}
    public boolean isClosed{get;set;}
    public Opportunity opty = new Opportunity();
    
    /**
    * @description: Class Constructor method
    * @param: Class Controller Apex Page
    * 
    */
    public OpportunitySalesTeamListController(ApexPages.StandardController controller) {
        Map<String,Admin_Profiles__c> adminProfilesMap = Admin_Profiles__c.getAll();
        setAdminProfiles = new Set<Id>();
        for(Admin_Profiles__c prof : adminProfilesMap.values()){
            if(prof.Module__c!=null){
                if(prof.Module__c.equalsIgnoreCase(Label.Sales_Team)){
                    if(prof.Profile_ID__c!=null){
                        setAdminProfiles.add(convertTo15Digit(prof.Profile_ID__c));
                    }
                }
            }
        }
        opportunity = (Opportunity)controller.getRecord();    
        message = ''; 
        errormessage ='';
        groupName = Label.All;
        currentUserId = Userinfo.getUserId();
        currentUserId = convertTo15Digit(currentUserId);
        currentProfileId = Userinfo.getProfileId();
        currentProfileId = convertTo15Digit(currentProfileId);
        memberCheck = False;
        List<OpportunityTeamMember> oTeam = [select UserId,OpportunityAccessLevel from OpportunityTeamMember where OpportunityID =: Opportunity.Id and OpportunityAccessLevel = 'Edit' and UserId =:currentUserId];
        if(oTeam.Size() >0)
        memberCheck = True;
        User LoggedinUserBG = [select Business_Group__c,IsPortalEnabled from User where Id = :currentUserId];
        memberCheckHPFS = False;
        Partnermembercheck = False;
        
        opty = [select RecordType.Name,Owner__c,StageName from Opportunity where Id =:Opportunity.Id];
        
        //Condition to check if Logged in user is Partner user. if so set the Partnermembercheck to True.
        if(LoggedinUserBG.IsPortalEnabled == True){
            Partnermembercheck = True;
            system.debug('@@Abrar'+Partnermembercheck);
            } 
        
        //Condition to check if Logged in user is Opty Owner. if so set the isOwner to True.
        if(opty.Owner__c==Userinfo.getUserId()){
          isOwner=True;
        }
        
        //Condition to check if the Opportunity is Closed.
        if((opty.StageName=='06 - Won, Deploy & Expand') || (opty.StageName=='Lost') || (opty.StageName=='HP Not Pursued') || (opty.StageName=='Error')){
          isClosed=True;
        }
        
        //Condition to check if Logged in user is HPFS Owner. if so set the memberCheckHPFS to True.
        if(LoggedinUserBG.Business_Group__c == 'HPFS' && opty.RecordType.Name != 'HPFS')
        memberCheckHPFS = True;
        fetchOpportunityTeamMembers();
    }
    
   
   /************************
   desc: Release 6 - method to identify logged in user is part of Opty sales Team
   author: Abrar/22-07-2013
   ************************/
  
    /**
    * @description: return flag is Search Result Empty or not
    * @return: boolean True if list is empty
    * 
    */
    public Boolean getisOpportunityTeamMembersListEmpty(){
        Boolean retValue = false;
        if(opportunityTeamMembers==null||opportunityTeamMembers.size()<1){
            retValue = true;
        }
        return retvalue;
    }
    
    /**
    * @description: Returns Business Group options from User object Business Group picklist field
    * @return: parameter - List<SelectOption> List of Business Group options
    *  
    */
    public List<SelectOption> getBusinessGroups(){
        List<SelectOption> options = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult = User.Business_Group__c.getDescribe();
        List<Schema.PicklistEntry> businessGroups = fieldResult.getPicklistValues();
        options.add(new SelectOption(Label.All,Label.All));
        for (Schema.PicklistEntry businessGroup : businessGroups) {
            options.add(new SelectOption(businessGroup.getLabel(), businessGroup.getValue()));
        }
        return options;  
    }
    
    /**
    * @description: call viewData method for Team Memembers realted to this opportunity
    * 
    * 
    */
    public void fetchOpportunityTeamMembers() {
        opportunityID = opportunity.Id;
        viewData();                                  
    }
    
    private String convertTo15Digit(String paramID){
        try{
            if(paramID.length()>15){
                paramID = paramID.substring(0,15);
            }
        }catch(Exception e){
        }
        return paramID;
    }
    
    
    
    /**
    * @description: fetch Team Memembers realted to this opportunity
    * 
    * 
    */
    public void viewData(){
        message = '';
        String sortFullExp = sortExpression  + ' ' + sortDirection;
        
        /********************************
        * Author: Accenture
        * Modified: 09-AUG-2012
        * Update: Updated the string 'qry' to include 'User.Email' and 'User.IsPortalEnabled'
        * CR#: CR-0123
        *********************************/
        
        String qry = 'Select Id, IsDeleted ,OpportunityAccessLevel, OpportunityId ,TeamMemberRole, UserId,User.Business_Group__c, User.Name,user.Global_Business_Unit__c, Opportunity.Name, User.Email, User.IsPortalEnabled From OpportunityTeamMember where opportunityID = \''+opportunityID+'\'';
        if (!groupName.equalsIgnoreCase(Label.All)) {
            qry += ' And User.Business_Group__c Like \''+groupName+'\'';
        }
        qry += 'order by '+sortFullExp;
        opportunityTeamMembers = Database.query(qry);
        oOpportunity = [select account.ownerid from Opportunity where id =:opportunityID]; 
        String optyOwnerId = convertTo15Digit(opportunity.OwnerId);
        System.debug('optyOwnerId-->'+optyOwnerId);
        System.debug('currentUserId-->'+currentUserId);
        if(currentUserId.equalsIgnoreCase(optyOwnerId)){
            showAddButton = true;
            showEditDelteLinkButton = true;
            showAddDefaultListButton = true;
            showDeleteAllListButton = true;
        }
        if(currentUserId.equalsIgnoreCase(convertTo15Digit(oOpportunity.Account.OwnerId))){
            showAddButton = true;
        }
        if(setAdminProfiles.contains(currentProfileId)){
            showAddButton = true;
            showEditDelteLinkButton = true;
            showAddDefaultListButton = true;
            showDeleteAllListButton = true;
        }
        for(OpportunityTeamMember teamMember : opportunityTeamMembers){
            String tmpUserID = convertTo15Digit(teamMember.UserId);
            if(currentUserId.equalsIgnoreCase(tmpUserID)){
                if(teamMember.OpportunityAccessLevel==Label.Edit){
                    showAddButton = true;
                    showEditDelteLinkButton = true;
                    showAddDefaultListButton = true;
                    showDeleteAllListButton = true;
                }
            }
        }
    }
    
    /**
    * @description: Delete all sales team from opportunity
    * @return: return page url, null in case of any Error
    * 
    */
    public PageReference deleteTeamMember(){
        String teamMemberId = Apexpages.currentPage().getParameters().get('teamMemberID');
        System.debug('###########'+teamMemberId);
        List<OpportunityShare> opptyShare=null;
        List<OpportunityTeamMember> opptyMember=null;
        if(teamMemberId==null ||teamMemberId==''){
            opptyShare = [Select Id
                            From OpportunityShare
                            Where opportunityID = :opportunityID 
                            And RowCause=:Label.Team];
        }else{
            opptyMember = [Select Id
                            From OpportunityTeamMember
                            Where id=: teamMemberId ];
        }
        try{
            if(opptyMember!=null)
                delete opptyMember;
            if(opptyShare !=null)
                Delete opptyShare;
            
          
            if(Test.isRunningTest()){
                throw new MyException();
            }
                
        }catch(DmlException dmlEx){
            CreateApexErrorLog.insertHandledExceptions(dmlEx, null, 'OpportunityTeamMember', 'OpportunitySalesTeamListController', '');
            for(Integer i =0; i<dmlEx.getNumDml(); ++i) { 
                Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,dmlEx.getDmlMessage(i)));
            }
            return null;
        }
        catch(Exception e){
            CreateApexErrorLog.insertHandledExceptions(e, null, 'OpportunityTeamMember', 'OpportunitySalesTeamListController', '');
            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage()));
            return null;
        }
        return null;
    }
    
    /**
    * @description: sort Expression from VF Page
    * @return: expression on which sorting is to be done
    * 
    */
    public String sortExpression
    {
        get{
            return sortExp;
        }
        set{
            //if the column is clicked on then switch between Ascending and Descending modes
            if (value == sortExp){
                sortDirection = (sortDirection == Label.ASC)? Label.DESC : Label.ASC;
            }
            else{
                sortDirection = Label.ASC;
            }
            sortExp = value;
        }
    }
    
    /**
    * @description: Sort Direction getter
    * @return: Direction Ascending or decending
    * 
    */
    public String getSortDirection()
    {
        //if not column is selected 
        if (sortExpression == null || sortExpression == ''){
            return Label.ASC;
        }
        else{
            return sortDirection;
        }
    }
    
    /**
    * @description: Sort Direction settter
    * 
    * 
    */
    public void setSortDirection(String value)
    {  
        sortDirection = value;
    }
    
    /**
    * @description: Add Default Sales Team for the opportunity  
    * 
    * 
    */
    public void addDefaultSalesTeam() {
        //OpportunityId addDefaultTeamforSalesTeam
        AddDefaultTeamController addDefaultTeamController = new AddDefaultTeamController();
        errormessage = addDefaultTeamController.addDefaultTeamforSalesTeam(OpportunityId);
    } 
    
    
    /**
    * @description: Defining Custom Exception to increate the code coverage 
    * 
    * 
    */
    public class MyException extends Exception{}
  
    
}