public with sharing class MyTerritoryDisplay {
    //public User userId { get; set; }
    public ID userId { get; set; }
    
    public MyTerritoryDisplay(ApexPages.StandardController controller) {
        //userId =(User)controller.getRecord(); 
        userId =ApexPages.CurrentPage().getParameters().get('id');
        system.debug('nasir1:'+ userId ); 
    }
    Public PageReference MyTerritoryDisplayUserDetail(){
    PageReference pr = null;
        Report reportObj=[Select Id from Report where DeveloperName = 'Sales_Territory_by_user_Do_not_change'  limit 1 ];
        String salesTerr= 'None';
        
        /*for(Sales_Territory_User_Assignment__c stua: [select id,Name,User__c,IsActive__c,Sales_Territory__c,
                         Sales_Territory__r.IsActive__c,Sales_Territory__r.Name from Sales_Territory_User_Assignment__c where Sales_Territory__r.IsActive__c=True
                                                                                                 AND IsActive__c=True
                                                                                                 AND User__c =:userId]  ){
            system.debug('nasir1:'+ stua);
            string territoryid=stua.Sales_Territory__r.Name;            
            if(salesTerr.length() < 170)  {
                if(salesTerr== 'None')
                    salesTerr= territoryid;
                else
                    salesTerr+= ',' + territoryid;                              
            }        
        }*/
        User user = [Select Name,Email from User where id =: userId];  
        String uid= user.Email;
        
        pr = new PageReference('/'+reportObj.Id+'?');
        //pr.getParameters().put('pv0', salesTerr);   
        pr.getParameters().put('pv0', uid);                                                                                         
        return pr;
        
    }

}