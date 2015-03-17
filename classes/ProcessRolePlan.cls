global class ProcessRolePlan {
  
   webservice String area; 
   webservice String region; 
   
   //Define an object in apex that is exposed in apex web service
   global class ProcessRole{
      webservice String name;
      webservice String Description;
      webservice Id roleId;
   }

   webservice static ProcessRole createProcessRolePlan(ProcessRole vProcessRole) {
       
       //A plan maps to the Account object in salesforce.com. 
       //So need to map the Plan class object to Account standard object
       Role__c role = new Role__c();
       role.Role_Name__c = vProcessRole.name;
       role.Description__c= vProcessRole.Description;
       insert role;
       
       vProcessRole.roleId=role.Id;
       return vProcessRole;
  }
  

}