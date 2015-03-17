/**********************************************************
* Class Name: MDCPViewHierarchyController 
* Author: Vijay Ranjan
* Date: 26-June-2013 
* Description: Class to Generate Custom Account Heararchy 
*                
***********************************************************/
public class MDCPViewHierarchyController {
public String AccountName{get;set;}
public list<Integer>indentation_Rows{get;set;}
public ID AccountId {get;set;}
public ID  getAccountId(){
    return AccountId;
}
public list<Account>HierarchyList ;
Public Account CurrentRecord;
public boolean recordAvailable;
public boolean listTruncated{get;set;}
public static list<Account>finalHierarchyList {get;set;}
Private Set<String> UniqueEntry;
public Integer SelectedRecordIndentation=0;
/**************@Constructor for MDCPViewHierarchyController**************/
public MDCPViewHierarchyController() {
    recordAvailable=false;
    listTruncated=false;
    AccountId= apexpages.currentpage().getparameters().get('id');
    getAccountHierarchy(AccountId);

}

/*******************@Function to Generate the Hierarchy***********************/
public Void getAccountHierarchy(id AccountId){
CurrentRecord=new Account();
try{
CurrentRecord=[Select ID,Name,parentid,ShippingCity,ShippingState,ShippingCountry,DUNS__c,Domestic_Ultimate_Duns__c,Global_Ultimate_DUNS_Number__c,NumberOfEmployees from Account where id=:AccountId];
}catch(exception e){}

AccountName=CurrentRecord.Name;
Account TopRecord=new Account();
id topAccountID=GetToplevelAccount(AccountId);
try{
TopRecord=[Select ID,Name,parentid,ShippingCity,ShippingState,ShippingCountry,DUNS__c,Domestic_Ultimate_Duns__c,Global_Ultimate_DUNS_Number__c,NumberOfEmployees from Account where id=:topAccountID];
}catch(exception e){}

if(TopRecord.id!=null){

TopRecord.NumberOfEmployees=0;
HierarchyList=new list<Account>();
HierarchyList.add(TopRecord); 
CurrentRecord.NumberOfEmployees=SelectedRecordIndentation;
}else{

CurrentRecord.NumberOfEmployees=0;
HierarchyList=new list<Account>();
HierarchyList.add(TopRecord); 

}
GetAllChildAccounts(topAccountID);
if(topAccountID==AccountId){
recordAvailable=true;
}
finalHierarchyList=new list<Account>(); 
UniqueEntry=new Set<String>();
orderHierarchyList(HierarchyList,UniqueEntry);
if(!recordAvailable){

system.debug('@@@@@@@@@@@@@@'+CurrentRecord.NumberOfEmployees);
integer totalrecords=finalHierarchyList.size();
Account currentParent=[Select ID,Name,ShippingCity,parentid,ShippingState,ShippingCountry,DUNS__c,Domestic_Ultimate_Duns__c,Global_Ultimate_DUNS_Number__c,NumberOfEmployees from Account where id=:CurrentRecord.parentID limit 1];
currentParent.NumberOfEmployees= CurrentRecord.NumberOfEmployees-1;
finalHierarchyList.add(totalrecords-3,currentParent);
 finalHierarchyList[totalrecords-4].Name='........';
 finalHierarchyList[totalrecords-4].ShippingCity='........';
 finalHierarchyList[totalrecords-4].ShippingState='........';
 finalHierarchyList[totalrecords-4].ShippingCountry='........';
 finalHierarchyList[totalrecords-4].DUNS__c='........';
 finalHierarchyList[totalrecords-4].Domestic_Ultimate_Duns__c='........';
 finalHierarchyList[totalrecords-4].Global_Ultimate_DUNS_Number__c='........'; 
  finalHierarchyList[totalrecords-4].NumberOfEmployees =CurrentRecord.NumberOfEmployees; 
finalHierarchyList[totalrecords-2].Name=CurrentRecord.Name;
 finalHierarchyList[totalrecords-2].ShippingCity=CurrentRecord.ShippingCity;
 finalHierarchyList[totalrecords-2].ShippingState=CurrentRecord.ShippingState;
 finalHierarchyList[totalrecords-2].ShippingCountry=CurrentRecord.ShippingCountry;
 finalHierarchyList[totalrecords-2].DUNS__c=CurrentRecord.DUNS__c;
 finalHierarchyList[totalrecords-2].Domestic_Ultimate_Duns__c=CurrentRecord.Domestic_Ultimate_Duns__c;
 finalHierarchyList[totalrecords-2].Global_Ultimate_DUNS_Number__c=CurrentRecord.Global_Ultimate_DUNS_Number__c;   
  finalHierarchyList[totalrecords-2].NumberOfEmployees =CurrentRecord.NumberOfEmployees; 
  finalHierarchyList[totalrecords-2].parentID=CurrentRecord.parentID;   
 finalHierarchyList[totalrecords-1].Name='........';
 finalHierarchyList[totalrecords-1].ShippingCity='........';
 finalHierarchyList[totalrecords-1].ShippingState='........';
 finalHierarchyList[totalrecords-1].ShippingCountry='........';
 finalHierarchyList[totalrecords-1].DUNS__c='........';
 finalHierarchyList[totalrecords-1].Domestic_Ultimate_Duns__c='........';
 finalHierarchyList[totalrecords-1].Global_Ultimate_DUNS_Number__c='........'; 
 finalHierarchyList[totalrecords-1].NumberOfEmployees =CurrentRecord.NumberOfEmployees; 
 finalHierarchyList.remove(totalrecords);  
 finalHierarchyList[totalrecords-2].id= AccountId; 
}

indentation_Rows=new list<integer>();
for(Account val:finalHierarchyList){
indentation_Rows.add(val.NumberOfEmployees);
}

}
/**************@Function to get All Parent Accounts**************/
public void GetAllChildAccounts(id AccountId){
list<id> parentacid=new list<id>();
integer listcount=0;
List<Account>ChildAccount=new List<Account>();
parentacid.add(AccountId);
    do {
        
        ChildAccount=GetChildAccount(parentacid);
        parentacid.clear();
        listcount=ChildAccount.size();
        for(Account acnt:ChildAccount){
                parentacid.add(acnt.id);
                HierarchyList.add(acnt);
        }
        ChildAccount.clear();
    } while (listcount>0);

}

/**************@Function to get All Parent Accounts**************/
public ID  GetToplevelAccount(id AccountId)
{
id topAccount=AccountId;
id parentacid=AccountId;
    do {
   
        Account acval=GetParentAccount(parentacid);

         parentacid=acval.id;
        if(acval.id!=null){
        SelectedRecordIndentation++;
        topAccount=acval.id;
        
    }
    } while (parentacid!=null);
return topAccount;
}


/******************@Function to Get Parent Account*****************/

Public Account GetParentAccount(id AccountId){
Account Accountrecord=new Account(); 
    try{
    ID  parentId=[select parentid from Account where id=:AccountId].parentid;
        if(parentId!=null){
        Accountrecord=[Select id,Name,ShippingCity,ShippingState,ShippingCountry,DUNS__c,Domestic_Ultimate_Duns__c,Global_Ultimate_DUNS_Number__c,NumberOfEmployees from Account where id=:parentId];
        }
    }catch(exception e){}
return Accountrecord;
}
/**************@Function to get ParentLevel**************/
public integer getParentLevel(ID accountID){
integer childlevel=0;

    for(Account var:HierarchyList){
        if(var.Id==accountID){
        childlevel=var.NumberOfEmployees;
        }
    }
return  (childlevel+1);
}
/******************@Function to Get Child Account*****************/

Public List<Account> GetChildAccount(List<id> AccountIdList){
list<Account> Accountrecord=new list<Account> (); 
    try{
    Accountrecord=[Select ID,Name,ShippingCity,parentid,ShippingState,ShippingCountry,DUNS__c,Domestic_Ultimate_Duns__c,Global_Ultimate_DUNS_Number__c,NumberOfEmployees from Account where parentid=:AccountIdList order by name limit 150] ;
    system.debug('Accountrecord.size()==='+Accountrecord.size());
    if(Accountrecord.size()!=0){
         integer currentlevel=getParentLevel(Accountrecord[0].parentid);
         for(Account var:Accountrecord){
         var.NumberOfEmployees=currentlevel;
         if(AccountId==var.id ){ recordAvailable=true;}
         }
    }
    if(Accountrecord.size()==150){
    listTruncated=true;
    }
 
    }catch(exception e){}
 
return Accountrecord;
}

/********************@function to order Hierarchy list*******************************/
public void orderHierarchyList(list<Account> HierarchyList,Set<String>  UniqueEntry ){


if(HierarchyList.size()>0){ 
    for(Account val: HierarchyList)
    {
    list<Account> childs=getChilds(val.Id );
        if(childs.size()>0){
            if(!UniqueEntry.contains(val.Id)){
            finalHierarchyList.add(val);
            UniqueEntry.add(val.Id);
            }
            orderHierarchyList(childs,UniqueEntry );
        }else{
            if(!UniqueEntry.contains(val.Id)){
            finalHierarchyList.add(val);
            UniqueEntry.add(val.Id);
            }
        }
    } 
}

}

/********************@function to get childs from Hierarchy list*******************************/
public list<Account> getChilds(id var){
list<Account>childlist=new list<Account>();
for(Account val:HierarchyList ){
if(val.parentID==var ){
childlist.add(val);
}
}
return childlist;
}

}