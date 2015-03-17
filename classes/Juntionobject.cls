public with sharing class Juntionobject {
    public list<learning__c> learn{get;set;}
    public Juntionobject(ApexPages.StandardController controller) {
        learn = new list<learning__c>();
        learn = [SELECT Id, Name, CurrencyIsoCode, CreatedDate, CreatedById, Name__c, Description__c, Is_Active__c, Type__c,  URL__c FROM Learning__c];
        
    }
    Public void goMethod(){}

}