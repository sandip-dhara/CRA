/**********************************************************************************
Name:  DealHealthChecklistExtractScheduled
Copyright © 2012  HP
===================================================================================
===================================================================================
Purpose:
-------
Batch Class to Extract DealHealthChecklist and send mail as an Attacahment
===================================================================================
===================================================================================
History
-------
VERSION      AUTHOR                DATE             DETAIL              
1.0 -       Pradeep Kumar L.G          23/10/2012      INITIAL DEVELOPMENT
**********************************************************************************/
global class DealHealthChecklistExtractScheduled implements Schedulable { 


    
    public List<Opportunity_Plan__c> opportunityplanlist;
    public static Boolean isTestrun=false;
    public List<User> userlist;

  global void execute(SchedulableContext context) {
      
      try{
          if(!isTestrun){
              
              opportunityplanlist= [Select Opportunity__c,Client_Name__c,Opportunity_Name__c,Opportunity_ID__c,Sales_Stage__c,DHC_2_Will_the_client_buy__c,DHC_2_Buyer_experience_with_HP__c,DHC_2_Client_Relationship_and_Insight__c,DHC_2_Client_Decision_Process__c,DHC_2_Competitive_Position__c,DHC_2_Solution_Scope__c,DHC_2_Differentiation__c,DHC_2_Teaming__c,DHC_2_Sales_Team_Staffing__c,DHC_2_Deal_Shape_and_Pricing__c,DHC_2_Delivery_Leadership_Team__c,DHC_2_Terms_and_Conditions__c,DHC_Comments_Buyer_Experience__c,DHC_Comments_Client_Decision_Process__c,DHC_Comments_Client_Relationship__c,DHC_Comments_Competitive_Position__c,DHC_Comments_Deal_Shape_and_Pricing__c,DHC_Comments_Delivery_Leadership_Team__c,DHC_Comments_Differentiation__c,DHC_Comments_Sales_Team_Staffing__c,DHC_Comments_Solution_Scope__c,DHC_Comments_Teaming__c,DHC_Comments_Terms_and_Conditions__c,DHC_Comments_WTB__c,DHC_last_updated__c,DHC_Last_Updated_Lagacy_No__c from Opportunity_Plan__c where Opportunity__c in(select id from Opportunity Where Business_Group2__c ='ES') AND DHC_last_updated__c!=null AND Sales_Stage__c!=null AND DHC_Last_Updated_Lagacy_No__c!=null AND (DHC_last_modified__c >=:System.Today() OR DHC_last_modified__c >=:System.Today()-1)];
            }
                 
        string header = 'Opportunity Id,DHC Sales Stage,Will They Buy,Buyer Experience With Hp,Client Relationship and Insight,Client Decision Process,Competetive Position,Solution Scope,Defferentation,Teaming,Sales Team Staffing,Deal Shape and Pricing,Delivery leadership team,Terms and Condition,Buyer Experience With Hp Comments,Client Decision Process Comments,Client Relationship and Insight Comments,Competetive Position Comments,Deal Shape and Pricing Comments,Delivery leadership team Comments,Defferentation Comments,Sales Team Staffing Comments,Solution Scope Comments,Teaming Comments,Terms and Condition Comments,Will They Buy Comments,Last Updated Timestamp,Last Update By Workforce Identifier,Last Updated By Full Name,Last Updated By Email Address\n';
        string finalstr = header ;
     
     Set<String> dhcusername=new Set<String>();
    for(Opportunity_Plan__c dhcuserlist: opportunityplanlist){
        if(dhcuserlist.DHC_Last_Updated_Lagacy_No__c!=null){
            dhcusername.add(dhcuserlist.DHC_Last_Updated_Lagacy_No__c);
        }   
    }
        if(!isTestrun){
            userlist=[select Email,UserName,Legacy_Employee_Ref__c,Name,CommunityNickname from User where (username in: dhcusername OR CommunityNickname in: dhcusername)];
        }
        Map<String,User> usermap=new Map<String,User>();
        Map<String,User> usermaplist=new Map<String,User>();
        for(User userdetail: userlist){
            usermap.put(userdetail.Username,userdetail);
            usermaplist.put(userdetail.CommunityNickname,userdetail);
        
        }
        system.debug('$$'+usermap);
       for(Opportunity_Plan__c dhclist: opportunityplanlist){
       
               String username=null;
               String useremailid=null;
               String legacyemployref=null;
               if(dhclist.DHC_Last_Updated_Lagacy_No__c!=null){
               String uniquename=dhclist.DHC_Last_Updated_Lagacy_No__c;
               system.debug('&&'+uniquename);
               try{
                username=usermap.get(uniquename).Name;
                useremailid=usermap.get(uniquename).Email;
                legacyemployref=usermap.get(uniquename).Legacy_Employee_Ref__c;
                }catch(Exception e){
                    username=usermaplist.get(uniquename).Name;
                    useremailid=usermaplist.get(uniquename).Email;
                    legacyemployref=usermaplist.get(uniquename).Legacy_Employee_Ref__c;
                }
               }
               
               String lastmodifiedtimestamp=dhclist.DHC_last_updated__c.Split(',')[1].replace('/','-').Trim();     
               
               string recordString = '"'+dhclist.Opportunity_ID__c+'","'+dhclist.Sales_Stage__c+'","'+dhclist.DHC_2_Will_the_client_buy__c+'","'+dhclist.DHC_2_Buyer_experience_with_HP__c+'","'+dhclist.DHC_2_Client_Relationship_and_Insight__c+'","'+dhclist.DHC_2_Client_Decision_Process__c+'","'+dhclist.DHC_2_Competitive_Position__c+'","'+dhclist.DHC_2_Solution_Scope__c+'","'+dhclist.DHC_2_Differentiation__c+'","'+dhclist.DHC_2_Teaming__c+'","'+dhclist.DHC_2_Sales_Team_Staffing__c+'","'+dhclist.DHC_2_Deal_Shape_and_Pricing__c+'","'+dhclist.DHC_2_Delivery_Leadership_Team__c+'","'+dhclist.DHC_2_Terms_and_Conditions__c+'","'+dhclist.DHC_Comments_Buyer_Experience__c+'","'+dhclist.DHC_Comments_Client_Decision_Process__c+'","'+dhclist.DHC_Comments_Client_Relationship__c+'","'+dhclist.DHC_Comments_Competitive_Position__c+'","'+dhclist.DHC_Comments_Deal_Shape_and_Pricing__c+'","'+dhclist.DHC_Comments_Delivery_Leadership_Team__c+'","'+dhclist.DHC_Comments_Differentiation__c+'","'+dhclist.DHC_Comments_Sales_Team_Staffing__c+'","'+dhclist.DHC_Comments_Solution_Scope__c+'","'+dhclist.DHC_Comments_Teaming__c+'","'+dhclist.DHC_Comments_Terms_and_Conditions__c+'","'+dhclist.DHC_Comments_WTB__c+'","'+lastmodifiedtimestamp+'","'+legacyemployref+'","'+username+'","'+useremailid+'" \n';
               finalstr = finalstr +recordString;
                            
       }
           String tocustumlabel=Label.GRIP_Extract_To_Mail_Id;
           String ccCustomlabel=Label.GRIP_Extract_CC_Mail_Id;
            
            List<String> toEmailaddress=new List<String>();
            List<String> ccEmailaddress=new List<String>();
            
            for(String tomailid: tocustumlabel.split(';')){
            
                toEmailaddress.add(tomailid);
            }                    
            for(String ccmailid: ccCustomlabel.split(';')){
            
                ccEmailaddress.add(ccmailid);
            }
           
        Messaging.EmailFileAttachment csvAttc = new Messaging.EmailFileAttachment();
                
                Blob csvBlob = Blob.valueOf(finalstr);
                string csvname= 'DHCExtract.csv';
                csvAttc.setFileName(csvname);
                csvAttc.setBody(csvBlob); 
              
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();                                
                 
                String subject ='Deal Health Checklist CSV';
                email.setSubject(subject);          
                email.setToAddresses (toEmailaddress);
                email.setCcAddresses (ccEmailaddress);                                
                email.setPlainTextBody('Please Find Attached DHC Extract Report as a CSV File');
                email.setFileAttachments(new Messaging.EmailFileAttachment[]{csvAttc});
                Messaging.SendEmailResult [] result = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email}); 
                  
        }catch(Exception e){
        
        }
    }
}