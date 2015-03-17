public with sharing class OPExtensionClass {
public Opportunity_Plan__c opt;
public string OPToolOptCR;
public string s;
public boolean styleVal = True;
public string OPToolMapCP;
public string OPToolMapVP;
public string styleType;
public string OPMapCP;
Public string myParam;
public string prvtab;




public OPExtensionClass(ApexPages.StandardController controller) {
    
    this.opt = (Opportunity_Plan__c)controller.getRecord();
    
/*    s =  'EG' + opt.Opp_Sales_Stage__c;*/
    }

public void OPMapCP1{ get{
    myParam = apexpages.currentpage().getparameters().get('ToolnameCP');
}
set;
}

public string getOPToolOptCR () {

/*s = 'EG' + opt.Opp_Sales_Stage__c + 'CR';*/
s = 'EG';
//OPToolsOptOut__c myCS = OPToolsOptOut__c.getInstance(s);
String myOpt ='No';
/*if ( myCS <> null )
    { myOpt = myCS.optout__c;}
    */
return myopt;
}

public Boolean styletype1 {get
    {
    Opportunity_Plan_Tool_Mapper__c OPToolsMap = Opportunity_Plan_Tool_Mapper__c.getInstance(Opportunity_Plan__c.User_BG__c + '-' + Opportunity_Plan__c.Opp_Sales_Stage__c);
    If(OPToolsMap.Relevant_Tools__c.contains(myParam))
    {styleVal = True;
    system.debug('***Style****'+styletype);
    }
    else
    {styleVal = False;
    system.debug('***Style****'+styletype);
    }
    return styleVal;
    }
    set;
}

public string getOPToolMapCP1 () 
    {
        string customsetting = (User.Business_Group__c + '-' + opt.Id);
        
        Opportunity_Plan__c opt1 = [SELECT Id, Name, Sales_Stage__c, Opp_Sales_Stage__c, User_BG__c FROM Opportunity_Plan__c where id = :opt.Id];
        system.debug('**Custom***'+customsetting);        
        customsetting = (opt1.user_bg__c + '-' + opt1.opp_sales_stage__c);
        system.debug('**Custom 1***'+customsetting);        
        Opportunity_Plan_Tool_Mapper__c OPToolsMap = Opportunity_Plan_Tool_Mapper__c.getInstance(customsetting);
        system.debug('***CSObject***'+OPToolsMap);
        If(OPToolsMap  == null)
        {
        styletype = 'activeTab';
        }
        else
        {
        If(OPToolsMap.Relevant_Tools__c.contains('CP'))
        {styletype = 'active';
        system.debug('***active****');
        }
        else
        {styletype = 'inactive';
        system.debug('***inactive****');
        }
        }
        
        return styletype;
    }
public string getOPToolMapCP () 
    {
        return OpToolMap('CP');
    }
public string getOPToolMapVP () 
    {
        return OpToolMap('VP');
    }
public string getOPToolMapOG () 
    {
        return OpToolMap('OG');
    }
public string getOPToolMapDG () 
    {
        return OpToolMap('DG');
    }
public string getOPToolMapCR () 
    {
        return OpToolMap('CR');
    }
public string getOPToolMapRS () 
    {
        return OpToolMap('RS');
    }
public string getOPToolMapCSP () 
    {
        return OpToolMap('CSP');
    }
public string getOPToolMapDHCL () 
    {
        return OpToolMap('DHCL');
    }
public string getOPToolMapCLSP () 
    {
        return OpToolMap('CLSP');
    }


public string OPToolMap (string tool) 
    {
        string customsetting = (User.Business_Group__c + '-' + opt.Id);
        Opportunity_Plan__c opt1 = [SELECT Id, Name, Sales_Stage__c, Opp_Sales_Stage__c, User_BG__c FROM Opportunity_Plan__c where id = :opt.Id];
        system.debug('**Custom tool***'+tool);        
        customsetting = (opt1.user_bg__c + '-' + opt1.opp_sales_stage__c);
        system.debug('**Custom 1***'+customsetting);        
        Opportunity_Plan_Tool_Mapper__c OPToolsMap = Opportunity_Plan_Tool_Mapper__c.getInstance(customsetting);
        system.debug('***CSObject***'+OPToolsMap);
        If(OPToolsMap  == null)
            {
            styletype = 'active';
            }
        else
            {
            If(OPToolsMap.Relevant_Tools__c.contains(tool))
                {styletype = 'active';
                system.debug('***active****');
                }
            else
                {styletype = 'inactive';
                system.debug('***inactive****');
                }
            }          
        return styletype;
    }
   public string getTabInFocus () {
return prvtab;
}
}