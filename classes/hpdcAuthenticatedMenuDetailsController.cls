public class hpdcAuthenticatedMenuDetailsController {
    
    public List<wrapper> lstWPMenu{get;set;}
    public List<String> lstMenuName{get;set;}
    public String tabName{get;set;}
    public String mainHeading{get;set;}
    public Boolean isSite{get;set;}
         
    public hpdcAuthenticatedMenuDetailsController(){        
        tabName = '';        
        if(hpCommon.GetLoginType() == 'siteuser'){
            isSite = true;
        }else{
            isSite = false;
        }
        if(ApexPages.currentPage().getParameters().get('tab') != null){
            tabName = ApexPages.currentPage().getParameters().get('tab');
            tabName = EncodingUtil.urlDecode(tabName, 'UTF-8');
            tabName = tabName.replace(' ','');
            tabName = tabName.trim();
        }
        if(ApexPages.currentPage().getParameters().get('menu') != null){
            mainHeading = ApexPages.currentPage().getParameters().get('menu');            
            mainHeading = EncodingUtil.urlDecode(mainHeading, 'UTF-8');
        }
        List<HPMenu__c> lstMenu = new List<HPMenu__c>();
        lstMenu = [select id,Name, SubMenuName__c, SubMenu__c, Active__c, Order__c,Description__c from HPMenu__c where SubMenu__r.Name = :mainHeading AND Active__c = true order by Order__c];
        system.debug('!Bingo '+lstMenu);
        lstWPMenu = new List<wrapper>();
        lstMenuName = new List<String>();
        for(HPMenu__c ob: lstMenu){            
            try{
                if(ob.Description__c != null){                
                    wrapper wp = new wrapper();
                    String temp = ob.Name.replace(' ','');
                    lstMenuName.add(temp.trim());                               
                    wp.id = temp.trim();
                    wp.menu = ob.Name;            
                    wp.dscription = ob.Description__c;
                    lstWPMenu.add(wp);                
                }
            }catch(Exception e){
                //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Error: '+e)); 
                system.debug(e);
            }
        }
        system.debug('!Bingo '+lstWPMenu);
    }
    
    public class wrapper{    
        public String id{get;set;}
        public String menu{get;set;}
        public String dscription{get;set;}                  
    }   
}