Public class shareRecord{
    Public Boolean SRecord(Id RecordId,Id RequesterId){
        Learning_Board__Share LB = new Learning_Board__Share();
        LB.parentId = RecordId;
        LB.UserOrGroupId = RequesterId;
        LB.AccessLevel = 'edit';
        Database.SaveResult sr = Database.insert(LB,false);
        if(sr.isSuccess()){
            system.debug('successfull in sharing');
            return true;
        }
        else{
            Database.Error err = sr.getErrors()[0];
            if(err.getStatusCode() == StatusCode.FIELD_FILTER_VALIDATION_EXCEPTION  && err.getMessage().contains('AccessLevel')){
                return true;
            }
            else{
                return false;
            }
        }
    }
}