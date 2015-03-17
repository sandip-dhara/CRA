public class DemoInsertclass{
    public void demoInsertMethod(){
         SLP_Process_Onboarding_User__c slpProcess = new SLP_Process_Onboarding_User__c();
            slpProcess.Email__c = 'demo@hp.com';
            slpProcess.SLP_BulkReg_Id__c='a8uZ0000000CnOAIA0';
            //insert slpProcess;            
            Database.SaveResult lstUpdateProfile = Database.insert(slpProcess, false);
            
        List<SLP_Process_Onboarding_User__c> slpPrOnboarding = [select Email__c,SLP_BulkReg_Id__c from SLP_Process_Onboarding_User__c where id = 'a8uZ0000000CnOAIA0']; 
         for(SLP_Process_Onboarding_User__c slp : slpPrOnboarding){
            slp.Email__c = 'imransk@gmail.com';
         }
         //update slpPrOnboarding;       
         Database.SaveResult[] lstUpdateProfile1 = Database.Update(slpPrOnboarding, false);
         
         User userObject = new User();

            userObject.Id = '005Z00000025ZU5';
            userObject.email = 'ishaik@hp.com';
            userObject.Isactive = true;
            userObject.email_address__c = 'ishaik@hp.com';
            userObject.username = 'ishaik@hp.com' + '.esit';
            userObject.federationidentifier = 'ishaik@hp.com';            
            userObject.digestfrequency = 'N';
            userObject.userpreferencesdisableallfeedsemail = true;
            userObject.FirstName = 'Imran';
            userObject.LastName = 'sk';
            userObject.Alias = 'ishaik';                
            userObject.legacy_employee_ref__c = '2206399';
            userObject.ProfileId = '00ed0000000dmuj';
            userObject.UserPreferencesDisableAllFeedsEmail  = true;
        //update userObject;
        Database.SaveResult lstUpdateProfile2 = Database.Update(userObject, false);
    }
}