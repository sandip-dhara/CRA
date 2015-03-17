/**
* Class Name: CPQXMLUtilController
* Author: HP - Mohit
* Date: 07-Nov-2012 
* Description: Create XML attachment file for CPQ ESSN Request
*/
public class CPQXMLUtilController {
public static void test_coverage()
{
}
   /* 
    Public String generateXML(String ObjectName, String RootNode,ID sObjectId)
    {
        
        String sXMLString='';
        String sSOQL='SELECT ';
        String sFieldList='';
        Boolean isFirstField=true;
        String sWhereClause=' where Id=\''+sObjectId+'\'';
        Map<String,CPQRequestXML__c> oCPQXML= CPQRequestXML__c.getAll();
        Sobject oSupportReq;
        
        
        if(!oCPQXML.isEmpty())
        {
         
          for(String XMLTags: oCPQXML.KeySet())
            {
                if(isFirstField)
                {
                    sFieldList=oCPQXML.get(XMLTags).APIName__c;
                    isFirstField=false;
                    System.debug('FirstField= '+sFieldList);
                }
                else
                {
                    sFieldList=sFieldList+','+oCPQXML.get(XMLTags).APIName__c;
                }
            }
          sSOQL= sSOQL+ ' '+sFieldList+ ' FROM '+ObjectName+sWhereClause;
          
          
          System.debug(sSOQL);
          
          oSupportReq=Database.query(sSOQL);
          
          System.debug(oSupportReq);
          
          XmlStreamWriter oXMLStream= new XmlStreamWriter();
          oXMLStream.writeStartDocument(null, '1.0');
         
          
          oXMLStream.writeStartElement('', RootNode, 'http://www.tibco.com/schemas/XSD/Schema.xsd');
          oXMLStream.writeDefaultNamespace('http://www.tibco.com/schemas/XSD/Schema.xsd');
          oXMLStream.writeNamespace('xs', 'http://www.w3.org/2001/XMLSchema');
          for(String XMLTags: oCPQXML.KeySet())
          {
            String sField=oCPQXML.get(XMLTags).APIName__c;
            String sDefaultValue=oCPQXML.get(XMLTags).DefaultValue__c;
            String sContents=String.valueOf(oSupportReq.get(sField));
            
            if(sContents==''||sContents==null)
            {
                sContents=sDefaultValue;
            }
            
            if(sContents==''||sContents==null)
            {
                
                oXMLStream.writeEmptyElement(null, XMLTags, null);
            }
            else
            {
                oXMLStream.writeStartElement(null, XMLTags, null);
                oXMLStream.writeCharacters(sContents);
                oXMLStream.writeEndElement();
            }
            
            
          }
          
          oXMLStream.writeEndElement(); 
          oXMLStream.writeEndDocument();
          sXMLString=oXMLStream.getXmlString();
          oXMLStream.close();
        }
        
        System.debug(sXMLString);
 
        return(sXMLString);
    }
*/
}