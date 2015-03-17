@RestResource(urlMapping='/CoreService/*')  
global with sharing class ApexRESTCycleExample {  
     @HttpGet  
     global static void doGet(){  
        // 微信加密签名    
        String signature=RestContext.request.params.get('signature');          
        // 时间戳    
        String timestamp=RestContext.request.params.get('timestamp');      
        // 随机数    
        String nonce=RestContext.request.params.get('nonce');         
        // 随机字符串    
        String echostr=RestContext.request.params.get('echostr');   
        system.debug(signature+'====='+timestamp+'====='+nonce+'====');  
        String endstr= ''; 
        if(checkSignature(signature,timestamp,nonce)){  
            RestContext.response.addHeader('Content-Type', 'text/plain');  
            RestContext.response.responseBody = Blob.valueOf(echostr);   
        }  
    }
    @HttpPost
    global static void doPost(){
		//RestContext.request.setCharacterEncoding('UTF-8');
		//RestContext.response.setCharacterEncoding('UTF-8');
		//PrintWriter out=response.getWriter();
		String signature=RestContext.request.params.get('signature'); 
		String timestamp=RestContext.request.params.get('timestamp'); 
		String nonce=RestContext.request.params.get('nonce');  

		if(checkSignature(signature,timestamp,nonce)){  
			//String respXML=CoreService.processRequest(request);
			//out.print(respXML);  
            RestContext.response.addHeader('Content-Type', 'text/plain');  
            RestContext.response.responseBody = Blob.valueOf('Welcome');   
        }
	}

    public static boolean checkSignature(String signature, String timestamp, String nonce) {    
            String[] arr = new String[] { 'SDFCTOKENSHANNKANG', timestamp, nonce };    
            // 将token、timestamp、nonce三个参数进行字典序排序    
           // Arrays.sort(arr);    
            arr.sort();  
            String content = '';    
            for (Integer i = 0; i < arr.size(); i++) {    
                content += arr[i];    
            }  
            Blob hash = Crypto.generateDigest('SHA1',Blob.valueOf(content));  
            String hexDigest = EncodingUtil.convertToHex(hash);  
            String singUpperCase = hexDigest.toUpperCase();  
            System.debug(singUpperCase +'===============');     
            
            // 将sha1加密后的字符串可与signature对比，标识该请求来源于微信    
            Boolean flag = singUpperCase != null ? singUpperCase .equals(signature.toUpperCase()) : false;  
            system.debug(flag + '=============='); 
            return flag;    
              
              
     }    
      
}