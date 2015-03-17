global class CPQEmailResponse {
    global class ResultClass {
        WebService String ResultCode;
        WebService String ResultMessage;

        public ResultClass() {}

        public ResultClass(String ResultCode, String ResultMessage) {
            this.ResultMessage = ResultMessage;
            this.ResultCode = ResultCode;
        }
    }

    global class EmailMessageClass {
        WebService String EmailBody;
        WebService String EmailSubject;

        public EmailMessageClass() {}

        public EmailMessageClass(String EmailSubject, String EmailBody) {
            this.EmailSubject = EmailSubject;
            this.EmailBody = EmailBody;
        }
    }

    WebService CPQEmailResponse.EmailMessageClass EmailMessage;
    WebService CPQEmailResponse.ResultClass Result;

    public CPQEmailResponse() {
        EmailMessage = new CPQEmailResponse.EmailMessageClass();
        Result = new CPQEmailResponse.ResultClass();
    }

    public CPQEmailResponse(CPQEmailResponse.EmailMessageClass oEMailResponse, CPQEmailResponse.ResultClass oResult) {
        EmailMessage = new CPQEmailResponse.EmailMessageClass(oEMailResponse.EmailSubject, oEMailResponse.EmailBody);
        Result = new CPQEmailResponse.ResultClass(oResult.ResultCode, oResult.ResultMessage);
    }
}