public class MaheshPOC {
public String val{get;set;}

    public void echoVal()
    {
     val = 'You have entered : 1 - '+Apexpages.currentPage().getParameters().get('firstParam')+' 2 -'+Apexpages.currentPage().getParameters().get('secondParam');
    }
}