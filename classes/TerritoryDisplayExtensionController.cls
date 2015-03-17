/**
* Class Name: TerritoryDisplayExtensionController 
* Author: Accenture
* Date: 23-JULY-2012 
* Requirement # Request Id:
* Description: Extension Controller of Accounts to show Territory Users on a button click.
*/
    
public with sharing class TerritoryDisplayExtensionController {

public Account theAcct { get; set; }
    /*
     * Method to fetch the Terriory Users (Sales Territory User Assignment) and pass them to a report as parameters to shoew Users assignned to Account's Territory.   
     * Called from trigger.
     */

public TerritoryDisplayExtensionController (ApexPages.StandardController stdController) {
        theAcct = (Account)stdController.getRecord();   
    }
        
    public PageReference accountTerritoryUser()  {
        
        PageReference pr = null;
        try{
                Report reportObj=[Select Id from Report where name = 'Territory User Assignment'  limit 1 ];
                String accountTerritory = 'None';
                String accountTerritory2 = 'None';
                String accountTerritory3 = 'None';
                String accountTerritory4 = 'None';
                String accountTerritory5 = 'None';
                String accountTerritory6 = 'None';
                String accountTerritory7 = 'None';
                
                for(Sales_Territory_Account_Assignment__c territory:[Select Id, Sales_Territory__c, Sales_Territory__r.IsActive__c , Account__c From Sales_Territory_Account_Assignment__c where Account__c =: theAcct.Id and Sales_Territory__c!=null AND Sales_Territory__r.IsActive__c = true]) {
                        string territoryid=territory.Sales_Territory__c;
                        if(accountTerritory.length() < 170)  {
                                if(accountTerritory == 'None')
                                    accountTerritory = territoryid.substring(0, 15);
                                else
                                    accountTerritory += ',' + territoryid.substring(0, 15);
                                //system.debug('accountTerritory ' + accountTerritory);                       
                            }
                        else if(accountTerritory2.length() < 170) {
                            if(accountTerritory2 == 'None')
                                accountTerritory2 = territoryid.substring(0, 15);
                            else
                                accountTerritory2 += ',' + territoryid.substring(0, 15);
                            //system.debug('accountTerritory2 ' + accountTerritory2);                     
                        } 
                        else if(accountTerritory3.length() < 170) {
                            if(accountTerritory3 == 'None')
                                accountTerritory3 = territoryid.substring(0, 15);
                            else
                                accountTerritory3 += ',' + territoryid.substring(0, 15);
                        }  
                          else if(accountTerritory4.length() < 170) {
                            if(accountTerritory4== 'None')
                                accountTerritory4= territoryid.substring(0, 15);
                            else
                                accountTerritory4+= ',' + territoryid.substring(0, 15);
                        } 
                        else if(accountTerritory5.length() < 170) {
                            if(accountTerritory5== 'None')
                                accountTerritory5= territoryid.substring(0, 15);
                            else
                                accountTerritory5+= ',' + territoryid.substring(0, 15);
                        }
                        else if(accountTerritory6.length() < 170) {
                            if(accountTerritory6== 'None')
                                accountTerritory6= territoryid.substring(0, 15);
                            else
                                accountTerritory6+= ',' + territoryid.substring(0, 15);
                        }
                        else if(accountTerritory7.length() < 170) {
                            if(accountTerritory7== 'None')
                                accountTerritory7= territoryid.substring(0, 15);
                            else
                                accountTerritory7+= ',' + territoryid.substring(0, 15);
                        }                 
                    }
        
                pr = new PageReference('/'+reportObj.Id+'?');
                pr.getParameters().put('pv0', accountTerritory);
                pr.getParameters().put('pv1', accountTerritory2);
                pr.getParameters().put('pv2', accountTerritory3);
                pr.getParameters().put('pv3', accountTerritory4);
                pr.getParameters().put('pv4', accountTerritory5);
                pr.getParameters().put('pv5', accountTerritory6);
                pr.getParameters().put('pv6', accountTerritory7);
        }
            catch(Exception e){
                system.debug('****Exception in SalesTerritoryDefnDisplay.SalesTerritory()****' + e.getMessage());
            }
                return pr;  
        }    

}