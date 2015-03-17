public class scheduleJob{
    
    public void sccheduleJob(){
        try{
            Scheduler_class.scheduleMe();
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,'Record Saved Sucessfully')); 
        }
        catch(Exception e){
            String error = e.getMessage();
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,error));        
        }                       
    }
}