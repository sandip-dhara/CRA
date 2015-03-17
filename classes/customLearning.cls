public with sharing class customLearning {

    public customLearning(ApexPages.StandardController controller) {

    }


    public List<Learning__c> newlist { get; set; }

    public String customLearning { get; set; }
    public string editorial{get;set;}
    public customLearning(){
       newlist = [SELECT Id FROM Learning__c where ID = 'a6wZ00000008ohZ']; 
    
    }
}