/********************
Author : HP (Abrar)
Desc : Sales Team component for Sales Team info to be added in VF Email Template
*********************/


public class SupReqOptySalesTeamCompController
 {
  public string SupportRequestId {get;set;}
  public Boolean isOpportunityTeamMembersListEmpty{get; set;}
  
    public List<OpportunityTeamMember> getOptySalesTeam() {
        Support_Request__c oSupportRequest=[Select Id,Opportunity__c from Support_Request__c where Id=:this.SupportRequestId ];
            List<OpportunityTeamMember> spc = [Select Id, IsDeleted ,OpportunityAccessLevel, OpportunityId,
                                             TeamMemberRole, UserId,User.Business_Group__c, 
                                              User.Name,user.Global_Business_Unit__c,
                                             Opportunity.Name From OpportunityTeamMember 
                                             where opportunityID=:oSupportRequest.Opportunity__c];
            if(spc==null || spc.size()<=0)
                  isOpportunityTeamMembersListEmpty=true;                                 
        
        return spc;
    }
}