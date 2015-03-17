/**********************************************************
* Class Name: PCLM_TodisplayTerritoryUsersController
* Author: HP 
* Date: 22-Mar-2013
* Description: Extension Controller of Locations and it will display the sales territory users associated to Location on a button click
***********************************************************/

public with sharing class PCLM_TodisplayTerritoryUsersController { 
/*
    public Location__c locationRecord{ get; set; }

    public PCLM_TodisplayTerritoryUsersController(ApexPages.StandardController controller) {
    locationRecord=(Location__C)controller.getRecord();
    }

    /*
    * @description:This Method will fetch the Terriory Users (Sales Territory User Assignment) and pass them to a report as parameters to show the Users assignned to Location's Territory.   
    * Called from trigger.
    
    
    public pageReference locationTerritoryUsers(){
        
        pageReference pr=null;  
        try{
        Report repObj=[select id from Report where name='Territory User Assignment For Location' limit 1];
        String locationTerritory='None';
        String locationTerritory1='None';
        String locationTerritory2='None';
        String locationTerritory3='None';
        String locationTerritory4='None';
        String locationTerritory5='None';
        String locationTerritory6='None';
        
        Set<String> salesTerrIdSet = new Set<String>();
       Change made in query after unit test 
        Location__c locARec = [select Location__r.Account__c  from Location__c where id =: locationRecord.Id ];
        
        for(Sales_Territory_Account_Assignment__c terr:[select Sales_Territory__c from Sales_Territory_Account_Assignment__c where 
                                                            Account__c=: locARec.Location__r.Account__c AND Sales_Territory__c!=null 
                                                            AND Sales_Territory__r.IsActive__c = true]){
                    salesTerrIdSet.add(terr.Sales_Territory__c);
        }
        
        
        
        for(Sales_Territory_Location_Assignment__c territory:[select Sales_Territory__c,Sales_Territory__r.IsActive__c,Location__c 
                                                              from Sales_Territory_Location_Assignment__c where Location__c=: locationRecord.Id 
                                                              AND Sales_Territory__c!=null AND Sales_Territory__r.IsActive__c = true]){
            salesTerrIdSet.add(territory.Sales_Territory__c);
        }
        
        if(salesTerrIdSet != null && salesTerrIdSet.size() > 0){
            
                for(String sterrId: salesTerrIdSet){
                
                    if(locationTerritory.length() < 170){
                        if(locationTerritory=='None')
                            locationTerritory=sterrId.substring(0,15);
                        else
                            locationTerritory+=','+sterrId.substring(0,15);
                    }
                    else if(locationTerritory1.length() < 170){
                        if(locationTerritory1=='None')
                            locationTerritory1=sterrId.substring(0,15);
                        else
                            locationTerritory1+=','+sterrId.substring(0,15);
                    }
                    
                    else if(locationTerritory2.length() < 170){
                        if(locationTerritory2=='None')
                            locationTerritory2=sterrId.substring(0,15);
                        else
                            locationTerritory2+=','+sterrId.substring(0,15);
                    }
                    
                    else if(locationTerritory3.length() < 170){
                        if(locationTerritory3=='None')
                            locationTerritory3=sterrId.substring(0,15);
                        else
                            locationTerritory3+=','+sterrId.substring(0,15);
                    }
                    
                    else if(locationTerritory4.length() < 170){
                        if(locationTerritory4=='None')
                            locationTerritory4=sterrId.substring(0,15);
                        else
                            locationTerritory4+=','+sterrId.substring(0,15);
                    }
                    
                    else if(locationTerritory5.length() < 170){
                        if(locationTerritory5=='None')
                            locationTerritory5=sterrId.substring(0,15);
                        else
                            locationTerritory5+=','+sterrId.substring(0,15);
                    }
                    
                    else if(locationTerritory6.length() < 170){
                        if(locationTerritory6=='None')
                            locationTerritory6=sterrId.substring(0,15);
                        else
                            locationTerritory6+=','+sterrId.substring(0,15);
                    }
                    
            }
            
        }
                
        pr=new pageReference('/'+repObj.Id+'?');
        pr.getParameters().put('pv0',locationTerritory);
        pr.getParameters().put('pv1',locationTerritory1);
        pr.getParameters().put('pv2',locationTerritory2);
        pr.getParameters().put('pv3',locationTerritory3);
        pr.getParameters().put('pv4',locationTerritory4);
        pr.getParameters().put('pv5',locationTerritory5);
        pr.getParameters().put('pv6',locationTerritory6);
    }
    
    catch(Exception e){
        system.debug('****Exception in SalesTerritoryDefnDisplay.SalesTerritory()****' + e.getMessage());
    }
        return pr;
    }
  */       
}