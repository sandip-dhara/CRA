public class OLC_DataTable {

    public User UserDetails {get;set;}

public class CustomUserRolesExpertise
{
public Id UserId{get;set;}
public string UserName{get;set;}
public string RoleName{get;set;}
public string ExpertName{get;set;}
}

public class DataClass
{
  public string UserName{get;set;}
  public string RoleName{get;set;}
  public string Experts {get;set;}
}

    public OLC_DataTable()
    {
        UserDetails = GetLoggedinUserDtls();
    }

    
       Public User GetLoggedinUserDtls()
       {
            User u = [Select Name,FullPhotoUrl,AboutMe, Email From User where User.id= :UserInfo.getUserId()];
            return U;
       }

        Public boolean IsLearningBoardCreator
        { 
            get
           { 
                AthenaUserAccess usrAccs=new AthenaUserAccess(); 
                if(usrAccs.IsModerator(UserInfo.getUserId()) || usrAccs.IsProducer(UserInfo.getUserId()) )
                    return true; 
                else
                    return false;
           } 
        }

Public String getSfInstance{
get{
return ApexPages.currentPage().getHeaders().get('Host');
}
} 

Public Id HdnUserId{get;set;}



public List<CustomUserRolesExpertise> GetUsers
{
get
{
List<CustomUserRolesExpertise> lstCutomRoles=new List<CustomUserRolesExpertise>();
String experts;
List<Id> lstUserId=new List<Id>();
List<Id> lstEsUserId=new List<Id>();
List<SLP_Expert__c> lstExpert=new List<SLP_Expert__c>();
List<ES_User__c> lstRoles=new List<ES_User__c>();
List<AggregateResult> lstUsers=[select assignee.id,assignee.name from permissionsetassignment where permissionset.name in ('ES_Social_Learning_Consumer','ES_Social_Learning_Producer','ES_Social_Learning_Moderator') group by assignee.id,assignee.name order by assignee.name asc];
system.debug('lstUsers:'+lstUsers.size());
    for(AggregateResult obj:lstUsers)
    {
    lstUserId.add((Id)obj.get('id'));
    }
system.debug('lstUserId:'+lstUserId.size());

lstRoles=[select id,user_id__c,role_id__r.id,role_id__r.role_name__c from ES_User__c where user_id__c in:lstUserId];
system.debug('lstRoles:'+lstRoles.size());
    for(ES_User__c esuserid:lstRoles)
    {
    lstEsUserId.add(esuserid.id);
    }
system.debug('lstEsUserId:'+lstEsUserId.size());

    lstExpert=[select id,ES_User_Id__c,ES_User_Id__r.User_Id__c,SLP_Secondary_Industry_Id__r.Secondary_Industry_Name__c,SLP_Secondary_Industry_Id__r.Industry_Name__c from SLP_Expert__c where ES_User_Id__c in:lstEsUserId and SLP_Secondary_Industry_Id__r.Is_Active__c=:True];

system.debug('Experts: '+lstExpert.size());

    Map<Id,string> mapUserExperts=new Map<Id,string>();
    for(SLP_Expert__c expertObj:lstExpert)
            {
                if(mapUserExperts.containsKey(expertObj.ES_User_Id__r.User_Id__c)){
                string strExperts=  mapUserExperts.get(expertObj.ES_User_Id__r.User_Id__c)+expertObj.SLP_Secondary_Industry_Id__r.Secondary_Industry_Name__c+' {'+expertObj.SLP_Secondary_Industry_Id__r.Industry_Name__c+'}'+', ';
                mapUserExperts.put(expertObj.ES_User_Id__r.User_Id__c,strExperts);
            
                }
                else{
                string strExperts=  expertObj.SLP_Secondary_Industry_Id__r.Secondary_Industry_Name__c+' {'+expertObj.SLP_Secondary_Industry_Id__r.Industry_Name__c+'}'+', ';
                mapUserExperts.put(expertObj.ES_User_Id__r.User_Id__c,strExperts);
                }
            }

for(AggregateResult obj:lstUsers)
{
    CustomUserRolesExpertise custRoleObj=new CustomUserRolesExpertise();
    custRoleObj.UserId=(Id)obj.get('id');
    custRoleObj.UserName=String.ValueOf(obj.get('name'));
    for(ES_User__c role:lstRoles)
    {
        if((Id)obj.get('id')==(Id)role.user_id__c)
        {
            custRoleObj.RoleName=role.role_id__r.role_name__c;
        }
        experts='';
        if(mapUserExperts.containsKey(custRoleObj.UserId))
            {
            experts=  mapUserExperts.get(custRoleObj.UserId);
            }

    if(experts!='')
    {
    custRoleObj.ExpertName=experts.substring(0,(experts.length()-2));
    }
    else
    {
    custRoleObj.ExpertName=experts;
    }
    }
    lstCutomRoles.add(custRoleObj);
    }
    system.debug('lstCutomRoles: '+lstCutomRoles.size());
    List<CustomUserRolesExpertise> lstFinalData=new List<CustomUserRolesExpertise>();
    for(CustomUserRolesExpertise obj:lstCutomRoles)
    {
    if(obj.RoleName!='' && obj.ExpertName!='')
    {
    lstFinalData.add(obj);
    }
    }
    system.debug('lstFinalData: '+lstFinalData.size());
    return lstFinalData;
}
set;
}

public PageReference SubmitEdit()
{
system.debug('HdnUserId :'+HdnUserId);
 PageReference pRef = new PageReference('/apex/SLP_EditUserRoleMapping');
        pRef.getParameters().put('UserId',HdnUserId);
        pRef.setRedirect(true);
        return pRef;
}


@RemoteAction
    public static List<DataClass> SubmitData(List<DataClass> lstData)
    {
         system.debug('lstData:'+lstData.size());
         return lstData;
    }

}