public class ExpertiseSampleController {

public Id SLPRoleId{get;set;}
public Id UserId{get;set;}

public List<SLP_Role__c> LstRoles{get;set;}
public List<SelectOption> LstRolesOption{get;set;}

public class CustomRoles
{
public id UserId{get;set;}
public string UserName{get;set;}
}

public List<CustomRoles> GetUsers
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
return lstCutomRoles;
}
set;
}

public ExpertiseSampleController ()
{
LstRolesOption=GetRoles();
}

public List<SelectOption> GetRoles()
{
 List<SelectOption> lstRolesOptions= new List<SelectOption>();       
List<SLP_Role__c> lstRols=[select id,name,role_name__c from SLP_Role__c where Is_Active__c=:True];
lstRolesOptions.add(new SelectOption('','--Select Role--'));
        
        
        for(SLP_Role__c role:lstRols){
            lstRolesOptions.add(new SelectOption(role.id,role.role_name__c));    
        }

        lstRolesOptions.add(new SelectOption('NO','No Roles'));

        return lstRolesOptions;
}

}