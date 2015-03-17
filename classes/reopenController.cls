public class reopenController 
{
        List<Case> Caseber =new List<Case>();
    List<Case> Caseins =new List<Case>();
    
    private final Case cas;
    
    public reopenController(ApexPages.StandardController stdController) {
        this.cas= (Case)stdController.getRecord();
    }


    public reopenController()
    {

        Caseber= [SELECT CaseNumber,Status,ClosedDate,IsEscalated,LastModifiedDate,Origin,SystemModstamp
                                     FROM Case where Status = 'Resolved' and SystemModstamp = THIS_WEEK];
        if (Caseber.size()>0)
        {
            for(Case ca: Caseber)
            {
            ca.Status='Re-Open';
            Caseins.add(ca);
            insert Caseins;
            }
        }
    }



}