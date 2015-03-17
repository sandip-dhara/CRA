public with sharing class CMSFoldersController {

	public String lastid {get;set;}
    public List<CMSFolder__c> folders {get;set;}
    public List<Page__c> pages {get;set;}
    public List<Site> sites {get;set;}
    public List<PageTemplate__c> pagetemplates {get;set;}
    public List<Web_Form__c> webforms {get;set;}
    public List<SitesWrapper> sitesinfo {get;set;}
    public String instance {get;set;}
    
    public String operation {get;set;}
    public String sfdcnodetype {get;set;}
    public Boolean squarebrackets {get;set;}
    public String operationresponse {get;set;}

    //Constructor
    public CMSFoldersController() {
    	squarebrackets = true;
    }
    
    //method that will dispatch the JQuery operation to the correct Apex method
	public PageReference dispatchOperation() {
		String operation = System.currentPageReference().getParameters().get('operation');
    	if(operation == 'get_children') getChildren();
    	if(operation == 'move_node') moveTreeNode();
    	if(operation == 'create_node') createNode();
    	if(operation == 'remove_node') removeNode();
    	if(operation == 'rename_node') renameNode();
    	return null;
	}
    
    
    public void getChildren() {
    	String node = System.currentPageReference().getParameters().get('id');
    	//node = '1' will be the intial call from the tree
        if(node == '1') {
        	//get the different Sites in this org
        	sites = [Select s.TopLevelDomain, s.Subdomain, s.UrlPathPrefix, s.Status, s.Name, s.MasterLabel, s.Id From Site s limit 25];
        	sitesinfo = new List<SitesWrapper>();
        	
        	for(Site s:sites) {
        		SitesWrapper sw = new SitesWrapper();
        		sw.id = s.Id;
        		sw.name =  s.MasterLabel;        		
        		//get the previewurl for this site from custom settings
        		String siteid = s.Id;
        		String shortid = siteid.substring(0,15);
        		CMSForceSites__c cmsfs = CMSForceSites__c.getAll().get(shortid);
        		if(cmsfs != null) sw.previewurl = cmsfs.Site_Url__c;
        		sitesinfo.add(sw);
        	}
        	
        	
        	if(sitesinfo != null && sitesinfo.size() > 0) this.lastid = sitesinfo.get(sites.size() -1).Id;
        	//get the internal instance (naX, apX, emea, ...)
        	//String sfdcurl = ApexPages.currentPage().getHeaders().get('Host');
			//Pattern p = Pattern.compile('[\\./](na|ap|eu|emea|cs|tapp)[0-9]*\\.');
			//Matcher mo = p.matcher(sfdcurl);
			//mo.find();
			//instance = mo.group().substring(1,mo.group().length()-1);
        	if(CMSForceDomain__c.getAll().get('cmsforcedomain') != null) instance = CMSForceDomain__c.getAll().get('cmsforcedomain').Url__c;
        	return;
        }
        
        //System.debug('Objecttype : ' + CMSForceUtils.getObjectType(node));
        
        if(CMSForceUtils.getObjectType(node) == 'Site') {
        	String leftchars = node.substring(0,15); //the query below needs the 15 char id representation
        	folders = [Select c.Type__c, c.Name, c.Id From CMSFolder__c c where Type__c = 'Page' and Parent_CMSFolder__c = '' and Site_Id__c =:leftchars];
            if(folders != null && folders.size() > 0) this.lastid = folders.get(folders.size() -1).Id;
            sfdcnodetype = 'pagesfolder';
            //pages = [Select p.Name, p.Id, p.Folder__c From Page__c p where p.Folder__c = ''];
            //if(pages != null && pages.size() > 0) this.lastid = pages.get(pages.size()-1).Id;
            
            return;
        }
        
        //if node = pages, get the pages folders with no parent folder
        /**
        if(node == 'pages') {
            folders = [Select c.Type__c, c.Name, c.Id From CMSFolder__c c where Type__c = 'Page' and Parent_CMSFolder__c = ''];
            if(folders != null && folders.size() > 0) this.lastid = folders.get(folders.size() -1).Id;
            sfdcnodetype = 'pagesfolder';
            pages = [Select p.Name, p.Id, p.Folder__c From Page__c p where p.Folder__c = ''];
            if(pages != null && pages.size() > 0) this.lastid = pages.get(pages.size()-1).Id;
            
            return;
        }**/
        //if node = pagetemplates, get the pagetemplates folders with no parent folder
        if(node == 'pagetemplates') {
            folders = [Select c.Type__c, c.Name, c.Id From CMSFolder__c c where Type__c = 'PageTemplate' and Parent_CMSFolder__c = ''];
            if(folders != null && folders.size() > 0) this.lastid = folders.get(folders.size() -1).Id;
            sfdcnodetype = 'pagetemplatesfolder';
            return;
        }
        //if node = webforms, get the webforms folders with no parent folder
        if(node == 'webforms') {
            folders = [Select c.Type__c, c.Name, c.Id From CMSFolder__c c where Type__c = 'WebForm' and Parent_CMSFolder__c = ''];
            if(folders != null && folders.size() > 0) this.lastid = folders.get(folders.size() -1).Id;
            sfdcnodetype ='webformsfolder';
            return;
        }
        //try to get subfolders and pages where the parent id is the node clicked
        String objecttype = CMSForceUtils.getObjectType(node);

       
        if(objecttype == 'CMSFolder__c') {
        	CMSFolder__c clicked = [select Id, Type__c, Name from CMSFolder__c where id =:node];
        	if(clicked.Type__c == 'Page') sfdcnodetype = 'pagesfolder';
        	if(clicked.Type__c == 'PageTemplate') sfdcnodetype = 'pagetemplatesfolder';
        	if(clicked.Type__c == 'WebForm') sfdcnodetype = 'webformsfolder';
        	
        	folders = [Select c.Type__c, c.Name, c.Id From CMSFolder__c c where Parent_CMSFolder__c =:node];
            if(folders != null && folders.size() > 0) this.lastid = folders.get(folders.size() -1).Id;
            
            if(clicked.Type__c == 'Page') {
	            pages = [Select p.Name, p.Id, p.Folder__c From Page__c p where p.Folder__c = :node];
	            if(pages != null && pages.size() > 0) this.lastid = pages.get(pages.size()-1).Id;
            }
            
            if(clicked.Type__c == 'PageTemplate') {
	            pagetemplates = [Select p.Name, p.Id, p.Folder__c, p.VisualForce_Page_Name__c From PageTemplate__c p where p.Folder__c = :node];
	            if(pagetemplates != null && pagetemplates.size() > 0) this.lastid = pagetemplates.get(pagetemplates.size()-1).Id;
            }
            if(clicked.Type__c == 'WebForm'){
            	webforms = [select w.Id, w.Name, w.Folder__c From Web_Form__c w where w.Folder__c = :node];
            	if(webforms != null && webforms.size() > 0) this.lastid = webforms.get(webforms.size()-1).Id;
            }
            
            return;
        }
    }
    
    //moves a node to a new parent
    public void moveTreeNode() {
    	String objectid = System.currentPageReference().getParameters().get('objectid');
    	String targetobjectid = System.currentPageReference().getParameters().get('targetobjectid');
    	//String targetfoldertype = System.currentPageReference().getParameters().get('targetfoldertype');
    	squarebrackets = false;
    	String movednode;
    	
    	//System.debug('**********************************' + objectid + ' / ' + targetobjectid + ' / ' + targetfoldertype);
     	
    	//obtain the dragged object's type
    	String draggedobjecttype = CMSForceUtils.getObjectType(objectid); 
    	//obtain the target object's type
    	String targetobjecttype = CMSForceUtils.getObjectType(targetobjectid);
 		try {
	 		//if pages are moved to the root, just clear their parent folder id
	 		//if(targetfoldertype == 'pagesroot') {
	 		//	Page__c page = new Page__c(id = objectid, Folder__c = null); 			
	 		//	upsert page;
	 		//}
	    	
	    	//case : page to page folder
	    	if(draggedobjecttype == 'Page__c' && targetobjecttype == 'CMSFolder__c') {
	    		Page__c page = new Page__c(id = objectid, Folder__c = targetobjectid);
	    		movednode = targetobjectid;			
	 			upsert page;
	    	}
	    	//case : folder to folder
	    	if(draggedobjecttype == 'CMSFolder__c' && targetobjecttype == 'CMSFolder__c') {
	    		CMSFolder__c folder = new CMSFolder__c(id = objectid, Parent_CMSFolder__c = targetobjectid);
	    		movednode = objectid; 			
	 			upsert folder;
	    	}
	    	//case : folder to Site root
	    	if(draggedobjecttype == 'CMSFolder__c' && targetobjecttype == 'Site') {
	    		CMSFolder__c folder = new CMSFolder__c(id = objectid, Parent_CMSFolder__c = null, Site_Id__c = targetobjectid.substring(0,15)); 			
	 			movednode = objectid;
	 			upsert folder;
	    	}
	    	//case : folder to templates root
	    	if(draggedobjecttype == 'CMSFolder__c' && targetobjectid == 'pagetemplates') {
	    		CMSFolder__c folder = new CMSFolder__c(id = objectid, Parent_CMSFolder__c = null);
	    		movednode = objectid;
	    		upsert folder;
	    	}
	    	//case : folder to webforms root
	    	if(draggedobjecttype == 'CMSFolder__c' && targetobjectid == 'webforms') {
	    		CMSFolder__c folder = new CMSFolder__c(id = objectid, Parent_CMSFolder__c = null);
	    		movednode = objectid;
	    		upsert folder;
	    	}
	    	//case pagetemplate to folder
	    	if(draggedobjecttype == 'PageTemplate__c') {
	    		//allow for the special case of dragging a template onto a pages folder. This needs to create a page with this template in the target folder
	    		CMSFolder__c f = [select Id, Type__c from CMSFolder__c where id =:targetobjectid];
	    		PageTemplate__c pt = new PageTemplate__c(id = objectid, Folder__c = targetobjectid);
	    		if(f.Type__c == 'Page') {	    			
	    			Page__c p = new Page__c(Folder__c = targetobjectid, PageTemplate__c = pt.Id, Name = 'New Page');
	    			insert p;
	    			operationresponse = '{ "status" : 2, "id" : "'+ p.Id +'", "parentid":"'+ targetobjectid+'" }';
	    			return;
	    		} 
	    		//if this isn't the case, just update the template's parent folder id
	    		else {
	    			
	    			movednode = objectid;
	    			upsert pt;
	    		}	    		
	    	}
	    	//case web form to folder
	    	if(draggedobjecttype == 'Web_Form__c') {
	    		Web_Form__c w = new Web_Form__c(id = objectid, Folder__c = targetobjectid);
	    		movednode = objectid;
	    		upsert w;	    		
	    	}
	    	operationresponse = '{ "status" : 1, "id" : "'+ movednode +'" }';
 		}
 		catch(Exception ex) {
 			operationresponse = '{ "status" : 0, "id" : "'+ ex.getMessage() +'" }';
 		}    	
    }
    
    //create a new node in the folder hierarchy
    public void createNode() {

    	String parentfolderid = System.currentPageReference().getParameters().get('id');
    	String newname = System.currentPageReference().getParameters().get('title');
    	String nodetype = System.currentPageReference().getParameters().get('type');
    	String parentfoldertype;
    	squarebrackets = false;
    	
    	if((parentfolderid != 'pagetemplates') && (parentfolderid != 'webforms')) {
    		parentfoldertype = CMSForceUtils.getObjectType(parentfolderid);
    	}
    	if(parentfolderid == 'pagetemplates') parentfoldertype ='templatesroot';
    	if(parentfolderid == 'webforms') parentfoldertype ='webformsroot';
    	
    	try {
    		//a folder is being added
	    	if(nodetype == 'folder') {
	    		String sfdcnodetype;
	    		//create the new folder
	    		CMSFolder__c newfolder = new CMSFolder__c();
	    		newfolder.Name = newname;	    			    		
	    		//folder added to a Site root
	    		if(parentfoldertype == 'Site') {
	    			newfolder.Site_Id__c = parentfolderid.substring(0,15);
	    			newfolder.Type__c = 'Page';
	    			sfdcnodetype = 'pagesfolder';
	    		}
	    		//folder added to templatesroot
	    		else if(parentfoldertype == 'templatesroot') {
	    			newfolder.Type__c = 'PageTemplate';
	    			sfdcnodetype = 'pagetemplatesfolder';
	    		}
	    		//folder added to webformsroot
	    		else if(parentfoldertype == 'webformsroot') {
	    			newfolder.Type__c = 'WebForm';
					sfdcnodetype = 'webformsfolder';	    			
	    		}
	    		//folder added to another folder: make sure it has the same type as its parent
	    		else {
	    			CMSFolder__c parent = [select Id, Type__c from CMSFolder__c where Id =:parentfolderid];
	    			newfolder.Parent_CMSFolder__c = parentfolderid;
	    			String parenttype = parent.Type__c;
	    			newfolder.Type__c = parenttype;
	    			if(parenttype == 'Page') sfdcnodetype = 'pagesfolder';
	    			if(parenttype == 'PageTemplate') sfdcnodetype = 'pagetemplatesfolder';
	    			if(parenttype == 'WebForm') sfdcnodetype = 'webformsfolder';
	    		}    		
	    		insert newfolder;	    		
	    		operationresponse = '{ "status" : 1, "id" : "' + newfolder.Id + '", "sfdcnodetype" : "'+sfdcnodetype+'" }';
	    	}
	    	//a page is being added
	    	if(nodetype == 'default') {
	    		//check what type of folder it's been added to
	    		CMSFolder__c parent = [select Id, Type__c from CMSFolder__c where Id =: parentfolderid];
	    		if(parent.Type__c == 'Page') {
	    			Page__c p = new Page__c(Name = newname, Folder__c = parentfolderid);
	    			insert p;
	    			operationresponse = '{ "status" : 1, "id" : "' + p.id + '", "sfdcnodetype" : "page" }';
	    		}
	    		//if(parent.Type__c == 'PageTemplate') {	    			
	    		//	operationresponse = '{ "status" : 1, "id" : "' + p.id + '", "sfdcnodetype" : "pagetemplate", "parentid":"'+parent.Id+'" }';
	    		//}
	    	}
    	}
    	catch(Exception ex) {
    		operationresponse = '{ "status" : 0, "id" : "' + ex.getMessage() + '" }';
    	}
    	
    	
    }
    
    
    //removes a node (folder or page)
    public void removeNode() {
    	String nodeid = System.currentPageReference().getParameters().get('id');
    	String nodetype = System.currentPageReference().getParameters().get('sfdcnodetype');
    	squarebrackets = false;
    	try {
    		if(nodetype == 'pagesfolder') { CMSFolder__c f = new CMSFolder__c(id = nodeid); delete f;}
    		if(nodetype == 'pagetemplatesfolder') { CMSFolder__c f = new CMSFolder__c(id = nodeid); delete f;}
    		if(nodetype == 'webformsfolder') { CMSFolder__c f = new CMSFolder__c(id = nodeid); delete f;}
    		
	    	if(nodetype == 'page') {Page__c p = new Page__c(id = nodeid); delete p;}
	    	if(nodetype == 'pagetemplate') {PageTemplate__c p = new PageTemplate__c(id = nodeid); delete p;}
	    	if(nodetype == 'webform') { Web_Form__c w = new Web_Form__c(id = nodeid); delete w;}
	    	operationresponse = '{ "status" : 1, "nodetypedeleted" : "'+nodetype+'" }';
    	}
    	catch(Exception ex) {
    		operationresponse = '{ "status" : 0, "id" : "' + ex.getMessage() + '" }';
    	}
    }
    
    //rename a node (folder)
    public void renameNode() {
    	String nodeid = System.currentPageReference().getParameters().get('id');
    	String nodetype = System.currentPageReference().getParameters().get('sfdcnodetype');
    	String nodename = System.currentPageReference().getParameters().get('title');
    	squarebrackets = false;
    	try {
	    	if(nodetype == 'pagesfolder' || nodetype == 'pagetemplatesfolder' || nodetype == 'webformsfolder') {
	    		CMSFolder__c f = new CMSFolder__c(id = nodeid, Name = nodename);
	    		upsert f;
	    		operationresponse = '{ "status" : 1 }';
	    	}
	    	if(nodetype == 'page') {
	    		Page__c p = new Page__c(id = nodeid, Name = nodename);
	    		upsert p;
	    		operationresponse = '{ "status" : 1 }';
	    	}
	    	if(nodetype == 'pagetemplate') {
	    		PageTemplate__c p = new PageTemplate__c(id = nodeid, Name = nodename);
	    		upsert p;
	    		operationresponse = '{ "status" : 1 }';
	    	}
	    	if(nodetype == 'webform') {
	    		Web_Form__c w = new Web_Form__c(id = nodeid, Name = nodename);
	    		upsert w;
	    		operationresponse = '{ "status" : 1 }';
	    	}
    	}
    	catch(Exception ex) {
    		operationresponse = '{ "status" : 0, "id" : "' + ex.getMessage() + '" }';
    	}
    }
    
    
    //wrapper class for the Sites information
    private class SitesWrapper {
    	public String id {get;set;}
    	public String name {get;set;}
    	public String previewurl {get;set;}
    }
    
    
    /** TESTS **/
    
    private static testmethod void t1() {
    	Site site = [select Id from Site limit 1];
		String siteid = site.Id;		
		//set up page and template folders
		CMSFolder__c pagefolder = new CMSFolder__c(Site_Id__c = siteid.substring(0,15),Type__c = 'Page', Name='test');
		insert pagefolder;
		CMSFolder__c pagefolder2 = new CMSFolder__c(Type__c = 'Page', Name='test', Parent_CMSFolder__c = pagefolder.Id);
		insert pagefolder2;
		CMSFolder__c pagefolder3 = new CMSFolder__c(Site_Id__c = siteid.substring(0,15),Type__c = 'Page', Name='test');
		insert pagefolder3;
		CMSFolder__c templatefolder = new CMSFolder__c(Type__c = 'PageTemplate', Name='test');
		insert templatefolder;
		CMSFolder__c templatefolder2 = new CMSFolder__c(Type__c = 'PageTemplate', Name='test', Parent_CMSFolder__c = templatefolder.Id);
		insert templatefolder2;
		CMSFolder__c webformfolder = new CMSFolder__c(Type__c = 'WebForm', Name='test');
		insert webformfolder;
		CMSFolder__c webformfolder2 = new CMSFolder__c(Type__c = 'WebForm', Name='test', Parent_CMSFolder__c = webformfolder.Id);
		insert webformfolder2;
		//set up a test template
		PageTemplate__c template = new PageTemplate__c(Name='test', VisualForce_Page_Name__c='TestTemplate', Folder__c = templatefolder.Id);
		insert template;
		//set up a test page
		Page__c pg = new Page__c(Name='testpage', PageTemplate__c = template.Id, Folder__c = pagefolder.Id);
		insert pg;
		//set up a test web form
		Web_Form__c form = new Web_Form__c();
		form.Name = 'Test';
		form.Object_Name__c = 'Test__c';
		form.Object_Label__c = 'Test';		
		form.Return_URL__c = 'http://www.salesforce.com';
		form.SavedByWebformeditor__c = true;
		form.Folder__c = webformfolder.Id;
		insert form;
		
		
		Test.setCurrentPage(Page.CMSFolders);
		
		CMSFoldersController cfc = new CMSFoldersController();
		
		//operation = get_children
		
		//initial call : get children, id = 1, this will fill in the sitesinfo list
		ApexPages.currentPage().getParameters().put('operation', 'get_children');
		ApexPages.currentPage().getParameters().put('id', '1');
		cfc.dispatchOperation();
		System.assert(cfc.sitesinfo.size()>0);
		//then we click on a site, this will fill up the folder list
		ApexPages.currentPage().getParameters().put('operation', 'get_children');
		ApexPages.currentPage().getParameters().put('id', site.Id);
		cfc.dispatchOperation();
		System.assert(cfc.folders.size() >0);
		
		//then we click on the pagetemplates root, this will fill up the folder list
		ApexPages.currentPage().getParameters().put('operation', 'get_children');
		ApexPages.currentPage().getParameters().put('id', 'pagetemplates');
		cfc.dispatchOperation();
		System.assert(cfc.folders.size() >0);
		for(CMSFolder__c f:cfc.folders) {
			f.Type__c = 'PageTemplate';
		}
		
		//then we click on the webforms root, this will fill up the folder list
		ApexPages.currentPage().getParameters().put('operation', 'get_children');
		ApexPages.currentPage().getParameters().put('id', 'webforms');
		cfc.dispatchOperation();
		System.assert(cfc.folders.size() >0);
		for(CMSFolder__c f:cfc.folders) {
			f.Type__c = 'WebForm';
		}
		
		//click on a folder
		ApexPages.currentPage().getParameters().put('operation', 'get_children');
		ApexPages.currentPage().getParameters().put('id', pagefolder.Id);
		cfc.dispatchOperation();
		System.assertEquals(cfc.folders[0].Id, pagefolder2.Id);
		System.assertEquals(cfc.pages[0].Id, pg.Id);
		
		//now also click on the pagetemplate folder
		ApexPages.currentPage().getParameters().put('operation', 'get_children');
		ApexPages.currentPage().getParameters().put('id', templatefolder.Id);
		cfc.dispatchOperation();
		System.assert(cfc.folders.size() == 1);
		
		//and the webform folder
		ApexPages.currentPage().getParameters().put('operation', 'get_children');
		ApexPages.currentPage().getParameters().put('id', webformfolder.Id);
		cfc.dispatchOperation();
		System.assert(cfc.folders.size() == 1);
		
		
		//operation = move_node
		
		//page to folder
		ApexPages.currentPage().getParameters().put('operation', 'move_node');
		ApexPages.currentPage().getParameters().put('objectid', pg.Id);
		ApexPages.currentPage().getParameters().put('targetobjectid', pagefolder3.Id);
		cfc.dispatchOperation();
		Page__c testpage = [select Id, Folder__c from Page__c where Id =:pg.id limit 1];
		System.assertEquals(testpage.Folder__c, pagefolder3.Id);
		
		//folder to folder
		ApexPages.currentPage().getParameters().put('operation', 'move_node');
		ApexPages.currentPage().getParameters().put('objectid', pagefolder2.Id);
		ApexPages.currentPage().getParameters().put('targetobjectid', pagefolder3.Id);
		cfc.dispatchOperation();
		CMSFolder__c testfolder = [select Id, Parent_CMSFolder__c from CMSFolder__c where Id =:pagefolder2.Id limit 1];
		System.assertEquals(testfolder.Parent_CMSFolder__c, pagefolder3.Id);
		
		//folder to Site
		ApexPages.currentPage().getParameters().put('operation', 'move_node');
		ApexPages.currentPage().getParameters().put('objectid', pagefolder2.Id);
		ApexPages.currentPage().getParameters().put('targetobjectid', site.Id);
		cfc.dispatchOperation();
		testfolder = [select Id, Parent_CMSFolder__c, Site_Id__c from CMSFolder__c where Id =:pagefolder2.Id limit 1];
		System.assertEquals(testfolder.Site_Id__c, site.Id);
		System.assertEquals(testfolder.Parent_CMSFolder__c, null);
		//pagetemplate to folder
		ApexPages.currentPage().getParameters().put('operation', 'move_node');
		ApexPages.currentPage().getParameters().put('objectid', template.Id);
		ApexPages.currentPage().getParameters().put('targetobjectid', templatefolder2.Id);
		cfc.dispatchOperation();
		PageTemplate__c testtemplate = [select Id, Folder__c from PageTemplate__c where Id =:template.Id];
		System.assertEquals(testtemplate.Folder__c, templatefolder2.Id);
		
		//pagetemplate to page folder : this needs to create a new page for that folder with that template
		ApexPages.currentPage().getParameters().put('operation', 'move_node');
		ApexPages.currentPage().getParameters().put('objectid', template.Id);
		ApexPages.currentPage().getParameters().put('targetobjectid', pagefolder.Id);
		cfc.dispatchOperation();
		testpage = [select Id, Name, PageTemplate__c, Folder__c from Page__c where Folder__c = :pagefolder.Id and PageTemplate__c = :template.Id and Name =: 'New Page'];
		System.assert(testpage != null);
		
		//webform to folder
		ApexPages.currentPage().getParameters().put('operation', 'move_node');
		ApexPages.currentPage().getParameters().put('objectid', form.Id);
		ApexPages.currentPage().getParameters().put('targetobjectid', webformfolder2.Id);
		cfc.dispatchOperation();
		Web_Form__c testform = [select Id, Folder__c from Web_Form__c where Id =: form.Id];
		System.assertEquals(testform.Folder__c, webformfolder2.Id);
		
		
		//operation create_node
		
		//folder added to site
		ApexPages.currentPage().getParameters().put('operation', 'create_node');
		ApexPages.currentPage().getParameters().put('id', site.Id);
		ApexPages.currentPage().getParameters().put('title', 'testnodexyz');
		ApexPages.currentPage().getParameters().put('type', 'folder');
		cfc.dispatchOperation();
		testfolder = [select Id, Name, Site_Id__c from CMSFolder__c where Name = 'testnodexyz' limit 1];
		System.assert(testfolder != null);
		
		//folder added to templates root folder
		ApexPages.currentPage().getParameters().put('operation', 'create_node');
		ApexPages.currentPage().getParameters().put('id', 'pagetemplates');
		ApexPages.currentPage().getParameters().put('title', 'testnodexyztemplates');
		//ApexPages.currentPage().getParameters().put('type', 'templatesroot');
		cfc.dispatchOperation();
		testfolder = [select Id, Name from CMSFolder__c where Name = 'testnodexyztemplates' limit 1];
		System.assert(testfolder != null);
		
		//folder added to webforms root folder
		ApexPages.currentPage().getParameters().put('operation', 'create_node');
		ApexPages.currentPage().getParameters().put('id', 'webforms');
		ApexPages.currentPage().getParameters().put('title', 'testnodexyzwebforms');
		//ApexPages.currentPage().getParameters().put('type', 'webformsroot');
		cfc.dispatchOperation();
		testfolder = [select Id, Name from CMSFolder__c where Name = 'testnodexyzwebforms' limit 1];
		System.assert(testfolder != null);
		
		//folder added to folder
		//to pagefolder
		ApexPages.currentPage().getParameters().put('operation', 'create_node');
		ApexPages.currentPage().getParameters().put('id', pagefolder.Id);
		ApexPages.currentPage().getParameters().put('title', 'testnodexyzpagefolder');
		cfc.dispatchOperation();
		testfolder = [select Id, Name, Parent_CMSFolder__c from CMSFolder__c where Name = 'testnodexyzpagefolder' limit 1];
		System.assertEquals(testfolder.Parent_CMSFolder__c, pagefolder.Id);
		
		//to templatefolder
		ApexPages.currentPage().getParameters().put('operation', 'create_node');
		ApexPages.currentPage().getParameters().put('id', templatefolder.Id);
		ApexPages.currentPage().getParameters().put('title', 'testnodexyztemplatefolder');
		cfc.dispatchOperation();
		testfolder = [select Id, Name, Parent_CMSFolder__c from CMSFolder__c where Name = 'testnodexyztemplatefolder' limit 1];
		System.assertEquals(testfolder.Parent_CMSFolder__c, templatefolder.Id);
		
		//to webform folder
		ApexPages.currentPage().getParameters().put('operation', 'create_node');
		ApexPages.currentPage().getParameters().put('id', webformfolder.Id);
		ApexPages.currentPage().getParameters().put('title', 'testnodexyzwebformfolder');
		cfc.dispatchOperation();
		testfolder = [select Id, Name, Parent_CMSFolder__c from CMSFolder__c where Name = 'testnodexyzwebformfolder' limit 1];
		System.assertEquals(testfolder.Parent_CMSFolder__c, webformfolder.Id);
		
		//page to folder
		ApexPages.currentPage().getParameters().put('operation', 'create_node');
		ApexPages.currentPage().getParameters().put('id', pagefolder.Id);
		ApexPages.currentPage().getParameters().put('title', 'testnodexyzpage');
		ApexPages.currentPage().getParameters().put('type', 'default');
		cfc.dispatchOperation();
		testpage = [select Id, Folder__c from Page__c where Name = 'testnodexyzpage'];
		System.assertEquals(testpage.Folder__c, pagefolder.Id);
		
		
		//operation rename_node
		//rename pagesfolder
		ApexPages.currentPage().getParameters().put('operation', 'rename_node');
		ApexPages.currentPage().getParameters().put('id', pagefolder3.Id);
		ApexPages.currentPage().getParameters().put('sfdcnodetype', 'pagesfolder');
		ApexPages.currentPage().getParameters().put('title', 'newname');
		cfc.dispatchOperation();
		testfolder = [select Id, Name from CMSFolder__c where Id =:pagefolder3.Id];
		System.assertEquals('newname', testfolder.Name);
		
		//rename page
		ApexPages.currentPage().getParameters().put('operation', 'rename_node');
		ApexPages.currentPage().getParameters().put('id', pg.Id);
		ApexPages.currentPage().getParameters().put('sfdcnodetype', 'page');
		ApexPages.currentPage().getParameters().put('title', 'newname');
		cfc.dispatchOperation();
		testpage = [select Id, Name from Page__c where Id =:pg.Id];
		System.assertEquals('newname', testpage.Name);
		
		//rename pagetemplate
		ApexPages.currentPage().getParameters().put('operation', 'rename_node');
		ApexPages.currentPage().getParameters().put('id', template.Id);
		ApexPages.currentPage().getParameters().put('sfdcnodetype', 'pagetemplate');
		ApexPages.currentPage().getParameters().put('title', 'newname');
		cfc.dispatchOperation();
		testtemplate = [select Id, Name from PageTemplate__c where Id =:template.Id];
		System.assertEquals('newname', testtemplate.Name);
		
		//rename webform
		ApexPages.currentPage().getParameters().put('operation', 'rename_node');
		ApexPages.currentPage().getParameters().put('id', form.Id);
		ApexPages.currentPage().getParameters().put('sfdcnodetype', 'webform');
		ApexPages.currentPage().getParameters().put('title', 'newname');
		cfc.dispatchOperation();
		testform = [select Id, Name from Web_Form__c where Id =:form.Id];
		System.assertEquals('newname', testform.Name);
		
		//operation remove_node
		
		//remove  page
		ApexPages.currentPage().getParameters().put('operation', 'remove_node');
		ApexPages.currentPage().getParameters().put('id', pg.Id);
		ApexPages.currentPage().getParameters().put('sfdcnodetype', 'page');
		cfc.dispatchOperation();		
		//List<Page__c> testpages = [select Id from Page__c where Id =:pg.Id];
		//System.assert(testpages.isEmpty());
		
		//remove pagetemlate
		ApexPages.currentPage().getParameters().put('operation', 'remove_node');
		ApexPages.currentPage().getParameters().put('id', template.Id);
		ApexPages.currentPage().getParameters().put('sfdcnodetype', 'pagetemplate');
		cfc.dispatchOperation();
		//List<PageTemplate__c> testtemplates = [select Id from PageTemplate__c where Id =:template.Id];
		//System.assert(testtemplates.isEmpty());
		
		//remove webform
		ApexPages.currentPage().getParameters().put('operation', 'remove_node');
		ApexPages.currentPage().getParameters().put('id', form.Id);
		ApexPages.currentPage().getParameters().put('sfdcnodetype', 'webform');
		cfc.dispatchOperation();
		//List<Web_Form__c> testforms = [select Id from Web_Form__c where Id=:form.Id];
		//system.assert(testforms.isEmpty());
		
		//remove pagesfolder
		ApexPages.currentPage().getParameters().put('operation', 'remove_node');
		ApexPages.currentPage().getParameters().put('id', pagefolder3.Id);
		ApexPages.currentPage().getParameters().put('sfdcnodetype', 'pagesfolder');
		cfc.dispatchOperation();
		//List<CMSFolder__c> testfolders = [select Id from CMSFolder__c where Id=:pagefolder3.Id];
		//System.assert(testfolders.isEmpty());
		
		//remove pagetemplatesfolder
		ApexPages.currentPage().getParameters().put('operation', 'remove_node');
		ApexPages.currentPage().getParameters().put('id', templatefolder.Id);
		ApexPages.currentPage().getParameters().put('sfdcnodetype', 'pagetemplatesfolder');
		cfc.dispatchOperation();
		//testfolders = [select Id from CMSFolder__c where Id=:templatefolder.Id];
		//System.assert(testfolders.isEmpty());
		
		//remove  webform folder
		ApexPages.currentPage().getParameters().put('operation', 'remove_node');
		ApexPages.currentPage().getParameters().put('id', webformfolder.Id);
		ApexPages.currentPage().getParameters().put('sfdcnodetype', 'webformsfolder');
		cfc.dispatchOperation();
		//testfolders = [select Id from CMSFolder__c where Id=:webformfolder.Id];
		//System.assert(testfolders.isEmpty());
		
    }
    

}