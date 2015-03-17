<!DOCTYPE html>
<html>
    <head>
    <title>SLP Login Test</title>
	</head>
	<body>
	<script>
	
/*
paul.dan.short@hp.com
Concepts documented in "Sec-Gw-SaaS-vendor-Integration.docx" by vincent.rabiller@hp.com

This client-side (JavaScript) implementation gets a sessionTk cookie from an HP gateway  
login site in non-interactive mode. Once the sessionTk cookie is delivered, it will be 
there for subsequent HttpRequests for the client's session. WARNING: the password is 
transmitted in cleartext by the client, so this Gateway SessionTk library should only 
be used for testing in environments where security isn't a concern. In production you 
should not do this, nor should you transmit any HP Confidental material while using 
this library during your tests. Please ensure that you unserstand the public-facing 
security holes this creates in your systems before deploying it to test.
*/
var GWSessionTk = {
    environment: 'ITG',
    username: 'unsecured-plm',
    password: 'Dog$101$Cat$Sat',
    debugStatus: '',
    errorStatus: '', // if empty no errors
    debugToConsole: true, // recommend that you leave this on (users won't see it)
    debugToPopups: false, // only set to true if you love to see alerts pop up when debugging
    isValidStateCheck: false, // the onCompleteCallback for isValid needs to check this
    currentSession: '',

    // has to be asynchronous b/c we need to set .withCredentials to true
    isValid: function(onCompleteCallback, timeoutInMilliseconds) {
        var isAsyncMode = onCompleteCallback != null && typeof onCompleteCallback != "undefined" && typeof onCompleteCallback  == 'function';
        isValidStateCheck = false;
        if(isNaN(timeoutInMilliseconds)) {
            timeoutInMilliseconds = 0;
        }
        var xhr = new XMLHttpRequest();
        var url = GWSessionTk._getCheckUrl();
        xhr.open('GET', url, true);
        xhr.withCredentials = true; 
        xhr.timeout = timeoutInMilliseconds;
        xhr.setRequestHeader('Authorization', 'Bearer ' + GWSessionTk.currentSession);
        xhr.ontimeout = function () { 
            var stat = 'Timed out after waiting ' + timeoutInMilliseconds/1000 + ' seconds to contact gateway.'; 
            GWSessionTk.errorStatus = stat;
            GWSessionTk._setDebugStatus(stat);
            if(isAsyncMode){ 
                onCompleteCallback(); 
            }
        };
        xhr.onreadystatechange = function () {
            if(xhr.readyState == 4) {
                if(xhr.status >= 400) {
                    GWSessionTk.errorStatus = xhr.status + ': ' +  xhr.statusText;
                    if(xhr.responseText) {
                        GWSessionTk.errorStatus += '<br/>' + xhr.responseText;
                    }
                    GWSessionTk._setDebugXHRStatus(GWSessionTk.errorStatus); 
                }
                else if(xhr.status == 200 && xhr.responseText) {
                    GWSessionTk._setDebugStatus(xhr.responseText);
                    var response = JSON.parse(xhr.responseText);
                    GWSessionTk.isValidStateCheck = ((response.status == 'ok') || (response.prn == 'unsecured-plm'));
                }
                else {
                    GWSessionTk._setDebugXHRStatus(xhr);                        
                }
                // the callback should be implemented to read GWSessionTk.isValidStateCheck
                if(isAsyncMode){ 
                    onCompleteCallback();
                }
            }
        };

        xhr.send(null);
    },

    // asynchronous unless onCompleteCallback is null/undefined/not a function
    login: function(onCompleteCallback, timeoutInMilliseconds) {
        return GWSessionTk._login(onCompleteCallback, timeoutInMilliseconds);
    },

    redirect: function (url) {
        var xhr = new XMLHttpRequest();
        xhr.open('HEAD', url, true); // peek at header to see if we can access it

        xhr.onreadystatechange = function() {
            if (xhr.readyState == 4) {
                if (xhr.status == 200 || (xhr.status > 300 && xhr.status < 400)) {
                    // 200 Success or 3xx Redirects: go directly to URL
                    GWSessionTk._setDebugStatus('Redirect to ' + url);
                    window.location.href = url; 
                }
                else if (xhr.status != 401) {
                    // 401 Unauthorized: we cannot access, so authenticate
                    GWSessionTk._login(function() {
                        GWSessionTk._setDebugStatus('Authenticate then Redirect to ' + url);
                        window.location.href = url; 
                    });
                }
                // Error or Unexpected
                else {
                    GWSessionTk._setDebugStatus('HTTP Status:' + xhr.status);
                    GWSessionTk.errorStatus = GWSessionTk.debugStatus;
                    document.write(GWSessionTk.errorStatus);
                }
           }
        }

        try {
            xhr.send(null);
        } catch (ex) {
            // For some reason we always get an exception but send seems to work
            /*
            var stat = 'Exception while trying to reach gateway: ' + ex.message;
            GWSessionTk.errorStatus = stat;
            GWSessionTk._setDebugStatus(stat); 
            */
        }
    },

    _login: function(onCompleteCallback, timeoutInMilliseconds) {
        // if we have a valid callback function then do this asynchronously; 
        // if not, then synchronous (blocking). Of course, async is recommended.
        var isAsyncMode = onCompleteCallback != null && typeof onCompleteCallback != "undefined" && typeof onCompleteCallback  == 'function';
        if(isNaN(timeoutInMilliseconds)) {
            timeoutInMilliseconds = 0;
        }
		
       var xhr = new XMLHttpRequest();
//        var xhr = new XDomainRequest();
        xhr.open('POST', GWSessionTk._getLoginUrl(), isAsyncMode);        
 //       xhr.open('POST', 'https://it-services-gw-itg.external.hp.com/sec-gw/login', true);        
        xhr.withCredentials = true; // must always do this, even if Firefox/Opera/Safari wont allow it in blocking mode
        /*
        if(isAsyncMode) { 
            xhr.withCredentials = true; 
        } 
        */      
        xhr.setRequestHeader('Content-type', 'application/x-www-form-urlencoded');
        xhr.ontimeout = function () { 
            var stat = 'Timed out after waiting ' + timeoutInMilliseconds/1000 + ' seconds to contact gateway.'; 
            GWSessionTk.errorStatus = stat;
            GWSessionTk._setDebugStatus(stat);
            if(isAsyncMode){ 
                onCompleteCallback(); 
            }
        };

        if(isAsyncMode) {
            xhr.timeout = timeoutInMilliseconds;
            xhr.onreadystatechange = function () {
                if(xhr.readyState == 4) {
                    if(xhr.status >= 400) {
                        GWSessionTk.errorStatus = xhr.status + ': ' +  xhr.statusText;
                        if(xhr.responseText) {
                            GWSessionTk.errorStatus += '<br/>' + xhr.responseText;
                        }
                        GWSessionTk._setDebugXHRStatus(GWSessionTk.errorStatus); 
                    }
                    else {
                        GWSessionTk._setDebugXHRStatus(xhr);                        
                    }
        onCompleteCallback();
                }
            };
        }           
        
        var params = 'interactive=0&idpid=at_hp&user=' + encodeURIComponent(GWSessionTk.username) + '&password=' + encodeURIComponent(GWSessionTk.password);

        try {
            xhr.send(params);
        } catch (ex) {
            var stat = 'Exception while trying to reach gateway: ' + ex.message;
            GWSessionTk.errorStatus = stat;
            GWSessionTk._setDebugStatus(stat);
        }

        if(!isAsyncMode) {
            GWSessionTk._setDebugXHRStatus(xhr);
            
        // force a cookie positioning by calling the decode sessionTk
        if(xhr.responseText) {
        var details = eval('(' + xhr.responseText + ')');
        if (details.status == 'authenticated') {
            var sessionTkValue = details.sessiontk;
            this._setCurrentSession(sessionTkValue);
        }
        }       
    }   
    },
    
    _setCurrentSession: function(sessionTk) {
        GWSessionTk.currentSession = sessionTk;
        return true;
    },

    _getLoginUrl: function() {
        return GWSessionTk._getBaseUrl() + '/sec-gw/login';
    },

    _getCheckUrl: function() {
        //return GWSessionTk._getBaseUrl() + '/sec-gw/sts/decodesessiontk';
        return GWSessionTk._getBaseUrl() + '/gw/hpit/casfw/test.diagnostic/1.1';
    },

    _getBaseUrl: function() {
        if (GWSessionTk.environment == 'DEV') {
            gw = 'https://d4t0178g.houston.hp.com:8443';
        } else if (GWSessionTk.environment == 'DEV_CSC') {
            gw = 'https://d4t0178g.houston.hp.com:8444';
        } else if (GWSessionTk.environment == 'ITG') {
            gw = 'https://it-services-gw-itg.external.hp.com';
        } else if (GWSessionTk.environment == 'ITG_CSC') {
            gw = 'https://it-services-gw-csc-itg.external.hp.com';
        }
        return gw;
    },

    _setDebugStatus: function(text) {
        GWSessionTk.debugStatus = text;
        if(GWSessionTk.debugToConsole) {
            console.log(text);
        }
        if(GWSessionTk.debugToPopups) {
            alert(text);
        }
		var debug_text_div = document.getElementById('debug_text');
		if (debug_text_div) {
			debug_text_div.innerHTML = text;
		}
    },

    _setDebugXHRStatus: function(xhr) {
        var text = 'xhr status:' + xhr.status;
        if(xhr.responseText) {
            var details = eval('(' + xhr.responseText + ')');
            text += '<br/>status: ' + details.status + '<br/>sessiontk: ' + details.sessiontk + '<br/>';
        }
        GWSessionTk._setDebugStatus(text);
    }
};  


GWSessionTk.login();
	
	</script>
	<p>Look at Developer Tools Console</p>
	<div id="debug_text">
	</div>
	</body>
</html>	