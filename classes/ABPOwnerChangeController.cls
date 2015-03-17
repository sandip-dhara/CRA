/**********************************************************
 * Page Name: ABPOwnerChangeController
 * Author: hp
 * Date: 07-Jul-2013 
 * Requirement # Request Id :
 * Description: To change the Account Plan owner
 * R6 Change:   Req No:4031 *              
 ***********************************************************/
 
public without Sharing class ABPOwnerChangeController {
    public String SelectedOpportunityAccessLevel{get;set;}
    public List<AccountPlanTeamMemberClass> accountPlanTeamMemberList {get;set;}
    private String OpportunityId;
    private Boolean keepOpptyTeam {get;set;}
    public String abpId{get;set;}
    private OpportunityTeamMember teamMember;
    private List<OpportunityShare> optyShareList;
    public Boolean keepOptyTeamFlag{set;get;}
    public Boolean sendEmailNotificationFlag{set;get;}
    public Account_Plan__c AcctPlanToUpdate;
    public list<String> ownerAddToST{get;set;}
    public boolean isOwnerSTMember{set;get;}
    public ID oldOwnerID;
    public string teamId{get;set;}
    List<Account_Plan__Share> newShares = new List<Account_Plan__Share>();
    public List<Account_Plan__Share> accShrs = new List<Account_Plan__Share>();
    
    public ABPOwnerChangeController(ApexPages.StandardController stdController) {
         if(Test.isRunningTest()){              
         }     
         else{
            abpId=ApexPages.currentPage().getParameters().get('Id');
         }        
         accountPlanTeamMemberList = new List<AccountPlanTeamMemberClass>();
         for(Integer i=0;i<1;i++){
            accountPlanTeamMemberList.add(new AccountPlanTeamMemberClass(abpId));
         }
         try{
            AcctPlanToUpdate=[select id,name,Ownerid from Account_Plan__c where id = :abpId];
            oldOwnerID=AcctPlanToUpdate.ownerID;
         }catch(Exception e){}       
    }
    
    public ABPOwnerChangeController(){}    
    
    public PageReference Save() {
        System.Savepoint sp=null;
        String usrProfileName = [select u.Profile.Name from User u where u.id = :Userinfo.getUserId()].Profile.Name;
        ID newOwnerID;
            User u;                                  
            for (AccountPlanTeamMemberClass teamMemberRow : accountPlanTeamMemberList) {
                    AcctPlanToUpdate.ownerid=teamMemberRow.teamMember.UserId;
                    newOwnerID=teamMemberRow.teamMember.UserId;
                    insertShareRecordsToNewOwner();
                    AcctPlanToUpdate.Owner_change_email__c =sendEmailNotificationFlag;
                    if (teamMemberRow.teamMember.UserId == oldOwnerID) {
                        pageReference pr = new pageReference('/'+abpId);
                        pr.setRedirect(true);
                        return pr;
                    }
             }
        Database.SaveResult result;
        try{
             result= Database.update(AcctPlanToUpdate,true);
             if(newshares.size()>0){                
                database.insert(newShares,false);            
             }
        }catch(Exception e){
            ApexPages.addMessages(e);
            return null;
        }
        pageReference pr = new pageReference('/'+abpId);
        pr.setRedirect(true);
        return pr;
    }
    
    public void insertShareRecordsToNewOwner(){
        Account_Plan__Share jobShr  = new Account_Plan__Share();
            if(Test.isRunningTest()){              
             }
            else{
                   accShrs = [SELECT Id, UserOrGroupId, AccessLevel, RowCause, ParentId FROM Account_Plan__Share where ParentId= :abpId and RowCause ='Manual'];             
                }
            if(accShrs.size() > 0){
                    for (Account_Plan__Share rec : accShrs) {  
                        Account_Plan__Share share = new Account_Plan__Share(); 
                        share.AccessLevel = rec.AccessLevel;
                        share.ParentId = rec.ParentId;
                        share.RowCause = rec.rowcause;
                        share.UserOrGroupId = rec.UserOrGroupId;
                        newShares.add(share);                    
                    }              
                }    
    }    
    
    public class AccountPlanTeamMemberClass{
        public OpportunityTeamMember teamMember {get; set;}
        public String SelectedOpportunityAccessLevel {get;set;}
        public AccountPlanTeamMemberClass(String abpId){
            teamMember = new OpportunityTeamMember();
            teamMember.OpportunityId = abpId;
            SelectedOpportunityAccessLevel = '';
        }
    }
}