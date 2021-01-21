using Toybox.WatchUi;
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
        		break;
        	}
        }
    }
    
    function login(callback) {
    
	   	var requestUrl = "https://ivopes.github.io/";
	   	
		var requestParams = {
				            //"client_id"=>"moje_id",
				            //"response_type"=>"code",
				         	};
	
	 	var resultUrl = "https://ivopes.github.io/redir.html";
	 	
	 	var resultType = Communications.OAUTH_RESULT_TYPE_URL;
	 	
	 	var resultKeys = {"code"=>"value"};
	 	
		var params = {
	       //"response_type" => "code",
	       // "client_id" => "123"
	   };
     
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
}
