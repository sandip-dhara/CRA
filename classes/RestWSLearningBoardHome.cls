@RestResource(urlMapping='/LearningBoardHome/*')
global with sharing class RestWSLearningBoardHome {
    @HttpPost
    global static RestWSResult Post(String method) {
        
        
         RestWSResult result = new RestWSResult();
        if(method == 'Featured')
        {
            result = new LearningBoardFeatured_Global(method);
            result.success = true;         
        }
        else if(method == 'MyTopics')
        {
            result = new LearningBoard_Global(method);
            result.success = true;         
        }
        else
        {
            result.success = false;
            result.error = 'Invalid method';
        }
        return result;
    }
}