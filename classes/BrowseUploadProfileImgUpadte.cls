public class BrowseUploadProfileImgUpadte
{
    public string nameFile{get;set;}
    public Transient Blob contentFile{get;set;}
    public Pagereference ReadFile(){ 
        try{
            if(contentFile.size() > 4313161){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Image size should not exceed 4MB'); 
                ApexPages.addMessage(myMsg);
            }else{
                Integer imgLength = contentFile.size();
                Boolean isPublicalyVisible = true;
                String communityId = null;  
                String userId= UserInfo.getUserId();   
                ConnectApi.Photo photo = ConnectApi.ChatterUsers.setPhoto(communityId, userId,  new ConnectApi.BinaryInput(contentFile,'image/jpg','userImage.jpg'));
                User currentUser = [SELECT Id, UserPreferencesShowProfilePicToGuestUsers FROM User WHERE Id =:userId];
                currentUser.UserPreferencesShowProfilePicToGuestUsers = isPublicalyVisible;
                system.debug('currentUser-----------'+currentUser);
            update currentUser; 
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.CONFIRM,'Profile Image Updated successfully'); 
            ApexPages.addMessage(myMsg);      
            }
        }
        catch(Exception e){
            String strException = string.valueof(e);
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,strException); 
            ApexPages.addMessage(myMsg);
        }
        return null;
   }
}