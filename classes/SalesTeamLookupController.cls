/**********************************************************
    * Class Name: SalesTeamLookupController
    * Author: HP
    * Date: 
    * Requirement # Request Id:
    * Description: 
    ***********************************************************/
    public class SalesTeamLookupController {
        
        public List<WrapUser> results{get;set;} // search results
        public String searchString{get;set;} // search keyword
        public String UserTypeString {get;set;} // partnerType keyword
        public String opportunityID;
        public List<OpportunityTeamMember> opteam=new List<OpportunityTeamMember>();
        public List<Id> locIdList =new List<Id>();
        
        public Id oppID {get;set;}
        public String retUrl {get;set;}
        public String abpPage{get;set;}
        
        /**
        * @description: Class Constructor method
        * 
        * 
        **/ 
        public SalesTeamLookupController () {
           
            // get the current search string
            opportunityID = Apexpages.currentPage().getParameters().get('optyid');       
            searchString = System.currentPageReference().getParameters().get('lksrch');     
            UserTypeString = System.currentPageReference().getParameters().get('userType');
           system.debug('usertype string ');
            system.debug('opportunityid '+opportunityID);
            runSearch();  
        }
        
       public set<ID> userIDvalues(){ 
       
            List<Channel_Partner__c> prtnrrec =new List<Channel_Partner__c>();
            set<User> salesTeamUsers=new set<User>();
            set<ID> prtnrID= new set<ID>();
            Set<ID> userid= new Set<ID>();
            List<Account> existPrtnrAcc=new List<Account>();
            Set<String> AccidSTr=new Set<String>();
            List<ID> locationList = new List<ID>();
            List<ID> conList = new List<ID>();
            List<Opportunity> currentOppty = new List<Opportunity>();
            List<User> opptyOwner = new List<User>();
            String partLocId;
           List<User> salesTeamList= new List<User>();

            currentOppty = [select OwnerId from Opportunity where Id=:opportunityID];
            /* Check if the owner is Partner user */
            opptyOwner = [select Id,Location_Record_Id__c from User where Id =: currentOppty[0].OwnerId and isPortalEnabled = True and isActive = true];
            List <User> userBsdOnLocList = new List<User>();
            if(opptyOwner.size()>0){
                userBsdOnLocList = [Select id From User where Location_Record_Id__c =:opptyOwner[0].Location_Record_Id__c and Id !=: currentOppty[0].OwnerId and isActive = true];
            }else{
                List<OpportunityTeamMember> salesTeamMembersList = [select UserId FROM OpportunityTeamMember where OpportunityId =:opportunityID];
                system.debug('salesTeamMembersList'+salesTeamMembersList);
                if(salesTeamMembersList.size()>0){
                    List<Id> userList = new List<Id>();
                    for(OpportunityTeamMember salesTeamMembersListVar:salesTeamMembersList){
                        userList.add(salesTeamMembersListVar.UserId);
                    }
                    system.debug('userList'+userList);
                    if(userList.size()>0){
                     salesTeamList=[select id,Location_Record_Id__c from User where id in :userList AND isActive = true];
                        for(User u:salesTeamList){                               
                            if(u.Location_Record_Id__c!=null && u.Location_Record_Id__c !=''){
                                partLocId=u.Location_Record_Id__c;
                                break;
                            }

                        }
                        //User u = [select Location_Record_Id__c from User where id= :userList[0]];
                        if(partLocId != null && partLocId !=''){
                            userBsdOnLocList = [Select id From User where Location_Record_Id__c =:partLocId and Id NOT IN :userList AND isActive = true LIMIT 50000];
                        }
                        else{
                        prtnrrec=[select Channel_Partner__c,Location__c from Channel_Partner__c where opportunity__c=: opportunityID];
                        for(Channel_Partner__c channel:prtnrrec){
                        locIdList.add(channel.Location__c);
                        }
                            if(locIdList.size() > 0){
                                userBsdOnLocList = [Select id from User where Location_Record_Id__c IN : locIdList AND isActive = true];
                            }
                        }
                    }                   
                }else{
                    prtnrrec=[select Channel_Partner__c,Location__c from Channel_Partner__c where opportunity__c=: opportunityID];  
                        system.debug('prtnrrec'+prtnrrec);
                    if(prtnrrec.size()>0){
                        String teamid = Apexpages.currentPage().getParameters().get('teamid'); 
                        if(teamid != Null && teamid !=''){
                            User u = [select Location_Record_Id__c from User where id= :teamid];
                            userBsdOnLocList = [Select id from User where Location_Record_Id__c = : u.Location_Record_Id__c and Id !=:teamid AND isActive = true];
                        }else{
                            for(Channel_Partner__c chp:prtnrrec){
                                locationList.add(chp.Location__c);
                            }
                             system.debug('a1c'+locationList);
                             userBsdOnLocList = [Select id From User where Location_Record_Id__c In  :locationList AND isActive = true];                        
                        }
                    }               
                }                                   
            }
            system.debug('userBsdOnLocListsize'+userBsdOnLocList.size());
            system.debug('userBsdOnLocList'+userBsdOnLocList);
            if(userBsdOnLocList.size()>0){
                for(User u:userBsdOnLocList){
                     userid.add(u.id);
                }
                
            }
            return userid;
            //system.debug('userid'+userid);
            //return userid;
         }         
     public set<ID> ABPUsers(){ 
            List<Channel_Partner__c> prtnrrec =new List<Channel_Partner__c>();
            set<User> salesTeamUsers=new set<User>();
            set<ID> prtnrID= new set<ID>();
            Set<ID> userid= new Set<ID>();
            List<Account> existPrtnrAcc=new List<Account>();
            Set<String> AccidSTr=new Set<String>();
            List<ID> locationList = new List<ID>();
            List<ID> conList = new List<ID>();
            List<Account_Plan__c> currentAccPlan = new List<Account_Plan__c>();
            List<User> ABPOwner = new List<User>();

            currentAccPlan = [select OwnerId from Account_Plan__c where Id=:opportunityID];
            /* Check if the owner is Partner user */
            if(Test.isRunningTest()){              
             }
            else{
            ABPOwner = [select Id,Location_Record_Id__c from User where Id =: currentAccPlan[0].OwnerId and isPortalEnabled = True];
            }
            List <User> userBsdOnLocList = new List<User>();
            if(ABPOwner.size()>0){
                userBsdOnLocList = [Select id From User where Location_Record_Id__c =:ABPOwner[0].Location_Record_Id__c and Id !=: currentAccPlan[0].OwnerId AND isActive = true LIMIT 50000];
            }            
            if(userBsdOnLocList.size()>0){
                for(User u:userBsdOnLocList){
                     userid.add(u.id);
                }                
            }
            return userid;            
         }    
         
         
      public PageReference search(){
            runSearch();
            return null;
       }
    
      
        private void runSearch() {
            // TODO prepare query string for complex serarches & prevent injections
            set<ID> useridval=new set<ID>();
            abpPage = Apexpages.currentPage().getParameters().get('abp');
            if(abpPage=='abpSearch'){
            useridval=ABPUsers();
            }else{            
            useridval=userIDvalues();
            }
            results = new STLookupAccountSearch().performSearch(searchString,userTypeString,useridval);               
        }
        
        /**********************************************************
        * Class Name: LookupAccountSearch
        * Author: Accenture
        * Date: 20-March-2012 
        * Requirement # Request Id:
        * Description: run the search in sharing mode and return the records found.
        ***********************************************************/
        public with sharing class STLookupAccountSearch {
            // run the search and return the records found. 
            private List<WrapUser> performSearch(string searchString,String UserTypeString,set<ID> userid) {
                
                String soql = 'select id,name,LastName,FirstName, Last_First_Name__c,Email,Business_Group__c,Global_Business_Unit__c,UserRoleid from user';
                String whereCondition = '';
                
                  if(searchString != null && searchString != ''){
                    if(searchString.contains('\'')){
                        searchString=String.escapeSingleQuotes(searchString);
                    }
                    searchString = searchString.replaceAll('\\*','%');
               
                    whereCondition = whereCondition +  ' name LIKE \''+'%' + searchString +'%\' and ';
                
                
                }
                
                if(userid.size()>0 && userid!=null&& UserTypeString!='User'){
                
                    if(searchString != null && searchString != ''){
                        searchString = searchString.replaceAll('\\*','%');
                   
                    }
               
                
                    if(userTypeString!=null && !userTypeString.equalsIgnoreCase('')){
                
                       // if(userTypeString.equalsIgnoreCase(Label.Channel_Partner)){
                            whereCondition = whereCondition + ' id = : userid and User_Type_Text__c like \''+'%'+'Partner\'     ';
                       // }
                      
                   
                       
                    }
                }
                else if(UserTypeString!='User'){
                    whereCondition = whereCondition +' name=\'XXXXXXXXXXX\' and ';
                
                }
                else{
                    whereCondition = whereCondition+' ( Not User_Type_Text__c  like \''+'%'+'Partner\') and ';
                }
               
                
            
                if(whereCondition!=null && whereCondition.length()>0 ){
                    whereCondition = ' where'+whereCondition.substring(0,whereCondition.length()-4);
                }
               
                
                
                soql = soql + whereCondition + ' limit 250';
                System.debug('query>>>'+soql);
                //return database.query(soql);
                List<User> userslist=database.query(soql); 
                List<WrapUser> userslistToReturn=new List<WrapUser>();
                for(User u : userslist){
                    
                    
                   String fullName=String.escapeSingleQuotes(u.name);
                   userslistToReturn.add(new WrapUser(fullName,u));
                
                }
                return userslistToReturn;  
            }
        }
        /**
        * @description: used by the visualforce page to send the link to the right dom element
        * @return: String returns url lkfm(form) paramter value
        * 
        **/
        public string getFormTag() {
            return System.currentPageReference().getParameters().get('lkfm');
        }
        /**
        * @description: used by the visualforce page to send the link to the right dom element for the text box
        * @return: String returns url lknm paramter value
        * 
        **/
        public string getTextBox() {
            return System.currentPageReference().getParameters().get('lknm');
        }
        /**
        * @description return flag is Search Result Empty or not
        * @return: boolean True if list is empty
        * 
        **/
        public Boolean getIsResultEmpty(){
            Boolean returnBoolean = false;
            if(results==null || results.size()<1){
                returnBoolean=true;
            }
            return returnBoolean;
    
        }
        public Static String convertTo15Digit(String paramID){
        try{
            if(paramID.length()>15){
                paramID = paramID.substring(0,15);
            }
        }catch(Exception e){
        }
        return paramID;
        }
     private class WrapUser{
        public User u {set;get;}
        public String name{set;get;}
        WrapUSer(String uname, user us){
            u=us;
            name=uname;
        }
    }
    }