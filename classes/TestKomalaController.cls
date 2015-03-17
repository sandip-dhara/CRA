public class TestKomalaController {
public String InputText{get;set;}

@RemoteAction
public static String EncodeText(String encodeText)
{
//String result=encodeText.escapeHtml4();
String result=EncodingUtil.urlEncode(encodeText,'UTF-8');
return result;
}

@RemoteAction
public static String DecodeText(String decodeText)
{
//String result=decodeText.unescapeHtml4();
String result=EncodingUtil.urlDecode(decodeText,'UTF-8');
return result;
}
}