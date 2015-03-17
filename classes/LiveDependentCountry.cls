global class LiveDependentCountry{
    
    Webservice Static String CountryTeam(string liveReg){
   
    String UserCountry;
       
    List<Live_Chat__c> SelectedCon = [select Country__c from Live_Chat__c where Region__c = :liveReg];    
    
    for (Live_Chat__c Country : SelectedCon){    
        system.debug('&&&'+String.ValueOf(Country));
    
        if(UserCountry!=null)
            UserCountry=UserCountry+','+String.ValueOf(Country);
        else if(UserCountry==null)
           UserCountry=String.ValueOf(Country);
    }
    
    system.debug('@@@'+UserCountry);
    return UserCountry;
    }
    
    
     
    Webservice Static String LiveSubject(string liveSub){
   
    String UserSubject;
       
    List<Live_Subject__c> SelectedSub = [select Subject__c from Live_Subject__c where CO_Area__c = :liveSub];    
    for (Live_Subject__c Subject : SelectedSub){    
        system.debug('&&&'+String.ValueOf(Subject));
    
        if(UserSubject!=null)
            UserSubject=UserSubject+String.ValueOf(Subject);
        else if(UserSubject==null)
           UserSubject=String.ValueOf(Subject);
    }
        
    system.debug('@@@'+UserSubject);
    return UserSubject;
    }
    
       
    /* Prepopulate Subject */
    Webservice Static String UserTimeZone(string TimeZoneKey){
        String DefaultTimeZone;
        String UsersTimeZone;
        
        Schema.DescribeFieldResult fieldResult = Case.Requestor_s_TimeZone__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for(Schema.PicklistEntry f : ple){
            DefaultTimeZone = String.ValueOf(f.getValue());
                       
            If(DefaultTimeZone.contains(TimeZoneKey)==true){
                system.debug('!!!'+DefaultTimeZone);
                UsersTimeZone = DefaultTimeZone;
            }
            system.debug('###'+UsersTimeZone);
        }
        return UsersTimeZone; 
    }



}