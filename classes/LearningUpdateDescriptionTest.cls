@isTest
public class LearningUpdateDescriptionTest {
    
    static testMethod void LearningUpdateDescriptionTest() 
    {
        Learning__c lrng1 = new Learning__c();
        lrng1.Name__c = 'Learning1 from Trigger';
        lrng1.Description__c = 'HP Converged Cloud, from Hewlett-Packard, combines software and cloud services into a unified set of packages and under a single unified architecture.[1] It is used by enterprise organizations so they can combine public cloud services with their own internal IT resources to create hybrid clouds, or a mix of different Cloud computing environments made up of private and public clouds';
        insert lrng1; 
        
        Learning__c lrng2 = new Learning__c();
        lrng2.Name__c = 'Learning2 from Trigger';
        lrng2.Description__c = 'Transform Legacy Applications to cloud';
        insert lrng2;      
    }
}