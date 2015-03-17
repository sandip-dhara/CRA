public class SPLCreateCommunity
{

    Public String strSearchValue{get;set;}
    public string CommunityName {get;set;}
public string CommunityDescription {get;set;}
public string ImageSelectionOption {get;set;}
{
ImageSelectionOption='UFC';
}
Public String CommunityId {get;set;}
public string dropSelectedval {get;set;}
public Attachment Communityattach {get;set;}   
//Public string[] ErrMsgs {get;set;}
  Public List<SelectOption> DefaultImagefilename{
     get{
            List<string> lstImgFileName=new List<string>();
            string imageFileNames = AthenaUtility.ApplicationSettingValue(AthenaUtility.LearningBoardDefaultImages);
            lstImgFileName = imageFileNames.split(',');
            List<SelectOption> options = new List<SelectOption>();
            integer index;
            options.add(new selectOption('SelectImage', '- Select Image -'));
            for(index=0;index<lstImgFileName.size();index++){
                string strText=lstImgFileName[index];               
                options.add( new SelectOption(lstImgFileName[index],strText.split('\\.')[0]));
            }
            return options;
        }
    set;    
    } 


public SPLCreateCommunity()
{
Communityattach=new Attachment();
 Communityattach.Name = 'Dummy Attachment';
        Communityattach.Body = Blob.valueOf('Dummy attachment');
        Communityattach.contentType = 'html/text';
//ErrMsgs = new string[]{'No image was selected.', 'No image was uploaded.', 'Image option was not chosen'};
}

public PageReference  RedirectToSLP_GlobalSearch()
    {            
        PageReference pRef = new PageReference('/apex/SLP_GlobalSearch');
        pRef.getParameters().put('SearchVal',strSearchValue);
        pRef.setRedirect(true);
        return pRef;
    }
Public String getStaticImagePath{
    get{
        return 'https://'+ URL.getSalesforceBaseUrl().getHost() + GetResourceURL('img_athena') +'/img_athena/';
        }
    }
      Public String getSfInstance{
    get{
        return ApexPages.currentPage().getHeaders().get('Host');
        }
    }
     Public User GetLoggedinUserDtls(){
        User u = [Select Name,SmallPhotoUrl From User where User.id= :UserInfo.getUserId()];
        return U;
    }

 public List<SelectOption> getImageOptions() {
        List<SelectOption> options = new List<SelectOption>(); 
        options.add(new SelectOption('UFC','Upload from Computer')); 
        options.add(new SelectOption('DI','Default Image')); 
        return options; 
    }

private static String GetResourceURL(String resourceName)  
      {  
        //Fetching the resource 
        string resourcepath='';
        List<StaticResource> resourceList= new List<StaticResource>();
        resourceList = [SELECT Name, NamespacePrefix, SystemModStamp FROM StaticResource WHERE Name = :resourceName];  
        //Checking if the result is returned or not  
        if(resourceList.size() == 1)  
        {  
           //Getting namespace  
           String namespace = resourceList[0].NamespacePrefix;  
           //Resource URL          
           resourcepath= '/resource/' + resourceList[0].SystemModStamp.getTime() + '/' + (namespace != null && namespace != '' ? namespace + '__' : '') + resourceName;
        }  
        return resourcepath;  
       }

public PageReference CreateCommunity()
{
 
PageReference pRef = ApexPages.currentPage();
try
            { 
system.debug('dropSelectedval:'+dropSelectedval);
Community__c community =new Community__c();
community.Name__c=CommunityName.trim();
community.Description__c=CommunityDescription;
community.Public__c=false;
community.IsActive__c=false;

system.debug('ImageSelectionOption:'+ImageSelectionOption);

 List<Community__c> LstCommunity=new  List<Community__c>();

LstCommunity=[SELECT Id, Name__c FROM Community__c where name__C=:CommunityName.trim()];
if (LstCommunity.size()>0)
    {
          ApexPages.addMessage( new ApexPages.Message(ApexPages.Severity.ERROR, 'Duplicate Community Name'));
pRef.setRedirect(false);
                            return pRef;
    }
else
{

if (ImageSelectionOption==null)
    {
           ApexPages.addMessage( new ApexPages.Message(ApexPages.Severity.ERROR, 'Please Select Commnunity option'));
pRef.setRedirect(false);
                            return pRef;
    }
else
{
    if(ImageSelectionOption=='DI')
        {
 
if (dropSelectedval =='SelectImage')
    {
         ApexPages.addMessage( new ApexPages.Message(ApexPages.Severity.ERROR, 'Please Upload Image'));
            pRef.setRedirect(false);
         return pRef;
    }

    else
        {

                If(dropSelectedval!='SelectImage')
                {
                    community.Default_Image_Name__c = dropSelectedval;
                    insert community; 
                }
        }
        }
 else if(ImageSelectionOption=='UFC')
    {
        community.Default_Image_Name__c='';
       

if((Communityattach.Name == 'Dummy Attachment'))
{
     ApexPages.addMessage( new ApexPages.Message(ApexPages.Severity.ERROR, 'Please Upload Image'));
        pRef.setRedirect(false);
         return pRef;
}
else
{
If(Communityattach!=null )
        {
        insert community; 
        this.CommunityId =community.id;
            Communityattach.ParentId = this.CommunityId;
            insert Communityattach;
        }
}

        

    }
}
}
}

    catch (SLP_Exception e)
            {
                 ApexPages.addMessage( new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
pRef.setRedirect(false);
                        return pRef;
            }
   catch (DMLException dmlex)
                {
                        ApexPages.addMessage( new ApexPages.Message(ApexPages.Severity.ERROR, dmlex.getMessage()));
pRef.setRedirect(false);
                        return pRef;
                }
    finally
    {
  
    }
        pRef = new PageReference('/apex/SLP_EditCommunity?id=' + this.CommunityId);
        pRef.setRedirect(true);
        return pRef;
}

}