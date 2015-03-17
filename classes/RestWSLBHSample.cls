@RestResource(urlMapping='/LearningBoardHomeSample/*')
global with sharing class RestWSLBHSample {
    @HttpPost
    global static RestWSResult Post(String method) {    
        
        RestWSResult result = new RestWSResult();
        if(method == 'Featured')
        {
            Result = new LearningBoardFeatured_Globalsample(method);
            result.success = true;
        }
        else if(method == 'MyTopics')
        {
            result = new LearningBoard_Globalsample(method);
            result.success = true;
        }
        else
        {
            result.success = false;
            result.error = 'Invalid method';
        }
        return result;
    }
    public class LearningBoardCustomClass{ 
            public id AttachmentId{get;set;}
            public String AttBody{get;set;}
            public String AttContentType{get;set;}
            public String LBName{get;set;}
            public String LBDescription{get;set;}   
            public String LBid{get;set;}
            public String LBOwnerName{get;set;} 
            public String LBOwnerURL{get;set;}
            public datetime LBCrtDate{get;set;}
            public integer LBNoOfLikes{get;set;}
            public integer LBNoOfComments{get;set;} 
            public boolean StaticImage{get;set;} 
        	Public string LBLDescription{get;set;}
    }
}