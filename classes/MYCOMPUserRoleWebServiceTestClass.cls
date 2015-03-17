@isTest 
private class MYCOMPUserRoleWebServiceTestClass {
    static testMethod void validateMYCOMPUserRoleWebService() {
    
        MYCOMPUserRoleWebService.UserRoleCountOpn usrcount=new MYCOMPUserRoleWebService.UserRoleCountOpn();
        MYCOMPUserRoleWebService.UserRoleDeleteOpn DeleteStatus=new MYCOMPUserRoleWebService.UserRoleDeleteOpn();
        String UserroleId=[Select id from userrole where name='SW WW SVP' limit 1].id;
        usrcount =MYCOMPUserRoleWebService.GetUserCount(UserroleId);
        DeleteStatus =MYCOMPUserRoleWebService.DeleteUserRole(UserroleId);
        
    }
}