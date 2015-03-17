/**
* This is a utility class for Apptus custom code
* Author : Apttus
*/


public with sharing class AptsUtil {

    // package namespace
    public static final String PACKAGE_CM_NAMESPACE = 'Apttus_CMConfig';
    
    // apttus package namespace prefix
    public static final String APTTUSPACKAGE_NAMESPACE_PREFIX = 'Apttus';
    
     public static String SALES_APPROVER = 'Approver';
     public static String SALES_INFORMER = 'Informer';
    
    
/**
   * Checks if the given string value is null or empty.
   * @param strValue the string to check
   * @return <code>true</code> if the string value is null or empty, <code>false</code> otherwise
   */
  public static Boolean nullOrEmpty(String strValue) {
    // check if null or zero length string
    return (strValue == null || strValue.trim().length() == 0);
    
  }
  
  /**
   * Checks if the given list of objects is null or empty.
   * @param objList the list of objects to check
   * @return <code>true</code> if the list is null or empty, <code>false</code> otherwise
   */
  public static Boolean nullOrEmpty(List<Object> objList) {
    // check if null or empty
    return (objList == null || objList.isEmpty());
    
  }     
    
    // Method to write Activity History
    public static void createActivityLogEntry(Id whatId, String subject) {
        Task task = new Task();
        task.ActivityDate = Date.today();
        task.Description = subject;
        task.OwnerId = UserInfo.getUserId();
        task.Priority = 'Normal';
        task.Status = 'Completed';
        task.Subject = subject;
        task.WhatId = whatId;

        insert task; 
    }    
       
  
  
    public static String getCurrentUserProfile()  {
        String profileName; 
         User[] userData = [select Id, Profile.Name, UserRole.Name from User where Id = :UserInfo.getUserId()];     
         if (userData.size() > 0)  {
            profileName = userData[0].Profile.Name;
         }
        return profileName;    
    }

    public static String parseUserName(String uName){
        String sUserEmail = '';
        sUserEmail = uName.split('@')[0];
        return sUserEmail;
    }
 
    public static Map<String,Id> getActiveUserMap(String condition) {
            Map<String, Id> mapExistingUser = new Map<String, Id>(); 
            List<User> listUser = new List<User>();
            String queryString = 'Select Username, IsActive, Id From User where IsActive = True';
            if (condition.length() > 0) {
                 queryString += ' and ('+condition+')';
            }
            System.debug('Get Active User query '+queryString);
            listUser = Database.query(queryString);
            for(User u: listUser){
                String uName = parseUserName(u.Username);
                mapExistingUser.put(uName, u.Id);
            }
            return mapExistingUser;
    }   



    //Returns a list of ids of queues that this user is a member of
    public static List<Id> getQueuesForUser(String userId) { 
        List<Id> listGroupIds = new List<Id>();
        List<GroupMember> listGroupMembers = [Select g.GroupId From GroupMember g
                                                where g.Group.Type='Queue'
                                                and g.UserOrGroupId=:userId
                                                ];                                                 
        if (listGroupMembers!=null && listGroupMembers.size()>0) {     
            for (GroupMember gm:listGroupMembers) {
                listGroupIds.add(gm.GroupId);
            }
        }
         
        return listGroupIds;
    }   
    
}