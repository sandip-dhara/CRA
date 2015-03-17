/**
* This is the controller class responsible for updating the profile picture 
* It will tahe the image url from the pafe and then get the blob content from the image
* once it is successfully converted to blob them it will call the chatter API to update the image
* Important Note : AS getting an image is web service call those URL need to be added in the remote site setting 
**/
public class UpdateImageController {
    public String photeURL {get;set;} // this variable will hold the actual URL pointing to the image
    public Boolean isPublicalyVisible  {get;set;} {isPublicalyVisible  = false;}
    /**
     * constructor of the class
     **/
    public UpdateImageController(){
        ApexPages.Message infoMsg = new ApexPages.Message(ApexPages.Severity.INFO, ''+ Label.Warning_to_USER);
        ApexPages.addMessage(infoMsg);
        
    }
    /**
    * This method will do a rest call to get the image content as bolb 
    * Call the chatter API to update the user image
    **/
    public Pagereference getAndUpdateImage(){
        updateProfilePhoto(photeURL,isPublicalyVisible);
        return null;
    }
    /**
     * This method will call the webservice to get the image and call parse response to update
     * the profile 
     **/
    Boolean updateProfilePhoto(String photeURL, Boolean isPubliclyVisible){
        Http httpInstance = new Http(); // creating the HTTP instance to do a rest call
        HttpRequest reqForImage = new HttpRequest(); // creating a HTTP request instance to create a request 
        // if blank showing error 
        if(photeURL == NULL || photeURL.trim() == ''){
            ApexPages.Message errMsg = new ApexPages.Message(ApexPages.Severity.ERROR,Label.URL_required );
            ApexPages.addMessage(errMsg);
            return false;  
        }
        //Replace any spaces with %20
        photeURL = photeURL.replace(' ', '%20');
        reqForImage.setEndpoint(photeURL); // setting the end point 
        reqForImage.setMethod('GET'); // setting the method 
        reqForImage.setHeader('Content-Type', 'image/png,image/jpg,image/gif'); // setting the content type 
        reqForImage.setCompressed(true);  // setting the compression 
        reqForImage.setTimeout(60000);  // setting the time out                    
        HttpResponse responseForImage = null; // instanciate the response                
        try{
            //These next three lines can show you the actual response for dealing with error situations
            string responseValue =''; // this sting will hold the response 
            responseForImage = httpInstance.send(reqForImage); // calling the webservice to get the image              
            parseResponse( responseForImage.getBodyAsBlob() );
        }
        catch(Exception e){
            ApexPages.Message errMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'' + Label.Upload_Failure + ' Error :' + e.getMessage());
            ApexPages.addMessage(errMsg);
            return false;
        }
        return true;
    }
    /**
     * This method will parse the response and try to update the uer profile  
     * 
     **/
    public Boolean  parseResponse(blob image){
        String communityId = null; // seiing the community id as null as it is not required 
        String userId= UserInfo.getUserId(); // setting the user id with current logged in user
        // Set photo for the logged in user  
        try{
            if(!Test.isRunningTest()) // Have to do see all data as it is not supported by test class
            ConnectApi.Photo photo = ConnectApi.ChatterUsers.setPhoto(communityId, userId,  new ConnectApi.BinaryInput(image,'image/jpg','userImage.jpg'));
            User currentUser = [SELECT Id, UserPreferencesShowProfilePicToGuestUsers FROM User WHERE Id =:userId];
            currentUser.UserPreferencesShowProfilePicToGuestUsers = isPublicalyVisible;
            update currentUser;
            // if all goes well showing the success message to the user 
            ApexPages.Message successMsg = new ApexPages.Message(ApexPages.Severity.CONFIRM,'' + Label.Upload_Success );
            ApexPages.addMessage(successMsg);
        } 
        catch(Exception e){ 
            ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR, '' + Label.Upload_Failure + ' Error :' + e.getMessage()); ApexPages.addMessage(errorMsg); return false;
        }
        return true;
    }
    public Pagereference checkImage(){
        if(photeURL == NULL || photeURL.trim() == '' ){
            ApexPages.Message errMsg = new ApexPages.Message(ApexPages.Severity.ERROR,Label.URL_required );
            ApexPages.addMessage(errMsg);
        }  
        return null;
    }
}