/************************************************
Author: Abrar
Date: 08/10/2012
Class: PrivateOpportunitiesController.
Desc: Controller for making opportunity as Private
        and Private opportunity to Public.
/************************************************/

global class PrivateOpportunitiesController{

 //method to make opty private
 
  webService static string createPrivateOppty(String OptyId)
   {
     string ctrychk = 'False';
     Opportunity opty = new Opportunity();
     String oId = OptyId;
     System.debug('Inside CreatePrivateOppty method');
          
     opty=[select Id, Account_Shipping_Country__c, AccountId, 
          Account_Private_Opportunity__c, Confidential__c 
          from Opportunity where Id = :oId];
          
     System.debug('Inside CreatePrivateOppty method Private flag'+opty.Confidential__c);
          
     string accCountry=opty.Account_Shipping_Country__c;
     
     
     List<Account> accMaster=[select Id, Name, ShippingCountry from Account where
                        ShippingCountry = :accCountry
                        and Name LIKE 'Master Private Account%'
                        LIMIT 1];
         
     if(accMaster.size()>0)
     system.debug('Account Master'+accMaster[0].Name);
     //system.debug('Account billing country'+accMaster[0].BillingCountry);
     
     if(accMaster.Size()>0)
     {
      if(opty.Account_Private_Opportunity__c==Null)
      {
       opty.Confidential__c = True;
       opty.Account_Private_Opportunity__c = opty.AccountId;
       opty.AccountId = accMaster[0].Id;
       //update opty;
        Database.SaveResult SR = database.update(opty,false);
        for(Database.Error err: SR.getErrors())
        {
           ctrychk = string.valueof(err.getMessage());
            
        }
       }
       return ctrychk;
       }
       else
       ctrychk = 'True';
       system.debug('####executing ELSE'+ctrychk);
       return ctrychk;
       
       }
     
 //method to make private opty to public
 
  webService static string createPublicOppty(String OptyId)
  {
      Opportunity opp = new Opportunity();
      String opId = OptyId;
      string ctrychk;
      
      System.debug('Inside CreatePrivateOppty method');
      
      opp=[select Id, Account_Shipping_Country__c, AccountId, 
          Account_Private_Opportunity__c, Confidential__c
          from Opportunity where Id = :opId];

     System.debug('Inside CreatePrivateOppty method Private flag'+opp.Confidential__c);
     
      if(opp.Account_Private_Opportunity__c!=Null && opp.AccountId!=Null)
       {
        opp.AccountId = opp.Account_Private_Opportunity__c;
        opp.Account_Private_Opportunity__c = Null;
        opp.Confidential__c= False;
//        update opp;
        Database.SaveResult SR = database.update(opp,False);
        for(Database.Error err: SR.getErrors())
        {
           ctrychk = string.valueof(err.getMessage());
            
        }
        
        }
        return ctrychk;
    }

}