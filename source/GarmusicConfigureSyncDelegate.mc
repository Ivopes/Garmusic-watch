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
        	case ids.START_SYNC: {
        		System.println("Sync menu press");
        		Media.startSync();
        		break;
        	}
        	case ids.LOGOUT: {
        		System.println("logout");
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
    //storage.setValue(keys.OAUTH_TOKEN, "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1aWQiOiIyIiwiZXhwIjoxNjE3MTI5MjcyLCJpc3MiOiJodHRwOi8vZ2FybXVzaWMuYXp1cmV3ZWJzaXRlcy5uZXQvIn0.fhyLhGVb4DCDs5LvuhOT4b1hpLa3_XhS_L6aIJm6SK0");
    	
    	if (storage.getValue(keys.OAUTH_TOKEN) != null) {
    		Media.startPlayback(null);
    	}
    
    
    
	   	//var requestUrl = "https://ivopes.github.io/";
	   	var requestUrl = APIConstants.getUrl() + "/login/watch";
	
		//var resultUrl = "https://ivopes.github.io/redir.html";
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
    	System.println("logout and delete");
    	
    	storage.clearValues();
    	
    	Media.resetContentCache();
    	
    	Media.startPlayback(null);
    }
}
