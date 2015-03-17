public class SarahTestCanvas{

    public String jsonParms {get; set; }
    public boolean controllerRenderBoolVar { get; set; }

    public SarahTestCanvas() {
        controllerRenderBoolVar  = false;
        
        // Create a JSONGenerator object.
        // Pass true to the constructor for pretty print formatting.
        JSONGenerator gen = JSON.createGenerator(true);
        
        // Write data to the JSON string.
        gen.writeStartObject();
        gen.writeStringField('BoardId', 'a6tZ00000008Rlv');
        gen.writeStringField('tid', 'a6wZ00000008q2qIAA');
        gen.writeStringField('UserName', 'Sarah Kennedy');       
        gen.writeEndObject();
        
        // Get the JSON string.
        jsonParms = gen.getAsString();
        
        system.debug('jsonparms ' +  jsonParms);
   
    }
    
    public Void SetRender()
{
    controllerRenderBoolVar  = true;
}
}