public with sharing class OAE_StartHereCtlr {
        public Boolean gotUsers {get;set;}
        public Boolean firstDone {get;set;}
        public Boolean secondDone {get;set;}
        
        public OAE_StartHereCtlr() {
                List<User> activeUsers = [select id, isActive, userType from User where isActive = true and userType = 'Standard' LIMIT 2];
                gotUsers = (activeUsers.size() > 1);
                List<Group> g = [Select id, name from Group where name = 'Lead Default Triage Queue'];
                firstDone = (g.size() > 0);                  
                List<Lead> l = [select id, company from Lead where company = 'zoom 4'];
                secondDone = (l.size() > 0);                 
        }
        public PageReference populateFirst() {
                OAE_DataSetup.setupFirstDataForDogAndPony();
                firstDone = true;
                return null;
        }
        public PageReference populateSecond() {
                OAE_DataSetup.setupSecondDataForDogAndPony();
                secondDone = true;
                return null;
        }
}