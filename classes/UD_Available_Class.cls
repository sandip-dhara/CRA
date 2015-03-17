public with sharing class UD_Available_Class {

    public UD_Available_Class(ApexPages.StandardController controller) {
    }
    public string getAvail () {
        string uid = userinfo.getUserId();
        string avl;
        List <UserData__C> ud = [select available__c from userdata__c where user__c = :uid LIMIT 1];
        if (ud.size() == 0) 
            { system.debug('returning null'); 
              return('null');
            }
        else { system.debug('in loop'); 
               for(UserData__C ud1 : ud){
                  if (ud1.available__c == true)
                       {avl = 'true';}
                  else {avl = 'false';}
               }
               system.debug('returning ' + avl); 
               return (avl);
            }
    }

    public integer getOpenCases () {
        string uid = userinfo.getUserId();
        string avl;
        integer mycase_count = [select count() from case where Ownerid = :uid and status!='Closed'];
        return(mycase_count);
    }

    public string switchAvail () {
        string uid = userinfo.getUserId();
        List <UserData__C> ud = [select available__c from userdata__c where user__c = :uid  LIMIT 1];
        if  (ud.size() == 0) return (null);
        else {
               for(UserData__C ud1 : ud){
                  if (ud1.available__c == true)
                       {ud1.available__c = false;}
                  else {ud1.available__c = true;}
               }
               update ud;
          }
        return (null);
    }

}