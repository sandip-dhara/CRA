public class SarahDescribeController{
 
    public String objectName {get;set;}
    public List<String> objectFields {get;set;}
    public List<SObject> SObjectListToShow {get;set;}
    
    public SarahDescribeController(){
        objectName= 'PermissionSetAssignment';
        SObjectListToShow = getSObjectList();
    }
    
    public class temp {
        string id {get;set;}
    }
    public List<SObject> getSObjectList(){
    
    List<sObject> abc = [SELECT AssigneeId, Assignee.name, PermissionSetId, PermissionSet.Name FROM PermissionSetAssignment ];
 
    //Getting field list for the sObject 
        objectFields =  new List<String>();
        Map<String , Schema.SObjectType> globalDescription = Schema.getGlobalDescribe();
        Schema.sObjectType sObjType = globalDescription.get(objectName);
 
        Schema.DescribeSObjectResult res = sObjType.getDescribe();
        Schema.DescribeFieldResult f = Schema.sObjectType.PermissionSetAssignment.fields.AssigneeId;
        f = f.getSObjectField().getDescribe();
 
        Map<String , Schema.SObjectField> mapFieldList = res.fields.getMap();
        for(Schema.SObjectField field : mapFieldList.values())
        {
            Schema.DescribeFieldResult fieldResult = field.getDescribe();
            if(fieldResult.isAccessible())
            {
                objectFields.add(fieldResult.getName());
            }
        }
 
        //Building Query with the fields
        Integer i = 0;
        String fieldsToFetch = '';
        Integer len = objectFields.size();
        for(String temp:objectFields)
        {
 
            if(i==len-1)
            {
                  fieldsToFetch = fieldsToFetch + temp;
            }
            else
            {
                  fieldsToFetch = fieldsToFetch + temp + ',';
            }
            i++;
        }
            String qryStr = 'Select ' + fieldsToFetch + ' From ' + objectName + ' LIMIT 10 ' ;
            return  Database.Query(qryStr);
    }
}