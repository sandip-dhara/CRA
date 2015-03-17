public class SLP_AddUserRoleMappingController{

public Id SLPRoleId{get;set;}
public Id UserId{get;set;}

Public String getSfInstance{
get{
return ApexPages.currentPage().getHeaders().get('Host');
}
}

Public User GetLoggedinUserDtls(){    
        User u = [Select Name,FullPhotoUrl,id From User where User.id= :UserInfo.getUserId()];
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

public List<SLP_Role__c> LstRoles{get;set;}
public List<SelectOption> LstRolesOption{get;set;}

public class CustomRoles
{
public id UserId{get;set;}
public string UserName{get;set;}
public string RoleName{get;set;}
public string ExpertName{get;set;}
}

Public string GetAvailableExperts
{
get
{
List<SLP_Secondary_Industry__c> lstAvlblExperts=[select id,Secondary_Industry_Name__c,Industry_Name__c from SLP_Secondary_Industry__c order by Secondary_Industry_Name__c asc];
string jsonString=JSON.serialize(lstAvlblExperts);
return jsonString;
}
set;
}

/*public List<CustomRoles> GetUsers
{
get
{
List<CustomRoles> lstCutomRoles=new List<CustomRoles>();
List<Id> lstIds=new List<Id>();
List<AggregateResult> lstUsers=[select assignee.id,assignee.name from permissionsetassignment where permissionset.name in ('ES_Social_Learning_Consumer','ES_Social_Learning_Producer','ES_Social_Learning_Moderator') group by assignee.id,assignee.name order by assignee.name asc];
for(AggregateResult obj:lstUsers)
{
lstIds.add((Id)obj.get('id'));
}
List<ES_User__c> esusers=[select id from ES_User__c where user_id__c in:lstIds];
List<Id> Ids=new List<Id>();
for(ES_User__c obj:esusers)
{
Ids.add(obj.id);
}

List<SLP_Expert__c> lstExpertUsers=[select ES_User_Id__r.user_id__c,ES_User_Id__r.name from SLP_Expert__c where ES_User_Id__c not in:Ids or (ES_User_Id__c in:Ids and SLP_Secondary_Industry_ID__c=:'')];
List<Id> lstExpertIds=new List<Id>();
for(SLP_Expert__c obj:lstExpertUsers)
{
lstExpertIds.add(obj.ES_User_Id__r.user_id__c);
}

List<ES_User__c> lstEsUsers=[select User_id__r.id,User_id__r.name from ES_User__c where User_id__r.id in:lstIds and role_id__c=:''];
List<Id> lstEsUsersId=new List<Id>();
for(ES_User__c obj:lstEsUsers)
{
lstEsUsersId.add(obj.User_id__r.id);
}

List<User> lstUsersInfo=[select id,name from User where id in:lstExpertIds or id in:lstEsUsersId];

//for(AggregateResult obj:lstUsers)
//{
//CustomRoles custRoleObj=new CustomRoles();
//custRoleObj.UserId=(Id)obj.get('id');
//custRoleObj.UserName=String.ValueOf(obj.get('name'));
//lstCutomRoles.add(custRoleObj);
//}

for(User obj:lstUsersInfo)
{
CustomRoles custRoleObj=new CustomRoles();
custRoleObj.UserId=obj.id;
custRoleObj.UserName=obj.name;
lstCutomRoles.add(custRoleObj);
}

return lstCutomRoles;
}
set;
}*/

public List<CustomRoles> GetUsers
{
get
{
List<CustomRoles> lstCutomRoles=new List<CustomRoles>();
String experts;
List<Id> lstUserId=new List<Id>();
List<Id> lstEsUserId=new List<Id>();
List<SLP_Expert__c> lstExpert=new List<SLP_Expert__c>();
List<ES_User__c> lstRoles=new List<ES_User__c>();
List<AggregateResult> lstUsers=[select assignee.id,assignee.name from permissionsetassignment where permissionset.name in ('ES_Social_Learning_Consumer','ES_Social_Learning_Producer','ES_Social_Learning_Moderator') group by assignee.id,assignee.name order by assignee.name asc];
for(AggregateResult obj:lstUsers)
{
lstUserId.add((Id)obj.get('id'));
}

lstRoles=[select id,user_id__c,role_id__r.id,role_id__r.role_name__c from ES_User__c where user_id__c in:lstUserId];

for(ES_User__c esuserid:lstRoles)
{
lstEsUserId.add(esuserid.id);
}

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
    CustomRoles custRoleObj=new CustomRoles();
    custRoleObj.UserId=(Id)obj.get('id');
    custRoleObj.UserName=String.ValueOf(obj.get('name'));
    for(ES_User__c role:lstRoles)
    {
    if((Id)obj.get('id')==(Id)role.user_id__c)
    {
    custRoleObj.RoleName=role.role_id__r.role_name__c;
    }
experts='';
    /*for(SLP_Expert__c expertObj:lstExpert)
    {
    if(expertObj.ES_User_Id__r.User_Id__c==(Id)obj.get('id'))
    {
    experts=experts+expertObj.SLP_Secondary_Industry_Id__r.Secondary_Industry_Name__c+'{'+expertObj.SLP_Secondary_Industry_Id__r.Industry_Name__c+'}'+',';
    }
    } */
        if(mapUserExperts.containsKey(custRoleObj.UserId))
            {
            experts=  mapUserExperts.get(custRoleObj.UserId);
            }
if(experts!='')
{
custRoleObj.ExpertName=experts.substring(0,(experts.length()-1));
}
else
{
custRoleObj.ExpertName=experts;
}
}
lstCutomRoles.add(custRoleObj);
}

system.debug('ListCustoRoles: '+lstCutomRoles);

List<CustomRoles> lstFinalData=new List<CustomRoles>();
for(CustomRoles obj:lstCutomRoles)
{
if((obj.RoleName=='' && obj.ExpertName=='') || (obj.RoleName==null && obj.ExpertName==null) || (obj.RoleName==null && obj.ExpertName=='') || (obj.RoleName=='' && obj.ExpertName==null))
{
lstFinalData.add(obj);
}
}

system.debug('ListFinalData: '+lstFinalData);
return lstFinalData;
}
set;
}

/*public String GetUsers
{
get
{
List<CustomRoles> lstCutomRoles=new List<CustomRoles>();
List<AggregateResult> lstUsers=[select assignee.id,assignee.name from permissionsetassignment where permissionset.name in ('ES_Social_Learning_Consumer','ES_Social_Learning_Producer','ES_Social_Learning_Moderator') group by assignee.id,assignee.name order by assignee.name asc];
for(AggregateResult obj:lstUsers)
{
CustomRoles custRoleObj=new CustomRoles();
custRoleObj.UserId=(Id)obj.get('id');
custRoleObj.UserName=String.ValueOf(obj.get('name'));
lstCutomRoles.add(custRoleObj);
}
string jsonString=JSON.serialize(lstCutomRoles);
return jsonString;
}
set;
}*/

public SLP_AddUserRoleMappingController()
{
LstRolesOption=GetRoles();
}

public List<SelectOption> GetRoles()
{
 List<SelectOption> lstRolesOptions= new List<SelectOption>();       
List<SLP_Role__c> lstRols=[select id,name,role_name__c from SLP_Role__c where Is_Active__c=:True order by role_name__c asc];
lstRolesOptions.add(new SelectOption('','--Select Role--'));
        
        
        for(SLP_Role__c role:lstRols){
            lstRolesOptions.add(new SelectOption(role.id,role.role_name__c));    
        }

        //lstRolesOptions.add(new SelectOption('NO','No Roles'));

        return lstRolesOptions;
}

@RemoteAction
public static void SaveChanges(Id userId,Id roleId,string experts)
{
system.debug('User Id '+userId);
system.debug('Role Id '+roleId);
//expertIds.remove(expertIds.size());
List<ES_User__c> lstRoles=[select id,role_ID__r.id,role_id__c from ES_User__c where User_Id__c=:userId];
system.debug('List Roles '+lstRoles);
if(lstRoles.size()>0)
{
lstRoles[0].Role_ID__c=roleId;
update lstRoles[0];
}
else
{
ES_User__c esuser=new ES_User__c();
esuser.user_id__c=userId;
esuser.role_id__c=roleId;
insert esuser;
system.debug('ES User Id '+esuser.id);
}
if(experts=='')
{
List<SLP_Expert__c> lstExperts=[select id,es_user_id__c,es_user_id__r.user_id__c from SLP_Expert__c where es_user_id__r.user_id__c=:userId];
if(lstExperts.size()>0)
{
for(SLP_Expert__c expert:lstExperts)
{
delete expert;
}
}
}
else
{
List<Id> expertIds=experts.split(',');
List<SLP_Expert__c> lstExperts=[select id,es_user_id__c,es_user_id__r.user_id__c from SLP_Expert__c where es_user_id__r.user_id__c=:userId];
List<ES_User__c> esuser=[select id from ES_User__c where user_id__c=:userId];
if(lstExperts.size()>0)
{
for(SLP_Expert__c expert:lstExperts)
{
delete expert;
}
for(Id ids:expertIds)
{
SLP_Expert__c expert=new SLP_Expert__c ();
expert.ES_User_id__c=esuser[0].id;
expert.SLP_Secondary_Industry_ID__c=ids;
insert expert;
}
}
else
{
for(Id ids:expertIds)
{
SLP_Expert__c expert=new SLP_Expert__c ();
expert.ES_User_id__c=esuser[0].id;
expert.SLP_Secondary_Industry_ID__c=ids;
insert expert;
}

}

}

}

}