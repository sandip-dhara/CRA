global with sharing class dhc_extension{

    public dhc_extension(ApexPages.StandardController controller){
        }

        //@RemoteAction
        global static List<DHC_Questions__c> getPicklist(String stage, String csf){
            List<DHC_Questions__c> lst_contacts = new List<DHC_Questions__c>([SELECT Rating__c FROM DHC_Questions__c WHERE Sales_Stage__c = :stage AND CSF__c = :csf ORDER BY Sort_Order__c ASC NULLS LAST]);
            return lst_contacts;
        }
        
       //public PageReference savepdf(){
       webservice static String  savepdf(String OpptyplanId){
           try
            {
               //String OpptyplanId=Apexpages.currentPage().getParameters().get('opplanid');
               system.debug('Code executed here');
               DateTime CurrentDate= DateTime.now();
                String FileName='Dealhealthchecklist';
                FileName+=CurrentDate.format('ddMMyyyy');
                PageReference PDFPage= new PageReference('/apex/dhc_pdfsave?id='+OpptyplanId);
                //PDFPage.setRedirect(false);
               Blob PDFContent= PDFPage.getContent();
               //opptyplanId might need to be oppid
                Attachment a = new Attachment(parentId = OpptyplanId, name=FileName+'.pdf', body = PDFContent);
                insert a;
              return 'Success';
              
               
            }
            catch(Exception e)
            {
                ApexPages.addMessages(e);
                return 'Fail';
                
                
            }

    
        }  
        @RemoteAction
        global static Integer saveCopy(String oppPlanId){
           try
            {
                DateTime CurrentDate= DateTime.now();
                String FileName='DHC_';
                FileName+=CurrentDate.format('ddMMyyyy');
                PageReference PDFPage= new PageReference('/apex/dhc_pdfsave?id='+oppPlanId);
                Blob PDFContent= PDFPage.getContent();
                Attachment a = new Attachment(parentId = oppPlanId, name=FileName+'.pdf', body = PDFContent);
                insert a;
                return 1;
              
               
            }
            catch(Exception e)
            {
                ApexPages.addMessages(e);
                return 0;
                
            }
        }
            
    
}