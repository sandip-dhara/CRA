// -------------------------------------------------------------------------------------------
// This class is used to cover Preview Template,Preview Page and Preview Updated content fumctionality on Page
// Version#     Date            Author                Description
// -------------------------------------------------------------------------------------------
// 1.0       7-Aug-2012     Rajit Kapoor           Initial Version
// ------------------------------------------------------------------------------------------
public class hpContentblockcomponentController
{
    public String strName {get;set;}//the name attribute of this component. This is passed as an attribute from the template. See setter method below
    
    //Name of Template Item passed as an attribute to component 
    public String strPTName {get;set;}
    
    //what items are we displayinga
    public List<PageToItem__c> lstPageToItems;  
    
    // what items are we displaying from TEMPLATE ITEM
    //public List<Site_Template_Item__c> lstTempToItems; 
    
    //the content that should appear on the page in this content block
    public List<ContentBlockItem__c> lstItems;
    
    //workaround for bug #W-638516
    public PageReference pagereferenceTemplateName{get;set;}
    
    public set<String> setContentBlockIds;
    
    //list to hold Staging Content Block items
    //public List<SiteSTGContentBlockItem__c> lstItemsSTG;
    
    //variable to store Object Name whether to pick the data from Site Content Block Item or Site Staging Content Block Item 
    public String strObjName{get; set;}
    
    // -------------------------------------------------------------------------------------------
    // This constructor is used to get query string parameter 'ObjName' to differentiate the functionality of 'Preview Page' and 'Preview Updated Content' 
    // Version#     Date            Author                Description
    // -------------------------------------------------------------------------------------------
    // 1.0       7-Aug-2012     Rajit Kapoor           Initial Version
    // ------------------------------------------------------------------------------------------
    public hpContentblockcomponentController()
    {
        strObjName = System.currentPageReference().getParameters().get('ObjName');
        
        //initilize all lists
        lstPageToItems = new List<PageToItem__c>{};
        //lstTempToItems = new List<Site_Template_Item__c>{};
    }
    
    // -------------------------------------------------------------------------------------------
    // This method is used to display Page Items and Template items if age Id exists or not.
    // Version#     Date            Author                Description
    // -------------------------------------------------------------------------------------------
    // 1.0       7-Aug-2012     Rajit Kapoor           Initial Version
    // -------------------------------------------------------------------------------------------    
    public List<ContentBlockItem__c> getlstItems() 
    {
        //getting Page Id
        String strPageId = System.currentPageReference().getParameters().get('PageId');
        
        //getting Template Id
        String strTempId = System.currentPageReference().getParameters().get('TempId');
        
        //for template preview mode: if there's no page id, just give back strSample content items to show their position
        if(strPageId == null ) 
        {
            //check if it's a preview of a 'get the contentblock call' ... see the save trigger on contentblockitem
            String strRegister = System.currentPageReference().getParameters().get('Register');
            lstItems = new List<ContentBlockItem__c>();
            
            //normal preview
            String strSample;
            
            if(strRegister == null)
            { 
                if(strName != null)
                    strSample = '<span id="contentblockitem" Name="'+strName+'" style="color:red; font-weight:bold;">{'+strName+'}</span>';
            }
            
            //we're telling the page that we need it's content for strRegistering the contentblock strNames by passing it a 'strRegister' url param
            //get the contentblock strNames, showing double {{...}} here in order for the parser to pick up the contentblock strNames (and not javascript methods etc ...)
            if(strRegister != null)
            { 
                if(strName != null)
                    strSample = '<span id="contentblockitem" Name="'+strName+'" style="color:red; font-weight:bold;">{{'+strName+'}}</span>';
                    
                //Code for TemplateItem
                if(strPTName != null)
                    strSample = '<span id="contentblockitem" Name="'+strPTName+'" style="color:red; font-weight:bold;">{{'+strPTName+'}}</span>';
            }
            
            lstItems.add(new ContentBlockItem__c(Name = strName, Content__c = strSample));
            
            //This Section Modified for  Manage TemplateItems  
           /* if(strTempId != null )
            {
                lstTempToItems = [Select p.cmsSiteTemplate__c, p.Id, p.Display_in_Contentblock__c, p.ContentBlockItem__r.Content__c,
                     p.ContentBlockItem__r.LastActivityDate, p.ContentBlockItem__r.SystemModstamp, p.ContentBlockItem__r.LastModifiedById, 
                     p.ContentBlockItem__r.LastModifiedDate, p.ContentBlockItem__r.CreatedById, p.ContentBlockItem__r.CreatedDate, 
                     p.ContentBlockItem__r.Name, p.ContentBlockItem__r.Id, p.ContentBlockItem__r.Type__c,p.ContentBlockItem__c 
                     From Site_Template_Item__c p where Display_in_Contentblock__c = :strPTName and cmsSiteTemplate__c = :strTempId order by Order__c ];
                
                //loop through Template items     
                for(Site_Template_Item__c objSiteTemplateItem : lstTempToItems) {
                        SiteContentBlockItem__c objSiteContentBlockItem = objSiteTemplateItem.ContentBlockItem__r;
                        lstItems.add(objSiteContentBlockItem);
                    }
            }*/
       /*   
        //workaround for bug #W-638516
        String PageName = [Select  p.PageTemplate__r.VisualForce_Page_strName__c, p.cmsSiteTemplate__c, p.PageTemplate__r.strName, p.strName, p.Id
                From Page__c p where id =:strPageId].PageTemplate__r.VisualForce_Page_strName__c;
                
        pagereferenceTemplateName= new PageReference('/apex/'+PageName);
        return items;  */  
        
            return lstItems;    
            
     
        }       
          
        //this part is when the content block needs to show the HTML
        lstPageToItems = [Select p.Page__c, p.Id, p.Display_in_Contentblock__c, p.ContentBlockItem__r.Content__c,
                     p.ContentBlockItem__r.LastActivityDate, p.ContentBlockItem__r.SystemModstamp, p.ContentBlockItem__r.LastModifiedById, 
                     p.ContentBlockItem__r.LastModifiedDate, p.ContentBlockItem__r.CreatedById, p.ContentBlockItem__r.CreatedDate, 
                     p.ContentBlockItem__r.Name, p.ContentBlockItem__r.Id, p.ContentBlockItem__r.Type__c,p.ContentBlockItem__c 
                     From PageToItem__c p where Display_in_Contentblock__c = :strName and Page__c = :strPageId order by Order__c];
                     
        lstItems = new List<ContentBlockItem__c>();
        
        //loop through Site Page Items
        for(PageToItem__c objSitePagetoItem :lstPageToItems) {
                ContentBlockItem__c objSiteContentBlockItem = objSitePagetoItem.ContentBlockItem__r;
                lstItems.add(objSiteContentBlockItem);
        }
        
        //This Section is Added for Manage Template  
        /*lstTempToItems = [Select p.cmsSiteTemplate__c, p.Id, p.Display_in_Contentblock__c, p.ContentBlockItem__r.Content__c,
                     p.ContentBlockItem__r.LastActivityDate, p.ContentBlockItem__r.SystemModstamp, p.ContentBlockItem__r.LastModifiedById, 
                     p.ContentBlockItem__r.LastModifiedDate, p.ContentBlockItem__r.CreatedById, p.ContentBlockItem__r.CreatedDate, 
                     p.ContentBlockItem__r.Name, p.ContentBlockItem__r.Id, p.ContentBlockItem__r.Type__c,p.ContentBlockItem__c 
                     From Site_Template_Item__c p where Display_in_Contentblock__c =:strPTName and cmsSiteTemplate__c = :strTempId order by Order__c ];
            
        for(Site_Template_Item__c objSiteTemplateItem : lstTempToItems) {
                SiteContentBlockItem__c objSiteContentBlockItem = objSiteTemplateItem.ContentBlockItem__r;
                lstItems.add(objSiteContentBlockItem);
        }*/
        
        //workaround for bug #W-638516
        String PageName = [Select  p.PageTemplate__r.VisualForce_Page_Name__c, p.PageTemplate__c, p.PageTemplate__r.Name, p.Name, p.Id
                From Page__c p where id = :strPageId].PageTemplate__r.VisualForce_Page_Name__c;
                
       
        pagereferenceTemplateName= new PageReference('/apex/'+PageName);
        return lstItems;
    }
    
    // -------------------------------------------------------------------------------------------
    // This method is used to get staging Content Block items.
    // Version#     Date            Author                Description
    // -------------------------------------------------------------------------------------------
    // 1.0       7-Aug-2012     Rajit Kapoor           Initial Version
    // -------------------------------------------------------------------------------------------
    public List<ContentBlockItem__c> getlstItemsSTG(){
        
        //getting page id
        /*String strPageId = System.currentPageReference().getParameters().get('PageId');
        setContentBlockIds = new set<String>{};  
        if(strPageId != null)
        {
             lstPageToItems = [Select p.Page__c, p.Id, p.Display_in_Contentblock__c, p.ContentBlockItem__r.Content__c,
                     p.ContentBlockItem__r.LastActivityDate, p.ContentBlockItem__r.SystemModstamp, p.ContentBlockItem__r.LastModifiedById, 
                     p.ContentBlockItem__r.LastModifiedDate, p.ContentBlockItem__r.CreatedById, p.ContentBlockItem__r.CreatedDate, 
                     p.ContentBlockItem__r.Name, p.ContentBlockItem__r.Id, p.ContentBlockItem__r.Type__c,p.ContentBlockItem__c 
                     From PageToItem__c p where Display_in_Contentblock__c = :strName and Page__c = :strPageId order by Order__c];
                     
            lstItemsSTG = new List<ContentBlockItem__c>();
            
            if(strObjName != null ||strObjName != '')
            {
                if(strObjName == 'Staging')
                {
                    for(PageToItem__c objSitePageToItem : lstPageToItems) {
                        setContentBlockIds.add(objSitePageToItem.ContentBlockItem__c);
                    }
                    
                    for(SiteSTGContentBlockItem__c objSTGContentBlockItem :[Select id,Content__c,Type__c,cmsCBI_Look_Up__c from SiteSTGContentBlockItem__c where cmsCBI_Look_Up__c in :setContentBlockIds])
                    {
                        lstItemsSTG.add(objSTGContentBlockItem);
                    }
            
                }
            }
    
        }
        //workaround for bug #W-638516
        if(strPageId != null && strPageId != ''){
            String strPageName = [Select  p.cmsSiteTemplate__r.cmsVisualForcePageName__c, p.cmsSiteTemplate__c, p.cmsSiteTemplate__r.Name, p.Name, p.Id
                From Page__c p where id =:strPageId].cmsSiteTemplate__r.cmsVisualForcePageName__c;
            pagereferenceTemplateName= new PageReference('/apex/'+strpageName);
        }
        return lstItemsSTG;*/
        return null;
    }
    
   //TEST METHODS
   public static testMethod void cmsContentblockcomponentControllerTracker() 
   {
        hpContentblockcomponentController ContentBlockController = new hpContentblockcomponentController();
        ContentBlockController.strname= 'tst';
        Apexpages.currentPage().getParameters().put('Register', 'Register');
       
        ContentBlockController.strPTName = 'tst';
        Site site = [select Id from Site limit 1];
        String siteid = site.Id;        
        //set up page and template folders
        CMSFolder__c pagefolder = new CMSFolder__c(Site_Id__c = siteid.substring(0,15),Type__c = 'Page', Name='test');
        insert pagefolder;
        
        
        CMSFolder__c templatefolder = new CMSFolder__c(Type__c = 'PageTemplate', Name='test');
        insert templatefolder;
        
        //set up a test template
        PageTemplate__c objTemplate= new PageTemplate__c(Name='test', VisualForce_Page_Name__c='TestTemplate', ContentBlockNames__c= 'a,b,c', Folder__c = templatefolder.Id);
        insert objtemplate;
       
        //set up a test ContentBlockItem
        ContentBlockItem__c objContentBlock= new ContentBlockItem__c(Name='test content', Content__c='some content');
        insert objContentBlock;
        
        //set up a test templateItem
        //Site_Template_Item__c objSiteTemplateItem = new Site_Template_Item__c(cmsSiteTemplate__c = objtemplate.id,ContentBlockItem__c = objContentBlock.Id);
        //insert objSiteTemplateItem;
       
        //set up a test page 
        Page__c objSitePage = new Page__c(Name='testpage', PageTemplate__c = objtemplate.Id, Folder__c = pagefolder.Id);
        insert objSitePage;
       
        //set up an existing pagetoitem
        PageToItem__c objPageToItem = new PageToItem__c(Page__c = objSitePage.Id, ContentBlockItem__c = objContentBlock.Id);
        insert objPageToItem;
        
       // PageReference pageReference = Page.cmspage;
        
        PageReference pageReference = new Pagereference('/cms/testpage');
        
        //Test.setCurrentPageReference(pageReference); 
          
        //without params : preview mode
        //with a real TempId 
        //pageReference.getParameters().put('TempId',objtemplate.Id);
        ContentBlockController.getlstItems();
        
        //with the Register param : contentblocdiscoverykstrName  mode
        pageReference.getParameters().put('Register','1');                                           
        ContentBlockController.getlstItems();
        
        //Apexpages.currentPage().getParameters().put('PageId', 'objSitePage.Id');
        
        //with a real PageId : page serving mode
        pageReference.getParameters().put('PageId',objSitePage.Id);                      
        ContentBlockController.getlstItems();
        
        pageReference.getParameters().put('ObjName','Staging');
        hpContentblockcomponentController ContentBlockController1 = new hpContentblockcomponentController();
        ContentBlockController1.getlstItemsSTG();         
            
    } 
    
     public static testMethod void cmsContentblockcomponentControllerTracker2() 
   {
        hpContentblockcomponentController ContentBlockController = new hpContentblockcomponentController();
       
       ContentBlockController.strname= 'tst';
       
        Site site = [select Id from Site limit 1];
        String siteid = site.Id;        
        //set up page and template folders
        CMSFolder__c pagefolder = new CMSFolder__c(Site_Id__c = siteid.substring(0,15),Type__c = 'Page', Name='test');
        insert pagefolder;
        
        
        CMSFolder__c templatefolder = new CMSFolder__c(Type__c = 'PageTemplate', Name='test');
        insert templatefolder;
        
        //set up a test template
        PageTemplate__c objTemplate= new PageTemplate__c(Name='test', VisualForce_Page_Name__c='TestTemplate', ContentBlockNames__c= 'a,b,c', Folder__c = templatefolder.Id);
        insert objtemplate;
       
        //set up a test ContentBlockItem
        ContentBlockItem__c objContentBlock= new ContentBlockItem__c(Name='test content', Content__c='some content');
        insert objContentBlock;
        
        //set up a test templateItem
        //Site_Template_Item__c objSiteTemplateItem = new Site_Template_Item__c(cmsSiteTemplate__c = objtemplate.id,ContentBlockItem__c = objContentBlock.Id);
        //insert objSiteTemplateItem;
       
        //set up a test page 
        Page__c objSitePage = new Page__c(Name='testpage', PageTemplate__c = objtemplate.Id, Folder__c = pagefolder.Id);
        insert objSitePage;
       
        //set up an existing pagetoitem
        PageToItem__c objPageToItem = new PageToItem__c(Page__c = objSitePage.Id, ContentBlockItem__c = objContentBlock.Id);
        insert objPageToItem;
        
       // PageReference pageReference = Page.cmspage;
        
        PageReference pageReference = new Pagereference('/cms/testpage');
        
        //Test.setCurrentPageReference(pageReference); 
          
        //without params : preview mode
        //with a real TempId 
        //pageReference.getParameters().put('TempId',objtemplate.Id);
        ContentBlockController.getlstItems();
        
        //with the Register param : contentblocdiscoverykstrName  mode
        pageReference.getParameters().put('Register','1');                                           
        ContentBlockController.getlstItems();
        
       // Apexpages.currentPage().getParameters().put('PageId', 'objSitePage.Id');
        
        //with a real PageId : page serving mode
        pageReference.getParameters().put('PageId',objSitePage.Id);   
         System.currentPageReference().getParameters().put('PageId',objSitePage.Id);                
        ContentBlockController.getlstItems();
        
        pageReference.getParameters().put('ObjName','Staging');
        hpContentblockcomponentController ContentBlockController1 = new hpContentblockcomponentController();
        ContentBlockController1.getlstItemsSTG();  
       }

}