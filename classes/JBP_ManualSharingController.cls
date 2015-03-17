/**********************************************************
    * Class Name:JBP_ManualSharingController 
    * Author: HP  
    * Date: 21-July-2013
    * R6 : Requirement #:5382
    * Description: Ability for Partner to request PBM to manually add additional Partner Users to view their JBP. Add additional users through the share button;    * and receive email when it is shared on them
    **********************************************************/
    public class JBP_ManualSharingController{
    //Variable Declaration
    public Boolean displayMsg { get; set; }
    public String searchUser { get; set; }
    public String selectedAction { get; set; }
    public String JBPPlanName{ get; set; }
    public String selectedUser { get; set; }
    Public List<string> leftselected{get;set;}
    Public List<string> rightselected{get;set;}
    List<string> leftvalues = new List<string>();
    List<string> rightvalues = new List<string>();
    Set<Id> finalUsers = new Set<Id>();
    public List<string> partnerAccIdList = new List<String>();
    List<String> partnerBRsList = new List<String>();
    List<User> allUsrList = new List<User>();
    List<User> allPortalUsersList = new List<User> ();
    Map<Id, String> accountIdNameMap = new Map<Id, String>();
    Map<String, Id> userNameIdMap = new Map<String, Id>();
    Map<String, Id> internalUserNameIdMap = new  Map<String, Id>();
    Map<Id,String> internalUserIdNameMap = new  Map<Id,String>();
    Map<String, List<Id>> removedUIdNameMap = new Map<String, List<Id>>();
    Map<String ,List<Id>> userNameIdListMap= new Map<String, List<Id>> (); 
    Map<String ,List<Id>> copyOfuserNameIdListMap= new Map<String, List<Id>> (); 
    Map<String, List<Id>> internalUserNameIdListMap = new Map<String, List<Id>>();
    Map<String, List<Id>> copyOfinternalUserMap = new Map<String, List<Id>>();
    Set<id> CurrentlySharedUserIdSet = new Set<id>();
    JBP__c jbp = new JBP__c();
    EmailTemplate emailTmplt;
    Id emailTemplateId;
    Id pareentID;
    //Constructor  
    public JBP_ManualSharingController(){
        leftselected = new List<String>();
        rightselected = new List<String>();
        pareentID= ApexPages.currentPage().getParameters().get('ParentID');
        JBPPlanName=ApexPages.currentPage().getParameters().get('planName');
        List<JBP__Share> shareRecList = [select UserOrGroupId from JBP__Share where ParentId =: pareentID];
        if(shareRecList.size()>0){
            for(JBP__Share share : shareRecList){
                CurrentlySharedUserIdSet.add(share.UserOrGroupId);
            }
        }
        jbp = [select Partner_Account__c, Partner_Account__r.ParentId, ownerId,Business_Relationship_jbp__c , Partner_Account__r.Name
                        from JBP__c
                            where id =:pareentID];
        emailTmplt=[SELECT Id, Name, DeveloperName
                            FROM EmailTemplate
                                where DeveloperName ='JBP_Partner_Plan_Share_Notification'];
        emailTemplateId= emailTmplt.Id;
        if(searchUser==null){
            displayMsg = true;
            allUsrList= [Select Id, Name from User  where isActive=True and isPortalEnabled=false and Id !=:jbp.ownerId Limit 100];
            for(integer var=0; var<allUsrList.size(); var++){
                if(!CurrentlySharedUserIdSet.contains(allUsrList[var].id)&& !finalUsers.contains(allUsrList[var].id)){
                    internalUserNameIdMap.put(allUsrList[var].Name, allUsrList[var].id);
                    internalUserIdNameMap.put(allUsrList[var].id, allUsrList[var].Name);
                    if(internalUserNameIdListMap.containsKey('User:'+allUsrList[var].Name)){
                        internalUserNameIdListMap.get('User:'+allUsrList[var].Name).add(allUsrList[var].Id);
                    }else{
                        internalUserNameIdListMap.put('User:'+allUsrList[var].Name, new List<Id>());
                        internalUserNameIdListMap.get('User:'+allUsrList[var].Name).add(allUsrList[var].Id);
                    }
                }
            }
            for(String internalUservar:internalUserNameIdListMap.keySet()){
                for(Id idVar:internalUserNameIdListMap.get(internalUservar)){
                    leftvalues.add(internalUservar);
                }
            }
        }
        if(jbp.Partner_Account__c != null){
            partnerAccIdList.add(jbp.Partner_Account__c);
            accountIdNameMap.put(jbp.Partner_Account__c,JBP.Business_Relationship_jbp__c);
            if(jbp.Partner_Account__r.ParentId != null){
                partnerAccIdList.add(jbp.Partner_Account__r.ParentId);
                Account acco=[select name, Id from Account where Id =:jbp.Partner_Account__r.ParentId];
                accountIdNameMap.put(jbp.Partner_Account__r.ParentId,acco.Name);
                List<Account> JBPParentBRs=[SELECT Id,MDCP_Business_Relationship__c, Name, ParentId FROM Account where ParentId =: jbp.Partner_Account__r.ParentId];
                for(Account acc:JBPParentBRs){
                    partnerAccIdList.add(acc.Id);
                    accountIdNameMap.put(acc.id,acc.MDCP_Business_Relationship__c);
                }    
            }
            partnerBRsList=convertTo15Digit(partnerAccIdList);
            allPortalUsersList= [Select Id, Name, Portal_Tab_Access__c,Partner_account_ID__c, ContactId from User  where Partner_account_ID__c IN:partnerBRsList and isActive=True and isPortalEnabled=true Limit 100];  
        }
        for(User portalUser :allPortalUsersList ){
            if(!CurrentlySharedUserIdSet.contains(portalUser.id)&& !finalUsers.contains(portalUser.id)){
                userNameIdMap.put(portalUser.Name, portalUser.Id);
                String capability= portalUser.Portal_Tab_Access__c;
                if(capability!= null && capability.contains('JBP')){
                    if(userNameIdListMap.containsKey(portalUser.Name+':'+accountIdNameMap.get(portalUser.Partner_account_ID__c))){
                        userNameIdListMap.get(portalUser.Name+':'+accountIdNameMap.get(portalUser.Partner_account_ID__c)).add(portalUser.Id);
                    }else{
                        userNameIdListMap.put(portalUser.Name+':'+accountIdNameMap.get(portalUser.Partner_account_ID__c), new List<Id>());
                        userNameIdListMap.get(portalUser.Name+':'+accountIdNameMap.get(portalUser.Partner_account_ID__c)).add(portalUser.Id);
                    }
                } 
            }           
        }
    }
    /*  R6 : ReqNumber -- 5382 Added by Amala --  STARTS
     *  @description: This method will search for the User and Partner User based on search String.
     *  @Params: null
     *  @return: void
    **/
    public PageReference findUser(){
        if(searchUser!=null && selectedUser=='PartnerUser') {
            displayMsg= false;
            leftvalues.clear(); 
            copyOfuserNameIdListMap.clear();
            copyOfinternalUserMap.clear();
            String star='*';
            star=star.repeat(searchUser.length());
            String percent='%';
            percent=percent.repeat(searchUser.length());
            if(searchUser.length()>1 && (!searchUser.contains(star)&& !searchUser.contains(percent))){
                searchUser = string.escapeSingleQuotes(searchUser);
                String tempSearchUser = searchUser.replaceAll('\\*','%');
                tempSearchUser = '%'+tempSearchUser+'%';
                List<User> findUserList= [Select Id, name, Portal_Tab_Access__c, Partner_account_ID__c from User where Partner_account_ID__c IN: partnerBRsList and isActive=True and IsPortalenabled= True and ( Name Like :tempSearchUser or Email =:searchUser)  limit 100];
            
                List<Account> accountList=[select name,MDCP_Business_Relationship__c, Id from Account where Id IN: partnerBRsList];
                for(Account accou: accountList){
                    accountIdNameMap.put(accou.Id, accou.MDCP_Business_Relationship__c);
                }
                for(User portalUser :findUserList ){
                    if(!CurrentlySharedUserIdSet.contains(portalUser.id) && !finalUsers.contains(portalUser.id)){
                        userNameIdMap.put(portalUser.Name, portalUser.Id);
                        String capability= portalUser.Portal_Tab_Access__c;
                        if(capability!= null && capability.contains('JBP')){
                            if(copyOfuserNameIdListMap.containsKey(portalUser.Name+':'+accountIdNameMap.get(portalUser.Partner_account_ID__c))){
                                copyOfuserNameIdListMap.get(portalUser.Name+':'+accountIdNameMap.get(portalUser.Partner_account_ID__c)).add(portalUser.Id);
                            }else{
                                copyOfuserNameIdListMap.put(portalUser.Name+':'+accountIdNameMap.get(portalUser.Partner_account_ID__c), new List<Id>());
                                copyOfuserNameIdListMap.get(portalUser.Name+':'+accountIdNameMap.get(portalUser.Partner_account_ID__c)).add(portalUser.Id);
                            }
                            leftvalues.add(portalUser.Name+':'+accountIdNameMap.get(portalUser.Partner_account_ID__c));
                        }  
                    }           
                }
            }
        }else if(searchUser!=null && selectedUser=='User') {
            displayMsg= false;
            leftvalues.clear(); 
            copyOfinternalUserMap.clear();
            copyOfuserNameIdListMap.clear();
            String star='*';
            star=star.repeat(searchUser.length());
            String percent='%';
            percent=percent.repeat(searchUser.length());
            if(searchUser.length()>1 && (!searchUser.contains(star)&& !searchUser.contains(percent))){
                searchUser = string.escapeSingleQuotes(searchUser);
                String tempSearchUser = searchUser.replaceAll('\\*','%');
                tempSearchUser = '%'+tempSearchUser+'%';
                List<User> findUserList= [Select Id, name from User where isActive=True and IsPortalenabled= false and ( Name Like :tempSearchUser or Email =:searchUser)  and Id !=:jbp.ownerId limit 100 ];
                for(integer var=0; var<findUserList.size(); var++){
                    if(!CurrentlySharedUserIdSet.contains(findUserList[var].id) && !finalUsers.contains(findUserList[var].id)){
                        internalUserNameIdMap.put(findUserList[var].Name, findUserList[var].id);
                        internalUserIdNameMap.put(findUserList[var].id, findUserList[var].Name);
                        if(copyOfinternalUserMap.containsKey('User:'+findUserList[var].Name)){
                            copyOfinternalUserMap.get('User:'+findUserList[var].Name).add(findUserList[var].Id);
                        }else{
                            copyOfinternalUserMap.put('User:'+findUserList[var].Name, new List<Id>());
                            copyOfinternalUserMap.get('User:'+findUserList[var].Name).add(findUserList[var].Id);
                        }
                        leftvalues.add('User:'+findUserList[var].Name);
                    }
                }
            }
        } 
        return null;
    }
    // ReqNumber -- 5382 Added by Amala --  END
    
    /* R6 : ReqNumber -- 5382 Added by Amala --  STARTS
    *  @description: This method will populate the User or Partner User name in the Multiselect Pick List
    *  @Params: null
    *  @return: void
    **/
    public List<SelectOption> getunSelectedValues(){
        if(searchUser==''  && selectedUser=='PartnerUser'){
            leftvalues.clear();
            for(String userNameIdListMapVar:userNameIdListMap.keySet()){
                for(Id idVar:userNameIdListMap.get(userNameIdListMapVar)){
                    leftvalues.add(userNameIdListMapVar);
                }
            }
        }           
        if(searchUser=='' && selectedUser=='User'){
            leftvalues.clear();
            for(String internalUserVar:internalUserNameIdListMap.keySet()){
                for(Id idVar:internalUserNameIdListMap.get(internalUserVar)){
                    leftvalues.add(internalUserVar);
                }
            }
        }
        List<SelectOption> optionsList = new List<SelectOption>();
        List<string> tempList = new List<String>();
        tempList.addAll(leftvalues);
        tempList.sort();
        for(string leftvalues : tempList)
        optionsList.add(new SelectOption(leftvalues,leftvalues));
        return optionsList;         
    }
    /* R6 : ReqNumber -- 5382 Added by Amala --  STARTS
    *  @description: This method will Add the left selected String to Right MultiSelect Picklist
    *  @Params: null
    *  @return: void
    **/
    
    public void populateSelectClickMap(Map<String ,List<Id>> copyOfuserNameIdListMap, String leftselectedVar){
    List<Id> tempIDList = new List<Id>();
            tempIDList.addall(copyOfuserNameIdListMap.get(leftselectedVar));
            if(tempIDList.size()>1){
                if(removedUIdNameMap.containsKey(leftselectedVar)){
                    removedUIdNameMap.get(leftselectedVar).add(tempIDList[0]);
                }else{
                    removedUIdNameMap.put(leftselectedVar, new List<Id>());
                    removedUIdNameMap.get(leftselectedVar).add(tempIDList[0]);
                }
                rightvalues.add(leftselectedVar);
                tempIDList.remove(0);
                copyOfuserNameIdListMap.remove(leftselectedVar);
                copyOfuserNameIdListMap.put(leftselectedVar,tempIDList);
            }else{
                if(removedUIdNameMap.containsKey(leftselectedVar)){
                    removedUIdNameMap.get(leftselectedVar).add(tempIDList[0]);
                }else{
                    removedUIdNameMap.put(leftselectedVar, new List<Id>());
                    removedUIdNameMap.get(leftselectedVar).add(tempIDList[0]);
                }
                rightvalues.add(leftselectedVar);
                copyOfuserNameIdListMap.remove(leftselectedVar);
            }
    }
    public PageReference selectclick(){
        rightselected.clear();
        for(String leftselectedVar:leftselected){
        if(copyOfuserNameIdListMap.containsKey(leftselectedVar) && searchUser!='' && selectedUser=='PartnerUser' ){
            populateSelectClickMap(copyOfuserNameIdListMap,leftselectedVar);
        }else if(copyOfinternalUserMap.containsKey(leftselectedVar) && searchUser!='' && selectedUser=='User'){
            populateSelectClickMap(copyOfinternalUserMap,leftselectedVar);
        }else if(userNameIdListMap.containsKey(leftselectedVar) ){
            populateSelectClickMap(userNameIdListMap,leftselectedVar);
        }else if(internalUserNameIdListMap.containsKey(leftselectedVar)){
            populateSelectClickMap(internalUserNameIdListMap,leftselectedVar);
        }
        leftvalues.clear();
        for(String userNameIdListMapVar:copyOfinternalUserMap.keySet()){
            for(Id idVar:copyOfinternalUserMap.get(userNameIdListMapVar)){
                leftvalues.add(userNameIdListMapVar);
            }
        }
        for(String internalUserNameVar:copyOfuserNameIdListMap.keySet()){
            for(Id idVar:copyOfuserNameIdListMap.get(internalUserNameVar)){
               leftvalues.add(internalUserNameVar);
            }
        }
    }
      return null;
    }
    /* R6 : ReqNumber -- 5382 Added by Amala --  STARTS
     *  @description: This method will display the Left selected values in the Right Multiselect PickList Pannel.
     *  @Params: null
     *  @return: void
    **/
    public List<SelectOption> getSelectedValues(){
        List<SelectOption> optionsList = new List<SelectOption>();
        List<string> tempList1 = new List<String>();
        tempList1.addAll(rightvalues);
        tempList1.sort();
        finalUsers.clear();
        for(String str:rightvalues){
            if(removedUIdNameMap.containsKey(str)){
                finalUsers.addAll(removedUIdNameMap.get(str));
            }        
        }
        for(String rightvalues : tempList1)
        optionsList.add(new SelectOption(rightvalues,rightvalues));
        return optionsList;
    }

    public void populateUnselectMap(String rightselectedVar, Map<String ,List<Id>> userNameIdListMap){
        List<Id> tempIDList = new List<Id>();
        tempIDList.addall(removedUIdNameMap.get(rightselectedVar));
        if(tempIDList.size()>1){
            if(userNameIdListMap.containsKey(rightselectedVar)){
                userNameIdListMap.get(rightselectedVar).add(tempIDList[0]);
            }else{
                userNameIdListMap.put(rightselectedVar, new List<Id>());
                userNameIdListMap.get(rightselectedVar).add(tempIDList[0]);
            }
            leftvalues.add(rightselectedVar);
            tempIDList.remove(0);
            removedUIdNameMap.remove(rightselectedVar);
            removedUIdNameMap.put(rightselectedVar,tempIDList);
        }else{
            if(userNameIdListMap.containsKey(rightselectedVar)){
                userNameIdListMap.get(rightselectedVar).add(tempIDList[0]);
            }else{
                userNameIdListMap.put(rightselectedVar, new List<Id>());
                userNameIdListMap.get(rightselectedVar).add(tempIDList[0]);
            }
            leftvalues.add(rightselectedVar);
            removedUIdNameMap.remove(rightselectedVar);
        }       
    }
    /*  R6 : ReqNumber -- 5382 Added by Amala --  STARTS
     *  @description: This method will Remove the Right selected String to Left MultiSelect Picklist
     *  @Params: null
     *  @return: void
    **/ 
    public PageReference unselectclick(){
        for(String rightselectedVar:rightselected){
            List<String> isPartnerUser = new List<String>();
            isPartnerUser=rightselectedVar.split(':');
                if(removedUIdNameMap.containsKey(rightselectedVar)){
                if(isPartnerUser[0]!= 'User'){
                    populateUnselectMap(rightselectedVar, userNameIdListMap );
                }else{
                    populateUnselectMap(rightselectedVar, internalUserNameIdListMap );
                }
            }
        }
        rightvalues.clear();
        for(String removedUIdNameMapVar:removedUIdNameMap.keySet()){
            for(Id idVar:removedUIdNameMap.get(removedUIdNameMapVar)){
                rightvalues.add(removedUIdNameMapVar);
            }
        }
        return null;
    }
    /*  R6 : ReqNumber -- 5382 Added by Amala --  STARTS
     *  @description: This method will share the record for the Selected User.
     *  @Params: null
     *  @return: void
    **/
    public PageReference shareandSendMail() {
        List<User> shareUserList = new List<User>();
        List<String> publicGroupIdList = new List<String>();
        List<JBP__Share> accPlanShareList = new List<JBP__Share>();
        shareUserList = [Select Id, name, email, IsPortalEnabled from user where isActive=True and Id in :finalUsers ];
        for(integer var=0;var<shareUserList.size(); var++){
            JBP__Share JBPPlanShare = new JBP__Share();
            JBPPlanShare.ParentId= pareentID;
            JBPPlanShare.UserOrGroupId = shareUserList[var].Id;
            if(selectedAction=='Read Only'){
                JBPPlanShare.AccessLevel='Read';
            }
            else{
                JBPPlanShare.AccessLevel='Edit';
            }
            accPlanShareList.add(JBPPlanShare);
        }
        if(accPlanShareList.size()>0){
        try{
            insert accPlanShareList;
        }catch(Exception e){
            System.debug('Exception:'+ e);
        }
        }if(shareUserList.size()>0){
            sendmail(shareUserList );
        }
        PageReference pageRef = new PageReference('/p/share/CustomObjectSharingDetail?parentId='+pareentID);
        pageRef.setRedirect(true);
        return pageRef;
    }
    /* ReqNumber -- 5382 Added by Amala --  STARTS
     *  @description: This method will send mail to the shared PortalUsers.
     *  @Params: null
     *  @return: void
    **/
    public void Sendmail(List<User> shareUserList){
        List<Messaging.SingleEmailMessage> mailList =new List<Messaging.SingleEmailMessage>();
        if(shareUserList.size()>0){   
            for(User stu: shareUserList){
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage() ; 
                mail.setTargetObjectId(stu.id);
                mail.saveAsActivity = false;
                mail.setTemplateId(emailTemplateId);
                mail.whatId=pareentID;
                maillist.add(mail);
            }
        } 
        if(mailList.size()>0){
            Messaging.sendEmail( mailList );         
        }                                                                                  
    }  
    /* ReqNumber -- 5382 Added by Amala --  STARTS
     *  @description: Method to convert 15 Digit.
     *  @Params: null
     *  @return: void
    **/ 
    public Static List<String> convertTo15Digit(List<String> paramID){
        List<String> convertedAccIdList = new List<String>();
        for(String convert: paramID){
            if(convert.length()>15){
            convertedAccIdList.add(convert.substring(0,15));
            }
        }
    return convertedAccIdList;
    }                      
    /* ReqNumber -- 5382 Added by Amala --  STARTS
     *  @description: Cancel the page.
     *  @Params: null
     *  @return: Page
    **/        
    public PageReference cancel() {
       PageReference pageRef = new PageReference('/p/share/CustomObjectSharingDetail?parentId='+pareentID);
       pageRef.setRedirect(true);
       return pageRef;
    }
    /* ReqNumber -- 5382 Added by Amala --  STARTS
     *  @description: To search the String based on Enter action .
     *  @Params: null
     *  @return: void
    **/
    public void enterSearch(){
        findUser();
    }
}