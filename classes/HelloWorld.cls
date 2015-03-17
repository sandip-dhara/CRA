public class HelloWorld{
public static void Print()
{
system.debug('Hey Komala! Welcome to the Apex coding');
}
    public void Printing()
    {
        Date objDate=Date.today();
    system.debug('Hey new user you have logged in at '+string.valueOf(objDate));
    }
    
    public List<Integer> GetIds()
    {
    List<integer> lstIds=new List<integer>();
        lstIds.add(1);
        lstIds.add(2);
        lstIds.add(3);
        lstIds.add(4);
        return lstIds;
    }
    
    public void PrintList()
    {
        List<Integer> lstIds=GetIds();
        for(integer i=0;i<lstIds.size();i++)
        {
            system.debug(lstIds.get(i));
        }
    }
}