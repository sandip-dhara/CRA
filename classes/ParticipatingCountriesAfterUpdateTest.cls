@isTest(SeeAllData=True)
public class ParticipatingCountriesAfterUpdateTest{
static Opportunity newOpty;

      
        static testmethod void testParticipatingCountriesAfterInsertUpdateTrigger(){  
        
        Account acc=TestingSetupDataUtil.createAccount('Test','test@abc.com','Customer');
        insert acc;
        
        //Insert Opportunity
        Opportunity opty = new Opportunity(AccountId = acc.id, StageName = '01 - Understand Customer', Name = 'abc', CloseDate = system.today());
        insert opty;
        
        System.runAs(TestingSetupDataUtil.testUser) {
        test.startTest();    
        
         /*List<MN_Opportunities_Information__c> PC=new List<MN_Opportunities_Information__c>();
         MN_Opportunities_Information__c newPC1 = new MN_Opportunities_Information__c(Region__c = 'Americas');             
         update newPC1;
         Delete newPC1;*/
       
         //Insert Participating Countries  
         MN_Opportunities_Information__c newPC1 = new MN_Opportunities_Information__c(Region__c = 'Americas',Country__c = 'chile',Multinational_OppMultinational_Oortunity__c = opty.id );      
         Insert newPC1;
         
         MN_Opportunities_Information__c newPC2 = new MN_Opportunities_Information__c(Region__c = 'EMEA',Country__c = 'Italy',Multinational_OppMultinational_Oortunity__c = opty.id );      
         Insert newPC2;
        
         
         List<MN_Opportunities_Information__c> PC=new List<MN_Opportunities_Information__c>();
         MN_Opportunities_Information__c newPC3 = new MN_Opportunities_Information__c(Region__c = 'Americas',Country__c = 'canada',Multinational_OppMultinational_Oortunity__c = opty.id );      
         newPC3.Region__c = 'Americas';
         PC.add(newPC3);
         
         
         MN_Opportunities_Information__c newPC4 = new MN_Opportunities_Information__c(Region__c = 'Asia Pacific',Country__c = 'china',Multinational_OppMultinational_Oortunity__c = opty.id );      
         newPC4.Region__c = 'EMEA';
         PC.add(newPC4);
        
         
         MN_Opportunities_Information__c newPC5 = new MN_Opportunities_Information__c(Region__c = 'Asia Pacific',Country__c = 'India',Multinational_OppMultinational_Oortunity__c = opty.id );      
         newPC5.Region__c = 'Asia Pacific';
         PC.add(newPC5);
         
         MN_Opportunities_Information__c newPC7 = new MN_Opportunities_Information__c(Region__c = 'EMEA',Country__c = 'Albania',Multinational_OppMultinational_Oortunity__c = opty.id );      
         newPC7.Region__c = 'EMEA';
         PC.add(newPC7);
         Insert PC;
        
         //Duplicate Countries
         MN_Opportunities_Information__c newPC6 = new MN_Opportunities_Information__c(Region__c = 'Asia Pacific',Country__c = 'Japan',Multinational_OppMultinational_Oortunity__c = opty.id );      
         newPC6.Region__c = 'Asia Pacific';
         PC.add(newPC6);
         Insert newPC6;
         newPC6.Country__c = 'Australia';
         update newPC6;
         
         
         Delete newPC1;
         Delete newPC2;
         
         test.stopTest();              
             
    }
    }   
    }