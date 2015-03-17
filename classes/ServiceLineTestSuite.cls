@isTest(SeeAllData=true)
public class ServiceLineTestSuite{
    
    public static testMethod void testServiceLineCreate(){

        test.StartTest();
        
        Service_Line__c v_SLC = new Service_Line__c(Name__c = 'test', Short_Description__c = 'test');
        insert v_SLC;
        ApexPages.StandardController sc = new ApexPages.standardController(V_SLC);
        ExtendedServiceLinesClass e = new ExtendedServiceLinesClass(sc);        
        e.save();
        e.DoSaveNew();
        System.assertEquals(e.SLC,V_SLC);
        
        test.StopTest();

    }
    
    public static testMethod void testServiceLineUpdate(){

        test.StartTest();
        
        String upId = 'a6vZ00000008WVJ';
        
        Service_Line__c v_SLC = Database.query(PLMTransferTools.CreateQueryAllFieldsSOQL('Service_Line__c') + ' where id=:upId');
        
        //upsert v_SLC;
        ApexPages.currentpage().getparameters().put('id' , upId);
        ApexPages.StandardController sc = new ApexPages.standardController(V_SLC);
        ExtendedServiceLinesClass e = new ExtendedServiceLinesClass(sc);        
        e.save();
        e.DoSaveNew();
        System.assertEquals(e.SLC,V_SLC);
        
        test.StopTest();

    }    
}