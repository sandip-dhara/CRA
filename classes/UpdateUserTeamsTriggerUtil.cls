/**
* Author: Shaijan Thomas
* Date: 13-JULY-2012 
* Requirement # Request Id: 1704(US-0573)
* Description: All the changes in Team and Team Member Objects are evaluated here
*/
public class UpdateUserTeamsTriggerUtil
{
    public static void UpdateUserTeamField(List<Team_Member__c > TeM) 
    {
       /* // Update user team field on insert of a record in Team Member Object.
        for(Team_Member__c tm:TeM)
        {
            if((tm.Team__c != null) && (tm.User__c != null))
            {
                List<User> TeamUser= new List<User>([select id,Name, Teams__c from User where id =:tm.User__c]);
                for (User TU: TeamUser)
                {
                    if (tm.User__c == TU.Id)
                    {
                        List<Team__c> Team = new List<Team__c>([select Name from Team__c where Id =: tm.Team__c]);
                        for (Team__c Te: Team)
                        {
                            system.debug('TU.Speciality : ' + TU.Teams__c +' === Name : ' + te.Name);
                            if(TU.Teams__c != null)
                            {
                                if(TU.Teams__c.contains(te.Name) == true){}
                                Else
                                {
                                    TU.Teams__c = TU.Teams__c + ',' + te.Name ;
                                }
                            }
                            else
                            {
                                TU.Teams__c = te.Name ;
                            }
                        }
                        system.debug('****TeamUser*****'+TeamUser);
                    update TeamUser;            
                    }
                }
            }
        }*/
    }
    public static void UpdateUserTeamFieldonupdate(List<Team_Member__c > NewOne,List<Team_Member__c > Old) 
    {
       /* // Update user team field on Update of a record in Team Member Object.- For New Value
        for(Team_Member__c tm:NewOne)
        {
            if((tm.Team__c != null) && (tm.User__c != null))
            {
                List<User> TeamUser= new List<User>([select id,Name, Teams__c from User where id =: tm.User__c]);
                for (User TU: TeamUser)
                {   
                    if (tm.User__c == TU.Id)
                    {
                        List<Team__c> Team = new List<Team__c>([select Name from Team__c where Id =: tm.Team__c]);
                        for (Team__c Te: Team)
                        {
                            system.debug('TU.Speciality : ' + TU.Teams__c +' === Name : ' + te.Name);
                            if(TU.Teams__c != null)
                            {
                                if(TU.Teams__c.contains(te.Name) == true){}
                                Else
                                {
                                    TU.Teams__c = TU.Teams__c + ',' + te.Name ;
                                }                               
                            }
                            else
                            {
                                TU.Teams__c = te.Name ;
                            }
                        }   
                        update TeamUser;            
                    }
                }
            }  
        }
        //  // Update user team field on Update of a record in Team Member Object.- for Old value
        for(Team_Member__c tm:Old)
        {
            List<Team_Member__c> TeamM = new List<Team_Member__c> ([Select id,Team__c, User__c from Team_Member__c where 
            (User__c =: tm.User__c) and (Team__c =: tm.Team__c)]);
            System.Debug('Team Size = '+TeamM.size());
            if(TeamM.size()<=0)
            {
                List<User> TeamUser= new List<User>([select id,Name, Teams__c from User where id =: tm.User__c]);
                for (User TU: TeamUser)
                {
                    system.debug('TU.Id=' + TU.Id);
                    if (tm.User__c == TU.Id)
                    {
                        List<Team__c> TeamName = new List<Team__c>([select Name from Team__c where Id =: tm.Team__c]);
                        for (Team__c TN: TeamName)
                        {
                            if(TU.Teams__c != null)
                            {
                                if(TU.Teams__c.contains(TN.Name) == true)
                                {
                                    TU.Teams__c = TU.Teams__c.replace(TN.Name+',','');
                                    TU.Teams__c = TU.Teams__c.replace(','+TN.Name,'');
                                    TU.Teams__c = TU.Teams__c.replace(TN.Name,'');
                                }
                                update TeamUser;
                            }
                        }     
                    }
                } 
            }
        }*/
    }
    public static void UpdateUserTeamFieldondelete(List<Team_Member__c > Old) 
    {
       /* for(Team_Member__c tm:Old)     
        {
          // Delete user team field value on delete of a record in Team Member Object.
            List<Team_Member__c> TeamM = new List<Team_Member__c> ([Select id,Team__c, User__c from Team_Member__c where 
            (User__c =: tm.User__c) and (Team__c =: tm.Team__c)]);
            System.Debug('Team Size = '+TeamM.size());
            if(TeamM.size()<=0)
            {
                List<User> TeamUser= new List<User>([select id,Name, Teams__c from User where id =: tm.User__c]);
                for (User TU: TeamUser)
                {
                    system.debug('TU.Id=' + TU.Id);
                    if (tm.User__c == TU.Id)
                    {
                        List<Team__c> TeamName = new List<Team__c>([select Name from Team__c where Id =: tm.Team__c]);
                        for (Team__c TN: TeamName)
                        {
                            if(TU.Teams__c != null)
                            {
                                if(TU.Teams__c.contains(TN.Name) == true)
                                {
                                    TU.Teams__c = TU.Teams__c.replace(TN.Name+',','');
                                    TU.Teams__c = TU.Teams__c.replace(','+TN.Name,'');
                                    TU.Teams__c = TU.Teams__c.replace(TN.Name,'');
                                }
                                update TeamUser;
                            }
                        }     
                    }
                }  
            }
        }*/
    }
    public static void UpdateUserTeamdelete(List<Team__c> Te) 
    {
    /* // Update user team field on Delete of a record in Team Object.
        for(Team__c t:Te)
        {
            List<Team_Member__c> TeamM= new List<Team_Member__c>([select id,User__c,Team__c from Team_Member__c 
            where Team__c =: t.Id]);
            System.debug('Team Size = '+TeamM.size());
            for (Team_Member__c TM: TeamM)
            {
                if((tm.Team__c != null) && (tm.User__c != null))
                {
                    List<User> TeamUser= new List<User>([select id,Name, Teams__c from User where id=:tm.User__c]);
                    for (User TU: TeamUser)
                    {
                        if (tm.User__c == TU.Id)
                        {
                            if(TU.Teams__c!= null)
                            {
                                if(TU.Teams__c.contains(T.Name) == true)
                                {
                                    TU.Teams__c= TU.Teams__c.replace(T.Name+',','');
                                    TU.Teams__c= TU.Teams__c.replace(','+T.Name,'');
                                    TU.Teams__c= TU.Teams__c.replace(T.Name,'');
                                }
                                update TeamUser;
                            }     
                        }
                    }
                }
            }
        }*/
    }
    public static void UpdateUserTeamUpdate(List<Team__c > TeNew, List<Team__c > TeOld) 
    {
 /*// Update user team field on Update of a record in Team Object.
        for(Team__c t1:TeOld)
    {
    for(Team__c t:TeNew)
    {
        List<Team_Member__c> TeamM= new List<Team_Member__c>([select id,User__c,Team__c from Team_Member__c 
        where Team__c =: t.Id]);
        System.debug('Team Size='+TeamM.size());
        for (Team_Member__c TM: TeamM)
        {
            if((tm.Team__c != null) && (tm.User__c != null))
            {
                List<User> TeamUser= new List<User>([select id,Name, Teams__c from User where id=:tm.User__c]);
                for (User TU: TeamUser)
                {
                    if (tm.User__c == TU.Id)
                    {
                        if(TU.Teams__c != null)
                        {
                            if(TU.Teams__c.contains(t1.name) == true)
                            {
                                TU.Teams__c = TU.Teams__c.replace(t1.name ,t.name );
                            }
                            update TeamUser;
                        }     
                    }
                }
            }
        }
    }
}*/
    }
}