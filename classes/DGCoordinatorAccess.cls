public class DGCoordinatorAccess {
public boolean CoordinatorAccess{get; set;}
public id ApprovalId;
public string OpportunityId{get; set;}
Public Opportunity_plan__c opp_plan_detail{get; set;}
public user currentuser;
    public DGCoordinatorAccess(ApexPages.StandardController controller) {  
    ApprovalId  = ApexPages.currentPage().getParameters().get('id');
    currentUser = [Select Id, Approver_Type__c From User where id=:Userinfo.getUserId()];
    If(currentUser.Approver_Type__c == 'Coordinator')
    {
    CoordinatorAccess=true;
    
    }
    }
    
public PageReference CustomChangeApprover(){ 
 try{
    PageReference pr = new PageReference('/apex/DGApprovalChange?id='+ApprovalId);
    pr.setRedirect(true);
    system.debug('Id!!!!!!!!!!!!!!!'+ApprovalId);
    return pr;
    }catch(Exception e){
    ApexPages.addmessages(e);
    return null;
    }
}
  
   
}