global class CPQEmailWebService {

    WebService Static CPQEmailResponse GenerateEmailBody(String sSupportRequestId) {
        try {
            Support_Request__c oSupportRequest = [SELECT Id, Name, Request_Submitted_From__c,Type_of_Request__c,CPQ_Request_Type__c,Account_Name__c,Account_Name_Latin_Capture__c,Opportunity_ID__c,Request_Description__c from Support_Request__C where Name = : sSupportRequestId limit 1];
            String sRequestForm = oSupportRequest.Request_Submitted_From__c;
            string eMailpage = '';
            string sEmailSubject='';
            
            if (sRequestForm != '' && sRequestForm.contains('ESSN')) {
                eMailpage = '/apex/CPQESSNEmailForm?id=' + oSupportRequest.id + '&pageMode=View' + '&email=Y';
            } else if (sRequestForm != '' && sRequestForm.contains('PPS')) {
                eMailpage = '/apex/CPQPPSEmailForm?id=' + oSupportRequest.id + '&pageMode=View' + '&email=Y';
            }

            if (eMailpage != '') {
                PageReference oEmailPage = new PageReference(eMailpage);
                oEmailPage.setRedirect(true);
                Blob b2;
                try {
                    b2 = oEmailPage.getContent();
                } catch (VisualforceException e) {
                    b2 = Blob.valueOf('<head>BLob when occur error----------------------Test------</head>');
                }

                string emailBody = b2.toString();
                system.debug('*****emailBody1****' + emailBody);
                //string emailBody = Page.getContent().toString();
                emailBody = emailBody.replaceAll(Label.CPQ_Remove_uncheckbox_email, 'False');
                emailBody = emailBody.replaceAll(Label.CPQ_Remove_checkbox_email, 'True');
                emailBody = emailBody.replaceAll(emailBody.substring(emailBody.indexof('<head>'), emailBody.indexof('</head>') + 7), '');
                system.debug('*****emailBody2****' + emailBody);
                Pattern p = Pattern.compile('<script.*[A-Za-z0-9/][^<>]*');
                Matcher m = p.matcher(emailBody);
                system.debug('********found****' + m.find());
                //string temp = m.replaceAll('');
                //system.debug('**********temp****'+temp);
                emailBody = m.replaceAll('');
                emailBody = emailBody.replaceAll('</script>', '');
                emailBody = emailBody.replaceAll('(\\<.*?>)', '');
                emailBody = emailBody.replaceAll('&nbsp;', '');
                emailBody = emailBody.replaceAll('amp;', '');
                emailBody = emailBody.replaceAll('&quot;', '');
                //system.debug('*****emailBody****'+emailBody);
                sEmailSubject='SF.Com-'+oSupportRequest.Name+'-'+oSupportRequest.Type_of_Request__c+'-'+oSupportRequest.CPQ_Request_Type__c+'-';
                if(oSupportRequest.Account_Name_Latin_Capture__c!='' && oSupportRequest.Account_Name_Latin_Capture__c!=null)
                {
                    sEmailSubject+=oSupportRequest.Account_Name_Latin_Capture__c;
                }
                else
                {
                    sEmailSubject+=oSupportRequest.Account_Name__c;
                }
                
                if(oSupportRequest.Request_Description__c!=null&&oSupportRequest.Request_Description__c!='')
                {
                    sEmailSubject+='-'+(oSupportRequest.Request_Description__c).replaceAll('\n',' ')+'-'+oSupportRequest.Opportunity_ID__c;
                }
                else
                {
                    sEmailSubject+='- '+'-'+oSupportRequest.Opportunity_ID__c;
                }
                
                CPQEmailResponse.ResultClass oResult = new CPQEmailResponse.ResultClass('0', 'SUCCESS');
                CPQEmailResponse.EmailMessageClass oEmailMessage = new CPQEmailResponse.EmailMessageClass(sEmailSubject, emailBody);
                CPQEmailResponse oEmailResponse = new CPQEmailResponse(oEmailMessage, oResult);


                System.debug('###################' + oEmailResponse);
                return (oEmailResponse);
            } else {
                CPQEmailResponse.ResultClass oResult = new CPQEmailResponse.ResultClass('ERROR_CODE__1', 'No Email Template Associated');
                CPQEmailResponse.EmailMessageClass oEmailMessage = new CPQEmailResponse.EmailMessageClass('', '');
                CPQEmailResponse oEmailResponse = new CPQEmailResponse(oEmailMessage, oResult);
                return (oEmailResponse);
            }

        } catch (QueryException e) {
            CPQEmailResponse.ResultClass oResult = new CPQEmailResponse.ResultClass('ERROR_CODE__4', 'Support Request Not Found In SFDC');
            CPQEmailResponse.EmailMessageClass oEmailMessage = new CPQEmailResponse.EmailMessageClass('', '');
            CPQEmailResponse oEmailResponse = new CPQEmailResponse(oEmailMessage, oResult);
            System.debug('###################' + oEmailResponse);
            return (oEmailResponse);
        }
    }


}