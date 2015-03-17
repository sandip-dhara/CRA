/**
 * Class Name: LocationUtil
 * Author: HP
 * Date: 12-March-2013 
 * Description: Contains all reusable methods belonging to Location object.
 */

public class LocationUtil{

    /**
     * @Description - To create location queues for portal enabled accounts.
     */
    public static void createQueueForPartnerAccs(Map<Id, Account> newAccountMap, Map<Id, Account> oldAccountMap){
        Set<Account> partnerEnabledAccountSet = new Set<Account>();
        List<id> accountIdList=new List<id>();
        Set<id> queueIdSet=new Set<id>();
        List<Group> partnerAccLocationQueuesList = new List<Group>();
        for(Id updatedAccID: newAccountMap.keyset()){
            if(oldAccountMap.get(updatedAccID).isPartner == false && newAccountMap.get(updatedAccID).isPartner == true ){
                partnerEnabledAccountSet.add(newAccountMap.get(updatedAccID));
                accountIdList.add(newAccountMap.get(updatedAccID).id);
            }
        }
        if(partnerEnabledAccountSet.size() == 0){
            return;
        }
        
        List<Location__c> partnerAccLocations=[select id, name,account__c from Location__c where account__c in : accountIdList];
              
        for(Account partnerEnabledAccount:partnerEnabledAccountSet){
            for(Location__c partAccLocation:partnerAccLocations){ 
                if(partAccLocation.account__c==partnerEnabledAccount.id){           
                    //Queue name should have maximum 4o characters. So, to generate it we are considering first 8 charachers as "Partner_" , next 25 characters from account and last 7 characters from location
                    Group locationQueueGroup = new Group();           
                    locationQueueGroup.type = 'Queue';
                    String accNameForQueCreation=null;    
                    Integer accNameLength = 34 - partAccLocation.Name.length();
                    if(partnerEnabledAccount.name.length()> accNameLength){
                        accNameForQueCreation=partnerEnabledAccount.name.substring(0,accNameLength);
                    }else{
                        accNameForQueCreation=partnerEnabledAccount.name;
                    }
          
                    locationQueueGroup.Name = 'PTNR_'+accNameForQueCreation+'_'+partAccLocation.Name;
                    locationQueueGroup.DeveloperName = 'Partner_Queue_'+partAccLocation.Id;
          
                    partnerAccLocationQueuesList.add(locationQueueGroup);
                }
            }
        }
        
        try{
            insert partnerAccLocationQueuesList;
        }catch(exception e){
            CreateApexErrorLog.insertHandledExceptions(e, null, 'Account', 'PartnerCollabAccountUtil', 'Class');
        }
        
        for(Group partnerAccLocationQueue:partnerAccLocationQueuesList){
            queueIdSet.add(partnerAccLocationQueue.id);
        }
        assignLocationQueToSObject(queueIdSet);
        
    }

    /**
     * @Description - To create location queues for only partner accounts.
     */

    public static void createPartnerAccQueueOnLocInsert(List<Location__c> newAccountLocationList){
        List<id> accountIdList=new List<id>();
        Map<Location__c,Account> partnerLocationAccMap=new Map<Location__c,Account>();
        List<Group> partnerAccLocationQueuesList =new List<Group>(); 
        Set<id> queueIdSet=new Set<id>();
        
        for(Location__c newAccountLocation:newAccountLocationList){
            accountIdList.add(newAccountLocation.account__c);
        }

        List<Account> accList=[select id, name, isPartner from account where id in : accountIdList];        
        for(Location__c newAccountLocation:newAccountLocationList){
            for(Account acc:accList){
                if((newAccountLocation.Account__c==acc.id)&&(acc.IsPartner)){
                    partnerLocationAccMap.put(newAccountLocation,acc);
                }
            }
        }
        
        for(Location__c partnerAccLocation:partnerLocationAccMap.keySet()){
            //Queue name should have maximum 4o characters. So, to generate it we are considering first 8 charachers as "Partner_" , next 25 characters from account and last 7 characters from location
            String accName=partnerLocationAccMap.get(partnerAccLocation).name;
            Group locationQueueGroup = new Group();           
            locationQueueGroup.type = 'Queue';
            String accNameForQueCreation=null;
            String locNameForQueCreation=null;            
            Integer accNameLength = 34 - partnerAccLocation.Name.length();
            if(accName.length()> accNameLength){
                        accNameForQueCreation=accName.substring(0,accNameLength);
                    }else{
                        accNameForQueCreation=accName;
                    }
            
            locationQueueGroup.Name = 'PTNR_'+accNameForQueCreation+'_'+partnerAccLocation.Name;
            locationQueueGroup.DeveloperName = 'Partner_Queue_'+partnerAccLocation.Id;
            partnerAccLocationQueuesList.add(locationQueueGroup);
        }

        
        try{
            insert partnerAccLocationQueuesList;
        }catch(exception e){
            CreateApexErrorLog.insertHandledExceptions(e, null, 'Account', 'PartnerCollabAccountUtil', 'Class');
        }
        
        for(Group partnerAccLocationQueue:partnerAccLocationQueuesList){
            queueIdSet.add(partnerAccLocationQueue.id);
        }
        assignLocationQueToSObject(queueIdSet);
    }

    /**
     * @Description - .
     */
    public static void deleteUserfromSalesTeam(List<Location_Partner_Users__c> triggerNewList, List<Location_Partner_Users__c> triggerOldList, List<String> locationList){
        
        List<Channel_Partner__c> cpList = new List<Channel_Partner__c>();
        List<Location_Partner_Users__c> alltriggerList = new List<Location_Partner_Users__c>();
        List<OpportunityTeamMember> opptyTeamMbrList = new List<OpportunityTeamMember>();
        List<OpportunityTeamMember> toDelOpptyTMbrList = new List<OpportunityTeamMember>();
        List<GroupMember> toDeleteGrpMbrList = new List<GroupMember>();
        List<Group> partnerLocQueueList = new List<Group>();
        List<Id> queueIDsList = new List<Id>();
        Set<Id> opptySet = new Set<Id>(); 
        List<GroupMember> grpMbrList = new List<GroupMember>();
        Map<Location_Partner_Users__c, Set<Id>> newlocpartOppMap = new Map<Location_Partner_Users__c, Set<Id>>();
        Map<Location_Partner_Users__c, Set<Id>> oldlocpartOppMap = new Map<Location_Partner_Users__c, Set<Id>>();
        Map<Id, Set<Id>> todeleteConOppMap = new Map<Id, Set<Id>>();
        
        alltriggerList.addall(triggerNewList);
        alltriggerList.addall(triggerOldList);
        
        system.debug('a1a'+alltriggerList);
        cpList = [select Id, Opportunity__c, Location__c from Channel_Partner__c where Location__c IN :locationList];

        system.debug('a1b'+cpList);
        for(Location_Partner_Users__c triggerNewListVar:triggerNewList){
            for(Channel_Partner__c cpListVar:cpList){
                if(triggerNewListVar.Location__c == cpListVar.Location__c){
                    system.debug('a1c');
                    if(newlocpartOppMap.containsKey(triggerNewListVar)){
                        newlocpartOppMap.get(triggerNewListVar).add(cpListVar.Opportunity__c);
                    }else{
                        newlocpartOppMap.put(triggerNewListVar, new Set<Id>());
                        newlocpartOppMap.get(triggerNewListVar).add(cpListVar.Opportunity__c);
                    }                   
                    opptySet.add(cpListVar.Opportunity__c);
                }
            }
        }       
        system.debug('a1d'+newlocpartOppMap);
        system.debug('a1e'+opptySet);
        
        for(Location_Partner_Users__c triggerOldListVar:triggerOldList){
            for(Channel_Partner__c cpListVar:cpList){
                if(triggerOldListVar.Location__c == cpListVar.Location__c){
                    system.debug('a1f');
                    if(oldlocpartOppMap.containsKey(triggerOldListVar)){
                        oldlocpartOppMap.get(triggerOldListVar).add(cpListVar.Opportunity__c);
                    }else{
                        oldlocpartOppMap.put(triggerOldListVar, new Set<Id>());
                        oldlocpartOppMap.get(triggerOldListVar).add(cpListVar.Opportunity__c);
                    }                   
                    opptySet.add(cpListVar.Opportunity__c);
                }
            }
        }
        system.debug('a1g'+oldlocpartOppMap);
        system.debug('a1h'+opptySet);
        
        partnerLocQueueList = [SELECT Id, Name, DeveloperName FROM Group WHERE DeveloperName LIKE 'Partner_Queue_%' AND Type = 'Queue'];
        
        for(Location_Partner_Users__c newlocpartOppMapVar:newlocpartOppMap.keySet()){
            for(Location_Partner_Users__c oldlocpartOppMapVar:oldlocpartOppMap.keySet()){
                if(newlocpartOppMapVar.Id == oldlocpartOppMapVar.Id){
                    Set<Id> todeleteOppSet = new Set<Id>();
                    Set<Id> tocompareOppSet = new Set<Id>();
                    todeleteOppSet.addall(oldlocpartOppMap.get(oldlocpartOppMapVar));
                    tocompareOppSet.addall(newlocpartOppMap.get(newlocpartOppMapVar));
                    system.debug('a1i'+todeleteOppSet);
                    system.debug('a1j'+tocompareOppSet);
                    todeleteOppSet.removeall(tocompareOppSet);
                    system.debug('a1k'+todeleteOppSet);
                    if(todeleteConOppMap.containsKey(newlocpartOppMapVar.Contact__c)){
                        todeleteConOppMap.get(newlocpartOppMapVar.Contact__c).addall(todeleteOppSet);
                    }else{
                        todeleteConOppMap.put(newlocpartOppMapVar.Contact__c, todeleteOppSet);
                    }
                    for(Group partnerLocQueue:partnerLocQueueList){
                        if(string.valueOf(partnerLocQueue.DeveloperName).contains(newlocpartOppMapVar.Location__c)) {
                            queueIDsList.add(partnerLocQueue.Id); 
                        }
                    }                   
                }
            }
        }
        
        opptyTeamMbrList = [select Id, User.ContactId, OpportunityId from OpportunityTeamMember where OpportunityId IN :opptySet];
        grpMbrList = [select Id,UserOrGroupId from GroupMember where GroupId IN :queueIDsList];
        system.debug('a1l'+opptyTeamMbrList);
        system.debug('a1m'+grpMbrList);
        
        for(OpportunityTeamMember opptyTeamMbrListVar:opptyTeamMbrList){
            if(todeleteConOppMap.containsKey(opptyTeamMbrListVar.User.ContactId)){ 
                if(todeleteConOppMap.get(opptyTeamMbrListVar.User.ContactId).contains(opptyTeamMbrListVar.OpportunityId)){
                    toDelOpptyTMbrList.add(opptyTeamMbrListVar);
                    for(GroupMember grpMbrListVar:grpMbrList){
                        if(grpMbrListVar.UserOrGroupId == opptyTeamMbrListVar.UserId){
                            toDeleteGrpMbrList.add(grpMbrListVar);
                        }
                    }
                }
            }
        }
        
        system.debug('a1n'+toDelOpptyTMbrList);
        system.debug('a1o'+toDeleteGrpMbrList);
        if(toDeleteGrpMbrList.size()>0)
        delete toDeleteGrpMbrList;
        if(toDelOpptyTMbrList.size()>0)
        delete toDelOpptyTMbrList;
    }

    /**
     * @description - To insert queueSobject records so that queue will be available to use for Lead & Strike count objects
     */
    @future
    public static void assignLocationQueToSObject(Set<id> queueIdSet){
        List<QueueSobject> queSObjList = new List<QueueSobject>();
        List<Group> partnerAccLocationQueuesList = [select name,id from Group where id in :queueIdSet];
        for(Group partnerAccLocationQueue: partnerAccLocationQueuesList){
            List<QueueSobject> newQobjs = new List<QueueSobject>{
                new QueueSobject(QueueId = partnerAccLocationQueue.ID, SobjectType = 'Lead'),
                new QueueSobject(QueueId = partnerAccLocationQueue.ID, SobjectType = 'Strike_Count_Track__c')};         
                queSObjList.add(newQobjs[0]);
                queSObjList.add(newQobjs[1]);
        }
        
        try{
            insert queSObjList;
        }catch(exception e){ 
            CreateApexErrorLog.insertHandledExceptions(e, null, 'Account', 'PartnerCollabAccountUtil', 'Class');
        }
    }
    
    /**
     * @description - insert User in PartnerLocation Queue
     * @param - contactLocationList - contact and Location  List
     */
    public static void insertUserInPartnerLocQueue(List<Location_Partner_Users__c> contactLocationList){
        //Getting all contact ids to fetch users
        Set<id> contactIds=new Set<id>();
        Set<id> contactLocationIds=new Set<id>();
        Map<id,id> contactUserMap=new Map<id,id>();
        
        for(Location_Partner_Users__c contactLocation:contactLocationList){
            contactIds.add(contactLocation.Contact__c);
            contactLocationIds.add(contactLocation.id);
        }
        List<User> userList=[Select Name, Id, ContactId From User  where ContactId in :contactIds];
        
        for(User member:userList){
            contactUserMap.put(member.ContactId,member.Id);
        }  
        assignUsersToTheQueue(contactLocationIds,contactUserMap);
    }
    
    /**
     * @description - assign users to the Queue
     * 
     */
    @future
    public static void assignUsersToTheQueue(Set<id> contactLocationIds,Map<id,id> contactUserMap){
        List<Location_Partner_Users__c> contactLocationList=[Select id,Location__c,Contact__c from Location_Partner_Users__c where id in: contactLocationIds];
        Database.SaveResult[] queueMemberList;
        List<GroupMember> queueMemberListToBeInserted = new List<GroupMember>(); 
        List<Group> partnerLocQueueList = [SELECT Id, Name, DeveloperName FROM Group WHERE DeveloperName LIKE 'Partner_Queue_%' AND Type = 'Queue'];
        for(Location_Partner_Users__c contactLocation:contactLocationList){
            for(Group partnerLocQueue:partnerLocQueueList){
                if(string.valueOf(partnerLocQueue.DeveloperName).contains(contactLocation.Location__c)){
                    GroupMember grpMember = new GroupMember();
                    grpMember.GroupId = partnerLocQueue.Id;
                    grpMember.UserOrGroupId = contactUserMap.get(contactLocation.Contact__c); 
                    queueMemberListToBeInserted.add(grpMember);
                }
            }
        }
        
        try{
            queueMemberList = database.insert(queueMemberListToBeInserted, true);
        }
        catch(exception e){
            CreateApexErrorLog.insertHandledExceptions(e, queueMemberList, 'GroupMember', 'PartnerCollabUserUtil', 'Class');
        }  
    }
}