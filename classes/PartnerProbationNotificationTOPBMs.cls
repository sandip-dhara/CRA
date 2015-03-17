global class PartnerProbationNotificationTOPBMs implements Database.Batchable<sObject> {
    public String query;
    public String email;
    Id toUserId;
    Id fromUserId;

    global Database.querylocator start(Database.BatchableContext BC){
                return Database.getQueryLocator(query);}
                
    global void execute(Database.BatchableContext BC, List<sObject> scope){
        Map<id,Lead> leadMap=new Map<id,Lead>();        
        Map<id,Location__c> locNewMap=new Map<id,Location__c>();
        Map<Id,List<Sales_Territory_User_Assignment__c>> accWithTerritoryGroupsUsersMap = new Map<id,List<Sales_Territory_User_Assignment__c>>();
        Map<Id,List<Sales_Territory_User_Assignment__c>> accWithTerritoryGrpUsrLeadAdminMap = new Map<id,List<Sales_Territory_User_Assignment__c>>();
        List<Lead> leadslist=new List<Lead>();//pend
        List<Location__c> LocationToUpdate=new List<Location__c>();
        Map<id,User> leadIDUserMap=new Map<id,User>();       
        Map<id,User> partnerSuperUserMap=new Map<id,User>();
        Map<id,id> LeadOwnerId=new Map<id,id>();
        Map<ID,ID> leadIDwithAccIdMap=new Map<ID,ID>();
        Map<ID,List<User>> locIDwithUserMap=new Map<ID,List<User>>();
        List<Lead> leadRecList=new List<Lead>();
        List<Location__c> partnerLocationList=new List<Location__c>();
        Set<String> PrmSuperAccounts=new Set<String>();
        for(sObject s : scope){
            Lead a = (Lead)s;
            String ownerid=a.ownerid;
            user u;
            if(ownerid.substring(0,3)!= '00G'){
                leadRecList.add(a);                
                leadMap.put(a.id,a);
                leadOwnerId.put(a.id,a.ownerID);
            }
            
        }
        System.debug('LeadOwners' + leadOwnerId.keyset());
        //for(User us :[select id,name,Partner_account_ID__c,Strike_Count__c,isPRMSuperUser,email from user where id in : leadOwnerId.values()]){
        
        //PRM:Suchitra R5:Req:6219:Start
        
        for(User us :[select id,name,Location_Record_Id__c,Strike_Count__c,isPRMSuperUser,email from user where id in : leadOwnerId.values()]){

            if(us.Location_Record_Id__c!=null){
                if (locIDwithUserMap.containsKey(us.Location_Record_Id__c)) {
                    List<User> usersList = new List<User>();
                    usersList = locIDwithUserMap.get(us.Location_Record_Id__c);
                    usersList.add(us);
                    locIDwithUserMap.put(us.Location_Record_Id__c,usersList);   
                }else {
                    List<User> usersList = new List<User>();
                    usersList.add(us);
                    locIDwithUserMap.put(us.Location_Record_Id__c,usersList);
                }
                
            }
            
        }
        
        partnerLocationList=[select id,name,HP_Lead_Status__c, Account__c from Location__c Where id in : locIDwithUserMap.keySet()];
        System.debug('locationId'+ locIDwithUserMap.keySet());
        for(Location__c loc: partnerLocationList){
            List<User> leadOWnersList=new List<User>();
            leadOWnersList=locIDwithUserMap.get(loc.id);
            Decimal strikecount=0;
            for(User leadOWnersListVar :leadOWnersList){
                system.debug('account name '+loc.name+' and user name '+ leadOWnersListVar.name);
                if(leadOWnersListVar.Strike_Count__c!= Null)
                strikeCount +=leadOWnersListVar.Strike_Count__c;
            }
            
            /*
            *@description :Renamed HP Lead Status field value from 'Probation' to 'Non compliant'                
            */               

            if(strikeCount >2){//if strikeCount >2 means the partner should be in Non compliant staus
                //PRM:Suchitra R4:Req:4046:Start               
                if(loc.HP_Lead_Status__c!='Non compliant' && loc.HP_Lead_Status__c!='Inactive'){
                    loc.HP_Lead_Status__c='Non compliant';                   
                 //PRM:Suchitra R4:Req:4046:End
                    locNewMap.put(loc.id,loc);
                    LocationToUpdate.add(loc);// this accounts are in Non compliant
          //PRM:Suchitra R5:Req:6219:End 
                }
        
            }

        }
      
        if(LocationToUpdate.size()>0){
            try{
                //update LocationToUpdate;
                Database.SaveResult[] results = Database.update(LocationToUpdate);
                if (results != null){
                    for (Database.SaveResult result : results) {
                        if (!result.isSuccess()) {
                            system.debug(' saveresult : not able to update');
                            Database.Error[] errs = result.getErrors();
                            for(Database.Error err : errs)
                            System.debug(err.getStatusCode() + ' - ' + err.getMessage());

                        }else{  system.debug('in the save result else block :'+result.isSuccess()); }
                    }
                }
                system.debug('PArtner Got Updated');
               }catch(Exception e){ system.debug('not able to save partner');}
            
        }
        
        if(locNewMap.size()>0){
        
            accWithTerritoryGroupsUsersMap = getUsersForLocation(locNewMap,false);
            accWithTerritoryGrpUsrLeadAdminMap = getUsersForLocation(locNewMap,true);
            
        }
            
        if(accWithTerritoryGroupsUsersMap == null || accWithTerritoryGroupsUsersMap.isEmpty()){
                
            return;
        }
                
        List<Messaging.SingleEmailMessage> mailList =new List<Messaging.SingleEmailMessage>();
        EmailTemplate etLeadAdmin = [SELECT id FROM EmailTemplate WHERE developerName = 'Notify_Lead_admin_of_Non_compliance'];
        EmailTemplate etPBMUSer = [SELECT id FROM EmailTemplate WHERE developerName = 'Notify_PBM_of_Non_compliance'];
       
        For(Id accIDG: accWithTerritoryGroupsUsersMap.keySet()){
            List<Sales_Territory_User_Assignment__c> STUsersList=new List<Sales_Territory_User_Assignment__c>();
            if(accWithTerritoryGroupsUsersMap.containsKey(accIDG) && locNewMap.containsKey(accIDG)){
                STUsersList=accWithTerritoryGroupsUsersMap.get(accIDG);
                Location__c acc=locNewMap.get(accIDG);
                 if(STUsersList.size()>0){   
                    for(Sales_Territory_User_Assignment__c stuG: STUsersList){
                        system.debug('a1a'+accIDG+'b11b'+stuG);
                        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage() ; 
                        mail.setTargetObjectId(stuG.User__r.id);
                        mail.setWhatId(acc.Id);
                        mail.saveAsActivity = false;
                        mail.setTemplateId(etPBMUSer.id);
                        maillist.add(mail);
                    }
                }
            }
        }

        For(Id accIDL: accWithTerritoryGrpUsrLeadAdminMap.keySet()){
            List<Sales_Territory_User_Assignment__c> STUsersListLead=new List<Sales_Territory_User_Assignment__c>();
            if(accWithTerritoryGrpUsrLeadAdminMap.containsKey(accIDL) && locNewMap.containsKey(accIDL)){
                STUsersListLead=accWithTerritoryGrpUsrLeadAdminMap.get(accIDL);
                Location__c acc=locNewMap.get(accIDL);
                if(STUsersListLead.size()>0){   
                    for(Sales_Territory_User_Assignment__c stuL: STUsersListLead){
                        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage() ; 
                        mail.setTargetObjectId(stuL.User__r.id);
                        mail.setWhatId(acc.Id);
                        mail.saveAsActivity = false;
                        mail.setTemplateId(etLeadAdmin.id);
                        maillist.add(mail);
                    }
                }               
            }
        }           
        if(mailList.size()>0){
            Messaging.sendEmail( mailList );              
        }
    }
    
    global void finish(Database.BatchableContext BC){

    }
    
    /**
     * @description - To get the list of partner location users associated to both external and non external territory to send email notification
     *                when the location is put on "Non Compliant"
     * 
     */
   
   public Map<Id,List<Sales_Territory_User_Assignment__c>> getUsersForLocation(Map<id,Location__c> loctNewMap,boolean pbms){
        Set<Id> partnerLocIds = new Set<Id>();
        Set<Id> terrIdsOfLead = new Set<Id>();      
        Map<Id,Sales_Territory_Location_Assignment__c> locWithTerritory;
        Map<Id,Sales_Territory_Account_Assignment__c> accWithTerritory;
        Map<Id,List<Sales_Territory_User_Assignment__c>> partnerTerritoriesUserAssignment;
        Map<Id,List<Id>> leadWithTrritories = new Map<id,List<Id>>();
        Map<Id,List<Sales_Territory_User_Assignment__c>> locWithTerritoryUsers = new Map<id,List<Sales_Territory_User_Assignment__c>>();
        Set<Id> grpIds = new Set<Id>();
        Boolean isBR = False;
        List<Id> brList = new List<Id>();
        
        for(Location__c newAcpRec : loctNewMap.values()){
            if(newAcpRec.id != null && String.valueOf(newAcpRec.id) != ''){
                partnerLocIds.add(newAcpRec.id);
                brList.add(newAcpRec.Account__c);
            }
        }
                
        if(pbms == false){
            locWithTerritory = new Map<Id,Sales_Territory_Location_Assignment__c>([Select Id, Location__c, Sales_Territory__c from Sales_Territory_Location_Assignment__c where Location__c in : partnerLocIds and Sales_Territory__r.isExternal__c=false]);
            system.debug('q0q'+locWithTerritory);
            if(locWithTerritory == null || locWithTerritory.isEmpty()){
                isBR = True;
                accWithTerritory = new Map<Id, Sales_Territory_Account_Assignment__c>([Select Id, Account__c, Sales_Territory__c from Sales_Territory_Account_Assignment__c where Account__c in : brList]);
                system.debug('q1q'+accWithTerritory);
                if(accWithTerritory == null || accWithTerritory.isEmpty()){
                    return null;
                }
            }
        }else{
            locWithTerritory = new Map<Id,Sales_Territory_Location_Assignment__c>([Select Id, Location__c, Sales_Territory__c from Sales_Territory_Location_Assignment__c where Location__c in : partnerLocIds and Sales_Territory__r.isExternal__c=true]);
            system.debug('q2q'+locWithTerritory);
            if(locWithTerritory == null || locWithTerritory.isEmpty()){
                return null;
            }           
        }
        if(isBR == True){
            for(Location__c newAcpRec : loctNewMap.values()){
                for(Sales_Territory_Account_Assignment__c accWithTerritoryRec : accWithTerritory.values()){
                    if((newAcpRec.Account__c == accWithTerritoryRec.Account__c) && (accWithTerritoryRec.Sales_Territory__c != null) 
                    && (String.valueOf(accWithTerritoryRec.Sales_Territory__c) != '')){
                        terrIdsOfLead.add(accWithTerritoryRec.Sales_Territory__c);
                        system.debug('q01q'+terrIdsOfLead);
                        if(LeadWithTrritories.containsKey(newAcpRec.id)){
                            List<ID> relTerrIds = leadWithTrritories.get(newAcpRec.id);
                            relTerrIds.add(accWithTerritoryRec.Sales_Territory__c);
                            leadWithTrritories.put(newAcpRec.id,relTerrIds);
                        }else{
                            leadWithTrritories.put(newAcpRec.id,new List<ID>{accWithTerritoryRec.Sales_Territory__c});
                        }
                    }
                }           
            }
        }else{
            for(Location__c newAcpRec : loctNewMap.values()){
                for(Sales_Territory_Location_Assignment__c locWithTerritoryRec : locWithTerritory.values()){
                    if((newAcpRec.id == locWithTerritoryRec.Location__c) && (locWithTerritoryRec.Sales_Territory__c != null) 
                    && (String.valueOf(locWithTerritoryRec.Sales_Territory__c) != '')){
                        terrIdsOfLead.add(locWithTerritoryRec.Sales_Territory__c);
                        system.debug('q02q'+terrIdsOfLead);
                        if(LeadWithTrritories.containsKey(newAcpRec.id)){
                            List<ID> relTerrIds = leadWithTrritories.get(newAcpRec.id);
                            relTerrIds.add(locWithTerritoryRec.Sales_Territory__c);
                            leadWithTrritories.put(newAcpRec.id,relTerrIds);
                        }else{
                            leadWithTrritories.put(newAcpRec.id,new List<ID>{locWithTerritoryRec.Sales_Territory__c});
                        }
                    }
                }           
            }
        }
        partnerTerritoriesUserAssignment = new Map<Id,List<Sales_Territory_User_Assignment__c>>();
        
        List<Sales_Territory_User_Assignment__c> tempSTUA;
        
        if(pbms == false){
             tempSTUA = [select Id, User__c,User__r.name, User__r.email ,User__r.id,user__r.Adoption_Role_Type__c,sales_Territory__c,Team_Role__c from Sales_Territory_User_Assignment__c where Sales_Territory__c in: terrIdsOfLead and user__r.Adoption_Role_Type__c='Partner Business Manager (IC)'];
        }else{
             tempSTUA = [select Id, User__c,User__r.name, User__r.email ,User__r.id,sales_Territory__c from Sales_Territory_User_Assignment__c where Sales_Territory__c in: terrIdsOfLead and Account_Team_Role__c='Leads Administrator'];
        }
        system.debug('q3q'+tempSTUA);
        if(tempSTUA !=null){
        for(Sales_Territory_User_Assignment__c tempSTUAVar:tempSTUA){
            if(!partnerTerritoriesUserAssignment.containsKey(tempSTUAVar.Id)){
                partnerTerritoriesUserAssignment.put(tempSTUAVar.Id, new List<Sales_Territory_User_Assignment__c>());
                partnerTerritoriesUserAssignment.get(tempSTUAVar.Id).add(tempSTUAVar);
            }else{
                partnerTerritoriesUserAssignment.get(tempSTUAVar.Id).add(tempSTUAVar);
            }
        }
        }else{
        return null;
        }
        
        if(partnerTerritoriesUserAssignment == null || partnerTerritoriesUserAssignment.isEmpty()){
            return null;
        }
        Map<ID,List<Sales_Territory_User_Assignment__c>> salesTerrUserMap=new Map<ID,List<Sales_Territory_User_Assignment__c>>();

        for(Id ptID: partnerTerritoriesUserAssignment.keyset()){
            for(Sales_Territory_User_Assignment__c stu:partnerTerritoriesUserAssignment.get(ptID)){
                if (salesTerrUserMap.containsKey(stu.Sales_Territory__c)) {
                    List<Sales_Territory_User_Assignment__c> usersList = new List<Sales_Territory_User_Assignment__c>();
                    usersList = salesTerrUserMap.get(stu.Sales_Territory__c);
                    usersList.add(stu);
                    salesTerrUserMap.put(stu.Sales_Territory__c,usersList);   
                }else {
                    List<Sales_Territory_User_Assignment__c> usersList = new List<Sales_Territory_User_Assignment__c>();
                    usersList.add(stu);
                    salesTerrUserMap.put(stu.Sales_Territory__c,usersList);
                }
            }
        }
        system.debug('q4q'+leadWithTrritories);
        system.debug('q5q'+salesTerrUserMap);
        for(Id accountId : leadWithTrritories.keySet()){
            List<Sales_Territory_User_Assignment__c> PBMSGroupListID=new List<Sales_Territory_User_Assignment__c>();           
            for(Id territoryId : leadWithTrritories.get(accountId)){
                if(salesTerrUserMap.containsKey(territoryId)){
                    for(Sales_Territory_User_Assignment__c sTerrUser:salesTerrUserMap.get(territoryId)){
                        PBMSGroupListID.add(sTerrUser);
                    }
                }
            }
            locWithTerritoryUsers.put(accountId,PBMSGroupListID);            
        }
        system.debug('q6q'+locWithTerritoryUsers);
        if(locWithTerritoryUsers != null || locWithTerritoryUsers.size()>0 ){
            return locWithTerritoryUsers;
        }else {
            return null;
        }   
    
    }
}