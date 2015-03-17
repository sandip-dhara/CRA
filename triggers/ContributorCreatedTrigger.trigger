trigger ContributorCreatedTrigger on Release_Deliverable_Contributor__c (after insert,after update) {
   /* List <FeedItem> FIPosts = new List <FeedItem>();
    for(Release_Deliverable_Contributor__c rdc: Trigger.new){
        if(Trigger.isInsert){
            FeedItem post = new FeedItem();
            //Core_Team_Member__c ctm = [select User__c, Offering_Release_ID__c from Core_Team_Member__c where id =: rdc.Team_Member_ID__c];            
            //Release_Deliverable_Contributor__c rdc[select Team_Member_ID__c, Release_Deliverable_Name__c from Release_Deliverable_Contributor__c where id=:rdc.id];                
            //post.parentId =  ctm.User__c;
            //post.parentId =  UserInfo.getUserId();
            //Offering_Release__c orc = [select Name__c from Offering_Release__c where id =: ctm.Offering_Release_ID__c];            
            post.Body='You are invited as the Release Deliverable Contributor For '+
                //'Offering Name-->' + orc.Offering_Name__c + '-->' + 
                'Release Name: ' + orc.Name__c + '-->' +  
                'Deliverable Name: ' + rdc.Release_Deliverable_Name__c;               
            //post.Body='You are invited as the Release Deliverable Contributor For ' + rdc.Release_Deliverable_Name__c;
            FIPosts.add(post);
        }
        if(Trigger.isUpdate){
            FeedItem post = new FeedItem();
            //Core_Team_Member__c ctm = [select User__c, Offering_Release_ID__c from Core_Team_Member__c where id =: rdc.Team_Member_ID__c];            
            //Release_Deliverable_Contributor__c rdc[select Team_Member_ID__c, Release_Deliverable_Name__c from Release_Deliverable_Contributor__c where id=:rdc.id];                
            post.parentId =  ctm.User__c;
            //post.parentId =  UserInfo.getUserId();            
            //Offering_Release__c orc = [select Name__c from Offering_Release__c where id =: ctm.Offering_Release_ID__c];            
            post.Body='You are invited as the Release Deliverable Contributor For '+
                //'Offering Name-->' + orc.Offering_Name__c + '-->' + 
                'Release Name: ' + orc.Name__c + '-->' +  
                'Deliverable Name: ' + rdc.Release_Deliverable_Name__c;  
            FIPosts.add(post);
        }    
    }
    database.insert(FIPosts);*/
}