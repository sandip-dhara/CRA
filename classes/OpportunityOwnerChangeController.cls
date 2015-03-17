/**********************************************************
 * Page Name: OpportunityOwnerChangeController
 * Author: hp
 * Date: 25-Sep-2012 
 * Requirement # Request Id :
 * Description: To change the opportunity owner
 * R4 Change:   Req No:4091
 *              The requirement is  to replace the 2 radio buttons with check-boxes 
 *              and always display those check-boxes, regardless if the Oppty Owner is in the Sales Team or not.
 *              If ISR does not select any option to remain on sales team when passing to partner user,
 *              the ISR will still by default be added as read only on the opportunity sales team. 
 ***********************************************************/


public with Sharing class OpportunityOwnerChangeController {
    public String SelectedOpportunityAccessLevel{get;set;}
    public List<OpportunityTeamMemberClass> opportunityTeamMemberList {get;set;}
    private String OpportunityId;
    private Boolean keepOpptyTeam {get;set;}
    public String Opptyid{get;set;}
    private OpportunityTeamMember teamMember;
    private List<OpportunityShare> optyShareList;
    public Boolean keepOptyTeamFlag{set;get;}
    public Boolean sendEmailNotificationFlag{set;get;}
    public Opportunity opptyToUpdate;
    public list<String> ownerAddToST{get;set;}
    public boolean isOwnerSTMember{set;get;}
    public ID oldOwnerID;
    public string teamId{get;set;}


    /* *
     * @description: Class Constructor method
     * @param: Class Controller Apex Page
     * 
     */ 

    public OpportunityOwnerChangeController(ApexPages.StandardController stdController) {
        
        //PRM:Amala R4:Req:4091- Start
        /* *
         * @description: The requirement is  to replace the 2 radio buttons with check-boxes 
         */
        ownerAddToST = new list<string>();
        isOwnerSTMember=False; 

        //PRM:Amala R4:Req:4091- Stop
        //PRM:Sameer R5 -- Start
            teamId = '';
            for(opportunityTeamMember o: [select userid, user.isPortalEnabled from opportunityTeamMember where opportunityid= :ApexPages.currentPage().getParameters().get('Id')]){
                system.debug('inside this for loop');
                if(o.user.isPortalEnabled){
                    teamid = o.userId;
                    break;
                    system.debug('inside this if loop');
                }
            }
        //PRM:Sameer R5 --Stop    
        Opptyid=ApexPages.currentPage().getParameters().get('Id');
        try{
            opptyToUpdate=[select id,name,Ownerid from opportunity where id = :Opptyid];
            oldOwnerID=opptyToUpdate.ownerID;
        }catch(Exception e){}
        opportunityTeamMemberList = new List<OpportunityTeamMemberClass>();
        for(Integer i=0;i<1;i++){
            opportunityTeamMemberList.add(new OpportunityTeamMemberClass(Opptyid));
        }
        try{
            opportunityTeamMember opTeam =[select id,Opportunityid,userid,TeamMemberRole,OpportunityAccessLevel from opportunityTeamMember
                                           where userid=:opptyToUpdate.ownerId and opportunityid= :Opptyid];
            
            
            if(opteam!=null)
                isOwnerSTMember=true;                              
        }catch(Exception e){ }
    }
    public PageReference Save() {
        System.Savepoint sp=null;
        String usrProfileName = [select u.Profile.Name from User u where u.id = :Userinfo.getUserId()].Profile.Name;
        ID newOwnerID;
        try{                                             
            User u;
            for (OpportunityTeamMemberClass teamMemberRow : opportunityTeamMemberList) {
                u=[select id,email from User where id= :teamMemberRow.teamMember.UserId];
                opptyToUpdate.ownerid=teamMemberRow.teamMember.UserId;
                newOwnerID=teamMemberRow.teamMember.UserId;
                opptyToUpdate.SendEmailNotification__c=sendEmailNotificationFlag;
                if (teamMemberRow.teamMember.UserId == oldOwnerID) {
                    pageReference pr = new pageReference('/'+opptyid);
                    pr.setRedirect(true);
                    return pr;
                }
            }
        }catch(Exception e){
            ApexPages.Message msg=new ApexPages.Message(ApexPages.Severity.Info,'Please select user' );
            ApexPages.addMessage(msg);
            return null;
        }
        opportunityTeamMember isNewOwnerTM=new opportunityTeamMember();
        Try{
            isNewOwnerTM=[select id,Opportunityid,userid,TeamMemberRole,OpportunityAccessLevel from opportunityTeamMember where 
                          opportunityid= :Opptyid and userid=:newOwnerID];
        }catch(Exception e){}
        List<opportunityTeamMember> opptyteam=new List<opportunityTeamMember>();
        for(opportunityTeamMember tm : [select id,Opportunityid,userid,TeamMemberRole,OpportunityAccessLevel from opportunityTeamMember where 
                                        opportunityid= :Opptyid]){
            opptyteam.add(tm);
        }                                                            
        List<OpportunityShare> toUpdateOpportunityShareList = new List<OpportunityShare>();
        if(isNewOwnerTM==Null){
            for(OpportunityShare opptyShare : [Select OpportunityAccessLevel, OpportunityId, 
                                               RowCause, UserOrGroupId
                                               From OpportunityShare
                                               Where OpportunityId =:Opptyid
                                               and rowcause='Team'
                                                   ] ) {
                toUpdateOpportunityShareList.add(opptyShare);                         
            }  
        }
        else{
            for(OpportunityShare opptyShare : [Select OpportunityAccessLevel, OpportunityId, 
                                               RowCause, UserOrGroupId
                                               From OpportunityShare
                                               Where OpportunityId =:Opptyid
                                               and rowcause='Team'
                                                   and UserORGroupID != :isNewOwnerTM.userID
                                                   ] ) {
                toUpdateOpportunityShareList.add(opptyShare);                         
            }  
        }
         //R4EF:IM15797476      Praveen Kumar Reddy
        /*  @desctiption: handling send email funcitonality when send emial flag checked 
        
        */
        
        Database.SaveResult result;
        try{
            //update  opptyToUpdate;
             result= Database.update(opptyToUpdate,true);  
            
                         
        }catch(Exception e){
            ApexPages.addMessages(e);
            return null;
        }
        //PRM:Amala R4:Req:4091- Start
        /* *
         * @description: The requirement is  to replace the 2 radio buttons with check-boxes and Make Read as default value 
         */
        if(ownerAddToST.size()==0)
            ownerAddToST.add('Read');
        //PRM:Amala R4:Req:4091- Stop

        OpportunityOwnerChangeExtn.teamSave(keepOptyTeamFlag,isOwnerSTMember,oldOwnerID,newOwnerID,OpptyId,ownerAddToST, opptyteam,toUpdateOpportunityShareList,result,sendEmailNotificationFlag);
        pageReference pr = new pageReference('/'+opptyid);
        pr.setRedirect(true);
        return pr;
    }
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