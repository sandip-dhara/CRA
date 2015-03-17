@isTest(SeeAllData=true)
public class RelDelContTestSuite{
    
    /*public static testMethod void testRelDelContNew(){

        test.StartTest();
        // release Deliverable id : a76Z00000004E4Q
        string CurReleaseDeliverableId =  'a76Z00000004E4Q';              
        Release_Deliverable__c rd =  [select Id,Name, Offering_Release_Stage_ID__c, Stage_Name__c,Release_Deliverable_Name__c from Release_Deliverable__c where id=:CurReleaseDeliverableId];
        Id rd_id = rd.Id;
        User testuser =  [select Id from User Where Username = 'shi-yong.chen@hp.com.esit' limit 1];
        Id userid= testuser.Id;              
        Release_Deliverable_Contributor__c testrdc = new Release_Deliverable_Contributor__c(Release_Deliverable_ID__c = rd_id ,Contributor__c = userid );        
        ApexPages.StandardController sc = new ApexPages.standardController(testrdc );        
        ExtendedRelDelCont e = new ExtendedRelDelCont(sc);
        e.getSortDirection();       
        e.RDCSearch();
        e.RDCSearchOrderByRname();  
        e.ShowByID(); 
        e.ValidateRelDelCont(testrdc) ;        
        e.save();
        e.doSaveAndNew();
        System.assertEquals(e.reldelcont,testrdc );
        test.StopTest();

    }
  
    public static testMethod void testRelDelContExtensionNewFromRD(){

        test.StartTest();
        User testuser =  [select Id from User Where Username = 'shi-yong.chen@hp.com.esit' limit 1];
        Id userid= testuser.Id;    
        Release_Deliverable_Contributor__c testrdc = new Release_Deliverable_Contributor__c(Contributor__c = userid );        
        
        ApexPages.currentpage().getparameters().put('CF00NZ000000135Yh' , 'RD-0001');
        ApexPages.StandardController sc = new ApexPages.standardController(testrdc);
        ExtendedRelDelCont e = new ExtendedRelDelCont(sc);
        e.getSortDirection();     
        e.RDCSearch();
        e.RDCSearchOrderByRname();  
        e.ShowByID(); 
        e.ValidateRelDelCont(testrdc) ;        
        e.save();
        e.doSaveAndNew();
        System.assertEquals(e.reldelcont,testrdc );
        test.StopTest();
    }
     
        public static testMethod void testRelDelContExtensionUpdate(){

        test.StartTest();
        string upId = 'a7FZ00000004Ddf';
        Release_Deliverable_Contributor__c testrdc = Database.query(PLMTransferTools.CreateQueryAllFieldsSOQL('Release_Deliverable_Contributor__c') + ' where id=:upId');
        ApexPages.currentpage().getparameters().put('id' , upId);
        ApexPages.StandardController sc = new ApexPages.standardController(testrdc);
        ExtendedRelDelCont e = new ExtendedRelDelCont(sc);
        e.getSortDirection();  
        e.RDCSearch();
        e.RDCSearchOrderByRname();  
        e.ShowByID();     
        e.save();
        e.ValidateRelDelCont(testrdc) ;       
        e.doSaveAndNew();
        System.assertEquals(e.reldelcont,testrdc);
        
        
        test.StopTest();

    }
   
*/
}