global class SLP_ExportToExcels {

    global class GenerateExportToExcel
    {
      public string FirstName {get;set;}
      public string LastName {get;set;}
      public string Name {get;set;}
      public string Email {get;set;}
      public string Role {get;set;}
      Public string ContributororMem {get;set;}
      public string BusinessGrp {get;set;}
      public string Region {get;set;}
    }

@RemoteAction
global static List<GenerateExportToExcel> GetCommunity()
{
  string CommunityId='a8AZ00000008OhyMAE';
  set<Id> setUserIds=new set<Id>();
  set<Id> setCMem=new set<Id>();
  Map<Id,string> MapUser=new Map<Id,string>();
  List<Id>  lstUSers=new List<Id>();
  Map<Id,string> MapCont=new Map<Id,string>();
  List<Community__Share> lstCommContri= [SELECT Id, ParentId, UserOrGroupId FROM Community__Share where ParentId=:CommunityId and AccessLevel ='Edit'];
  for(Community__Share CS: lstCommContri)
  {
    setUserIds.add(CS.UserOrGroupId);
    MapUser.put(CS.UserOrGroupId,'Contributor');
    MapCont.put(CS.UserOrGroupId,'Contributor');
    lstUSers.add(CS.UserOrGroupId);
  }
  
   List<Community_Member__c> lstCommMem=[SELECT User_Id__c, User_Id__r.FirstName , User_Id__r.LastName,User_Id__r.Name,User_Id__r.Email FROM Community_Member__c where status__c='Approved' and Community_Id__c=:CommunityId];
   for(Community_Member__c CMC:lstCommMem)
   {
     if(!MapUser.containsKey(CMC.User_Id__c))
     {
       MapUser.put(CMC.User_Id__c,'Member');
       lstUSers.add(CMC.User_Id__c);
     }
   }
   List<User> lstUsersName= [SELECT Id, LastName, Name, FirstName,Email FROM User where Id in:lstUSers and IsActive=true];
   
   set<Id> setUsr=new set<Id>();
   for(Id usr:lstUsers)
   {
    setUsr.add(usr);
   }
   Map<Id,string> MapRole=new Map<Id,string>();
   Map<Id,string> MapBG=new Map<Id,string>();
   Map<Id,string> MapRN=new Map<Id,string>();
   List<ES_User__c> lstEsUsr= [SELECT Id,User_Id__c, Region_Id__r.Region_Name__c,Role_ID__r.Role_name__c, Business_Group_Id__r.Business_Group_Name__c FROM ES_User__c where User_Id__c in:setUsr ];
   for(ES_User__c ESUsr:lstEsUsr)
   {
     MapRole.put(ESUsr.User_Id__c,ESUsr.Role_ID__r.Role_name__c);
     MapBG.put(ESUsr.User_Id__c,ESUsr.Business_Group_Id__r.Business_Group_Name__c);
     MapRN.put(ESUsr.User_Id__c,ESUsr.Region_Id__r.Region_Name__c);
   }
   List<GenerateExportToExcel> lstGenerate=new List<GenerateExportToExcel>();
   for(User uId:lstUsersName)
   {
     GenerateExportToExcel GETE=new GenerateExportToExcel();
     GETE.FirstName=uId.FirstName;
     GETE.LastName=uId.LastName;
     GETE.Name=uId.Name;
     GETE.Email=uId.Email;
     if(MapCont.containsKey(uId.Id))
     {
      GETE.ContributororMem='Contributor';
     }
     else
     {
     GETE.ContributororMem='Member';
     }
     if(MapRole.containsKey(uId.Id))
     {
     GETE.Role=MapRole.get(uId.Id);
     }
     else
     {
     GETE.Role='';
     }
     if(MapBG.containsKey(uId.Id))
     {
       GETE.BusinessGrp=MapBG.get(uId.Id);
     }
     else
     {
     GETE.BusinessGrp='';
     }
     if(MapRN.containsKey(uId.Id))
     {
       GETE.Region=MapRN.get(uId.Id);
     }
     else
     {
     GETE.Region='';
     }
     
     lstGenerate.add(GETE);
   }
   
   // string strhtml='<html><head></head><body> <table>'; 
   // string tableheader='<tr><th>FirstName</th><th>LastName </th><th>Name</th><th>Email</th> </tr>';
   // strhtml+=tableheader;
  
   // for(Community_Member__c CommMem:lstCommMem)
   // {
     // string htmBody='<tr>';
     // htmBody+='<td>'+CommMem.User_Id__r.FirstName+' </td>';
     // htmBody+='<td>'+CommMem.User_Id__r.LastName+' </td>';
     // htmBody+='<td>'+CommMem.User_Id__r.Name+' </td>';
     // htmBody+='<td>'+CommMem.User_Id__r.Email+' </td>';
     
     // htmBody+='</tr>';
     
    // strhtml+=htmBody;
    
   
   // }
   // //strhtml+= '</table>';
  // strhtml+= '</table> </body> </html>';
  return lstGenerate;
}

}