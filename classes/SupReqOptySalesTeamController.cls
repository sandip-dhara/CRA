/**********************************************************
* Class Name: SupReqOptySalesTeamController
* Author: Accenture
* Date: 12-June-2012 
* Requirement # Request Id:
* Description: Controller class for SupReqOptySalesTeam vf page
***********************************************************/
public class SupReqOptySalesTeamController {
    private Support_Request__c stdControllerRecord;
    public List<OpportunityTeamMember> OpportunityTeamMembersList{get; set;}
    public Boolean isOpportunityTeamMembersListEmpty{get; set;}
    
    public SupReqOptySalesTeamController(ApexPages.StandardController controller) {
        stdControllerRecord = (Support_Request__c)controller.getRecord();
        OpportunityTeamMembersList=[Select Id, IsDeleted ,OpportunityAccessLevel, OpportunityId ,TeamMemberRole, UserId,User.Business_Group__c, User.Name,user.Global_Business_Unit__c, Opportunity.Name From OpportunityTeamMember where opportunityID=:stdControllerRecord.Opportunity__c];
        if(OpportunityTeamMembersList==null || OpportunityTeamMembersList.size()<=0)
            isOpportunityTeamMembersListEmpty=true;
     }
}