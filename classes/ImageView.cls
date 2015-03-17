public with sharing class ImageView {

private List<Id> photoIds; 

public List<Id> photos {
        get {
            if(photoIds == null) {
                photoIds = new List<Id>();
                for(Attachment att : [select Id from Attachment where ParentId = 'a6tZ00000008RI5IAM']) {
                    photoIds.Add(att.Id);
                }
            }
                             
            return photoIds;
        }
}
}