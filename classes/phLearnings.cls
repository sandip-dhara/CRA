public class phLearnings {

public Id LeId{get;set;}
public Attachment att{get;set;}

public Attachment getAttchmentDetail ()
    {
    Attachment att = new Attachment();
    att = [SELECT Id,Name,BodyLength,ContentType,OwnerId,Createdby.Name,CreatedById FROM Attachment WHERE parentid = :LeId];
    return att;   
    }

}