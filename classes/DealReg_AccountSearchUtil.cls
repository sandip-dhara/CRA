/**********************************************************
* Class Name: SearchUtil
* Author: HP Release 3
* Date: 27-Sep-2012 
* Requirement # Request Id:
* Description: Utility class to perform search action
***********************************************************/
public class DealReg_AccountSearchUtil{
    
      /*
       * @Description: Method to perform search for accounts.
       * @Return: List<Account> -  List of accounts that match with given criteria.
       */
       public static List<Account> runSearch(String searchKey,String searchCountry, String searchCity,List<Account> results,Integer size,Integer noOfRecords) {     
           
              searchKey=searchKey.replace('*', '%');
              searchKey=String.escapeSingleQuotes(searchKey);
              if(null!=searchCountry){
              searchCountry=String.escapeSingleQuotes(searchCountry);
              }
              if(null!=searchCity){
              searchCity=String.escapeSingleQuotes(searchCity);
              }
              list<id> createdContacts=new list<id>();               
              String soql = 'select id, name,ShippingStreet,ShippingCity,ShippingState,ShippingPostalCode,ShippingCountry,Alternate_Name__c,AccountNumber,MDCP_Organization_ID__c,MDCP_Subscribed_Flag__c,Mdcp_SiteId__c  from account where RecordType.Name=\'Customer\' and Verified_account__c=\'True\'';
              soql = Soql + ' and name LIKE \''  + searchKey + '%\'';       
              if((''!=searchKey  && null!=searchKey ) && (''!=searchCountry  && null!=searchCountry ) && (''!=searchCity  && null!=searchCity )){
                 soql = soql + ' and ShippingCountry LIKE \'' + searchCountry +'%\''
                             + ' and ShippingCity LIKE \'' + searchCity +'%\''
                             + ' order by name '
                             + ' limit 25'; 
                                            
              }else if((''!=searchKey && null!=searchKey) && (''!=searchCountry && null!=searchCountry)){
                 soql = soql + ' and ShippingCountry LIKE \'' + searchCountry +'%\''
                               + ' order by name '
                               + ' limit 25';                   
              }else if((''!=searchKey && null!=searchKey) && (''!=searchCity && null!=searchCity)){
                 soql = soql + ' and ShippingCity LIKE \'' + searchCity+'%\''
                               + ' order by name '
                               + ' limit 25';                  
              }else{
                 soql = soql + ' order by name '
                               + ' limit 25'; 
                                   
              }               
              return Database.query(soql);  
       }               
}