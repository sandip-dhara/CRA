@isTest
public class LBUpdateDescriptionTest {
    
    static testMethod void LBUpdateDescriptionTest() 
    {
         Learning_Board__c lrngBrd1 = new Learning_Board__c();
        lrngBrd1.Name__c = 'LB from Trigger';
        lrngBrd1.Description__c = 'HP Converged Cloud, from Hewlett-Packard, combines software and cloud services into a unified set of packages and under a single unified architecture.[1] It is used by enterprise organizations so they can combine public cloud services with their own internal IT resources to create hybrid clouds, or a mix of different Cloud computing environments made up of private and public clouds';
        insert lrngBrd1; 
        
        Learning_Board__c lrngBrd2= new Learning_Board__c();
        lrngBrd2.Name__c = 'LB1 from Trigger';
        lrngBrd2.Description__c = 'Transform Legacy Applications to cloud';
        insert lrngBrd2;          
    }
}