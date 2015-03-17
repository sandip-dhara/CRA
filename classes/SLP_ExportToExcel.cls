global class SLP_ExportToExcel 
{
     @RemoteAction
    global static List<Community__c> GetCommunity()
    {
      List<Community__c> lstCommunity=[select Id,name__c From Community__c];
      return lstCommunity;
    }
 }