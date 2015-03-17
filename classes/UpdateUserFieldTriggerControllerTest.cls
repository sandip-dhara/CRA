/**
* Author: Shaijan Thomas
* Date: 13-JULY-2012 
* Requirement # Request Id: 1704(US-0573)
* Description: Test class for UpdateUserTeamsTriggerUtil Class
*/
@isTest(SeeAllData=true)
private class UpdateUserFieldTriggerControllerTest 
{
    public static testMethod void UpdateUserFieldTriggerControllerTest() 
    {        
        Test.startTest();        
        User usr = [Select id from User where Id = :UserInfo.getUserId()];
        Team__c Team = new Team__c();
        Team.Name ='TestTeam';
        Insert Team;
        
        Team__c Team1 = new Team__c();
        Team1.Name ='TestTeam';
        Insert Team1;

        Team_Member__c TM= new Team_Member__c();
        TM.Team__c = Team.Id;
        TM.User__c = usr.Id;
        insert TM;
        update TM;
        Team.Name = 'Team Update';
        update Team;
        
        
        delete TM;
        delete Team1;
        
        //setupDataUpdateUserTeamFieldonupdate();
        //setupDataUpdateUserTeamFieldondelete();
       // setupDataUpdateUserTeamdelete();
        //setupDataUpdateUserTeamUpdate();
        Test.stopTest();
    }
}
   /* private static void setupDataUpdateUserTeamField() 
    {
        List<Team_Member__c > TMNew= New List<Team_Member__c >();
        User usr = [Select id from User where Id = :UserInfo.getUserId()];
       // User usr1 = [select id from user where id !=: UserInfo.getUserId() and Teams__c=''  limit 1];
        Team__c Team = new Team__c();
        Team.Name ='TestTeam';
        Insert Team;

        Team_Member__c TM= new Team_Member__c();
        TM.Team__c = Team.Id;
        TM.User__c = usr.Id;
        TMNew.Add(TM);
        
        
       /* Team_Member__c TM1= new Team_Member__c();
        TM1.Team__c = Team.Id;
        TM1.User__c = usr1.Id;
        TMNew.Add(TM1);

        insert TMNew;           
    }*/
   /* private static void setupDataUpdateUserTeamFieldonupdate() 
    {
        List<Team_Member__c > TMNew= New List<Team_Member__c >();
        List<Team_Member__c > TMOld= New List<Team_Member__c >();

        User usr = [Select id from User where Id = :UserInfo.getUserId()];
        User urs1 = [Select id from User where Id != :usr.Id limit 1];

        Team__c Team = new Team__c();
        Team.Name ='TestTeam';
        Insert Team;

        Team_Member__c TM= new Team_Member__c();
        TM.Team__c = Team.Id;
        TM.User__c = usr.Id;
        Insert TM;

        TMNew.Add(TM);

       // Team_Member__c TM1= new Team_Member__c();
        TM.User__c = urs1.Id;
        TMOld.Add(TM);
        Update TMOld;

       // TMOld.Add(TM);
       // UpdateUserTeamsTriggerUtil.UpdateUserTeamFieldonupdate(TMNew,TMOld);  
    }
    private static void setupDataUpdateUserTeamFieldondelete() 
    {
        List<Team_Member__c > TMOld= New List<Team_Member__c >();
        User usr = [Select id from User where Id = :UserInfo.getUserId()];

        Team__c Team = new Team__c();
        Team.Name ='TestTeam';
        Insert Team;

        Team_Member__c TM= new Team_Member__c();
        TM.Team__c = Team.Id;
        TM.User__c = usr.Id;
        
        Insert TM;
        delete TM;
        TMOld.Add(TM);
        
        UpdateUserTeamsTriggerUtil.UpdateUserTeamFieldondelete(TMOld);  
    }
private static void setupDataUpdateUserTeamdelete() 
    {   
        List<Team__c > TMOld= New List<Team__c >();
        User usr = [Select id from User where Id = :UserInfo.getUserId()];

        Team__c Team = new Team__c();
        Team.Name ='TestTeam';
        Insert Team;

        Team_Member__c TM= new Team_Member__c();
        TM.Team__c = Team.Id;
        TM.User__c = usr.Id;
        
        Insert TM;
        delete Team;
        TMOld.Add(Team);
        UpdateUserTeamsTriggerUtil.UpdateUserTeamdelete(TMOld);  
    }
    private static void setupDataUpdateUserTeamUpdate() 
    {

        List<Team__c > TMNew= New List<Team__c >();
        List<Team__c > TMOld= New List<Team__c >();
        User usr = [Select id from User where Id = :UserInfo.getUserId()];

        Team__c Team = new Team__c();
        Team.Name ='TestTeam';
        Insert Team;
        
        TMNew.Add(Team);

        Team_Member__c TM= new Team_Member__c();
        TM.Team__c = Team.Id;
        TM.User__c = usr.Id;
        Insert TM;

        Team.Name ='TestUpdate';
        Update Team;
        TMOld.Add(Team);
        UpdateUserTeamsTriggerUtil.UpdateUserTeamUpdate(TMNew,TMOld);  
    }*/