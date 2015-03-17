Public Class AthenaUserAccess{

    Public Boolean IsModerator(string userID){
    
        String usrProfileName = [select u.Profile.Name from User u where u.id = :userID].Profile.Name;
    
        if(usrProfileName=='ES IT Administrator' || usrProfileName=='IT Administrator')
            Return True;
        else If(usrProfileName=='ES Base Profile'){
            List<PermissionSet> usrAsgndPermSet=[SELECT Id, Name, Label, UserLicenseId FROM PermissionSet where  IsOwnedbyprofile=FALSE and id in (SELECT  PermissionSetId FROM PermissionSetAssignment where AssigneeId=:userID)];
            for(PermissionSet permSet: usrAsgndPermSet){
                If(permSet.Name=='ES_Social_Learning_Moderator')
                    return true;             
            }
            return false;            
        }
        else  
            return false;
    }
        
    Public Boolean IsProducer(string userID){
         String usrProfileName = [select u.Profile.Name from User u where u.id = :userID].Profile.Name;
         List<PermissionSet> usrAsgndPermSet=[SELECT Id, Name, Label, UserLicenseId FROM PermissionSet where  IsOwnedbyprofile=FALSE and id in (SELECT  PermissionSetId FROM PermissionSetAssignment where AssigneeId=:userID)];
         If(usrProfileName=='ES Base Profile'){
            for(PermissionSet permSet: usrAsgndPermSet){
                If(permSet.Name=='ES_Social_Learning_Producer')
                    return true;                
            }
            return false;        
         }
         else
            return False;
        
    }          
}