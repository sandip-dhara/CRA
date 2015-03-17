/**
 * Class Name: DealReg_CampaignBeforeUpdateContrlrTest
 * Author: HP
 * Date: 18-Oct-2012 
 * Requirement # Request Id:3396 
 * Description: Test Class which covers DealReg_CampaignBeforeUpdateController,DealReg_ProgProductTriggerController- classess and 
 * Trigger-DealRegCheckAllProductElligibleField  
 * Trigger-DealRegProgProdBeforeInsert
 * Trigger-DealRegProgProdBeforeUpdate
 */
@IsTest
private class DealReg_CampaignBeforeUpdateContrlrTest{

    static testMethod void testCase(){
        /*Setup Data For Profile*/
        Profile prof = [select id from Profile WHERE Name LIKE '%IT Administrator%' limit 1];
         Profile internalProfile = [SELECT Id FROM Profile WHERE Name LIKE '%IT Administrator%' Limit 1];
               UserRole testRole=[SELECT id from UserRole where portalrole =null  limit 1];
               User testUser = new User(ProfileId = internalProfile.id,
                                        LastName = 'Test13', 
                                        FirstName = 'Test13', 
                                        Username = 'testing13@hp.com', 
                                        Alias='test13', 
                                        CommunityNickname='test Approve13', 
                                        Email='test13@hp.com',
                                        TimeZoneSidKey='America/Chicago',
                                        EmailEncodingKey='ISO-8859-1', 
                                        LanguageLocaleKey='en_US', 
                                        LocaleSidKey='en_US',
                                        IsActive=True,
                                        Email_Address__c='test13@hp.com',
                                        EmployeeNumber='653486625',
                                        Legacy_Employee_Ref__c='14875465',
                                        UserRoleId =testRole.id,
                                        Adoption_Role_Type__c = 'IT'
                                        );
                insert testUser; 
                System.RunAs(testUser){
        /*Setup Data to insert User*/    
        User approverUser = new User(ProfileId = prof.id,LastName = 'Test', FirstName = 'Test',Adoption_Role_Type__c = 'IT', Username = 'testing456@hp.com', Alias='test', CommunityNickname='test Approve', Email='test@hp.com',TimeZoneSidKey='America/Chicago',EmailEncodingKey='ISO-8859-1', LanguageLocaleKey='en_US', LocaleSidKey='en_US',IsActive=false,Email_Address__c='test@hp.com',EmployeeNumber='6534866',Legacy_Employee_Ref__c='487547');
        Insert approverUser ;
        /*Setup Data To select Recordtype of Program Partner*/
        Id record=RecordTypeIdHelper.getRecordTypeId('Campaign','Partner Program'); 
        //Recordtype record=[Select Id, Name from Recordtype where  Name LIKE  '%Partner Program%'];
        /*Setup Data To Insert Campaign*/
        Campaign camp = new Campaign ();
        camp.Name='Partner for Growth Test1';
        camp.Level_1_Approver_1__c=approverUser.ID;
        camp.All_Products_Eligible__c='No';
        camp.RecordTypeId=record;
        camp.StartDate=system.today();
        insert camp ;
        /*Setup Data To insert Product */
        Product2 prod = new Product2();
        prod.Name='TestProduct';
        prod.Product_Line__c='ProductLine';
        insert prod;
        product2 prodnew = new product2();
        prodnew.Name='TestProduct2';
        prodnew.Product_Line__c='ProductLine2';
        insert prodnew;
        /*Setup Data To insert Program Product Assocoation*/        
        Program_Product_Association__c progProd = new Program_Product_Association__c();
        progProd.Product__c=prod.Id;
        progProd.Program__c=camp.Id;
        insert progProd ;
        /*Setup Data to update campaign All Products Eligible field to Yes to check for validation*/
        camp.All_Products_Eligible__c='Yes';
        try{
            update camp;
        }catch(Exception e){
            System.debug('Product Program Association already exixts, please delete');
        }
        /*Setup Data To insert Program Product Assocoation to check duplicate association*/          
        Program_Product_Association__c progProdDuplicate = new Program_Product_Association__c();
        progProdDuplicate.Product__c=prod.Id;
        progProdDuplicate.Program__c=camp.Id;
        try{
            insert progProdDuplicate;
        }catch(Exception e){
            System.debug('Product Program Association already exixts');
        }
        /*Setup Data To update Program Product Assocoation to check update functionality*/          
        progProd.Product__c=prodnew.Id;
        update progProd;
        /*Setup Data To insert Camapaign to check recordtype validation*/          
        Campaign campCheckElligibleFlag = new Campaign ();
        campCheckElligibleFlag.Name='Partner for Growth Test2';
        campCheckElligibleFlag.Level_1_Approver_1__c=approverUser.ID;
        campCheckElligibleFlag.All_Products_Eligible__c='Yes';
        campCheckElligibleFlag.StartDate=system.today();
        insert campCheckElligibleFlag;
        /*Setup Data To insert Program Product Assocoation to check recordtype validation*/          
        Program_Product_Association__c ProdDuplicate = new Program_Product_Association__c();
        ProdDuplicate.Product__c=prod.Id;
        ProdDuplicate.Program__c=campCheckElligibleFlag.Id;
        try{
            insert ProdDuplicate;
        }catch(Exception e){
            System.debug('This program is applicable for all products, no need of asscocation');
        }
        /*Setup Data To check mute trigger validation*/          
        Global_Config__c globalConfig = new Global_Config__c(); 
        globalConfig.Mute_Triggers__c = True;
        insert globalConfig; 
        Campaign campMute = new Campaign ();
        campMute.Name='Partner for Growth Test3';
        campMute.Level_1_Approver_1__c=approverUser.ID;
        campMute.All_Products_Eligible__c='Yes';
        campMute.StartDate=system.today();
        insert campMute;
        update campMute;
        Program_Product_Association__c ProdMute = new Program_Product_Association__c();
        ProdMute.Product__c=prod.Id;
        ProdMute.Program__c=campCheckElligibleFlag.Id;
        try{
            insert ProdMute;
        }catch(Exception e){
            System.debug('This program is applicable for all products, no need of asscocation');
        }
        update ProdMute;
                }
    }

}