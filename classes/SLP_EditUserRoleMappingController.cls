public class SLP_EditUserRoleMappingController{

    public string SLPRoleId{
        get
        {
         string strRID='';
        List<ES_User__c> EsU=   [SELECT Id, User_Id__c, Role_ID__c FROM ES_User__c where User_Id__c=:ParamUserId limit 1];
        if(EsU!=null && EsU.size()>0)
        {
         strRID= EsU[0].Role_ID__c;
        }
        return strRID;
          
                
        }
        set;
    }
public Id UserId{get;set;}

public class clsAreaOfFocus
{
  public boolean IsExpert {get;set;}
  public string AreaFocusName {get;set;}
}

Public User GetLoggedinUserDtls(){    
        User u = [Select Name,FullPhotoUrl,id From User where User.id= :UserInfo.getUserId()];
        return U;
    }

public List<SLP_Role__c> LstRoles{get;set;}
public List<SelectOption> LstRolesOption{get;set;}
public Id ParamUserId{get;set;}

Public String getSfInstance{
get{
return ApexPages.currentPage().getHeaders().get('Host');
}
} 

Public ES_User__c GetUserRole
{
get
{
ES_User__c userrole=new ES_User__c ();
try
{
userrole=[select role_id__r.id,role_id__r.name from ES_User__c where user_id__c=:ParamUserId];
}
catch(Exception ex)
{
}
return userrole;
}
set;
}

    Public string GetAvailableExperts
    {
        get
        {
            List<Id> lstIds=new List<Id>();
            List<SLP_Expert__c> lstSlctdExperts=[select SLP_Secondary_Industry_Id__r.id,SLP_Secondary_Industry_Id__r.Secondary_Industry_Name__c,SLP_Secondary_Industry_Id__r.Industry_Name__c from SLP_Expert__c where es_user_id__r.user_id__c=:ParamUserId order by SLP_Secondary_Industry_Id__r.Secondary_Industry_Name__c asc];
            for(SLP_Expert__c expert:lstSlctdExperts)
            {
              lstIds.add(expert.SLP_Secondary_Industry_Id__r.id);
            }
                List<SLP_Secondary_Industry__c> lstAvlblExperts=[select id,Secondary_Industry_Name__c,Industry_Name__c from SLP_Secondary_Industry__c where id not in:lstIds order by Secondary_Industry_Name__c asc];
                string jsonString=JSON.serialize(lstAvlblExperts);
            return jsonString;
        }
        set;
    }

        Public boolean IsLearningBoardCreator
        { 
            get
           { 
                AthenaUserAccess usrAccs=new AthenaUserAccess(); 
                if(usrAccs.IsModerator(UserInfo.getUserId()) || usrAccs.IsProducer(UserInfo.getUserId()) )
                    return true; 
                else
                    return false;
           } 
        }

Public string GetSelectedExperts
{
get
{
List<SLP_Expert__c> lstSlctdExperts=[select SLP_Secondary_Industry_Id__r.id,SLP_Secondary_Industry_Id__r.Secondary_Industry_Name__c,SLP_Secondary_Industry_Id__r.Industry_Name__c from SLP_Expert__c where ES_User_id__r.user_id__r.id=:ParamUserId order by SLP_Secondary_Industry_Id__r.Secondary_Industry_Name__c asc];
JSONGenerator generator = JSON.createGenerator(true);   //instantiation of the generator
string jsonString=JSON.serialize(lstSlctdExperts);
return jsonString;
}
set;
}

  public List<SLP_Expert__c> ExpertSelected
  {
    get
    {
      
       List<SLP_Expert__c> lstSlctdExperts=[select SLP_Secondary_Industry_Id__r.id,Is_Expert__c,SLP_Secondary_Industry_Id__r.Secondary_Industry_Name__c,SLP_Secondary_Industry_Id__r.Industry_Name__c from SLP_Expert__c where ES_User_id__r.user_id__r.id=:ParamUserId order by SLP_Secondary_Industry_Id__r.Secondary_Industry_Name__c asc];
       return lstSlctdExperts;
    }
    set;
  
  }

public class CustomRoles
{
public id UserId{get;set;}
public string UserName{get;set;}
}

Public User GetUserDetails
{
get
{
User usr=[select id,name from user where id=:ParamUserId];
UserId=usr.id;
return usr;
}
set;
}

public SLP_EditUserRoleMappingController()
{
ParamUserId=ApexPages.currentPage().getParameters().get('UserId'); 
LstRolesOption=GetRoles();
}

public List<SelectOption> GetRoles()
{
 List<SelectOption> lstRolesOptions= new List<SelectOption>();       
List<SLP_Role__c> lstRols=[select id,name,role_name__c from SLP_Role__c where Is_Active__c=:True];
lstRolesOptions.add(new SelectOption('','--Select Role--'));
        
        if(lstRols.size()>0)
        {
        for(SLP_Role__c role:lstRols){
            lstRolesOptions.add(new SelectOption(role.id,role.role_name__c==null?'':role.role_name__c));    
        }
        }

        lstRolesOptions.add(new SelectOption('NO','No Roles'));

        return lstRolesOptions;
}

@RemoteAction
    public static void SaveChanges(Id userId,Id roleId,List<clsAreaOfFocus> lstAreaFocus)
    {
    system.debug('lstAreaFocus:'+lstAreaFocus);
    List<ES_User__c> lstRoles=[select id,role_ID__r.id,role_id__c from ES_User__c where User_Id__c=:userId];
    if(lstRoles.size()>0)
    {
    lstRoles[0].Role_ID__c=roleId;
    update lstRoles[0];
    }
    else
    {
    ES_User__c esuser=new ES_User__c();
    esuser.user_id__c=userId;
    esuser.role_id__C=roleId;
    insert esuser;
    }

    if(lstAreaFocus.size()==0)
    {
       List<SLP_Expert__c> lstSLPExperts= [SELECT Id, ES_User_ID__c, SLP_Secondary_Industry_ID__c FROM SLP_Expert__c where es_user_id__r.user_id__c=:userId ];
       delete lstSLPExperts;
    }
    else
    {
    List<ES_User__c> lstEsUsr= [SELECT Id, User_Id__c FROM ES_User__c where User_Id__c=:UserId];
      List<SLP_Secondary_Industry__c> lstSLPSecI= [SELECT Id, Industry_Name__c, Secondary_Industry_Name__c, Is_Active__c FROM SLP_Secondary_Industry__c where Is_Active__c =true];
            Map<string,string> mapExperts=new Map<string,string>();
            List<string> lstslpsExist=new List<string>();
            
            for(SLP_Secondary_Industry__c slpSI:lstSLPSecI)
            {
              mapExperts.put(slpSI.Secondary_Industry_Name__c,slpSI.Id);
              lstslpsExist.add(slpSI.Secondary_Industry_Name__c);
            }
            set<Id> setExistExpertsId=new set<Id>();
            List<string> strExperts=new List<string>();
            for(clsAreaOfFocus caF: lstAreaFocus)
            {
             strExperts.add(caF.AreaFocusName);
            }
            
        List<SLP_Secondary_Industry__c> lstSLPExist=[SELECT Id, Industry_Name__c, Secondary_Industry_Name__c, Is_Active__c FROM SLP_Secondary_Industry__c where Is_Active__c =true and Secondary_Industry_Name__c in:strExperts];
            for(SLP_Secondary_Industry__c SlpSecI:lstSLPExist)
            {
              setExistExpertsId.add(SlpSecI.Id);
            }
            
                system.debug('mapExperts:'+mapExperts);
                List<SLP_Expert__c> lstExp=[SELECT Id, ES_User_ID__c, SLP_Secondary_Industry_ID__c FROM SLP_Expert__c where es_user_id__r.user_id__c=:userId   and SLP_Secondary_Industry_ID__c not in:setExistExpertsId];
                delete lstExp;
                
                List<SLP_Expert__c> lstSLPExp=[SELECT Id, ES_User_ID__c, SLP_Secondary_Industry_ID__c FROM SLP_Expert__c where es_user_id__r.user_id__c=:userId  ];
                Map<string,string> mapSLPExperts=new Map<string,string>();
                for(SLP_Expert__c slpExp:lstSLPExp)
                {
                  mapSLPExperts.put(slpExp.SLP_Secondary_Industry_ID__c,'');
                }
                system.debug('mapSLPExperts:'+mapSLPExperts);
                for(clsAreaOfFocus clsAF:lstAreaFocus)
                {
                string strExt= clsAF.AreaFocusName;
                boolean IsEx=clsAF.IsExpert;
                        string strExp='';
                        if(!mapExperts.containsKey(strExt))
                        {
                            SLP_Secondary_Industry__c slpInd=new SLP_Secondary_Industry__c();
                            slpInd.Secondary_Industry_Name__c=strExt;
                            slpInd.Is_Active__c=true;
                            insert slpInd;
                            strExp=slpInd.Id;
                        }
                        else
                        {
                            strExp= mapExperts.get(strExt);
                        }
                            system.debug('strExp:'+strExp);
                        if(!mapSLPExperts.containskey(strExp))
                        {
                            SLP_Expert__c slpExperts=new SLP_Expert__c();
                            slpExperts.ES_User_ID__c=lstEsUsr[0].Id;
                            slpExperts.SLP_Secondary_Industry_ID__c =strExp;
                            slpExperts.Is_Expert__c=IsEx;
                            system.debug('##'+UserId+'$$'+strExp+'ESS'+lstEsUsr[0].Id);
                            insert slpExperts;
                            system.debug('insert');
                        }
                        else
                        {
                        SLP_Expert__c slpExpertsUpdate=[SELECT Id, ES_User_ID__c, SLP_Secondary_Industry_ID__c, Is_Expert__c FROM SLP_Expert__c where  SLP_Secondary_Industry_ID__c =:strExp and ES_User_ID__c =:lstEsUsr[0].Id limit 1];
                        slpExpertsUpdate.Is_Expert__c=IsEx;
                        update slpExpertsUpdate;
                        }
                    }
    }
    
    
    
      

    }

}