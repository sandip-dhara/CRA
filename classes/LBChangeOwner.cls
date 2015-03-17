public class LBChangeOwner {

public Learning_Board__C LB
{
get{
  Learning_Board__C lrngBrd=[Select ownerid,Name__c from learning_Board__c where id='a6tZ00000008RHR'];
  return lrngBrd;
  }
}
public void ChangeOwner(){
system.debug(' Change Owner Id' + LB.ownerid);
}    
    
}