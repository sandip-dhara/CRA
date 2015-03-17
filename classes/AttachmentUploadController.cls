public with sharing class AttachmentUploadController 
{
    public String parentId {get;set;}
    public Attachment attach {get;set;}
   
    public AttachmentUploadController()
    {
        attach = new Attachment();
    }
   
    //When user clicks upload button on Visualforce Page, perform upload/insert
    //Redirect user to newly inserted document
    public void upload()
    {
    
       List<string> contype=new List<string>();
       contype.add('image/jpeg');
              contype.add('image/png');
                     contype.add('image/jpg');
        List<Attachment> lbatt=[select id from Attachment where ParentId =:parentId and ContentType=:contype];
        delete lbatt;

        //This shows how to insert an Attachment
        attach.ParentId = parentId;
        insert attach;
         
        attach.Body=null; 
        //return new ApexPages.Standardcontroller(attach).view();   
    }
}