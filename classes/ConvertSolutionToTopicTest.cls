@isTest
private class ConvertSolutionToTopicTest {

    public static testmethod void DoTest(){
 
        ApexPages.StandardController stdController;
        
        ConvertSolutionToTopic cls = new ConvertSolutionToTopic(stdController); 
        
        cls.Topic.GETSAT_TOPIC__Style__c = 'Idea';
        cls.Topic.GETSAT_TOPIC__Subject__c = 'Test123';
        cls.Topic.GETSAT_TOPIC__Description__c = 'Test456';
        cls.Topic.GETSAT_TOPIC__Tags__c = 'Test';
        
        Pagereference pr = cls.DoSubmit();
        
        
        for(GETSAT_TOPIC__Topic__c tp : [Select Id, GETSAT_TOPIC__Subject__c,GETSAT_TOPIC__Description__c From GETSAT_TOPIC__Topic__c order by CreatedDate DESC Limit 1 ]){
            
            
            system.assertEquals(tp.GETSAT_TOPIC__Subject__c, 'Test123');
            
            system.assertEquals(tp.GETSAT_TOPIC__Description__c, 'Test456');
            
              
        }
        
    }
    
}