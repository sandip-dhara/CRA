@RestResource(urlMapping='/Skill/*')
global with sharing class Skill{
		@HttpGet
        Global static Learning_Board__c getSkillById(){
            RestRequest req = RestContext.request;
            String SkillId = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
//            Skill__c result = [select Name__c, Is_Active__c from Skill__c where Name =:'SN -00000008' ];
            Learning_Board__c result = [select id,Name__c,description__c,  Owner.name,Owner.Id, Featured__c,CreatedDate from Learning_Board__c where Is_Active__c = True and Featured__c = True and Owner.Name=:'Anto Fernando'];
            return result;
        }
}