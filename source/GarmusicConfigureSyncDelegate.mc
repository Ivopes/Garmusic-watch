using Toybox.WatchUi;
using Toybox.Application.Storage as storage;
using Toybox.Media;
using MenuIds as ids;
using APIConstants;
using StorageKeys as keys;

class GarmusicConfigureSyncDelegate extends WatchUi.BehaviorDelegate {

    function initialize() {
        BehaviorDelegate.initialize();
    }

    function onSelect(item) { 
        switch (item.getId()) {
        	case ids.LOGIN: {
        		login(method(:loginCallback));
        		System.println("login");
        		break;
        	}
        	case ids.LOGOUT: {
        		System.println("logout");
        		logout();
        		break;
        	}
        }
    }
    
    function login(callback) {
    	if (storage.getValue(keys.OAUTH_TOKEN) != null) {
    		Media.startPlayback(null);
    	}
    
    
	   	//var requestUrl = "https://ivopes.github.io/";
	   	var requestUrl = APIConstants.getUrl() + "/login/watch";
	
		//var resultUrl = "https://ivopes.github.io/redir.html";
		var resultUrl = APIConstants.getApiUrl() + "/login";
	 	
	 	var resultType = Communications.OAUTH_RESULT_TYPE_URL;
	 	
	 	var resultKeys = {"token"=>"value"};
	 	
		var params = {};
     
     	Communications.registerForOAuthMessages(callback);

	    Communications.makeOAuthRequest(
	        requestUrl,
	        params,
	        resultUrl,
	        resultType,
	        resultKeys
	    );		   
    }
    
    function loginCallback(reponseType) {
    	if (reponseType.responseCode != 200) {
    		return;
    	}
    	
    	storage.setValue(keys.OAUTH_TOKEN, reponseType.data["value"]);
    	
    	Media.startPlayback(null);
    }
    
    function logout() {
    	System.println("logout and delete");
    	
    	storage.clearValues();
    	
    	Media.resetContentCache();
    	
    	Media.startPlayback(null);
    }
}
