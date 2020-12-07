using Toybox.System;
using Toybox.Communications;
using ConfigModule;

module AuthController {

	function login(callback) {
		
	   	var requestUrl = "https://localhost:44303/login";
		var requestParams = {
				            //"client_id"=>"moje_id",
				            "response_type"=>"code",
				         	};
	
	 	var resultUrl = "https://localhost:44303/songs";
	 	var resultType = Communications.OAUTH_RESULT_TYPE_URL;
	 	var resultKeys = {"myCode"=>"value"};
var params = {
       "scope" => Communications.encodeURL("https://localhost:44303/login"),
       "redirect_uri" => "https://www.google.com",
       "response_type" => "code",
       "client_id" => "123"
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
}