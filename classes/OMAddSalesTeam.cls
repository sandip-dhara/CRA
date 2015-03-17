/**********************************************************
* Class Name: OMAddSalesTeam
* Author: Chintapalli Sudhakara Reddy
* Date: 4/4/2013 6:22 AM 
* Capability:OM Enhancements
* Description: This class has methods called from Javascript code.In Speciality opportunity matches related list
               Add Sales team button java script code call this class.  
***********************************************************/


global class OMAddSalesTeam{
    webservice static String Som(list<String> specialityIDs ,ID opptyID){
        system.debug('@@'+specialityIDs);
        List<Product_Specialty_Oppty_Assignment__c> psoaList=[select id,user_id__c,Product_Specialty_User_Assignment__r.User__r.name from Product_Specialty_Oppty_Assignment__c where id in :specialityIDs];
        Set<ID> assignId=new Set<ID>();
        //OpportunityTeamMember oppTeamMember=new OpportunityTeamMember();
        Map<ID,String> userIDNameMap=new Map<ID,String>();
        
        for(Product_Specialty_Oppty_Assignment__c psoa:psoaList){
            assignId.add(psoa.user_id__C );
            userIDNameMap.put(psoa.user_id__c,psoa.Product_Specialty_User_Assignment__r.User__r.name);
        }
        List<OpportunityTeamMember> teammemberList=new LIst<OpportunityTeamMember>();
        String existingTeamMembers='';
        for(OpportunityTeamMember teamMember: [select userID from OpportunityTeamMember where userID in :assignId and OpportunityId=:opptyID]){
            assignId.remove(teamMember.userID);
            if(userIDNameMap.containsKey(teamMember.userID)){
                existingTeamMembers=existingTeamMembers+ userIDNameMap.get(teamMember.userID)+',';
            }
        }
        if(existingTeamMembers !='' && existingTeamMembers != null)
           existingTeamMembers = existingTeamMembers.subString(0,existingTeamMembers.length()-1)+'  already existing in the salesteam';
        String newTeamMembers='';   
        for(ID userID:assignId){
          
                 newTeamMembers=newTeamMembers+userIDNameMap.get(userID)+',';
                 OpportunityTeamMember oppTeamMember=new OpportunityTeamMember();
                 oppTeamMember.OpportunityId=OpptyId;
                 //oppTeamMember.TeamMemberRole=label.Part_Colab_Inside_Sales;
                 oppTeamMember.TeamMemberRole=label.SaleTeam_User_Role;
                 oppTeamMember.UserId=userID;  
                 //oppTeamMember.OpportunityAccessLevel ='Read';                        
                 teammemberList.add(oppTeamMember);
         }
              
          if(newTeamMembers!='' && newTeamMembers!= null)
           newTeamMembers= newTeamMembers.subString(0,newTeamMembers.length()-1)+' successfully added to salesteam';
          if(existingTeamMembers!='' && existingTeamMembers != null && newTeamMembers !='' && newTeamMembers !=null)
          existingTeamMembers=existingTeamMembers+'|'+newTeamMembers ;
          else if(existingTeamMembers!='' && existingTeamMembers != null && (newTeamMembers =='' || newTeamMembers ==null))
           existingTeamMembers=existingTeamMembers;
           else if((existingTeamMembers=='' || existingTeamMembers == null) && newTeamMembers !='' && newTeamMembers !=null)
           existingTeamMembers=newTeamMembers;
          if(teammemberList.size()>0)
          insert teammemberList;
          if(existingTeamMembers!=null && existingTeamMembers !='')
          return existingTeamMembers;
          else
          return 'success';
    }
    }