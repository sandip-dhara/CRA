/**********************************************************
* Class Name: ABPScoreCardController 
* Author: HP
* Date:15/09/2012 
* Requirement # Request Id:3255 
* Description: ABPScoreCardController has using display the Relationship suit & Organization Chart Data .
              
***********************************************************/


public class ABPScoreCardController {
    public Customer_Relationship_Map__c OppPlan;
    Public List<Customer_Relationship_Map__c> RelSuiteContacts;
    public String relmap {get;set;}
    Public String AccPlanId;
    Public Integer RelSuiteC;
    Public List<AggregateResult> RelSuiteMa;
    Public List<AggregateResult> RelSuiteSMa;
    Public List<AggregateResult> RelSuiteMi;
    Public List<Customer_Relationship_Map__c> RelStyleV1;
    Public List<Customer_Relationship_Map__c> RelStyleV2;
    Public List<Customer_Relationship_Map__c> RelStyleV3;
    Public List<Customer_Relationship_Map__c> RelStyleV4;
    public List<String> RelStringSplit;
    
      public ABPScoreCardController (ApexPages.StandardSetController controller) {
           
          AccPlanId = ApexPages.currentPage().getParameters().get('id');
           System.debug('AccountPlanId========'+AccPlanId);
        }
        
        public List<Customer_Relationship_Map__c> RelSuite {get
            {
            RelSuiteContacts = [select Id,Contact__r.Name,Contact__r.Title,Contact__r.id,Parent_Contact__c,RM_S__c,PP_S__c from Customer_Relationship_Map__c where Account_Plan__c = :AccPlanId ORDER BY PP_S__c DESC];
            
            
            return RelSuiteContacts;
            }        
            set;
         }
         
          public integer RelSuiteCount {get
            {
            RelSuiteC = [select count() from Customer_Relationship_Map__c where Account_Plan__c = :AccPlanId];
            return RelSuiteC;
            }        
            set;
         }
         
        
         
         public pageReference cancel(){
        pageReference pr = new pageReference('/'+AccPlanId);
        pr.setRedirect(true);
        return pr;
        
    }
         
         
        Public String getContactdata()
        {
        List<Customer_Relationship_Map__c> contacts = [Select Contact__r.Name,Contact__r.Title,Role__c,Parent_Contact__c from Customer_Relationship_Map__c where Account_Plan__c = :AccPlanId and Parent_Contact__c != ''];
       System.debug('===============Contacts Of Data================'+contacts);
        String datastr='';
        String dataname = '';
        String datatitle = '';
        
         for (integer i=0;i<contacts.size();i++)
            {
                If(contacts[i].Contact__r.Title == null)
                datatitle='';
                else 
                datatitle = contacts[i].Contact__r.Title;
                       
                dataname = '{v:\''+ contacts[i].Contact__r.Name +'\',f:\''+ contacts[i].Contact__r.Name +'<br/><font color=\"blue\"><i>'+ contacts[i].Contact__r.Title +'<i></font>\'' + '}';
                datastr += '[' + dataname;
                datastr += ',\'';
                datastr += contacts[i].Parent_Contact__c;
                datastr += '\',\'';
               datastr += datatitle;
                datastr += '\'],';
                system.debug('***google****'+datastr);
                                
               
            } 
           
            if(  datastr != ''){
            //datastr= datastr.substring(0,datastr.length()-1);// }
            datastr = datastr.substring(0,datastr.length()-1);
            system.debug('***google123****'+datastr);
            }
            return datastr;
    
        }   
        
        //we are not using this class now
         public class rsCustom {
            }
         
         
         
         public Integer RelSuiteMax {get
            {
            RelSuiteMa = [select MAX(PP_S__c) max from Customer_Relationship_Map__c  where Account_Plan__c = :AccPlanId];
            
            return integer.valueOF(RelSuiteMa[0].get('max'));
            }        
            set;
         }
         
         public Integer RelSuiteSMax {get
            {
            
            
            RelSuiteSMa = [select MAX(PP_S__c) max from Customer_Relationship_Map__c where Account_Plan__c = :AccPlanId and PP_S__c <> :RelSuiteMax];
            
            return integer.valueOF(RelSuiteSMa[0].get('max'));
            }        
            set;
         }
         public Integer RelSuiteMin {get
            {
            RelSuiteMi = [select MIN(PP_S__c) min from Customer_Relationship_Map__c where Account_Plan__c = :AccPlanId];
            
            return integer.valueOf(RelSuiteMi[0].get('min'));
            }        
            set;
         }
        
        public List<Customer_Relationship_Map__c> RelSuite2 {get
            {
            // query lists
            RelSuiteContacts = [select Id,Contact__r.Name,Contact__r.Title,Role__c,Parent_Contact__c,RM_S__c,PP_S__c from Customer_Relationship_Map__c where Account_Plan__c = :AccPlanId  ORDER BY PP_S__c DESC];
             System.debug('============================New Data'+RelSuiteContacts);
            //list to be returned
           List<Customer_Relationship_Map__c> relsuitecon = new List<Customer_Relationship_Map__c>();
            
           
            
            return RelSuiteContacts ;
            }        
            set;
         }
          
    }