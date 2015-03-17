/*
* NAME : ApttusParsXMLDomClassUtil
* NOTE : This is Utility Class to Parse XML file, used for Tibco Employee Hierarchy webservice response data,
*		 It will store output data to EmployeeBean Data Structure.
* Author : Apttus (Axay Varu)
*
*/
public with sharing class ApttusParsXMLDomClassUtil {
	
    public List<EmployeeBean> emp	{get;	set;}
    
    public ApttusParsXMLDomClassUtil()
    {
    	emp = new List<EmployeeBean>();
    }
    
    public List<EmployeeBean> parse(String toParse) 
    {
      DOM.Document doc = new DOM.Document();
      	try 
      	{
        	doc.load(toParse);    
        	DOM.XMLNode root = doc.getRootElement();
        	return walkThrough(root);
        	} catch (System.XMLException e) {  // invalid XML
        	return null;
      	}
    }

    // Recursively walk through the XML
    public List<EmployeeBean> walkThrough(DOM.XMLNode node) {
           
      List<String> returnList = new List<String>();
      
      if (node.getNodeType() == DOM.XMLNodeType.COMMENT) {
        
      }
      if (node.getNodeType() == DOM.XMLNodeType.TEXT) {
      	
        
      }
      if (node.getNodeType() == DOM.XMLNodeType.ELEMENT) {
                
        if (node.getText().trim() != '') 
        {
        	returnList = node.getText().trim().split('\\|\\|');
        	if(returnList.size() > 3)
        	{
        		
        			EmployeeBean eb = new EmployeeBean();
        			eb.cn = returnList[0];
        			eb.employeeNumber = returnList[1];
        			eb.mail = returnList[2];
        			eb.managerEmployeeNumber = returnList[3];
        			emp.add(eb);
        	}
         }
        
        for (Dom.XMLNode child: node.getChildElements()) {
          walkThrough(child);
        }
        return emp;
      }
      return emp;  //should never reach here
      
    }
}