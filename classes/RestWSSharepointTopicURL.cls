@RestResource(urlMapping='/SharepointTopicURL/*')
global with sharing class RestWSSharepointTopicURL{
    @HttpPost
        global static List<Topics> Post() {
        //RestWSResult result = new RestWSResult();

      //  List<Learning__c> lstLearning = [Select id,Doc_Id__c From Learning__c where url__c!=null and Type__C='Upload Document' and URL__C like '%Sharepoint%' and exourl__c=''];
       // List<Collateral__c> lstCollateral = [Select id,Sharepoint_Document_ID__c From Collateral__c where url__c!=null and Type__C='Upload Document' and URL__C like '%Sharepoint%'  and exourl__c=''];
        List<Topics> tpcs = new List<Topics>();
        
        List<Learning_Board_Learning__c> lstLBL = [Select Learning_ID__c,Learning_Board_ID__c,Learning_ID__r.Doc_Id__c,Learning_Board_ID__r.Name__c  From Learning_Board_Learning__c where Learning_ID__r.url__c!=null and Learning_ID__r.Type__C='Upload Document' and Learning_ID__r.URL__C like '%Sharepoint%' and Learning_ID__r.exourl__c=''];
        List<Collateral__c > lstCol = [Select id,Sharepoint_Document_ID__c,Community_Category_ID__r.Community_ID__c,Community_Category_ID__r.Community_ID__r.Name__c  From Collateral__c where url__c!=null and Type__C='Upload Document' and URL__C like '%Sharepoint%'  and exourl__c=''];
        
       //List<Community_Category__c> lstLBL = [Select Name From Community_Category__c];
           
         /*  for(Learning__c lb : lstLearning){
                 Topics tpc = new Topics();
                 tpc.topicid= lb.id;
                 tpc.folderid = lb.Doc_Id__c;
                 tpcs.add(tpc);
            }
      for(Collateral__c col : lstCollateral){
                 Topics tpc = new Topics();
                 tpc.id = col.id;
                 tpc.docid = col.Sharepoint_Document_ID__c;
                 tpcs.add(tpc);
            }
     */ 
     Topics tpc = new Topics();

        for(Learning_Board_Learning__c lbl : lstLBL ){
                 tpc = new Topics();
                 tpc.topicid= lbl.Learning_ID__c;
                 tpc.folderid = lbl.Learning_Board_ID__c ;
                 tpc.docid = lbl.Learning_ID__r.Doc_Id__c;
                 tpc.name = lbl.Learning_Board_ID__r.Name__c;
                 tpc.type = 'LEARNINGBOARD';
                 tpcs.add(tpc);
            }
         for(Collateral__c col : lstCol ){
                 tpc = new Topics();
                 tpc.topicid= col.id;
                 tpc.folderid = col.Community_Category_ID__r.Community_ID__c;
                 tpc.docid = col.Sharepoint_Document_ID__c;
                 tpc.name = col.Community_Category_ID__r.Community_ID__r.Name__c;
                 tpc.type = 'COMMUNITY';
                 tpcs.add(tpc);
            }   
        return tpcs;
    }
    
    global class Topics{
        Public String topicid{get;set;}
        Public String folderid {get;set;}
   //     Public String id{get;set;}
        Public String docid {get;set;}
        Public String name {get;set;}
        Public String type {get;set;}
    }
}