public class ExtendedTeamMemberDisplay {
    
    public ExtendedTeamMemberDisplay(ApexPages.StandardController controller) { 
        Offering_Release__c orc= (Offering_Release__c)controller.getRecord();   
        para_OffRelID = orc.id;
        if(para_OffRelID != '' && para_OffRelID != null){
            List<Release_Role__c> releaseRoleList = [select Role_Name__c,Release_Name__c,id,Contributor__c,Reviewer__c,Accountable__c from Release_Role__c where Offering_Release__c =: para_OffRelID];
            para_OffRelName = releaseRoleList[0].Release_Name__c; 
            ctmList = [select Id, Accountable__c, Name, User__r.Name,Contributor__c,Reviewer__c,Role_Name__c from Core_Team_Member__c where Release_Role__r.Offering_Release__c =: para_OffRelID order by Role_Name__c];                
            if(ctmList.size() == 0){
                DisplayIndicator = false;
            }
            else{
                DisplayIndicator = true;
            }
        }                         
    }
    public string para_OffRelID{get; set;}
    public string para_OffRelName{get; set;}
    public List<Core_Team_Member__c> ctmList{get;set;}
   
    public boolean DisplayIndicator {get;set;}
   
}