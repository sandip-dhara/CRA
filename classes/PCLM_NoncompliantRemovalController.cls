/**********************************************************
* Class Name: PCLM_NoncompliantRemovalController
* Author: HP 
* Date: 13-Dec-2012 
* Description: To Update the strike count to zero when the HP Lead Status value changed from 
              'Non compliant' to either 'Active','Inactive' or 'Disqualified'
**********************************************************/

public with sharing class PCLM_NoncompliantRemovalController{
    public PCLM_NoncompliantRemovalController(){
    }
   /* public static void toUpdateStrikeCount(map<id, account> newAccountMap, map<id, account> oldAccountMap){
    List<Contact> contactIdList = new List<Contact>();
    List<Id> accountIdList= new List<Id>();
    List<String> partnerAccIdList = new List<String>();
    List<User> userList = new List<User>();
    List<User> toUpdateUserList = new List<User>();   
        for(Id updatedAccID: newAccountMap.keyset()){
            if((oldAccountMap.get(updatedAccID).HP_Lead_Status__c=='Non compliant')&&((newAccountMap.get(updatedAccID).HP_Lead_Status__c!='Non compliant')&&(newAccountMap.get(updatedAccID).HP_Lead_Status__c!=null))){
                accountIdList.add(newAccountMap.get(updatedAccID).Id);
            }
        }
        if(accountIdList.size()!=0){
            contactIdList = [Select AccountId from Contact where AccountId In :accountIdList];
            for(integer var=0; var<contactIdList.size();var++){
                partnerAccIdList.add(convertTo15Digit(contactIdList[var].AccountId));
            }
        }
        if(contactIdList.size()!=0){       
            userList =[select Strike_Count__c from User where Partner_account_ID__c In :partnerAccIdList];
                For(User usr: userList ){
                    usr.Strike_Count__c =0;
                    toUpdateUserList.add(usr);
                }
            update toUpdateUserList;
        }
        }


    public Static String convertTo15Digit(String paramID){
        try{
            if(paramID.length()>15){
                paramID = paramID.substring(0,15);
            }
        }catch(Exception e){
        system.debug('**Exception in PCLM_NoncompliantRemovalController ****' + e.getTypeName() + ': ' + e.getMessage() + ' -- ' + e.getCause()+'##'+e.getStackTraceString());
        }
        return paramID;
    }*/
}