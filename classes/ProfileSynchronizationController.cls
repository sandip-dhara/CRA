/**
* @Description : Class used to update the current logged in user's profile picture.
*                It supports both internal or external webservice images
**/

public class ProfileSynchronizationController {
    

    public String imageUrl {get; set;}
    public Boolean isPubliclyVisible {get; set;}
    public Boolean isExternalUrl {get; set;}
    private static final String PROFILE_PIC_NAME = UserInfo.getName()+' profile pic';
    
    // Permitted image mime types
    private static final Set<String> permittedImageMimeTypes = new Set<String>{'image/gif','image/png','image/jpeg','image/pjpeg'};

    // Maximum file size limit 
    private static final Integer MAX_FILE_SIZE = 3000000;

    @TestVisible
    private User currentLoggedInUser {get {
                                        if (currentLoggedInUser == null){
                                                                                // update the user record 
                                            List<User> rsUsers = [SELECT Id, UserPreferencesShowProfilePicToGuestUsers FROM User WHERE Id =: UserInfo.getUserId() LIMIT 1];
                                            currentLoggedInUser = rsUsers[0];
                                        }
                                        return currentLoggedInUser;
                                    } set;}

    /** 
    *@Description : No argument constructor
    **/ 
    public ProfileSynchronizationController(){
        this.imageUrl = '';
        this.isPubliclyVisible = currentLoggedInUser.UserPreferencesShowProfilePicToGuestUsers;
        this.isExternalUrl = false;
    }


    /** 
    *@Description : Method used to call the updateProfilePhoto interface method
    *@Return void
    **/ 
    public PageReference updateProfilePicture(){

        Boolean hasError = false;

        try{

            // Check if salesforce url is not blank 
            if (String.isBlank(imageUrl)){
                ApexPages.addMessage(new Apexpages.Message(ApexPages.Severity.ERROR,Label.Blank_Url));
                hasError = true;
            }

            // return null if the url is blank
            if (hasError) return null;

            // update the profile picture
            Boolean isSuccess = updateProfilePhoto(new Url(imageUrl), isPubliclyVisible);

            // resturn null if profile picture is not successfully updated.
            if (!isSuccess) return null;

            if (isSuccess) ApexPages.addMessage(new Apexpages.Message(ApexPages.Severity.CONFIRM,Label.Success_Message));
        }catch(Exception ex){
            ApexPages.addMessage(new Apexpages.Message(ApexPages.Severity.ERROR,ex.getMessage()));
        }

        return null;
    }

    /** 
    *@Description : Method used to get the image and update the current logged in user's profile picture
    *@Return Boolean returns true if updated successfully else false otherwise
    **/ 
    public Boolean updateProfilePhoto(URL url, Boolean isPubliclyVisible){
        Boolean isSuccessfullyUploaded = false;
        Blob profilePic = (Test.isRunningTest() ? Blob.valueOf('Some image') : null);

        // Get the response
        if (this.isExternalUrl){
            HttpResponse response = new Http().send(createHttpRequestInstance());

            // Check the content Type of the reponse
            if (response.getHeader('Content-Type') != null && !permittedImageMimeTypes.contains(response.getHeader('Content-Type'))){
                ApexPages.addMessage(new Apexpages.Message(ApexPages.Severity.ERROR,response.getHeader('Content-Type')+' '+Label.Invalid_format));
                return isSuccessfullyUploaded;
            }

            // Get the image as blob
            profilePic = response.getBodyAsBlob();
        }else{
            PageReference profilePicContent = new PageReference(this.imageUrl);
            profilePicContent.setRedirect(true);
            // Get the image as blob 
            profilePic = profilePicContent.getContent();
        }
        
        if (profilePic != null && profilePic.size() > MAX_FILE_SIZE){
            ApexPages.addMessage(new Apexpages.Message(ApexPages.Severity.ERROR,Label.File_Size_Error+' '+Decimal.valueOf(profilePic.size())/1000000.00+' Mb.'));
            return isSuccessfullyUploaded;
        }

        // update the user record 
        currentLoggedInUser.UserPreferencesShowProfilePicToGuestUsers = isPubliclyVisible;
        update currentLoggedInUser;


        // Update the profile pic
        ConnectApi.BinaryInput profilePicInput = new ConnectApi.BinaryInput(profilePic,'image/jpeg',PROFILE_PIC_NAME);
        if (!Test.isRunningTest()) ConnectApi.Photo uploadedPhoto = ConnectApi.ChatterUsers.setPhoto('internal',UserInfo.getUserId(),profilePicInput);

        
        isSuccessfullyUploaded = true;

        // Get the Image 
        return isSuccessfullyUploaded;
    }


    /** 
    *@Description : Method used to cretae a http request 
    *@Return HttpRequest httprequest instance
    **/
    private HttpRequest createHttpRequestInstance(){
        HttpRequest request = new HttpRequest();
        request.setEndpoint(this.imageUrl);
        request.setCompressed(true);
        request.setMethod('GET');
        request.setHeader('Content-Type', 'image/jpeg');
        return request;
    }
}