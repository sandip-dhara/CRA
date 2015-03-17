/**********************************************************
 * Page Name: OpportunityOwnerChangeExtn
 * Author: hp
 * Date: 25-Sep-2012 
 * Requirement # Request Id :
 * Description: To change the opportunity owner
 * R4 Change:   Req No:4091
 *              The requirement is  to replace the 2 radio buttons with check-boxes 
 *              and always display those check-boxes, regardless if the Oppty Owner is in the Sales Team or not.
 *              If ISR does not select any option to remain on sales team when passing to partner user,
 *              the ISR will still by default be added as read only on the opportunity sales team. 
 ***********************************************************/

Public  WithOut Sharing Class OpportunityOwnerChangeExtn{

    public static void teamSave(Boolean keepOptyTeamFlag,Boolean isOwnerSTMember,ID oldOwnerID,ID newOwnerID,String OpptyId, list<String> ownerAddToST,
        List<opportunityTeamMember> opptyteam,List<OpportunityShare> toUpdateOpportunityShareList,Database.SaveResult result,Boolean sendEmailNotificationFlag){                 
        OpportunityShare newShareRec = new OpportunityShare(); 
        OpportunityTeamMember oppTeamMember =new OpportunityTeamMember();
        User newUser= new User();
        User oldUser = new User();
        newUser=[select id,name,Partner_account_ID__c, IsportalEnabled  from User where id = :newOwnerID];
        oldUser=[select id,name,Partner_account_ID__c, IsportalEnabled  from User where id = :oldOwnerID];
         

        try{
            if(keepOptyTeamFlag==true){              
                opportunityTeamMember ownertm=new opportunityTeamMember();
                if(isOwnerSTMember==true){
                    ownertm= [select id,Opportunityid,userid,TeamMemberRole,OpportunityAccessLevel
                              from opportunityTeamMember 
                              where opportunityid= :Opptyid and userid=:oldOwnerID];                   
                }
                if(opptyteam.size()>0){
                    update opptyteam; 
                }
                if(ownertm.userid!=null){
                    update ownertm;
                }
                OpportunityShare opptyShareOw=new OpportunityShare();
                if(isOwnerSTMember==true){
                    opptyShareOw= [Select OpportunityAccessLevel, OpportunityId, RowCause, UserOrGroupId
                                   From OpportunityShare
                                   Where OpportunityId =:Opptyid
                                   and UserOrGroupId =:oldOwnerID
                                   and rowcause='Team'];
                    if(ownerAddToST[0]=='' || ownerAddToST[0]==null)                         
                        opptyShareOw.OpportunityAccessLevel='Read';                       
                    if(ownerAddToST[0]=='Read')                         
                        opptyShareOw.OpportunityAccessLevel='Read';
                    if(ownerAddToST[0]=='RW')                         
                        opptyShareOw.OpportunityAccessLevel='Edit';                 
                }  

                //   PRM:Amala R4:Req:4091- Start

                /**
                 * @description:Displaying the two check boxes, regardless if the Oppty Owner is in the Sales Team or not.
                 */

                if(isOwnerSTMember==false){
                   // if((newOwnerID != oldOwnerID) && (newUser.IsportalEnabled == true) && (oldUser.IsportalEnabled == false)) {                      
                     if((newOwnerID != oldOwnerID) && ((newUser.IsportalEnabled == true)||(newUser.IsportalEnabled == false)) && (oldUser.IsportalEnabled == false)) {                      
                        oppTeamMember.OpportunityId=OpptyId;
                        oppTeamMember.TeamMemberRole=label.Part_Colab_Inside_Sales;
                        oppTeamMember.UserId=oldOwnerID;
                        insert oppTeamMember ;               
                        newShareRec.opportunityId = Opptyid;
                        newShareRec.UserOrGroupId = oldOwnerID;         
                        if(ownerAddToST[0]==null || ownerAddToST[0]=='' ||  ownerAddToST[0]=='Read'  )                         
                            newShareRec.OpportunityAccessLevel='Read';
                        else if(ownerAddToST[0]=='RW')                         
                            newShareRec.OpportunityAccessLevel='Edit';
                        insert newShareRec;                    
                    }
                }  
                //   PRM:Amala R4:Req:4091- Stop

                if(toUpdateOpportunityShareList.size()>0){                   
                    update toUpdateOpportunityShareList;
                }   
                if(opptyShareOw!=Null)
                    update opptyShareOw;      

            }
            else
            {
                if(opptyteam.size()>0){ 
                    delete opptyteam;
                } 
                //   PRM:Amala R4:Req:4091- Start

                /**
                 * @description:  If keepOptyTeamFlag is false and When ISR canges owner to Partner without checking any heck box
                 *                by default providing the user Read access and added to sales team
                 */ 
               if((newOwnerID != oldOwnerID) && (newUser.IsportalEnabled == true) && (oldUser.IsportalEnabled == false)) { 
                  //if((newOwnerID != oldOwnerID) && ((newUser.IsportalEnabled == true)||(newUser.IsportalEnabled == false)) && (oldUser.IsportalEnabled == false)) {                                           
                    oppTeamMember.OpportunityId=OpptyId;
                    oppTeamMember.TeamMemberRole=label.Part_Colab_Inside_Sales;
                    oppTeamMember.UserId=oldOwnerID;
                    insert oppTeamMember ;               
                    newShareRec.opportunityId = Opptyid;
                    newShareRec.UserOrGroupId = oldOwnerID;         
                    if(ownerAddToST[0]==null || ownerAddToST[0]=='')                         
                        newShareRec.OpportunityAccessLevel='Read';
                    insert newShareRec;                    
                }
                //   PRM:Amala R4:Req:4091- Stop
            }  
        }catch (System.DmlException e) {} 
        Opportunity oppty=[select id,ownerID,owner.email from Opportunity where id = :result.getID()];
        EmailTemplate OwnerChangeET= [SELECT id FROM EmailTemplate WHERE developerName = 'OpportunityChangeOwner'];
         if(result.isSuccess()&& sendEmailNotificationFlag==true){
                    
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage() ; 
                    mail.setTargetObjectId(newUser.Id);
                    //mail.setToAddresses(new String[] { oppty.owner.email });
                    mail.setWhatId(oppty.id);
                    mail.setSaveAsActivity(false);                   
                    mail.setTemplateId(OwnerChangeET.id);
                    Messaging.sendEmail(new Messaging.SingleEmailMessage[]{mail}); 
                     
             }                      
    }
}