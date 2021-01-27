using Toybox.WatchUi;
using Toybox.Application.Storage as storage;
using Toybox.Media;
using MenuIds as ids;
using APIConstants;

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
    
	   	var requestUrl = "https://ivopes.github.io/";
	   	//var requestUrl = "https://localhost:44303/login/watch";
	
		var resultUrl = "https://ivopes.github.io/redir.html";
		//var resultUrl = "https://localhost:44303/login";
	 	
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
    	System.println(reponseType.data);
    }
    
    function logout() {
    	System.println("logout and delete");
    	
    	storage.clearValues();
    	
    	Media.resetContentCache();
    }
}
