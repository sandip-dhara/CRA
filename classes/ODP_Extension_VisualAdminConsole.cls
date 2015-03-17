public class ODP_Extension_VisualAdminConsole {

    public String test{get;set;}
    public User LoggedUser{get;set;}
    public ODP_Extension_VisualAdminConsole(ApexPages.StandardController controller) {
        
        LoggedUser = [select id, smallphotourl, email, name from User where id=:UserInfo.getUserId()];
    }

}