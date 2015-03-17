/**********************************************************
* Class Name: UserAutomation 
* Author: HP
* Description: This is a class that performs creation of sales terrritory and provide share for opty for User Automation.
***********************************************************/
public with sharing class UserAutomation 
{
    public static void createTerritoryBasedOnAdminUser(List<Location_Partner_Users__c> contactLocationList)
    {
        //Getting all contact ids to fetch users
        Map<Location_Partner_Users__c,Id> userLoc = new Map<Location_Partner_Users__c,Id>();
        List<Id> contactIdTemp = new List<Id>();
        List<Id> locId = new List<id>();
        
        if(contactLocationList !=null && contactLocationList.size() >0)
        {
            for(Location_Partner_Users__c tempLocPart : contactLocationList)
            {
                contactIdTemp.add(tempLocPart.Contact__c);
            }
            try
            {               
                List<User> userPartner =[Select Name, Id, IsActive,ContactId, Territory_Partner_Admin_Role__c From User  where ContactId  IN :contactIdTemp];           
                for(Location_Partner_Users__c contactLocation:contactLocationList)
                {
                    boolean matchFound = false;
                    for(User usr : userPartner)
                    {
                        if(usr.ContactId == contactLocation.Contact__c)
                        {
                            if(usr.IsActive == true)
                            { 
                                if(contactLocation.Territory_Partner_Admin_Role__c != null && contactLocation.Territory_Partner_Admin_Role__c != '' )                                                               
                                {
                                    userLoc.put(contactLocation,usr.id);
                                    
                                }
                            }                           
                        }
                    }                               
                }  
                              
                if (userLoc != null && userLoc.size() > 0)
                {      
                    createTerritory(userLoc,true,false);
                }
            }
            catch(Exception e)
            {
                system.debug('Exception Occured while fetching user');
            }
        }       
    }
    public static boolean afterContactLocationDelete(List<Location_Partner_Users__c> deleteContactLocation, Boolean firstCall, Boolean secondCall, Boolean thirdCall , Boolean fourthCall)
    {
        List<GroupMember> tobeDeletedMember = new List<GroupMember>();
        List<Location__c> getLoc = new List<Location__c>();
        List<User> getUser  = new List<User>();            
        List<Sales_Territory_User_Assignment__c> getSalesTerrUser = new List<Sales_Territory_User_Assignment__c>();
        List<Sales_Territory_Location_Assignment__c> getSalesTerrLoc = new List<Sales_Territory_Location_Assignment__c>();
        List<Sales_Territory__c>  salesTerritoryList = new List<Sales_Territory__c>();
        List<Sales_Territory_User_Assignment__c> toBeDeletedAssignUsr = new List<Sales_Territory_User_Assignment__c>();
        List<Sales_Territory_Location_Assignment__c> toBeDeletedAssignLoc = new List<Sales_Territory_Location_Assignment__c>();
        List<OpportunityShare> tobeDeletedShares =new List<OpportunityShare>();
        List<Sales_Territory_User_Assignment__c> usrAssignedList = new List<Sales_Territory_User_Assignment__c>();            
        List<Sales_Territory_Location_Assignment__c> locAssignedList = new List<Sales_Territory_Location_Assignment__c>();  
        List<Channel_Partner__c> channelPartnerList = new List<Channel_Partner__c>();
        List<String> newTerrName =new List<String>();
        List<Id> contactIds=new List<Id>();
        List<Id> locIds = new List<Id>();       
        List<OpportunityShare> optyShareList = new List<OpportunityShare>();
        Map<Id,List<Location__c>> newLocMap = new Map<Id,List<Location__c>>();
        Map<Id,User> newUsrMap = new Map<Id,User>();        
        Map<String,Sales_Territory__c> newSTMap = new Map<String,Sales_Territory__c>();
        Map<Sales_Territory__c,List<Sales_Territory_User_Assignment__c>> newAssignUsrMap = new Map<Sales_Territory__c,List<Sales_Territory_User_Assignment__c>>();
        Map<Sales_Territory__c,Sales_Territory_Location_Assignment__c> locAssignMap = new Map<Sales_Territory__c,Sales_Territory_Location_Assignment__c>();
        Map<Location__c,List<Id>> channelPartnerMap = new Map<Location__c,List<Id>>();
        Map<Id,Sales_Territory__c> newLocSTMap = new Map<Id,Sales_Territory__c>();
        Map<Id,OpportunityShare> newOptyShareMap = new Map<Id,OpportunityShare>();
        Sales_Territory__c  salesTerritory = new Sales_Territory__c();
    
        Set<Id> userIdSet = new Set<Id>();
        List<Id> optyIdList2 = new List<Id>();
        Boolean optyProcessed = false;      
        User tempUser = new User();    
                
        If(deleteContactLocation != null && deleteContactLocation.size() > 0) 
        {         
            try
            {
                for(Location_Partner_Users__c tempLocPart : deleteContactLocation)
                {
                    contactIds.add(tempLocPart.Contact__c);
                    locIds.add(tempLocPart.Location__c);
                }               
                getUser = [Select Id,contactId From User  where ContactId IN :contactIds];
                getLoc = [select id,Name, Sell_Into_Market__c from Location__c where id in :locIds];            
                boolean isTerrNameProcessed = false;
                for(Location_Partner_Users__c contactLocation:deleteContactLocation)
                {
                    List<Location__c> tempLocList = new List<Location__c>();
                    for(Location__c tempLoc: getLoc)
                    {                   
                        if(!isTerrNameProcessed)
                        {
                            newTerrName.add('ST-'+tempLoc.Name+'_'+tempLoc.Sell_Into_Market__c);
                        }   
                        if(tempLoc.Id == contactLocation.Location__c)
                        {
                            tempLocList.add(tempLoc);
                        }                       
                    }
                    isTerrNameProcessed = true;
                    newLocMap.put(contactLocation.id,tempLocList);
                    for(User tempusr : getUser)
                    {
                        if(tempusr.ContactId == contactLocation.Contact__c)
                        {
                            newUsrMap.put(contactLocation.id,tempusr);
                        }                           
                    }           
                }           
                salesTerritoryList = [select Id,name, GroupID__c from Sales_Territory__c where Name  In :newTerrName];
                usrAssignedList = [Select Id,Sales_Territory__c ,User__c from Sales_Territory_User_Assignment__c  where Sales_Territory_User_Assignment__c.Sales_Territory__c IN :salesTerritoryList];
                locAssignedList = [Select Id,Sales_Territory__c,Location__c from Sales_Territory_Location_Assignment__c where Sales_Territory_Location_Assignment__c.Sales_Territory__c IN :salesTerritoryList];
                for(Sales_Territory__c tempSales:salesTerritoryList)
                {
                    List<Sales_Territory_User_Assignment__c> userIdList = new List<Sales_Territory_User_Assignment__c>(); 
                    for(String terrNametemp : newTerrName)
                    {
                        if(tempSales.Name == terrNametemp)
                        {
                            newSTMap.put(terrNametemp,tempSales);
                        }                       
                    }
                    for(Sales_Territory_User_Assignment__c tempAssignUser : usrAssignedList)
                    {
                        if(tempAssignUser.Sales_Territory__c == tempSales.Id)
                        {
                            userIdList.add(tempAssignUser);
                        }       
                    }
                    newAssignUsrMap.put(tempSales,userIdList);
                    for(Sales_Territory_Location_Assignment__c tempAssignLoc : locAssignedList)
                    {
                        if(tempAssignLoc.Sales_Territory__c == tempSales.Id)
                        {
                            locAssignMap.put(tempSales,tempAssignLoc);
                            newLocStMap.put(tempAssignLoc.Location__c,tempSales);
                        }
                        
                    }
                }
                channelPartnerList = [select id,opportunity__c,Location__c from Channel_Partner__c where Location__c IN :getLoc];
                List<Id> grpId =new List<Id>();
                for(Location__c tempgetLoc : getLoc)
                {
                    List<Id> optyIdList = new List<Id>();
                    for(Channel_Partner__c tempChannelPartner : channelPartnerList)
                    {
                        if(!optyProcessed)
                        {
                            optyIdList2.add(tempChannelPartner.Opportunity__c);
                        }
                        if(tempChannelPartner.Location__c == tempgetLoc.Id)
                        {
                            optyIdList.add(tempChannelPartner.Opportunity__c);
                        }                       
                    }
                    Sales_Territory__c stNewTemp = newLocStMap.get(tempgetLoc.id);  
                    grpId.add(stNewTemp.GroupId__c);                
                    optyProcessed = true;
                    channelPartnerMap.put(tempgetLoc,optyIdList);
                }               
                optyShareList = [select id, opportunityId from OpportunityShare where opportunityId in :optyIdList2 and UserorGroupId in :grpId];
                for(OpportunityShare optyShareTemp:optyShareList)
                {
                    newOptyShareMap.put(optyShareTemp.OpportunityId,optyShareTemp);
                }       
                System.debug('newOptyShareMap.....'+ newOptyShareMap);
                for(Location_Partner_Users__c contactLocation:deleteContactLocation)
                {    
                    tempUser = newUsrMap.get(contactLocation.id);                
                    List<Location__c> getTempLoc = newLocMap.get(contactLocation.id);
                    if(getTempLoc != null)
                    {  
                        for(Location__c newTempLoc : getTempLoc)
                        {                  
                            String terrName = 'ST-'+newTempLoc.Name+'_'+newTempLoc.Sell_Into_Market__c;                        
                            salesTerritory = newSTMap.get(terrName);                        
                            if(salesTerritory != null)
                            {
                                List<Sales_Territory_User_Assignment__c> getAssignedUser = newAssignUsrMap.get(salesTerritory);
                                for(Sales_Territory_User_Assignment__c tempVar : getAssignedUser)
                                {
                                    if(tempVar.User__c == tempUser.Id)
                                    {
                                        toBeDeletedAssignUsr.add(tempVar);
                                    }
                                }
                                if(!((getAssignedUser.size() - toBeDeletedAssignUsr.size()) >= 1))
                                {
                                    Sales_Territory_Location_Assignment__c loc = locAssignMap.get(salesTerritory);
                                    toBeDeletedAssignLoc.add(loc);                              
                                    List<Id> optyShareDelete = channelPartnerMap.get(newTempLoc);                                                           
                                    for(Id tempOppId : optyShareDelete)
                                    {
                                        OpportunityShare tempShare = newOptyShareMap.get(tempOppId);
                                        if(tempShare!=null)
                                        {
                                            tobeDeletedShares.add(tempShare);
                                        }   
                                    }                               
                                }
                            }
                        }                        
                    }
                }
                if(firstCall)
                { 
                    Id groupId = salesTerritory.GroupID__c;
                    List<GroupMember> grpMem = [select id,GroupId,UserorgroupId from GroupMember where GroupId = :groupId] ;                        
                    Group grp = [select id from Group where id = :groupId];
                    for(GroupMember tempgrpMem : grpMem)
                    {
                        if(tempUser.Id == tempgrpMem.UserorgroupId)
                        {
                            tobeDeletedMember.add(tempgrpMem);
                        }
                    }
                    delete tobeDeletedMember;  
                    return true;                                
                }
                else if(secondCall)
                { 
                    if(toBeDeletedAssignUsr != null && toBeDeletedAssignUsr.size()>0)
                    {                                   
                        delete(toBeDeletedAssignUsr);                                   
                    }
                    return true;                
                }
                else if(thirdCall)
                {
                    if(toBeDeletedAssignLoc != null && toBeDeletedAssignLoc.size()>0)
                    {
                        delete(toBeDeletedAssignLoc);
                    }
                    return true;                                                                                   
                }    
                else if(fourthCall)
                {
                    if(tobeDeletedShares != null && tobeDeletedShares.size()>0)
                    {
                        delete(tobeDeletedShares);                  
                    }
                    return true; 
                }            
                if(toBeDeletedAssignUsr != null && toBeDeletedAssignUsr.size()>0)
                {                                   
                    delete(toBeDeletedAssignUsr);                                   
                }
                if(toBeDeletedAssignLoc != null && toBeDeletedAssignLoc.size()>0)
                {
                    delete(toBeDeletedAssignLoc);
                }
                if(tobeDeletedShares != null && tobeDeletedShares.size()>0)
                {
                    delete(tobeDeletedShares);                  
                }
            }
            catch(Exception e)
            {
                system.debug('Exception Occured while deleting from SalesTerritory UserAssignment');
            }                   
        } 
        return true; 
    }
    
    @future
    public static void afterUpdateDeleteLocPartUser(List<Id> newUserList,Boolean firstCall,Boolean secondCall,Boolean thirdCall,Boolean fourthCall) 
    {   
        if (newUserList != null && newUserList.size() > 0 ) 
        {           
            try
            {
                List<Sales_Territory_User_Assignment__c> getSalesTerrUser = new List<Sales_Territory_User_Assignment__c>();
                List<Sales_Territory_Location_Assignment__c> getSalesTerrLoc = new List<Sales_Territory_Location_Assignment__c>();
                List<Location_Partner_Users__c> conLoc = new List<Location_Partner_Users__c>();
                Sales_Territory__c  salesTerritory = new Sales_Territory__c();
                Location__c getLoc = new Location__c();
                List<Id> locIds = new List<Id>();                
                Set<Id> userIdSet = new Set<Id>();
                User user = new User();
                               
                List<Id> conId = new List<Id>();
                List<Location_Partner_Users__c> locPartList = new List<Location_Partner_Users__c>();
                Map<ID,User> newUsrMap = new Map<Id,User>([select id,contactId,IsActive from User where id in :newUserList]);
                Map<Id,List<Location_Partner_Users__c>> newLocPartUsrMap = new Map<Id,List<Location_Partner_Users__c>>();
                
                for(User tempUsr : newUsrMap.values())
                {
                    conId.add(tempUsr.contactId);
                }
                
                locPartList = [select id, Location__c,Contact__c,Territory_Partner_Admin_Role__c from Location_Partner_Users__c where Contact__c  in :conId];
                
                for(Id tempConId : conId)
                {
                    List<Location_Partner_Users__c> tempLocPartList = new List<Location_Partner_Users__c>();
                    for(Location_Partner_Users__c locId : locPartList)
                    {
                        if(locId.Contact__c == tempConId)
                        {
                            tempLocPartList.add(locId);
                        }
                    }
                    newLocPartUsrMap.put(tempConId,tempLocPartList);
                }       
                for (Id usrId : newUserList) 
                {
                    
                    user = newUsrMap.get(usrId);
                    conLoc = newLocPartUsrMap.get(user.contactId);
                    if(user.IsActive == true)
                    { 
                        if(firstCall || secondCall)
                        {
                            Id contactId = user.ContactId;
                            Map<Location_Partner_Users__c,Id> procLoc = new Map<Location_Partner_Users__c,Id>();                          
                            for(Location_Partner_Users__c locPart : conLoc)
                            {
                                procLoc.put(locPart,user.Id);
                            }
                            createTerritory(procLoc,firstCall,secondCall);
                        }
                    }                    
                    else if(user.IsActive != true)
                    {                       
                        afterContactLocationDelete(conLoc,firstCall,secondCall,thirdCall,fourthCall);                                      
                    }
                }  
            }
            catch(Exception e)
            {
                system.debug('Exception Occured while deleting Users from territory');
            }          
        }   
    }
    
    public static void createTerritory(Map<Location_Partner_Users__c,Id> locList,boolean firstCall, boolean secondCall)
    {
        try
        {
            String terrName;            
            Id partUser;
            Location__c loc = new Location__c();            
            Id usrId;  
            Map<Id,Id> newUsrLocListMap = new Map<Id,Id>(); 
            Map<Id,Location_Partner_Users__c> newLocationPartnerMap = new Map<Id,Location_Partner_Users__c>(); 
            Sales_Territory_Location_Assignment__c terrLoc = new Sales_Territory_Location_Assignment__c();  
            Sales_Territory_User_Assignment__c tempUsrAssign = new Sales_Territory_User_Assignment__c();
            Sales_Territory__c salesTerritory = new Sales_Territory__c();           
            List<OpportunityShare> optyShareList = new List<OpportunityShare>();
            List<Sales_Territory_User_Assignment__c> terrUser = new List<Sales_Territory_User_Assignment__c>();
            List<Sales_Territory_User_Assignment__c> updUsrList = new List<Sales_Territory_User_Assignment__c>();
            List<String> newTerrNameList = new List<String>(); 
            List<Sales_Territory_Location_Assignment__c> locAssign = new List<Sales_Territory_Location_Assignment__c>();
            List<Sales_Territory_Location_Assignment__c>  tempNewTerrLocListMap= new List<Sales_Territory_Location_Assignment__c>();
            List<Sales_Territory__c>  salesTerritoryList = new List<Sales_Territory__c>();   
            List<Sales_Territory_User_Assignment__c> newSalesTerrUsrAssignList = new  List<Sales_Territory_User_Assignment__c>();
            List<Channel_Partner__c> OptyList = new List<Channel_Partner__c>();
            List<Channel_Partner__c> tempOptyList = new List<Channel_Partner__c>();
            List<Id> optyId = new List<ID>();
            List<Sales_Territory__c> tempSTListMap = new List<Sales_Territory__c>();
            Map<String,Sales_Territory__c> newSTTerrMap = new Map<String,Sales_Territory__c>(); 
            Map<String,List<Sales_Territory_User_Assignment__c>> newUsrAssignMap = new Map<String,List<Sales_Territory_User_Assignment__c>>();                  
            Map<Id,Sales_Territory_Location_Assignment__c> newTerrLocMap = new Map<Id,Sales_Territory_Location_Assignment__c>();
            Map<Channel_Partner__c,Opportunity> optyAllocationMap = new Map<Channel_Partner__c,Opportunity>();
            Map<String,List<Channel_Partner__c>> optyMap = new Map<String,List<Channel_Partner__c>>();          
            Map<Id, List<Id>> userOptyIdList = new Map<Id, List<Id>>();
            Map<Id,List<OpportunityTeamMember>> optyMemMap = new Map<Id,List<OpportunityTeamMember>>();
            List<Id> newTempLocId = new List<Id>();
            for(Location_Partner_Users__c tempLocPart : loclist.keyset())
            {
                newTempLocId.add(tempLocPart.Location__c);
                newUsrLocListMap.put(tempLocPart.Location__c,loclist.get(tempLocPart));
                newLocationPartnerMap.put(tempLocPart.Location__c,tempLocPart);
            }
            Map<Id,Location__c> newLocMap = new Map<Id,Location__c>([select id,Name, Sell_Into_Market__c from Location__c where id  in :newTempLocId]);
            Map<Id,User> usrMap = new Map<Id,User>([select id,contactId,IsActive,Territory_Partner_Admin_Role__c from User where id in :locList.values()]);         
            Map<id,List<id>> tempLocOpptyMap=new Map<id,List<id>>();
            Map<id,List<id>> locOpptyMap=new Map<id,List<id>>();
            List<id> optyIdList = null;
            optyList = [Select Id, Opportunity__c,Location__c From Channel_Partner__c where Location__c  in :newTempLocId];
            
            for(Id locId : newTempLocId)
            {
                loc = newLocMap.get(locId);
                String tempTerrName = 'ST-'+loc.Name+'_'+loc.Sell_Into_Market__c;
                newTerrNameList.add(tempTerrName);
                boolean isProcessed = false;
                List<Channel_Partner__c> tempOptyAssignList = new List<Channel_Partner__c>();
                optyIdList = new List<Id>();
                for(Channel_Partner__c tempOpty : optyList)
                {                     
                    if(!isProcessed)
                    {
                        optyIdList.add(tempOpty.opportunity__c);
                        optyId.add(tempOpty.opportunity__c);
                    }  
                }
                tempLocOpptyMap.put(locId,optyIdList);
            }   
            tempNewTerrLocListMap = [select id,Sales_Territory__c from Sales_Territory_Location_Assignment__c where Sales_Territory_Location_Assignment__c.Sales_Territory__r.name in :newTerrNameList];

            for(Sales_Territory_Location_Assignment__c saleLocAssign : tempNewTerrLocListMap)
            {
                newTerrLocMap.put(saleLocAssign.Sales_Territory__c,saleLocAssign);
            }       
              
           
            tempSTListMap = [select id,Name, GroupId__c from Sales_Territory__c where Name IN :newTerrNameList];
            for(Sales_Territory__c sTerr : tempSTListMap)
            {
                newSTTerrMap.put(sTerr.Name,sTerr);
            }            
            
            newSalesTerrUsrAssignList = [select id,User__c,Sales_Territory__c from Sales_Territory_User_Assignment__c where Sales_Territory_User_Assignment__c.Sales_Territory__r.Name in :newTerrNameList];
            
            //UA:R5:Raghvendra:04/06/2013:start
            Date todaysDt = Date.today();
            List<Opportunity> finalOptyList =  new List<Opportunity>();
            //TM:CR-7525:Raghvendra:Start
            System.debug('opty Id List ... '+optyId);
            List<Opportunity> isrOptyList = [Select Id from Opportunity where owner__r.IsPortalEnabled = false and CloseDate >: todaysDt and Id in : optyId and Account.Confidential_Account__c = false and Confidential__c = false and Id in (Select OpportunityId from OpportunityTeamMember where user.IsPortalEnabled = true and OpportunityId in : optyId)];
            List<Opportunity> ptnrOptyList = [Select Id from Opportunity where owner__r.IsPortalEnabled = true and Id in : optyId and CloseDate >: todaysDt and Account.Confidential_Account__c = false and Confidential__c = false];
            //TM:CR-7525:Raghvendra:End
            if(isrOptyList != null && isrOptyList.size()>0){
                finalOptyList = isrOptyList;
            }
            if(ptnrOptyList != null && ptnrOptyList.size()>0){
                for(Opportunity ptnrOpty: ptnrOptyList)
                {
                    finalOptyList.add(ptnrOpty);
                } 
            }   
            Set<id> finalOptyIdList=new Set<id>();
            if(finalOptyList != null && finalOptyList.size()>0){
                for(Opportunity finalOpty:finalOptyList){
                finalOptyIdList.add(finalOpty.id);
                }
            }               
            for(id locid:tempLocOpptyMap.keySet()){
                optyIdList = new List<Id>();
                for(Id opptyId : tempLocOpptyMap.get(locid)){
                    if(finalOptyIdList.contains(opptyId)){
                        optyIdList.add(opptyId);
                        
                    }
                }
                locOpptyMap.put(locid,optyIdList);
            }
        
            for(Sales_Territory__c tempSalesTerr : newSTTerrMap.values())
            {
                List<Sales_Territory_User_Assignment__c> salesTerrAssign = new List<Sales_Territory_User_Assignment__c>();
                for(Sales_Territory_User_Assignment__c tempSalesUsr : newSalesTerrUsrAssignList)
                {
                    if(tempSalesTerr.id == tempSalesUsr.Sales_Territory__c)
                    {
                        salesTerrAssign.add(tempSalesUsr);                      
                    }
                }
                newUsrAssignMap.put(tempSalesTerr.Name,salesTerrAssign);
            }
            boolean newTerr = false; 
            List<String> tempTerrNameList = new List<String>();   
            if(firstCall)
            {                   
                for(Id locId : newTempLocId)
                {   
                    loc = newLocMap.get(locId);
                    terrName = 'ST-'+loc.Name+'_'+loc.Sell_Into_Market__c;               
                    usrId = newUsrLocListMap.get(locId);               
                    salesTerritory = newSTTerrMap.get(terrName);  
                    if(salesTerritory == null || Sales_Territory__c.id==null)
                    {
                        newTerr =true;
                        salesTerritory = new Sales_Territory__c(Name = terrName);
                        salesTerritory.MyComp_Sales_Territory_Name__c=terrName;
                        salesTerritory.Account_Access__c='Edit';
                        salesTerritory.Opportunity_Access__c='Read';
                        salesTerritory.Case_Access__c='Read';
                        salesTerritory.IsPartner__c=true;
                        salesTerritory.IsActive__c=true;
                        salesTerritory.isExternal__c=true;
                        salesTerritory.Notes__c='Location Territory';  
                        salesTerritoryList.add(salesTerritory);
                        tempTerrNameList.add(terrName);                                                                                    
                    }                      
                }
                system.debug('salesTerritoryList1***** '+salesTerritoryList);
                system.debug('tempTerrNameList***** '+tempTerrNameList);
                if(newTerr)
                {
                    insert salesTerritoryList;
                    system.debug('salesTerritoryList***** '+salesTerritoryList);
                    salesTerritoryList = [select id,Name, GroupId__c from Sales_Territory__c where Name IN :tempTerrNameList];
                
                     for(Sales_Territory__c salesTerr : salesTerritoryList)
                     {
                        newSTTerrMap.put(salesTerr.Name, salesTerr );
                     }
                }
                List<Sales_Territory_User_Assignment__c> newTerrUserList = new List<Sales_Territory_User_Assignment__c>();
                for(Id locId : newTempLocId)
                {
                    loc = newLocMap.get(locId);
                    terrName = 'ST-'+loc.Name+'_'+loc.Sell_Into_Market__c;               
                    usrId = newUsrLocListMap.get(locId);               
                    salesTerritory = newSTTerrMap.get(terrName); 
                                             
                    terrUser = newUsrAssignMap.get(terrName);                  
                    Location_Partner_Users__c locPartUser = new Location_Partner_Users__c();
                    locPartUser = newLocationPartnerMap.get(locId);
                    partUser = locList.get(locPartUser);
                    boolean usrFound = false; 
                    if(terrUser != null && terrUser.size() > 0 )
                    {
                        for(Sales_Territory_User_Assignment__c tempUsr : terrUser)
                        {
                            if(partUser == tempUsr.User__c )
                            {
                                tempUsr.Account_Team_Role__c = locPartUser.Territory_Partner_Admin_Role__c; 
                                updUsrList.add(tempUsr);    
                                usrfound = true;                        
                            }
                        }
                    }                                      
                    if(!(usrFound) || terrUser == null || terrUser.size() == 0 )
                    {                   
                        tempUsrAssign.Sales_Territory__c = salesTerritory.id;
                        tempUsrAssign.User__c= usrId ;
                        tempUsrAssign.Account_Team_Role__c = locPartUser.Territory_Partner_Admin_Role__c;           
                        newTerrUserList.add(tempUsrAssign);                      
                    }
                }
                if(updUsrList !=null && updUsrList.size()>0)
                {
                    upsert updUsrList;
                }
                
                if(newTerrUserList !=null && newTerrUserList.size()>0)
                {
                    insert newTerrUserList;
                }
                for(Id locId : newTempLocId)
                {
                    loc = newLocMap.get(locId);
                    terrName = 'ST-'+loc.Name+'_'+loc.Sell_Into_Market__c;               
                    usrId = newUsrLocListMap.get(locId);               
                    salesTerritory = newSTTerrMap.get(terrName);                           
                    terrUser = newUsrAssignMap.get(terrName);
                        
                    terrLoc= newTerrLocMap.get(salesTerritory.id);       
                    if(terrLoc == null)
                    {
                        terrLoc = new Sales_Territory_Location_Assignment__c();
                        terrLoc.Sales_Territory__c = salesTerritory.id;
                        terrLoc.Location__c= locId ;       
                        locAssign.add(terrLoc);                       
                    }
                }
                upsert locAssign; 
                for(Id locId : newTempLocId)
                {
                    loc = newLocMap.get(locId);
                    terrName = 'ST-'+loc.Name+'_'+loc.Sell_Into_Market__c;               
                    usrId = newUsrLocListMap.get(locId);               
                    salesTerritory = newSTTerrMap.get(terrName); 
                    for(id opttyid : locOpptyMap.get(locId)){
                        OpportunityShare optyShare = new OpportunityShare ();
                        optyShare.OpportunityId = opttyid; 
                        optyShare.UserOrGroupId = salesTerritory.GroupID__c;
                        optyShare.OpportunityAccessLevel = 'Read';
                        optyShareList.add(optyShare);
                    }                       
                }               
                if(optyShareList != null && !optyShareList.isEmpty())
                {
                    insert optyShareList;
                }
            //UA:R5:Raghvendra:04/06/2013:End           
            }
            if(secondCall)
            {
                List<GroupMember> tempGroupMember = new List<GroupMember>();
                    
                for(Id locId : newTempLocId)
                {               
                    loc = newLocMap.get(locId);
                    terrName = 'ST-'+loc.Name+'_'+loc.Sell_Into_Market__c;               
                    usrId = newUsrLocListMap.get(locId);               
                    salesTerritory = newSTTerrMap.get(terrName);
                    User tempUsr = usrMap.get(usrId);
                    
                    GroupMember grpMem = new GroupMember();
                    
                    grpMem.GroupId = salesTerritory.GroupID__c;
                    grpMem.UserOrGroupId = tempUsr.id;
                    
                    tempGroupMember.add(grpMem);                    
                }
                if(tempGroupMember != null)
                {
                    insert tempGroupMember;
                }                 
            }           
        }  
        catch(Exception e)
        {
            system.debug(e);
        } 
    }                    
}