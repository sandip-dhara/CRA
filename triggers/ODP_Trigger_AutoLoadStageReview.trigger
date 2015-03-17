trigger ODP_Trigger_AutoLoadStageReview on Release_Stage__c (after update, after insert) { 
    if(Trigger.isUpdate){
        String host = URL.getSalesforceBaseUrl().toExternalForm();
        for(Release_Stage__c relstg : trigger.new){
            try{
                Release_Stage__c relstgOld = null;
                for(Release_Stage__c rel : trigger.old)
                {
                    if(rel.Id == relstg.Id)
                    {
                        relstgOld = rel;
                        break;
                    }
                }
                System.Debug('before pac delete' + relstg.PAC_Name__c + '|' + relstg.Status__c + '////////' + relstgOld.Status__c );
                //NOTIFICATE to review stage                    
                if (relstgOld.Status__c != 'In Review' && relstg.Status__c == 'In Review' && relstg.PAC_Name__c != null){
                                  
                    
                    ODP_PAC__c PACItem = new ODP_PAC__c();
                    PACItem = [select Name, Id from ODP_PAC__c where Id =: relstg.PAC_Name__c];
                    List <ODP_PAC_Member__c> PACMemberList = [select Id,User__r.id from ODP_PAC_Member__c where PAC_Name__c =:PACItem.Id ];
                    
                    Offering_Release__c orc = [select OwnerId, Facilitator__r.Id from Offering_Release__c where id =: relstg.Offering_Release_ID__c]; 
                    User ownerUser = [select email, Name from User where id =: orc.Facilitator__r.Id ];
                    User FacilitatorUser = [select email, Name from User where id =: orc.Facilitator__r.Id]; 
                                                      
                    for(ODP_PAC_Member__c opc : PACMemberList){
                       
                        if( relstgOld.Status__c != relstg.Status__c){ 
                                                  
                            User userTemp = [select Name, Email from User where id =: opc.User__r.id]; 
                            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                        
                            String[] toAddresses = new String[] {userTemp.Email};
                            mail.setToAddresses(toAddresses);
                            mail.setSenderDisplayName('Athena ODP'); 
                            mail.setSubject('Notification - The status of the Stage Review ' + relstg.Release_Name__c + ' is In Review now,  Please review it.'); 
                            mail.setUseSignature(false);
                       
                            string bodyString = '<html><head><meta http-equiv="Content-Type" content="text/html; charset=utf-8"><title></title></head>';
                            bodyString = bodyString + '<style>a:link {color:white;}a:visited {color:#D7410B;}a:hover {color:#D7410B;}a:active {color:#D7410B;}.fontclass{font-family: \'HP Simplified\',\'Arial\',\'sans-serif\' !important;}</style><body style="font-family: \'HP Simplified\',\'Arial\',\'sans-serif\' !important;"><p>&nbsp;</p>';
                            bodyString = bodyString + '<table align="center" border="0" cellpadding="1" cellspacing="1" style="width: 800px;">';
                            bodyString = bodyString + '<tbody><tr><td><h3><span style="font-size:24px;"><span style="font-family:HP Simplified,Arial,sans-serif;"><strong><b class="fontclass">Opportunity Development<br></b>';
                            bodyString = bodyString + '<small>HP Enterprise Services IT</small></strong></span></span></h3></td><td>';
                            bodyString = bodyString + '<img alt="" src="https://hp--plmesit--c.cs10.content.force.com/servlet/servlet.ImageServer?id=015J0000000HBJY&oid=00DJ00000036uji" style="width: 100px; height: 100px; border-width: 0px; border-style: solid; margin: 0px; float: right;"></td></tr></tbody></table>';
                            bodyString = bodyString + '<table align="center" border="0" cellpadding="1" cellspacing="1" style="width: 800px; height: 300px;">';
                            bodyString = bodyString + '<tbody><tr><td><h1><b class="fontclass">For Your Information</b>&nbsp;</h1><p>';
                            bodyString = bodyString + '<span style="font-size:16px;"><span style="font-family:HP Simplified,Arial,sans-serif;">';
                            bodyString = bodyString + 'To  '+ userTemp.Name +' ,&nbsp;</span></span></p>';
                            bodyString = bodyString + '<p><span style="font-size:16px;"><span style="font-family:HP Simplified,Arial,sans-serif;">You are invited as the Stage Review BEP for '+ relstg.Release_Name__c + '.The status of the Stage Review ' + relstg.Release_Name__c + ' is In Review now,  Please review it.</span></span></p><p>';
                            bodyString = bodyString + '<table style="border:1px solid black;width:100%;"><tr>';
                            bodyString = bodyString + '<td style="background-color:#D7410B; padding-left:10px;color:white; white-space:nowrap;"><b class="fontclass">Stage</b></td>';
                            bodyString = bodyString + '<td style="background-color:#0096D6;color:white;">';
                            bodyString = bodyString + '<b class="fontclass"><a href="' + host + '/apex/ODP_ReleaseStageApprovalDetail?id='+relstg.id+'">' + relstg.Release_Name__c +' </a></b>' + '</td></tr>';
                            bodyString = bodyString + '<tr><td style="background-color:#a9a9a9; padding-left:10px;padding-right:30px;color:white; white-space:nowrap;width:230px;"><b class="fontclass">Contacts for questions</b></td>';
                            bodyString = bodyString + '<td style="background-color:#0096D6;color:white;">';
                            bodyString = bodyString + '<b class="fontclass">Business Engagement Partner : <a href="mailto:' + ownerUser.email  + '">  ' + ownerUser.Name + ' </a></b></td></tr></table></p>';
                            bodyString = bodyString + '<p><span style="font-size:16px;"><span style="font-family:HP Simplified,Arial,sans-serif;"><br <br="">Regards,&nbsp;</span></span></p>';
                            bodyString = bodyString + '<p><span style="font-size:16px;"><span style="font-family:HP Simplified,Arial,sans-serif;">HP ESIT Engagement Team</span></p>';
                            bodyString = bodyString + '</td></tr></tbody></table>';
                            bodyString = bodyString + '<h3 style="color:blue;">&nbsp;</h3><p>&nbsp;</p><p>&nbsp;</p><p>&nbsp;</p>';
                            bodyString = bodyString + '<hr><p style="text-align: center;">';
                            bodyString = bodyString + '<span style="font-size:10px;"><span style="font-family:HP Simplified,Arial,sans-serif;">&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp;HP Confidential and Internal use only</span></span></p>';
                            bodyString = bodyString + '</body></html>';
                       
                            mail.setHtmlBody(bodyString);

                            // Send the email you have created.
                            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });                           
                        }      
                    }
                    
                    if(FacilitatorUser != null){
                            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();                       
                            String[] toAddresses = new String[] {FacilitatorUser.Email};
                            mail.setToAddresses(toAddresses);
                            mail.setSenderDisplayName('Athena Offering Life Cycle'); 
                            mail.setSubject('Notification - The status of the Stage Review ' + relstg.Release_Name__c + ' is In Review now,  Please prepare for stage review.'); 
                            mail.setUseSignature(false);
                       
                            string bodyString = '<html><head><meta http-equiv="Content-Type" content="text/html; charset=utf-8"><title></title></head>';
                            bodyString = bodyString + '<style>a:link {color:white;}a:visited {color:#D7410B;}a:hover {color:#D7410B;}a:active {color:#D7410B;}.fontclass{font-family: \'HP Simplified\',\'Arial\',\'sans-serif\' !important;}</style><body style="font-family: \'HP Simplified\',\'Arial\',\'sans-serif\' !important;"><p>&nbsp;</p>';
                            bodyString = bodyString + '<table align="center" border="0" cellpadding="1" cellspacing="1" style="width: 800px;">';
                            bodyString = bodyString + '<tbody><tr><td><h3><span style="font-size:24px;"><span style="font-family:HP Simplified,Arial,sans-serif;"><strong><b class="fontclass">Opportunity Development<br></b>';
                            bodyString = bodyString + '<small>HP Enterprise Services IT</small></strong></span></span></h3></td><td>';
                            bodyString = bodyString + '<img alt="" src="https://hp--plmesit--c.cs10.content.force.com/servlet/servlet.ImageServer?id=015J0000000HBJY&oid=00DJ00000036uji" style="width: 100px; height: 100px; border-width: 0px; border-style: solid; margin: 0px; float: right;"></td></tr></tbody></table>';
                            bodyString = bodyString + '<table align="center" border="0" cellpadding="1" cellspacing="1" style="width: 800px; height: 300px;">';
                            bodyString = bodyString + '<tbody><tr><td><h1><b class="fontclass">For Your Information</b>&nbsp;</h1><p>';
                            bodyString = bodyString + '<span style="font-size:16px;"><span style="font-family:HP Simplified,Arial,sans-serif;">';
                            bodyString = bodyString + 'To  '+ FacilitatorUser.Name +' ,&nbsp;</span></span></p>';
                            bodyString = bodyString + '<p><span style="font-size:16px;"><span style="font-family:HP Simplified,Arial,sans-serif;">You are the Business Engagement Partner for Opportunity ['+ relstg.Release_Name__c + '].The status of the Stage [' + relstg.Release_Name__c + '] is In Review now,  Please prepare for the stage review.</span></span></p><p>';
                            bodyString = bodyString + '<table style="border:1px solid black;width:100%;"><tr>';
                            bodyString = bodyString + '<td style="background-color:#D7410B; padding-left:10px;color:white; white-space:nowrap;"><b class="fontclass">Stage</b></td>';
                            bodyString = bodyString + '<td style="background-color:#0096D6;color:white;">';
                            bodyString = bodyString + '<b class="fontclass"><a href="' + host + '/apex/ODP_ReleaseStageApprovalDetail?id='+relstg.id+'">' + relstg.Release_Name__c +' </a></b>' + '</td></tr>';
                            bodyString = bodyString + '<tr><td style="background-color:#a9a9a9; padding-left:10px;padding-right:30px;color:white; white-space:nowrap;width:230px;"><b class="fontclass">Contacts for questions</b></td>';
                            bodyString = bodyString + '<td style="background-color:#0096D6;color:white;">';
                            bodyString = bodyString + '<b class="fontclass">Business Engagement Partner : <a href="mailto:' + ownerUser.email  + '">  ' + ownerUser.Name + ' </a></b></td></tr></table></p>';
                            bodyString = bodyString + '<p><span style="font-size:16px;"><span style="font-family:HP Simplified,Arial,sans-serif;"><br <br="">Regards,&nbsp;</span></span></p>';
                            bodyString = bodyString + '<p><span style="font-size:16px;"><span style="font-family:HP Simplified,Arial,sans-serif;">HP ESIT Engagement Team</span></p>';
                            bodyString = bodyString + '</td></tr></tbody></table>';
                            bodyString = bodyString + '<h3 style="color:blue;">&nbsp;</h3><p>&nbsp;</p><p>&nbsp;</p><p>&nbsp;</p>';
                            bodyString = bodyString + '<hr><p style="text-align: center;">';
                            bodyString = bodyString + '<span style="font-size:10px;"><span style="font-family:HP Simplified,Arial,sans-serif;">&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp;HP Confidential and Internal use only</span></span></p>';
                            bodyString = bodyString + '</body></html>';
                       
                            mail.setHtmlBody(bodyString);

                            // Send the email you have created.
                            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });                         
                    }
                    
                                  
                }
                //create stage reviewer and notify them                
                else if(relstg.PAC_Name__c != relstgOld.PAC_Name__c && relstg.PAC_Name__c != null && (relstg.Status__c == 'Not Started' || relstg.Status__c == 'In Progress' ))
                { 
                    List<Stage_Review__c>   srcExistList = [select id from Stage_Review__c where Release_Stage_ID__c =: relstg.id ];
                    if(srcExistList.size() > 0){
                        for(Stage_Review__c srTemp: srcExistList ){ 
                        System.Debug('pac delete' + relstg.PAC_Name__c + '|' + relstgOld.PAC_Name__c);
                            delete srTemp;     
                        }
                    }
                    
                    ODP_PAC__c PACItem = new ODP_PAC__c();
                    PACItem = [select Name, Id from ODP_PAC__c where Id =: relstg.PAC_Name__c];
                    List <ODP_PAC_Member__c> PACMemberList = [select Id,User__r.id from ODP_PAC_Member__c where PAC_Name__c =:PACItem.Id ];
                    Offering_Release__c orc = [select OwnerId,Facilitator__r.Id from Offering_Release__c where id =: relstg.Offering_Release_ID__c]; 
                    User ownerUser = [select email, Name from User where id =: orc.Facilitator__r.Id ];                                 
                    for(ODP_PAC_Member__c opc : PACMemberList){
                        Stage_Review__c src = new Stage_Review__c();
                        src.Release_Stage_ID__c = relstg.Id;
                        src.PAC_Member_ID__c = opc.Id ; 
                        insert src;
                        
                        
                        if( relstgOld.Status__c != relstg.Status__c){                        
                            User userTemp = [select Name, Email from User where id =: opc.User__r.id]; 
                            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                        
                            String[] toAddresses = new String[] {userTemp.Email};
                            mail.setToAddresses(toAddresses);
                            mail.setSenderDisplayName('Athena ODP'); 
                            mail.setSubject('Notification - You are invited as the Stage Reviewer for '+ relstg.Release_Name__c); 
                            mail.setUseSignature(false);
                       
                            string bodyString = '<html><head><meta http-equiv="Content-Type" content="text/html; charset=utf-8"><title></title></head>';
                            bodyString = bodyString + '<style>a:link {color:white;}a:visited {color:#D7410B;}a:hover {color:#D7410B;}a:active {color:#D7410B;}.fontclass{font-family: \'HP Simplified\',\'Arial\',\'sans-serif\' !important;}</style><body style="font-family: \'HP Simplified\',\'Arial\',\'sans-serif\' !important;"><p>&nbsp;</p>';
                            bodyString = bodyString + '<table align="center" border="0" cellpadding="1" cellspacing="1" style="width: 800px;">';
                            bodyString = bodyString + '<tbody><tr><td><h3><span style="font-size:24px;"><span style="font-family:HP Simplified,Arial,sans-serif;"><strong><b class="fontclass">Opportunity Development<br></b>';
                            bodyString = bodyString + '<small>HP Enterprise Services IT</small></strong></span></span></h3></td><td>';
                            bodyString = bodyString + '<img alt="" src="https://hp--plmesit--c.cs10.content.force.com/servlet/servlet.ImageServer?id=015J0000000HBJY&oid=00DJ00000036uji" style="width: 100px; height: 100px; border-width: 0px; border-style: solid; margin: 0px; float: right;"></td></tr></tbody></table>';
                            bodyString = bodyString + '<table align="center" border="0" cellpadding="1" cellspacing="1" style="width: 800px; height: 300px;">';
                            bodyString = bodyString + '<tbody><tr><td><h1><b class="fontclass">For Your Information</b>&nbsp;</h1><p>';
                            bodyString = bodyString + '<span style="font-size:16px;"><span style="font-family:HP Simplified,Arial,sans-serif;">';
                            bodyString = bodyString + 'To  '+ userTemp.Name +' ,&nbsp;</span></span></p>';
                            bodyString = bodyString + '<p><span style="font-size:16px;"><span style="font-family:HP Simplified,Arial,sans-serif;">You are invited as the Stage Reviewer for '+ relstg.Release_Name__c + '. Please check the details as below</span></span></p><p>';
                            bodyString = bodyString + '<table style="border:1px solid black;width:100%;"><tr>';
                            bodyString = bodyString + '<td style="background-color:#D7410B; padding-left:10px;color:white; white-space:nowrap;"><b class="fontclass">Release Stage</b></td>';
                            bodyString = bodyString + '<td style="background-color:#0096D6;color:white;">';
                            bodyString = bodyString + '<b class="fontclass"><a href="' + host + '/' + relstg.id+'">' + relstg.Stage_Name__c+' </a></b>' + '</td></tr>';
                            bodyString = bodyString + '<tr><td style="background-color:#a9a9a9; padding-left:10px;padding-right:30px;color:white; white-space:nowrap;width:230px;"><b class="fontclass">Contacts for questions</b></td>';
                            bodyString = bodyString + '<td style="background-color:#0096D6;color:white;">';
                            bodyString = bodyString + '<b class="fontclass">Business Engagement Partner : <a href="mailto:' + ownerUser.email  + '">  ' + ownerUser.Name + ' </a></b></td></tr></table></p>';
                            bodyString = bodyString + '<p><span style="font-size:16px;"><span style="font-family:HP Simplified,Arial,sans-serif;"><br <br="">Regards,&nbsp;</span></span></p>';
                            bodyString = bodyString + '<p><span style="font-size:16px;"><span style="font-family:HP Simplified,Arial,sans-serif;">HP ESIT Engagement Team</span></p>';
                            bodyString = bodyString + '</td></tr></tbody></table>';
                            bodyString = bodyString + '<h3 style="color:blue;">&nbsp;</h3><p>&nbsp;</p><p>&nbsp;</p><p>&nbsp;</p>';
                            bodyString = bodyString + '<hr><p style="text-align: center;">';
                            bodyString = bodyString + '<span style="font-size:10px;"><span style="font-family:HP Simplified,Arial,sans-serif;">&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp;HP Confidential and Internal use only</span></span></p>';
                            bodyString = bodyString + '</body></html>';
                       
                            mail.setHtmlBody(bodyString);

                            // Send the email you have created.
                            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });                           
                        }      
                    }                   
                }
                //sql improvement huter 2 change the condition from (relstg.PAC_Name__c == null) to (relstgOld.PAC_Name__c != null &&relstg.PAC_Name__c == null)
                else if((relstg.Status__c == 'Not Started' || relstg.Status__c == 'In Progress' ) && relstgOld.PAC_Name__c != null && relstg.PAC_Name__c == null){ 
                    List<Stage_Review__c>   srcExistList = [select id from Stage_Review__c where Release_Stage_ID__c =: relstg.id ];
                    if(srcExistList.size() > 0){
                        for(Stage_Review__c srTemp: srcExistList ){ 
                            delete srTemp;     
                        }
                    }
                }                    
            }
            catch(exception e)            
            {                                
                System.debug(e.getMessage());                         
            }                 
        }
    }

}