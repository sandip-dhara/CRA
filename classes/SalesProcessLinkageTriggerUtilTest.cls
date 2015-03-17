/**********************************************************
* Class Name: SalesProcessLinkageTriggerUtilTest
* Author: Accenture
* Date: 24-APR-2012 
* Description: This class does the test coverage for SalesProcessLinkageTriggerUtil class.
***********************************************************/
@isTest
private class SalesProcessLinkageTriggerUtilTest{
    static Sales_Process_Linkage__c  salesLinkage;
    static Opportunity opty;
    

    public static void setupData() {
        //Fetching record type id for Account Creation
        String RecordTypeId ='';
        try{
            RecordTypeId = RecordTypeIdHelper.getRecordTypeId('Account','Customer');
        }catch(Exception e){
            System.debug('Exception:'+e.getMessage());
        }
        //Create a test account
        Account acc = new Account();
        acc = TestingSetupDataUtil.createAccount('testAccount', 'testAccount@acc.com', 'Customer');
        insert acc;
        System.assertEquals(acc.Id != null,true);
        //create a test opportunity
        opty=new Opportunity();  
        opty = TestingSetupDataUtil.createOpportunity(acc.Id, 'Opty999zzz', System.Today()+30);
        insert opty;
        System.assertEquals(opty.Id != null,true);
        //create a test sales process linkage
        salesLinkage = new Sales_Process_Linkage__c();
        salesLinkage = TestingSetupDataUtil.createSalesProcessLinkage(opty.Id);
        insert salesLinkage;
        System.assertEquals(salesLinkage.Id != null,true);
    }
    
    static testMethod void SalesProcessInsertPositiveTest() {
        setupData();
        Sales_Process_Linkage__c fetchedsalesLinkage = [select id,Unique_SalesLinkage_ID__c from Sales_Process_Linkage__c where id=:salesLinkage.id];
        System.assertNotEquals('',fetchedsalesLinkage.Unique_SalesLinkage_ID__c);
    }
    
    static testMethod void SalesProcessUpdatePositiveTest() {
        setupData();
        //create unique id
        String randomstr = Math.round(Math.random()*Math.pow(10, 7))+'';
        String salesId ='';
        if(randomstr!=null){
            if(randomStr.length()>6){
                salesId = randomstr.substring(0,6);
            }else{
                salesId = randomstr.substring(0,randomstr.length()-1);
            }
        }
        salesLinkage.ID__c =salesId ;
        update salesLinkage;
        System.assertEquals(salesLinkage.ID__c == salesId , true); 
        //fetch updated record
        Sales_Process_Linkage__c fetchedsalesLinkage = [select id,Unique_SalesLinkage_ID__c from Sales_Process_Linkage__c where id=:salesLinkage.id];
        String createdLinkageID = opty.id+'-'+'Eclipse'+'-'+salesId ;
        
        //check test createdlinkageId is equal with trigger generated id
        //System.assertEquals(createdLinkageID,fetchedsalesLinkage.Unique_SalesLinkage_ID__c);
    }
}