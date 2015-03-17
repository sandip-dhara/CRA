global with sharing class SarahMobile1{
public SarahMobile1 (ApexPages.StandardController controller) {} // empty constructor
 
    @RemoteAction
    global static SLP_RemoteResult GetUsers(String permissionSet) {
     
        SLP_RemoteResult result = new SLP_RemoteResult();
    //
        //  get the users with matches on the psermission set
        // 
    //
    // where PermissionSet.Name in ('ES_Social_Learning_Consumer', 'ES_Social_Learning_Producer', 'ES_Social_Learning_Moderator') 
    //
    Set<String> boardUids = new Set<String>();
        String  SearchStrWithLike= '%'+ permissionSet + '%';
         List<sObject> usersMatch = [SELECT AssigneeId
                FROM PermissionSetAssignment 
                where PermissionSet.Name like : SearchStrWithLike ];
        
         for (sObject b : usersMatch) { 
            if (!boardUids.contains(String.valueOf(b.get('AssigneeId')))) {
                boardUids.add(String.valueOf(b.get('AssigneeId')));
            }
         }
        
        system.debug(boardUids);
        
        // 
        // get the user details
        // 
        List<User> users = [select u.id, u.name, u.title, u.department, u.SmallPhotoUrl, u.FullPhotoUrl, u.Email, u.Phone from User u where u.id in : boardUids order by u.name];
            if(users.size()< 1){
                result.success = false;
                result.error = 'No Available Users'; 
            }
            else{
                result = new SLP_RR();
                result.success = true;
                SLP_RR restWSSL= (SLP_RR)result;
                restWSSL.ListUsers = new List<SLPUserDetails>();
                for(User b:users){
                    if (b.SmallPhotoUrl.indexOf('profilephoto/005/') == -1) {
                        system.debug('user ' + b.Id);
                        SLPUserDetails udetails = new SLPUserDetails();
                        udetails.ID= b.Id;
                        udetails.Name = b.Name;
                         if(b.Email!= null && b.Email!= 'null')
                         {
                             udetails.Email = b.Email;
                         }
                        else
                        {
                            udetails.Email = 'dummyEmail@hp.com';
                        }
                         if(b.Phone!= null && b.Phone!= 'null')
                         {
                             udetails.Phone = b.Phone;
                         }
                        else
                        {
                            udetails.Phone = '000-000-0000';
                        }
                        if(b.title!= null && b.title!= 'null')
                        {
                             if(b.title.length() > 25)
                             {                            
                            udetails.Title = b.title.substring(0, 25) + '...';
                             }
                             else
                             {
                            udetails.Title = '';
                             }
                        }
            
                        udetails.SmallPhotoUrl = b.SmallPhotoUrl;
                                if(b.department!=null && b.title!=null && b.department!='null' && b.title!='null')
                        {
                        udetails.TitleDepartment= b.title + ', ' + b.department;  
                        }
                        else if((b.department!=null && b.department!='null') && (b.title==null || b.title=='null'))
                        {
                        udetails.TitleDepartment=  b.department;  
                        }
                        
                        else if((b.department==null || b.department=='null')  && (b.title!=null && b.title!='null'))
                        {
                        udetails.TitleDepartment=  b.title;  
                        }
                        else {
                        udetails.TitleDepartment= '';
                        }
                        
                        restWSSL.ListUsers.add(udetails);
                    }

        		}
        	}
        system.debug('resultend ' + result);
        return result;
    }
            


     global class SLPUserDetails
        {
        global String Id;
        global String Name;
        global String Email;
        global String Phone;
        global String Title;
        global String TitleDepartment;
        global String SmallPhotoUrl;

        }
    global class SLP_RR extends SLP_RemoteResult
        {
            global List<SLPUserDetails> ListUsers;
        }

    global virtual class SLP_RemoteResult {
        global boolean success;
        global String error;

    }
}