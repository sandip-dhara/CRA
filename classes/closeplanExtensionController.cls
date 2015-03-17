/**
* Class Name: closeplanExtensionController 
* Author: HP(Mousumi Panda)
* Date: 30-Sept-2012 
* Requirement:Close Plan Tool
*/

public with sharing class closeplanExtensionController {
public class ClosePlanWrapperClass
    {
       
      public integer index {get;set;}
      public Close_Plan__c ocloseplanObj{get;set;}
      public ClosePlanWrapperClass(Close_Plan__c ocloseplanObj){
          system.debug('Index****wrapper class:'+this.index);
          this.ocloseplanObj=ocloseplanObj;
      }
    }


public ApexPages.StandardController std; 
public String id;
public String printView {get;set;}
public Integer rows {get;set;}

public Integer i{get;set;}

public Integer rowcount{get;set;}
public Opportunity_Plan__c objOpptyplanItem{get;set;}
//public Id chosencloseplandtlId {get; set;}
public List<ClosePlanWrapperClass> closeplanItemWrapper;
public boolean isdelete;
public boolean isaddrow;
public List<Close_Plan__c> TobeDeletedItem;

public closeplanExtensionController(ApexPages.StandardController controller) {
        
        TobeDeletedItem =new List<Close_Plan__c>();
        i=0;
        std = controller;
        this.objOpptyplanItem = (Opportunity_Plan__c )controller.getRecord();
        this.id = ApexPages.currentPage().getParameters().get('id');
        this.printView = ApexPages.currentPage().getParameters().get('printView');
        
        
}
    
    
    
    public List<Decision__c> getBuyingCriteria(){
        List<Decision__c> qlist = new List<Decision__c>([SELECT Criteria__c FROM Decision__c WHERE Opportunity_Plan__c = :Id]);
        List<Decision__c> result = new List<Decision__c>();
        for (Decision__c d : qlist) {
            if (d.Criteria__c != null) {
                result.add(d);
            }
        }
        return result;
    }
    public List<Relationship_Suite__c> getDecisionMakers(){
        
        List<Relationship_Suite__c> rs = new List<Relationship_Suite__c>([SELECT Contact__r.Name,Contact__r.Title, Relationship_map__c FROM Relationship_Suite__c WHERE Opportunity_Plan__c = :Id ]);
        List<Relationship_Suite__c> result = new List<Relationship_Suite__c>();
        String compareme; 
        for (Relationship_Suite__c r : rs){
            compareme = String.valueOf(r.Relationship_map__c);
            if (compareme == null){
                compareme = '_';
            }
            if (compareme.indexOf('Decision Maker',0) > -1){
                result.add(r);
            }
        }
        return result;
    }
    
    
   public List<ClosePlanWrapperClass> getCloseplanItemWrapper(){
   
    system.debug('closeplanItemWrapper***********'+closeplanItemWrapper );
    If(closeplanItemWrapper == null || isdelete== true){
    List<Close_Plan__c> CloseplanItem = [Select Status1__c, OwnerId, Opportunity_Plan__c, OWNER1__c, Name,HP_CUSTOMER_3rd_PARTY__c, HELP_NEEDED__c, EXEC_INVOLMENT__c, DESCRIPTION__c, DATES__c From Close_Plan__c WHERE Opportunity_Plan__c = :Id ORDER BY Opportunity_Plan__c];
    closeplanItemWrapper = new List<ClosePlanWrapperClass>();
    if(CloseplanItem != null){
        for(Close_Plan__c cp: CloseplanItem){
        ClosePlanWrapperClass clsplanWrapper = new ClosePlanWrapperClass(cp);
        clsplanWrapper.index = closeplanItemWrapper.size()+1;
               closeplanItemWrapper.add(clsplanWrapper );
            }
    }
        
    if(closeplanItemWrapper.size()<3){
        rowcount=3-closeplanItemWrapper.size();
        for(integer i=0;i<rowcount;i++){
           Close_Plan__c cpAddRow=new Close_Plan__c();
           cpAddRow.Opportunity_Plan__c=Id;
           ClosePlanWrapperClass clsplanWrapper = new ClosePlanWrapperClass(cpAddRow);
           clsplanWrapper.index = closeplanItemWrapper.size()+1;
           closeplanItemWrapper.add(clsplanWrapper );
        }
    }
    
     
        
    
      
    }
    If(isaddrow == true){
        Close_Plan__c CPI = new Close_Plan__c();
        CPI.Opportunity_Plan__c=Id;
        system.debug('Current Index when u ckick add row  u add one row*****'+closeplanItemWrapper.size());
        
        ClosePlanWrapperClass clsplanWrapper = new ClosePlanWrapperClass(CPI);
           clsplanWrapper.index = closeplanItemWrapper.size()+1;
           closeplanItemWrapper.add(clsplanWrapper );
      isaddrow=false;
    }
       system.debug('closeplanItemWrapper.size()'+closeplanItemWrapper.size());
       system.debug('closeplanItemWrapper***********'+closeplanItemWrapper );
        return closeplanItemWrapper;
        
   }
    
    public void deleteFromDb(Integer deleteIndex)
    {
     
     ClosePlanWrapperClass cpwl = closeplanItemWrapper[deleteIndex];
             system.debug('************deleteindex::::'+deleteIndex);
             system.debug('************closeplanItemWrapper[deleteIndex]::::'+closeplanItemWrapper[deleteIndex]);
             system.debug('************cpwl ::::'+cpwl);
                  If(cpwl.ocloseplanObj.Id != null){
                     
                         Close_Plan__c objClosePlan = cpwl.ocloseplanObj;
                            //delete objClosePlan;
                            TobeDeletedItem.add(objClosePlan);
                  }
    }
    
   public void addRow(){
   isaddrow=true;
     
   }
   public pagereference removeOffRowcallplan(){
   
   Integer deleteIndex = Integer.valueof(ApexPages.currentPage().getParameters().get('delrowindex')) - 1;
        system.debug('CurrentIndex******before delete Removing row'+deleteIndex);
     
       deleteFromDb(deleteIndex);
        
       closeplanItemWrapper.remove(deleteIndex);
       for(integer i = deleteIndex; i<closeplanItemWrapper.size(); i++)
       {
           closeplanItemWrapper[i].index--;
       }
     
      System.debug('Delete******Index***AfterRemoving row'+deleteIndex);
   return null; 
   }
    

    

    
 public PageReference customSave(){ 
 try{
List<ClosePlanWrapperClass> closeplanWrapperlist = getCloseplanItemWrapper();     
List<Close_Plan__c> listUpdate = new List<Close_Plan__c>();
List<Close_Plan__c> listInsert = new List<Close_Plan__c>();
   for(ClosePlanWrapperClass cpwl : closeplanWrapperlist){
        If(cpwl.ocloseplanObj.Id != null){
           Close_Plan__c objClosePlan = cpwl.ocloseplanObj;
           listUpdate.add(objClosePlan);
         }
        else{
            If(cpwl.ocloseplanObj.DATES__c!=null|| cpwl.ocloseplanObj.DESCRIPTION__c!=null || cpwl.ocloseplanObj.EXEC_INVOLMENT__c!=null || cpwl.ocloseplanObj.HELP_NEEDED__c!=null || cpwl.ocloseplanObj.HP_CUSTOMER_3rd_PARTY__c!=null || cpwl.ocloseplanObj.Owner1__c!=null || cpwl.ocloseplanObj.Status1__c!=null){
              Close_Plan__c objClosePlan = cpwl.ocloseplanObj;
                      listInsert.add(objClosePlan);
                   }
                    }
                                
      }
      if(!TobeDeletedItem.isEmpty())
      delete TobeDeletedItem;
      if(!listUpdate.isEmpty())
        update listUpdate;
      if(!listInsert.isEmpty())
        insert listInsert;
        Update objOpptyplanItem;
        
PageReference pr = new PageReference('/apex/closeplanpage?id='+Id);
pr.setRedirect(false);
system.debug('Id!!!!!!!!!!!!!!!'+Id);
return pr;
    }catch(Exception e){
    ApexPages.addmessages(e);
    return null;
    }
}
    
    public PageReference customCancel(){
        
        std.cancel();
        PageReference pr = new PageReference('/apex/closeplanpage?id='+Id);
        pr.setRedirect(true);
        return pr;
    
    }
    
   
    
    
}