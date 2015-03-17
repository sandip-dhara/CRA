global class MYCOMPUserRoleWebService{

//inner class to store @GetUserCount result
global class UserRoleCountOpn{
      webservice Integer Usercount;
      webservice String ResultStatus;
 }
 
//inner class to store @DeleteUserRole result 
global class UserRoleDeleteOpn{
    webservice String Resultstring;
 } 
 
 
/*******************@WebService Method to Count Number of User Associated****************************/ 

webservice static UserRoleCountOpn GetUserCount(string  UserRoleID) {
MYCOMPUserRoleWebService.UserRoleCountOpn var=new MYCOMPUserRoleWebService.UserRoleCountOpn();
    integer totalCount=0;
    integer usercount=0;
    integer levelcount=0;
    list<userrole> childids=new list<userrole>();
    Set<ID> Finalchildrecords=new Set<ID>();        
    list<ID> ids=new list<ID>();
    ids.add(UserRoleID);
    usercount=[select count() from user where UserRoleId =:UserRoleID];    
    totalCount=totalCount+usercount;
       do {
                childids=getchildrecordID(ids);
                ids.clear();
                levelcount=childids.size();
                    for(userrole rl:childids)
                    {
                        Finalchildrecords.add(rl.id);
                        ids.add(rl.id);
                    }
                    usercount=[SELECT count() FROM User where userroleid=:ids];
                    totalCount=totalCount+usercount;
                   childids.clear();
           } while(levelcount>0);

var.Usercount=totalCount;
if(totalCount==0){
var.ResultStatus='No User Associated';
}
else{
var.ResultStatus='User Associated';
}   
system.debug('Number of Users===='+var.Usercount);
return var;
}

/****************************@Method to pull child of UserRoleList**************************/

global static list<userrole> getchildrecordID(list<ID> var){
list<userrole> roles=[SELECT Id,Name FROM UserRole where ParentRoleId =:var];
return roles;
}

/*******************@WebService Method to Delete UserRole****************************/

webservice static UserRoleDeleteOpn DeleteUserRole(string  UserRoleID){
MYCOMPUserRoleWebService.UserRoleDeleteOpn resultvar=new MYCOMPUserRoleWebService.UserRoleDeleteOpn();
Boolean success;
integer childrolecount;
List<List<userrole>>UserRoleHierarchyList=new List<List<userrole>>();
list<userrole> NLevelUserRoleIds=new list<userrole>();
list<userrole> CurrentRoleIds=new list<userrole>();
List<ID>RoleIds=new List<ID>();
//pulling current userrole
CurrentRoleIds=[SELECT Id,Name FROM UserRole where Id =:UserRoleID];
UserRoleHierarchyList.add(CurrentRoleIds);
NLevelUserRoleIds=[select ID,name FROM UserRole where ParentRoleId =:UserRoleID];
//Storing Immediate Child list for  checking the child
    for(userrole rl:CurrentRoleIds){
        RoleIds.add(rl.id);
    }
if(NLevelUserRoleIds.size()>0){
            NLevelUserRoleIds.clear();
            do {
            NLevelUserRoleIds=getchildrecordID(RoleIds);
            childrolecount=NLevelUserRoleIds.size();
                if(NLevelUserRoleIds.size()>0){
                    RoleIds.clear();
                    for(userrole rl:NLevelUserRoleIds){
                      RoleIds.add(rl.id);
                    }
                    
                  List<userrole>currentlevel=new  List<userrole>();
                  currentlevel.addAll(NLevelUserRoleIds);            
                  UserRoleHierarchyList.add(currentlevel);              
                  NLevelUserRoleIds.clear();              
                }else{
                    success=DeleteNLevelUserRole(UserRoleHierarchyList);
                }
            }while(childrolecount>0);
}else{
success=DeleteNLevelUserRole(UserRoleHierarchyList);
} 
if(success==true)
{
resultvar.Resultstring='Delete Successful';
}else{
resultvar.Resultstring='Delete Failed';
} 
return resultvar;
}

/****************************@Method to Delete UserRoleList**************************/

global static Boolean DeleteNLevelUserRole(List<List<UserRole>> UserRoleHierarchyList){
Boolean result=true;
   for(integer i=UserRoleHierarchyList.size()-1;i>=0;i--){
       if(result==false){break;}
        try{
         delete(UserRoleHierarchyList.get(i));
            }catch(exception e){result=false;}
        }
return result;
}
}