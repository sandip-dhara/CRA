trigger ParticipatingCountriesBeforeUpdate on MN_Opportunities_Information__c (before insert, before Update) {

    public list<MN_Opportunities_Information__c> countryListToUpsert = new list<MN_Opportunities_Information__c>();
    public list<MN_Opportunities_Information__c> countryItemList = new list<MN_Opportunities_Information__c>();
     public list<MN_Opportunities_Information__c> ExistingCountries = new list<MN_Opportunities_Information__c>();
    set<Id> opptyIDs = new Set<ID>(); 
    
    
    for(MN_Opportunities_Information__c pc : Trigger.New){
            countryItemList.add(pc);
            opptyIDs.add(pc.Multinational_OppMultinational_Oortunity__c); 
            }  
        ExistingCountries = [Select Country__c,Est_Opportunity_Value__c from MN_Opportunities_Information__c where Multinational_OppMultinational_Oortunity__c in :opptyIDs];                             
    
    
    if(Trigger.IsInsert){
    for(MN_Opportunities_Information__c pc1 :ExistingCountries )
        {
            for(MN_Opportunities_Information__c c : countryItemList){
               
                if(c.Country__c != pc1.Country__c)      
                 {
                  countryListToUpsert.add(c);
                }
                      else{
                            c.addError('The selected Country already exist. Please select another Country');  
                            }
                              }
                                }
                      } 
      if(Trigger.IsUpdate){
          for(MN_Opportunities_Information__c pc1 :ExistingCountries )
        {
            for(MN_Opportunities_Information__c c : countryItemList){
               if(Trigger.NewMap.get(c.id).Country__c !=Trigger.oldMap.get(c.id).Country__c ){
                    if(c.Country__c == pc1.Country__c)      
                     {
                     c.addError('The selected Country already exist. Please select another Country');  
                    }
                 
                   
               }
             }
        }                         
      
     }
}