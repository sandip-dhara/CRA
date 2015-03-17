public class FileUploader 
{
    public string nameFile{get;set;}
    public Blob contentFile{get;set;}
    public String downloadUrl{get;set;}
    String messegae = '';
    Integer errorCount = 0;
    Integer sucessCount = 0;
    String[] filelines = new String[]{};
    List<Process_Onboard_User__c> accstoupload;
    List<Document> docsUpload = new List<Document>();
    public Pagereference ReadFile()
    { 
     System.debug('**a**'+contentFile.toString());
        String s = EncodingUtil.base64Encode(contentFile);        
        System.debug('**1**'+s);
        Blob b =  EncodingUtil.base64Decode(s);
        System.debug('**2**'+b);     
        nameFile= b.toString();
        System.debug('****'+nameFile);
        filelines = nameFile.split('\n');
        System.debug('---'+filelines);
        accstoupload = new List<Process_Onboard_User__c>();       
        
        for (Integer i=1;i<filelines.size();i++)
        {
            String[] inputvalues = new String[]{};
            inputvalues = filelines[i].split(',');
             System.debug('inputvalues****'+inputvalues);                     
            // Process_Onboard_User__c pou = new Process_Onboard_User__c();

               System.debug('filelines[i]:'+ filelines[i]);
               //System.debug('inputvalues[0]:'+ inputvalues[0]);


                System.debug('inputvalues[0]:'+ inputvalues[0]);
                System.debug('inputvalues[1]:'+ inputvalues[1]);
                System.debug('inputvalues[2]:'+ inputvalues[2]);
                System.debug('inputvalues[3]:'+ inputvalues[3]);
                System.debug('inputvalues[4]:'+ inputvalues[4]);
                System.debug('inputvalues[5]:'+ inputvalues[5]);
                System.debug('inputvalues[6]:'+ inputvalues[6]);

              //  pou.Area_Of_Focus__c = inputvalues[0];
               // pou.Board_Contributor__c = inputvalues[1];
                //pou.Board_Member__c = inputvalues[2];
                //pou.Community_Contributor__c = inputvalues[3];
                //pou.Community_Member__c = inputvalues[4];
                //pou.Email__c = inputvalues[5];
                //pou.Role__c = inputvalues[6];
               // accstoupload.add(pou);
        }       
        try{
        //insert accstoupload;
        Database.SaveResult[] srList = Database.insert(accstoupload, false);

            System.debug('srList:'+ srList);
            for (Database.SaveResult sr : srList) {
                if (sr.isSuccess()) {
                    sucessCount++;
                    // Operation was successful, so get the ID of the record that was processed
                    System.debug('Successfully inserted account. Account ID: ' + sr.getId());
                }
                else {
                    // Operation failed, so get all errors                                                      
                    for(Database.Error err : sr.getErrors()) {                        
                        errorCount++;
                        messegae = err.getMessage() + ',' + messegae;                        
                        System.debug('The following error has occurred.');                    
                        System.debug('error message'+ err.getMessage());
                        System.debug('Account fields that affected this error: ' + err.getFields());
                    }
                }
            }
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.CONFIRM,+'Total Files Upload Success:'+sucessCount));
            ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,+'Total Files Failed To Upload :'+errorCount);
            ApexPages.addMessage(errormsg);            
            Document docs = new Document();
                docs.Name = 'Error Data';
                docs.body = contentFile;                          
                docs.type = 'pdf';
                docs.ContentType = 'application/pdf';               
                docs.Description = messegae;
                docs.FolderId = userinfo.getUserId();             
            insert docs; 
            downloadUrl = '/servlet/servlet.FileDownload?file='+docs.id;         
        }
        catch (Exception e)
        {
            System.debug('********'+e);
            ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,'An error has occured. Please check the template or try again later');
            ApexPages.addMessage(errormsg);
        }    
        return null;
    }
    
    public List<Process_Onboard_User__c> getuploadedAccounts()
    {
        if (accstoupload!= NULL)
            if (accstoupload.size() > 0)
                return accstoupload;
            else
                return null;                    
        else
            return null;
    }            
}