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
        		break;
        	}
        	case ids.START_SYNC: {
        		Media.startSync();
        		break;
        	}
        	case ids.LOGOUT: {
        		logout();
        		break;
        	}
        }
    }
    
    function onBack() {
    	Media.startPlayback(null);
    	return true;
    }
    
    function login(callback) {
    // Uncomment next line if tested on simulator to simulate login
    // storage.setValue(keys.OAUTH_TOKEN, "<YOUR JWT>");
    	
    	if (storage.getValue(keys.OAUTH_TOKEN) != null) {
    		Media.startPlayback(null);
    	}
    
	   	var requestUrl = APIConstants.getUrl() + "/login/watch";
	
		var resultUrl = APIConstants.getUrl() + "/login/watch/code";
	 	
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
    	
    	storage.clearValues();
    	
    	Media.resetContentCache();
    	
    	Media.startPlayback(null);
    }
}
