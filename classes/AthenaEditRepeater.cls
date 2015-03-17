public class AthenaEditRepeater {
        Public class LearningDtlsCustomClass
        {
           public string LeaningCat {get;set;}
        }

        Public class LearningDtlsLB
        {
            public string LeaningBoardName {get;set;}
        }
public List<LearningDtlsCustomClass> lstL1 {get;set;}
public List<LearningDtlsLB> lstL2 {get;set;}
public string HD_Area{get;set;}
public string HD_Current {get;set;}
public string HD_Allocated {get; set;}
// List<LearningDtlsCustomClass> ListHDDevicesbyVendor {get; set;}
public AthenaEditRepeater ( )
{
 // constructor code
 List<LearningDtlsCustomClass> lstL=new List<LearningDtlsCustomClass>();
  List<LearningDtlsLB> lstLDt=new List<LearningDtlsLB>();
 HD_Area='Heatest';
 HD_Current='curresr';
 HD_Allocated='allc';
List<Learning_Category__c> lstLearning= [SELECT Id,Name__c FROM Learning_Category__c];
for(Learning_Category__c cat : lstLearning)
{
LearningDtlsCustomClass lcu=new LearningDtlsCustomClass();
lcu.LeaningCat=cat.Name__c;
lstL.add(lcu);
}
lstL1=lstL;

List<Learning_Board_Learning__c> lstLBLC=[SELECT Name, Id, Learning_Board_ID__c, Learning_ID__c, Learning_Category_Id__c FROM Learning_Board_Learning__c where Learning_Board_ID__c='a6tZ00000008RI0IAM'];
list<Attachment> Att = new List<Attachment>();             
            Att = [SELECT Id, Body, ContentType, Name,ParentId FROM Attachment WHERE Parentid ='a6tZ00000008S5gIAE']; 

for(Attachment LBLC:Att){
LearningDtlsLB LBLNew=new LearningDtlsLB();
LBLNew.LeaningBoardName=LBLC.Id;
lstLDt.add(LBLNew);
}
lstL2=lstLDt;
}

            

}