/*************************
* Class : OpportunityBlacklistingTest
*Author : Abrar
*Description : Test Class for OpportunityBlacklisting
**************************/
@isTest(SeeAllData=True)
public class OpportunityBlacklistingTest
{
private static Opportunity blacklistOpportunity;
private static Opportunity blacklistOpportunitygeneral;
private static List<Opportunity> opList = new List<Opportunity>();
private static List<Opportunity> opList2 = new List<Opportunity>();
private static feeditem opfeed=new feeditem();
private static feedcomment opfeedcomment=new feedcomment();


Public static void SetupData()
{
Account blacklistAccount = new Account(Name='TestAccountBlacklist',Confidential_Account__c=True,Blacklist_Type__c='UK Public Sector',Source_System_Account_ID__c='sa1231' );
insert blacklistAccount ;
blacklistOpportunity = new Opportunity();
blacklistOpportunity.Name = 'JaguarOpty';
blacklistOpportunity.AccountId = blacklistAccount.Id;
blacklistOpportunity.Description= 'JaguarOpty';
blacklistOpportunity.Opportunity_Update__c= 'JaguarOpty';
blacklistOpportunity.StageName= '01 - Understand Customer';
blacklistOpportunity.CurrencyIsoCode= 'USD';
blacklistOpportunity.CloseDate = System.Today()+30;
insert blacklistOpportunity;
Blacklisted_Word__c blacklistWords = new Blacklisted_Word__c();
Blacklisted_Word__c blacklistWords1 = new Blacklisted_Word__c();
blacklistWords.Word__c = 'Jaguar';
blacklistWords.RegexValue__c ='\b([j|J][a|A][g|G][u|U][a|A][r|R])\b';
blacklistWords.Add_to_Compliance_Audit__c=TRUE;
blacklistWords.Prevent_Post_on_Breach__c=FALSE;
blacklistWords.Custom_Expression__c='';
blacklistWords.is_Active__c=True;
blacklistWords.Type__c = 'UK Public Sector';
blacklistWords.Substitution__c='****';
opList.add(blacklistOpportunity);
insert blacklistWords;
blacklistWords1.Word__c= 'rusky';
blacklistWords1.RegexValue__c='\b([r|R][u|U][s|S][k|K][y|Y])\b';
blacklistWords1.Add_to_Compliance_Audit__c=TRUE;
blacklistWords1.Prevent_Post_on_Breach__c=FALSE;
blacklistWords1.Custom_Expression__c='';
blacklistWords1.is_Active__c=True;
blacklistWords1.Type__c = 'UK Public Sector';
blacklistWords1.Substitution__c='****';
//insert blacklistWords1;
}

Public static void SetupData2()
{
Account blacklistAccountgeneral = new Account(Name='TestAccountBlacklistgeneral',Source_System_Account_ID__c='sa1231' );
insert blacklistAccountgeneral ;
blacklistOpportunitygeneral = new Opportunity();
blacklistOpportunitygeneral.Name = 'JaguarOptyRover';
blacklistOpportunitygeneral.AccountId = blacklistAccountgeneral.Id;
blacklistOpportunitygeneral.Description= 'JaguarOptyRover';
blacklistOpportunitygeneral.Opportunity_Update__c= 'JaguarOptyRover';
blacklistOpportunitygeneral.StageName= '01 - Understand Customer';
blacklistOpportunitygeneral.CurrencyIsoCode= 'USD';
blacklistOpportunitygeneral.CloseDate = System.Today()+30;
insert blacklistOpportunitygeneral;
Blacklisted_Word__c blacklistWordsgeneral = new Blacklisted_Word__c();
blacklistWordsgeneral.Word__c = 'Rover';
blacklistWordsgeneral.is_Active__c=True;
blacklistWordsgeneral.Substitution__c='****';
opList2.add(blacklistOpportunitygeneral);
}

      public static testMethod void positiveTest()
      {
       Test.startTest();
       SetupData();
       opfeed.parentId=blacklistOpportunity.Id;
       opfeed.body='Jaguar';
       insert opfeed;
       //opfeedcomment.FeedItemId=opfeed.Id;
       //opfeedcomment.CommentBody='Jaguar';
       //insert opfeedcomment;
       Opportunityblacklisting opblacklisting=new Opportunityblacklisting();
       system.debug(opList);
       opblacklisting.filterwords(opList);
       //FeedItemBlacklisting opfeedblacklisting=new FeedItemBlacklisting();
       //opfeedblacklisting.filterwords(opfeed);
       //opfeedblacklisting.filterwords(opfeedcomment);
       }
       
       public static testMethod void positiveTest2()
      {
       Test.startTest();
       SetupData2();
       Opportunityblacklisting opblacklisting2=new Opportunityblacklisting();
       opblacklisting2.filterwords(opList2);
       }
       
}