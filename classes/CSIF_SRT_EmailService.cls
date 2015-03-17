/**********************************************************
 * Class Name: CSIF_SRT_EmailService
 * Author: HP
 * Date: 26-SEP-2012 
 * Requirement # 
 * Description: A global Email Service Class to process the mails and update the records of Support Request in SFDC.
 ***********************************************************/

global class CSIF_SRT_EmailService implements Messaging.InboundEmailHandler {

    /**
     * @description: Method to process InbountEmail
     * @parameter: Inbound Email and Inbound Envelope
     */
    global Messaging.InboundEmailResult handleInboundEmail(Messaging.inboundEmail email, 
            Messaging.InboundEnvelope env){


        Messaging.InboundEmailResult result = new Messaging.InboundEmailResult();

        String myPlainText= '';

        myPlainText = email.plainTextBody;
        Integer Index1= myPlainText.indexOf('SFDC Support Request Number:');
        Integer Index2= myPlainText.indexOf('Status:');
        Integer Index3= myPlainText.indexOf('SRT Id:');
        Integer Index4= myPlainText.indexOf('CSIF Id:');

        String RequestName= myPlainText.subString(Index1+29, Index1+29+13);

        String Sub= email.Subject;

        try {
            List<Support_Request__c> supportRequest=[Select id, Status__c, Response_Comments__c, Support_Sub_Type__c From Support_Request__c Where Name=: RequestName];
            String status;
            if(supportRequest.size()>0){


                if(supportRequest[0].Support_Sub_Type__c=='CSIF'){

                    if(Index4!=-1){
                        status= myPlainText.subString(Index2+8, Index4-1);
                        String csifID= myPlainText.subString(Index4+9, Index4+9+11);
                        //supportRequest[0].System_Support_Request_Long_Nr__c=csifID; 
                        supportRequest[0].Status__c=status;

                        Integer Index6=myPlainText.indexOf('Notes to Sales Rep:');
                        Integer Index7=myPlainText.lastIndexOf('/*--');
                        String note;
                        if((Index6+20)>=(Index7-1))
                            note='';
                        else
                            note=myPlainText.subString(Index6+20, Index7-1);

                        supportRequest[0].Response_Comments__c=note;
                    }
                    else if(Index4==-1 && Index3 ==-1){
                        Integer Index8= myPlainText.indexOf('/*--');
                        status= myPlainText.subString(Index2+8, Index8-1);
                        supportRequest[0].Status__c=status;

                        Integer Index6=myPlainText.indexOf('Notes to Sales Rep:');
                        Integer Index7=myPlainText.lastIndexOf('/*--');
                        String note;
                        if((Index6+20)>=(Index7-1))
                            note='';
                        else
                            note=myPlainText.subString(Index6+20, Index7-1);

                        supportRequest[0].Response_Comments__c=note;
                    }


                }

                else if(supportRequest[0].Support_Sub_Type__c=='SRT'){
                    if(Index3!=-1){
                        status= myPlainText.subString(Index2+8, Index3-1);
                        String srtID= myPlainText.subString(Index3+8, Index3+8+10);
                        supportRequest[0].System_Support_Request_Long_Nr__c=srtID;
                        supportRequest[0].Status__c=status;

                        Integer Index6=myPlainText.indexOf('Notes to Sales Rep:');
                        Integer Index7=myPlainText.lastIndexOf('/*--');
                        String note;
                        if((Index6+20)>=(Index7-1))
                            note='';
                        else
                            note=myPlainText.subString(Index6+20, Index7-1);

                        supportRequest[0].Response_Comments__c=note;
                    }

                    else if(Index4==-1 && Index3 ==-1){
                        Integer Index8= myPlainText.indexOf('/*--');
                        status= myPlainText.subString(Index2+8, Index8-1);

                        supportRequest[0].Status__c=status;

                        Integer Index6=myPlainText.indexOf('Notes to Sales Rep:');
                        Integer Index7=myPlainText.lastIndexOf('/*--');
                        String note;
                        if((Index6+20)>=(Index7-1))
                            note='';
                        else
                            note=myPlainText.subString(Index6+20, Index7-1);

                        supportRequest[0].Response_Comments__c=note;

                    }
                }
                if(supportRequest[0].Support_Sub_Type__c=='Premier Resource'){

                    Integer Index9= myPlainText.indexOf('Status:');
                    Integer Index10= myPlainText.indexOf('/*--');
                    Integer Index11= myPlainText.indexOf('Delivery Manager:');
                    Integer Index12= myPlainText.indexOf('Type of Resource Assigned (TAM, ESM, NCRE, NASE -separate by semi-colons):');
                    Integer Index13= myPlainText.indexOf('Comments:');
                    Integer Index14= myPlainText.indexOf('/*--', Index13);
                    Integer Index15= myPlainText.indexOf('Resource Assigned Date:');
                    //Integer Index16= myPlainText.indexOf('Premier Routing Setup:');
                    Integer Index17= myPlainText.indexOf('ESM Assigned:');
                    Integer Index18= myPlainText.indexOf('TAM Assigned:');
                    Integer Index19= myPlainText.indexOf('NCRE Assigned:');
                    Integer Index20= myPlainText.indexOf('NASE Assigned:');
                    Integer Index21= myPlainText.LastindexOf('/*--');

                    if((Index9+8)<(Index10-1)){
                        supportRequest[0].Request_Status__c = myPlainText.subString(Index9+8, Index10-1);

                    }

                    if((Index11+18)<(Index12-1)){
                        supportRequest[0].Delivery_Manager__c = myPlainText.subString(Index11+18, Index12-1);

                    }

                    if((Index12+75)<(Index13-1)){
                        supportRequest[0].Type_of_Resource_Assigned__c = myPlainText.subString(Index12+75, Index13-1);

                    }
                    if((Index13+10)<(Index14-1)){
                        supportRequest[0].Response_Comments__c = myPlainText.subString(Index13+10, Index14-1);

                    }

                    if((Index15+24)<(Index17-1)){
                        supportRequest[0].Resource_Assigned_Date__c = myPlainText.subString(Index15+24, Index17-1);

                    }
                    /*if((Index16+23)<(Index17-1)){
                        supportRequest[0].Premier_Routing_Setup__c = myPlainText.subString(Index16+23, Index17-1);

                    }*/
                    if((Index17+14)<(Index18-1)){
                        supportRequest[0].ESM_Assigned__c = myPlainText.subString(Index17+14, Index18-1);

                    }
                    if((Index18+14)<(Index19-1)){
                        supportRequest[0].TAM_Assigned__c = myPlainText.subString(Index18+14, Index19-1);

                    }
                    if((Index19+15)<(Index20-1)){
                        supportRequest[0].NCRE_Assigned__c = myPlainText.subString(Index19+15, Index20-1);

                    }
                    if((Index20+15)<(Index21-1)){
                        supportRequest[0].NASE_Assigned__c = myPlainText.subString(Index20+15, Index21-1);

                    }



                }

                update supportRequest;

                /* List<attachment> attachList= new List<Attachment> ();

                if (email.binaryAttachments != null && email.binaryAttachments.size() > 0) {
                    for (integer i = 0 ; i < email.binaryAttachments.size() ; i++) {


                        Attachment attachment1 = new Attachment();
                        attachment1.ParentId = supportRequest[0].Id;
                        attachment1.Name = email.binaryAttachments[i].filename;
                        attachment1.Body = email.binaryAttachments[i].body;

                        attachList.add(attachment1);
                    }
                    insert attachList;
                } */
            }
        }

        catch (QueryException e) {
            System.debug('Query Issue: ' + e);
        }

        result.success = true;

        // Return the result for the Apex Email Service
        return result;
    }
}