/**********************************************************
* Class Name: OpportunitySalesTeamController
* Author: Accenture
* Date: 20-March-2012 
* Requirement # Request Id:
* Description: Controller class for Custom Sales Team Vf page on Opportunity.
***********************************************************/
public class OpportunitySalesTeamController {
    public String SelectedOpportunityAccessLevel{get;set;}
    public List<OpportunityTeamMemberClass> opportunityTeamMemberList {get;set;}
    private String OpportunityId;
    public String Opptyid{get;set;}
    private OpportunityTeamMember teamMember;
    private List<OpportunityShare> optyShareList;
    public String teamid{get;set;}
    /**
    * @description: Class Constructor method
    * @param: Class Controller Apex Page
    * 
    */ 
    public OpportunitySalesTeamController(ApexPages.StandardController stdController) {
        teamMember = (OpportunityTeamMember)stdController.getRecord();
        String OpportunityId = ApexPages.currentPage().getParameters().get('optyId');
       
        SelectedOpportunityAccessLevel = teamMember.OpportunityAccessLevel;
        optyShareList = [Select OpportunityAccessLevel, OpportunityId, 
                            RowCause, UserOrGroupId
                            From OpportunityShare
                            Where OpportunityId =:OpportunityId
                            And RowCause = 'Team' 
                            And UserOrGroupId =: teamMember.User.id];
    }
    
    /**
    * @description: Class Constructor method
    * 
    * 
    */ 
    public OpportunitySalesTeamController(){
        OpportunityId = ApexPages.currentPage().getParameters().get('id');
         opptyid=OpportunityId;
        opportunityTeamMemberList = new List<OpportunityTeamMemberClass>();
        for(Integer i=0;i<5;i++){
            opportunityTeamMemberList.add(new OpportunityTeamMemberClass(OpportunityId));
        }
    }
    
    /**
    * @description: Call Save Method And set page back to null
    * @return: return page null
    * 
    */
    public PageReference Save_New() {
        pageReference pr = Save();
        return null;
    }
    
    /**
    * @description: perform database commit
    * @return: return page url, null in case of any Error
    * 
    */
    public PageReference SaveTeamEdit() {
        System.Savepoint sp=null;
        for(OpportunityShare optyShare : optyShareList){
            optyShare.OpportunityAccessLevel = SelectedOpportunityAccessLevel;
        }
        try{
            if(teamMember!=null){
                update teamMember;
            }
            if(optyShareList!=null){
                update optyShareList;
            }
        }catch(DmlException dmlEx){
            for(Integer i =0; i<dmlEx.getNumDml(); ++i) { 
                Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,dmlEx.getDmlMessage(i)));
            }
            Database.rollback(sp);
            CreateApexErrorLog.insertHandledExceptions(dmlEx, null, 'OpportunityTeamMember', 'OpportunitySalesTeamController', '');
            return null;
        }
        catch(Exception e){
            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage()));
            Database.rollback(sp);
            CreateApexErrorLog.insertHandledExceptions(e, null, 'OpportunityTeamMember', 'OpportunitySalesTeamController', '');
            return null;
        }
        String retUrl = ApexPages.currentPage().getParameters().get('retURL');
        pageReference pr = new pageReference(retUrl);
        pr.setRedirect(true);
        return pr;
    }
    
    /**
    * @description: return to previous page
    * @return: return page url from retURL page paramter value
    * 
    */
    public PageReference Cancel() {
        String retUrl = ApexPages.currentPage().getParameters().get('retURL');
        pageReference pr = new pageReference(retUrl);
        pr.setRedirect(true);
        return pr;
    }
    
    /**
    * @description: perform database commit
    * @return: return page url, null in case of any Error
    * 
    */
    public PageReference Save() {
        System.Savepoint sp=null;
        try {
            //user id with opportunity teamMember map
            Map<id,OpportunityTeamMember> toInsertTeamMembersMap = new Map<id,OpportunityTeamMember>(); 
            //user id with wrapper class record map
            Map<id,OpportunityTeamMemberClass> userWithTeamMemberClassMap = new Map<id,OpportunityTeamMemberClass>();
            for (OpportunityTeamMemberClass teamMemberRow : opportunityTeamMemberList) {
                if (teamMemberRow.teamMember.UserId != null) {
                    if(teamMemberRow.teamMember.TeamMemberRole==null ||teamMemberRow.teamMember.TeamMemberRole==''){
                        teamMemberRow.teamMember.TeamMemberRole.addError('You must enter a value');
                        Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'You must enter a value'));
                        return null;
                    }
                    if(toInsertTeamMembersMap.containsKey(teamMemberRow.teamMember.UserId)){
                        Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Duplicate User Found in the list'));
                        return null;
                    }
                    else{
                        toInsertTeamMembersMap.put(teamMemberRow.teamMember.UserId,teamMemberRow.teamMember);
                        userWithTeamMemberClassMap.put(teamMemberRow.teamMember.UserId,teamMemberRow);
                    }
                }
            }
            //Database save point
            sp = Database.setSavepoint();
            insert toInsertTeamMembersMap.values();
            List<OpportunityShare> toUpdateOpportunityShareList = new List<OpportunityShare>();
            for(OpportunityShare opptyShare : [Select OpportunityAccessLevel, OpportunityId, 
                                                RowCause, UserOrGroupId
                                                From OpportunityShare
                                                Where OpportunityId =:OpportunityId
                                                And RowCause ='Team'
                                                And UserOrGroupId IN : toInsertTeamMembersMap.keySet()] ) {
        
                OpportunityTeamMemberClass teamMemberRow = userWithTeamMemberClassMap.get(opptyShare.UserOrGroupId);
                if (teamMemberRow != null){
                  opptyShare.OpportunityAccessLevel = teamMemberRow.SelectedOpportunityAccessLevel;
                  toUpdateOpportunityShareList.add(opptyShare);
                }
            }
            if (toUpdateOpportunityShareList.size() > 0){
                update toUpdateOpportunityShareList;
            }
        }catch(DmlException dmlEx){
            for(Integer i =0; i<dmlEx.getNumDml(); ++i) { 
                Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,dmlEx.getDmlMessage(i)));
            }
            Database.rollback(sp);
            CreateApexErrorLog.insertHandledExceptions(dmlEx, null, 'OpportunityTeamMember', 'OpportunitySalesTeamController', '');
            return null;
        }
        catch(Exception e){
            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage()));
            Database.rollback(sp);
            CreateApexErrorLog.insertHandledExceptions(e, null, 'OpportunityTeamMember', 'OpportunitySalesTeamController', '');
            return null;
        }
        String retUrl = ApexPages.currentPage().getParameters().get('retURL');
        pageReference pr = new pageReference(retUrl);
        pr.setRedirect(true);
        return pr;
    }
    
    /**
    * getting the selected team id to VF page 
    */
    public PageReference TeamIdValue(){
        teamid=opportunityTeamMemberList[0].teammember.userid;
        system.debug('selected team id value '+opportunityTeamMemberList[0].teammember.userid);
        return null;
    }
    /**
    * @description Display OpportunityAccessLevel Picklist
    * @return: parameter - List<SelectOption> of AccessLevels
    * 
    */
    public List<SelectOption> getOpportunityAccessLevel(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Read','Read Only'));
        options.add(new SelectOption('Edit','Read/Write'));
        return options;
    }
    
    /**
    * @description: Remove Team for delete all button and delete link
    * @return: return page url, null in case of any Error
    * 
    */
    public pageReference deleteTeamMember(){
        List<OpportunityTeamMember> opptyMember=null;
        String teamMemberId = Apexpages.currentPage().getParameters().get('teamMemberID');
        String opportunityID = Apexpages.currentPage().getParameters().get('optyid');
        system.debug('#############'+teamMemberId);
        system.debug('#############'+opportunityID);
        if(teamMemberId==null ||teamMemberId==''){
         /**
            * @description: Update the following if Section for , Partner should be able to delete the sale team member, only if the sale team members are partner
            * Owner : Karthick AP
            * Date : 08/16/2012
            */
        if(PartnerCollabUtil.isLoggedInPartnerUser())
        {
            opptyMember = [Select Id
                            From OpportunityTeamMember
                            Where opportunityID = :opportunityID and User.IsPortalEnabled = True];
                            //Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Info,'Partner Records Deleted'));
         }
         else
         {
             opptyMember = [Select Id
                            From OpportunityTeamMember
                            Where opportunityID = :opportunityID];
         }
        }else{
        if(PartnerCollabUtil.isLoggedInPartnerUser())
        {
            opptyMember = [Select Id
                            From OpportunityTeamMember
                            Where id=: teamMemberId and User.IsPortalEnabled = True];
                            //Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Info,'Partner Records Deleted'));
        }
        else
        {
            opptyMember = [Select Id
                            From OpportunityTeamMember
                            Where id=: teamMemberId ];
        }
        }
        try{
            if(opptyMember!=null)
                delete opptyMember;
        }catch(DmlException dmlEx){
            CreateApexErrorLog.insertHandledExceptions(dmlEx, null, 'OpportunityTeamMember', 'OpportunitySalesTeamController', '');
            for(Integer i =0; i<dmlEx.getNumDml(); ++i) { 
                Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,dmlEx.getDmlMessage(i)));
            }
            return null;
        }
        catch(Exception e){
            CreateApexErrorLog.insertHandledExceptions(e, null, 'OpportunityTeamMember', 'OpportunitySalesTeamController', '');
            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage()));
            return null;
        }
        String retUrl = ApexPages.currentPage().getParameters().get('retURL');
        pageReference pr = new pageReference(retUrl);
        pr.setRedirect(true);
        return pr;
    }
    
    /**
     * @description used as wrapper class for storing data of each line
     * 
     * @author Accenture
     */
    public class OpportunityTeamMemberClass{
        public OpportunityTeamMember teamMember {get; set;}
        public String SelectedOpportunityAccessLevel {get;set;}
        
        public OpportunityTeamMemberClass(String OpportunityId){
            teamMember = new OpportunityTeamMember();
            teamMember.OpportunityId = OpportunityId;
            SelectedOpportunityAccessLevel = '';
        }
    }
}