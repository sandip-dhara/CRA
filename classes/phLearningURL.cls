public with sharing class phLearningURL {

public String url{get; set;}



 public phLearningURL(ApexPages.StandardController controller) {
        /*this.LearningBoardsid = ApexPages.currentPage().getParameters().get('id');
        i = 0;
        AttachmentFilesVideo = new list<LearningAttachmentClass>();
        AttachmentFilesPDF = new list<LearningAttachmentClass>(); 
        AttachmentFilesPPT = new list<LearningAttachmentClass>(); 
        AttachmentFilesWord = new list<LearningAttachmentClass>();*/
    url='//www.youtube.com/embed/UfMG2B9eNVg?feature=player_detailpage';
System.debug('magurl'+url);
 if(url.contains('watch?v='))
    {
          url=url.replace('watch?v=', 'embed/');
      }  
     }
 
}