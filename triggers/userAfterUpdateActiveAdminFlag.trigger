trigger userAfterUpdateActiveAdminFlag on User (After update) 
{
    List<User> newTempUsr = Trigger.new;
    List<User> oldTempUsr = Trigger.old;
    boolean usrAutomationReqd = false;
    for(User newUsr : newTempUsr)
    {
        for(User oldUsr : oldTempUsr)
        {
            if(newUsr.id == oldUsr.id)
            {
                if(newUsr.IsActive != oldUsr.IsActive )
                {
                    usrAutomationReqd = true;
                }
            }
        }
    }
    if(usrAutomationReqd)
    {
        if(Trigger.isUpdate && Trigger.isAfter) 
        {       
           List<Id> usrID = new List<Id>();
           for(User user : trigger.new )
           {
               usrID.add(user.id);
           }
           UserAutomation.afterUpdateDeleteLocPartUser(usrID,true,false,false,false);
           UserAutomation.afterUpdateDeleteLocPartUser(usrID,false,true,false,false);
           UserAutomation.afterUpdateDeleteLocPartUser(usrID,false,false,true,false);
           UserAutomation.afterUpdateDeleteLocPartUser(usrID,false,false,false,true);
        }   
    }
}