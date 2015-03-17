public class OpportunitySourceHandler
{
    private static boolean bCurrentExecution = false ;
    
    public static void setCurrentExecution(boolean bIn)
    {
        bCurrentExecution  = bIn;
    }
    
    public static boolean getCurrentExecution()
    {
        return bCurrentExecution;
    }
    
}