public with sharing class AthenaSearchAndAddTagsController 
{

    public String tagvalue { get; set; }
    Public String tagid {get;set;}
    Set<String> tag_list = new Set<String>();  // declare a set of String called tag_list
    Set<String> tag_split = new Set<String>(); // declare a set of String called tag_split
    
    public AthenaSearchAndAddTagsController() 
    {
        tagvalue='';
    }
    
    public PageReference save() 
    {
        Tag__c taga=new Tag__c();
        List<Tag__c> tagresult=new List<Tag__c>();
        tagresult=[select id,Value__c from Tag__c];
        List<String> tagspilit=new List<String>();
        
        tagspilit=tagvalue.split(';');
        
        for(Tag__c tag_ite : tagresult)
        {
             tag_list.add(tag_ite.Value__c);
        }
        
        for(String tag_iteprop :tagspilit)
        {
         tag_split.add(tag_iteprop);
        }
        system.debug('#######################'+tagspilit);
        if(tagvalue!=null)
        {
        
        }
        return null;
    }



}