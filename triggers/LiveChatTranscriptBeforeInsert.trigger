trigger LiveChatTranscriptBeforeInsert on LiveChatTranscript (before insert) {
    
    for(LiveChatTranscript liveChat : Trigger.new){
       if(liveChat.Record_Type__c == 'CO Live Transcript'){ 
             liveChat.RecordTypeId = [Select Id From RecordType WHERE Name ='CO Live Transcript' and SobjectType ='LiveChatTranscript' limit 1].Id;       
             liveChat.user__c= [select id from user where email=:livechat.email__c limit 1].Id; 
       }
       //insert liveChat;
       system.debug('@@@'+liveChat);
    
    }
}