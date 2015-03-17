/*
* Name : SalesTerrUserAUtil
* Description : Utility class for call on insert, uodate, delete operation on Sales Territory User Assignment.
* Owner : Accenture
*
*/

public class SalesTerrUserAUtil {

    public static void userAssignmentAfterInsert(List<Sales_Territory_User_Assignment__c> triggerNew){
        
        //Future call to create Group Member (Future call used to avoid Mixed DML exception)
        Set<Id> stAssignIdSet = new Set<Id>();
        for(Sales_Territory_User_Assignment__c stUserAssign : triggerNew){
       
            if(stUserAssign.IsActive__c == true){
                stAssignIdSet.add(stUserAssign.Id); 
            }
        }
        CreateGroupMemberForTerrUser.createGroupMember(stAssignIdSet);
    }
    
    //To populate key for checking record duplication.

    public static void userAssignmentBeforeInsert(List<Sales_Territory_User_Assignment__c> triggerNew){
        
        for(Sales_Territory_User_Assignment__c stUserAssign : triggerNew){
                stUserAssign.SalesTUserKey__c = '' + stUserAssign.User__c + '-' + stUserAssign.Sales_Territory__c;
                stUserAssign.New_Or_Changed__c = true; 
        }
    }
    public static void userAssignmentDelete(List<Sales_Territory_User_Assignment__c> triggerOld){
        
        Set<Id> groupIdSet = new Set<Id>();
        Set<Id> userIdSet = new Set<Id>();
        Set<Id> stuaIdToDelGM = new Set<Id>();
        Set<String> stGrpUserSet = new Set<String>();              
        set<id> stSet= new Set<Id>();
                
        
        for(Sales_Territory_User_Assignment__c obj : triggerOld){
            
                stuaIdToDelGM.add(obj.Id);          
        }
        //Raghvendra : Partner variable :start
        Set<Id> partGroupIdSet = new Set<Id>();
        Set<Id> partUserIdSet = new Set<Id>();
        set<String> partUserNameSet= new Set<String>();
        //Raghvendra : Partner variable :End
        for(Sales_Territory_User_Assignment__c stUAObj : [Select Id,Sales_Territory__c, Sales_Territory__r.GroupId__c , User__c,User__r.Name,Sales_Territory__r.IsPartner__c from Sales_Territory_User_Assignment__c where Id in : stuaIdToDelGM]){

            groupIdSet.add(stUAObj.Sales_Territory__r.GroupId__c);
            userIdSet.add(stUAObj.User__c);            
            stGrpUserSet.add(stUAObj.Sales_Territory__r.GroupId__c + '' + stUAObj.User__c);  
            stSet.add(stUAObj.Sales_Territory__c);
            
            //Raghvendra : Partner territory check :start
            if(stUAObj.Sales_Territory__r.IsPartner__c==true){
                partGroupIdSet.add(stUAObj.Sales_Territory__r.GroupId__c);
                partUserIdSet.add(stUAObj.User__c);
                partUserNameSet.add(stUAObj.User__r.Name);
            }
            //Raghvendra : Partner territory check :End
        }
        Set<Id> gmToDelete = new Set<Id>();
        for(GroupMember gmObj : [Select Id, UserOrGroupId, GroupId from GroupMember where GroupId In :groupIdSet AND UserOrGroupId In : userIdSet]){
            system.debug('nasirdelete1:'+ gmObj);
            if(stGrpUserSet.contains(gmObj.GroupId + '' + gmObj.UserOrGroupId)){
                gmToDelete.add(gmObj.Id);
            }
        }
        
        //Raghvendra:06/08/2013 : Start
        if(partGroupIdSet != null && partGroupIdSet.size() >0 && partUserIdSet != null && partUserIdSet.size() >0 && partUserNameSet != null && partUserNameSet.size() >0){
            delPartnerSOM(partGroupIdSet, partUserIdSet, partUserNameSet);
        }
        //Raghvendra:06/08/2013 : End
        
        //Future call to remove Group Member (Future call used to avoid Mixed DML exception)
        if(!gmToDelete.isEmpty()){
            CreateGroupMemberForTerrUser.deleteGroupMember(gmToDelete);
        }
        
    }
    
    // To remove Group Member on User Assignment IsActive flagged to false.

    public static void userAssignmentUpdate(List<Sales_Territory_User_Assignment__c> triggerNew, List<Sales_Territory_User_Assignment__c> triggerOld){
        
        Set<Id> groupIdSet = new Set<Id>();
        Set<Id> userIdSet = new Set<Id>();
        Set<String> stGrpUserSet = new Set<String>();
        Set<Id> stuaIdToDelGM = new Set<Id>();
        Set<Id> stuaIdToCreateGM = new Set<Id>();
        
       /* List<Sales_Territory_User_Assignment__c> accountTeamUserAdd = new List<Sales_Territory_User_Assignment__c>();
        List<Sales_Territory_User_Assignment__c> accountTeamUserDel = new List<Sales_Territory_User_Assignment__c>();*/
       
        // TM:R5:Nasir JAwed: Req-0593: Start
        for(Integer i=0; i< triggerNew.size(); i++){            
            //if(triggerNew[0].IsActive__c != triggerOld[0].IsActive__c && triggerNew[0].IsActive__c == false){
               // stuaIdToDelGM.add(triggerNew[0].Id); 
             if(triggerNew[i].IsActive__c != triggerOld[i].IsActive__c && triggerNew[i].IsActive__c == false){
                stuaIdToDelGM.add(triggerNew[i].Id);      
               //TM: Sreenath this process of commented code is working from batch job..                
             /*   if(triggerNew[0].Add_to_Account_Team__c != triggerOld[0].Add_to_Account_Team__c && triggerNew[0].Add_to_Account_Team__c == false){
                    accountTeamUserDel.add(triggerNew[0]);
                }*/  
            } //else if(triggerNew[0].IsActive__c != triggerOld[0].IsActive__c && triggerNew[0].IsActive__c == true){
                //stuaIdToCreateGM.add(triggerNew[0].Id);
               else if(triggerNew[i].IsActive__c != triggerOld[i].IsActive__c && triggerNew[i].IsActive__c == true){
                    stuaIdToCreateGM.add(triggerNew[i].Id);
                }
                // TM:R5:Nasir JAwed: Req-0593: End
                /*if(triggerNew[0].Add_to_Account_Team__c != triggerOld[0].Add_to_Account_Team__c && triggerNew[0].Add_to_Account_Team__c == true){
                    accountTeamUserAdd.add(triggerNew[0]);
                }       
             else if(triggerNew[0].Add_to_Account_Team__c != triggerOld[0].Add_to_Account_Team__c && triggerNew[0].Add_to_Account_Team__c == true){
                    accountTeamUserAdd.add(triggerNew[0]);
            } else if(triggerNew[0].Add_to_Account_Team__c != triggerOld[0].Add_to_Account_Team__c && triggerNew[0].Add_to_Account_Team__c == false){
                    accountTeamUserDel.add(triggerNew[0]);
            }*/
        }
        //Raghvendra : Partner variable :start
        Set<Id> partGroupIdSet = new Set<Id>();
        Set<Id> partUserIdSet = new Set<Id>();
        set<String> partUserNameSet= new Set<String>();
        //Raghvendra : Partner variable :End
        for(Sales_Territory_User_Assignment__c stUAObj : [Select Id,Sales_Territory__c, Sales_Territory__r.GroupId__c , User__c,User__r.Name,Sales_Territory__r.IsPartner__c from Sales_Territory_User_Assignment__c where Id in : stuaIdToDelGM]){
            groupIdSet.add(stUAObj.Sales_Territory__r.GroupId__c);
            userIdSet.add(stUAObj.User__c);
            stGrpUserSet.add(stUAObj.Sales_Territory__r.GroupId__c + '' + stUAObj.User__c);
           
            //Raghvendra : Partner territory check :start
            if(stUAObj.Sales_Territory__r.IsPartner__c==true){
                partGroupIdSet.add(stUAObj.Sales_Territory__r.GroupId__c);
                partUserIdSet.add(stUAObj.User__c);
                partUserNameSet.add(stUAObj.User__r.Name);
            }
            //Raghvendra : Partner territory check :End
            
        }
        
        Set<Id> gmToDelete = new Set<Id>();
        for(GroupMember gmObj : [Select Id, UserOrGroupId, GroupId from GroupMember where GroupId In :groupIdSet AND UserOrGroupId In : userIdSet]){
            if(stGrpUserSet.contains(gmObj.GroupId + '' + gmObj.UserOrGroupId)){
                gmToDelete.add(gmObj.Id);
            }
        }
        System.debug(partGroupIdSet +'&&&&&&&'+partUserIdSet +'%%%%%%%'+partUserNameSet);
        //Raghvendra:06/08/2013 : Start
        if(partGroupIdSet != null && partGroupIdSet.size() >0 && partUserIdSet != null && partUserIdSet.size() >0 && partUserNameSet != null && partUserNameSet.size() >0){
            delPartnerSOM(partGroupIdSet, partUserIdSet, partUserNameSet);
        }
        //Raghvendra:06/08/2013 : End
        
        //Future call to remove Group Member (Future call used to avoid Mixed DML exception)
        if(!gmToDelete.isEmpty()){
            CreateGroupMemberForTerrUser.deleteGroupMember(gmToDelete);
        }
        
       //Future call to again add Group Member when record set to IsActive = TRUE (Future call used to avoid Mixed DML exception)
        if(!stuaIdToCreateGM.isEmpty()){
            CreateGroupMemberForTerrUser.createGroupMember(stuaIdToCreateGM);
        }
       
        
    }
    
    //sreenath 11/27/2012 flag making true starts
    public static void userAssignmentbeforeUpdate(Map<Id,Sales_Territory_User_Assignment__c> stuaNewMap, Map<Id,Sales_Territory_User_Assignment__c> stuaOldMap){
     for(Id stuaId: STUANewMap.keyset()){
            if(stuaNewMap.get(stuaId).Add_to_Account_Team__c != stuaOldMap.get(stuaId).Add_to_Account_Team__c){                  
                stuaNewMap.get(stuaId).New_Or_Changed__c = true;
            }
        }  
    }
    //sreenath 11/27/2012 flag making true ends
    
    //TM:Debmalya:Req:2090:Update flag on Sales Territory on updation of Add to Account Team Flag:Start
    public static void salesTerrFlagOnUpdate(Map<Id,Sales_Territory_User_Assignment__c> stuaNewMap, Map<Id,Sales_Territory_User_Assignment__c> stuaOldMap){
        Set<Id> territoryIds = new Set<Id>(); 
        for(Id stuaId: STUANewMap.keyset()){
            if(stuaNewMap.get(stuaId).Add_to_Account_Team__c != stuaOldMap.get(stuaId).Add_to_Account_Team__c){                  
                territoryIds.add(stuaNewMap.get(stuaId).Sales_Territory__c);
            }
        }
        stUpdate(territoryIds);
    }
    
    public static void salesTerrFlagOnInsert(List<Sales_Territory_User_Assignment__c> triggerNew){
        Set<Id> territoryIds = new Set<Id>();
        for(Sales_Territory_User_Assignment__c stuarec: triggerNew){
            if(stuarec.Add_to_Account_Team__c == true){
                territoryIds.add(stuarec.Sales_Territory__c);
            }
        }
        stUpdate(territoryIds);
    }
    
    public static void stUpdate(Set<Id> stUpdate){
        if(stUpdate.size() > 0){
            List<Sales_Territory__c> terrlist = [Select Id, Account_Team_Changes__c,EvaluateTerritory_for_Realignment__c From Sales_Territory__c where Id in :stUpdate];
            for (Integer i =0;i<terrlist.size();i++) {                
                terrlist[i].Account_Team_Changes__c = true;
                //terrlist[i].EvaluateTerritory_for_Realignment__c = true;
            }
            update terrlist;
        }
    }
    //TM:Debmalya:Req:2090:Update flag on Sales Territory:End
    
      //TM:R5:Nasir Jawed:Update flag called "New_Specialty_search__c" on Specialty when a
     // user is inserted in Sales territory user assignment:Start
      public static void flagCheckOnSpecialtyAfterInsert(Map<Id,Sales_Territory_User_Assignment__c> triggerNew){
          Set<ID> psId= new Set<ID>();
          Set<ID> stSet= new Set<ID>();
          Set<ID> stUser= new Set<ID>();
          List<Product_Specialty_User_Assignment__c> prodSpecUserAssin = new List<Product_Specialty_User_Assignment__c>();
          List<Product_Specialty__c> psUpdate = new List<Product_Specialty__c>();
          List<Sales_Territory__c> stUpdate = new List<Sales_Territory__c>();
          
          for(Sales_Territory_User_Assignment__c stu:triggerNew.Values()){
              stUser.add(stu.User__c);
              stSet.add(stu.Sales_Territory__c);
              system.debug('test:'+stUser);
              system.debug('test2:'+stSet);
          }
          for(Product_Specialty_User_Assignment__c psua:[select id,Product_Specialty__c,User__c,New_User_Insert_Sales_Territory__c from Product_Specialty_User_Assignment__c
                                                 where User__c IN :stUser AND To_Be_Deleted__c=False ]){
              psua.New_User_Insert_Sales_Territory__c=true;
              prodSpecUserAssin.add(psua);
              psId.add(psua.Product_Specialty__c);  
          } 
          for(Product_Specialty__c ps:[select id,New_Specialty_search__c from Product_Specialty__c where id=:psId ] ){
              ps.New_Specialty_search__c= true;
              psUpdate.add(ps);
              if(ps.New_Specialty_search__c == true){
                  for(Sales_Territory__c st:[select id,New_User_Alert__c,DateTime_User_Insert__c from Sales_Territory__c where id IN:stSet]){
                      st.New_User_Alert__c=true;
                      st.DateTime_User_Insert__c=System.Now();
                      stUpdate.add(st);
                      system.debug('test3:'+stUpdate);
                  }
              }
              system.debug('test4:'+psUpdate );
          }
          update prodSpecUserAssin;
          update psUpdate ;
          update stUpdate;
      }
    // TM:R5:Nasir Jawed:Update flag called "New_Specialty_search__c" on Specialty:End  
    
    
     //Raghvendra:06/08/2013 : This method deletes SOM when a user is deleted or made isActive=False in STUA  : start
     private static void delPartnerSOM(set<id> groupIdSet, set<id> userIdSet, set<String> userNameSet){
     
       /* List<Product_Specialty_Oppty_Assignment__c> psoaList= new List<Product_Specialty_Oppty_Assignment__c>();
        set<Id> optySet = new set<Id>();
        //get all the shared opty for deleted or deactivated user
        for(OpportunityShare getOpty : [Select id, opportunityId from OpportunityShare where UserorGroupId in : groupIdSet]){
            if(getOpty != null){
                optySet.add(getOpty.opportunityId);
            }
        
        }
        
        set<Id> grMemSet = new set<Id>();
        //checking same opty is shared with some other group.
        for(OpportunityShare getOptyInOthTerr : [Select id, opportunityId, UserorGroupId from OpportunityShare where opportunityId in : optySet]){
            if(getOptyInOthTerr != null){
                grMemSet.add(getOptyInOthTerr.UserorGroupId);
            }       
        }
        system.debug('grMemSet  :'+ grMemSet );
        set<Id> grpSet = new set<Id>();
        for(GroupMember grpMem :[select id,GroupId,UserorgroupId from GroupMember where GroupId in : grMemSet and UserorgroupId in :userIdSet]){
            if(grpMem != null){
                grpSet.add(grpMem.GroupId);
             }       
        }
        system.debug('grpSet  :'+ grpSet);
        set<Id> stId = new set<Id>();
        for(sales_territory__c st :[Select id,name from sales_territory__c where GroupId__c in : grpSet]){
            if(st != null){
                stId.add(st.id);
            }       
        }
        if(stId.size()==1){
          try{
            for(Product_Specialty_Oppty_Assignment__c psoa:[select id,Assigned_User__c,Opportunity__c from Product_Specialty_Oppty_Assignment__c where Opportunity__c IN:optySet AND Assigned_User__c IN:userNameSet ]){
              psoaList.add(psoa);  
              system.debug('psoaList :'+ psoaList);   
            }
            if(psoaList!=null && psoaList.size()>0){ 
              delete psoaList;  
              system.debug('psoaList123  :'+ psoaList); 
            }
          }catch(Exception e){
            system.debug('This exception occur while deleting SOM:'+ e.getMessage());
          }
        }*/
    List<Product_Specialty_Oppty_Assignment__c> psoaList= new List<Product_Specialty_Oppty_Assignment__c>();
    set<id> optySet = new set<id>();
    set<id> terrGrp = new set<id>();
    set<id> grpSet = new set<id>(); 
    set<id> optyOtherGroupSet = new set<id>();   
    //fetching all the opty from SOM for which user is deleted ot inacivated.  
    for(Product_Specialty_Oppty_Assignment__c psoa:[select id,Assigned_User__c,Opportunity__c from Product_Specialty_Oppty_Assignment__c where Assigned_User__c IN:userNameSet ]){
        if(psoa != null){
          psoaList.add(psoa); 
          optySet.add(psoa.Opportunity__c);  
        }
    }
    //find all the groups where this user exist.
    for(GroupMember grpMem :[select id,GroupId,UserorgroupId from GroupMember where GroupId not in : groupIdSet and UserorgroupId in :userIdSet]){
        if(grpMem != null){
            grpSet.add(grpMem.GroupId);
        }       
    }       
    for(Group grp :[select id, name from Group where Id in : grpSet and name like 'STerr%']){
        if(grp != null){
            terrGrp.add(grp.Id);
        }       
    }
    
    for(OpportunityShare getOpty : [Select id, opportunityId from OpportunityShare where opportunityId in :optySet and UserorGroupId in : terrGrp]){
        if(getOpty != null){
            optyOtherGroupSet.add(getOpty.opportunityId);
        }        
    }
    if(optyOtherGroupSet.size()==0 || optyOtherGroupSet.size()<0){
        try{
            if(psoaList!=null && psoaList.size()>0){ 
                          delete psoaList;  
                          system.debug('psoaList123  :'+ psoaList); 
            }
        }   
        catch(Exception e){
                system.debug('This exception occur while deleting SOM:'+ e.getMessage());
        }
     }
   }           
    //Raghvendra:06/08/2013 : This method deletes SOM when a user is deleted or made isActive=False in STUA : End
}