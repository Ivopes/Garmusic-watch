using Toybox.System;
using Toybox.Communications;
using APIConstants;

module Controllers {
	//class webRequestsController {
	
		function getMP3(callback) {
		    var url = API_DEV + "/Mp3";  // set the url
			System.println(API_DEV+"/Mp3");
		    var params = {                                              // set the parameters
		            "definedParamsinedParams" => "123456789abcdefg"
		    };
		
		    var options = {                                             // set the options
		         :method => Communications.HTTP_REQUEST_METHOD_GET,      // set HTTP method
		         //:headers => {                                           // set headers
		         //        "Content-Type" => Communications.REQUEST_CONTENT_TYPE_URL_ENCODED},
		                                                                 // set response type
		         :responseType => Communications.HTTP_RESPONSE_CONTENT_TYPE_TEXT_PLAIN,
		         //:mediaEncoding => Media.ENCODING_MP3
		    };
		
		    //var responseCallback = method(:callback);                  // set responseCallback to
		                                                                 // onReceive() method
		    // Make the Communications.makeWebRequest() call
		    Communications.makeWebRequest(url, params, options, callback);
	    }
	    function getPlaylist(callback) {
		    var url = API_DEV + "/Playlist";  // set the url
			System.println(API_DEV+"/Playlist");
		    var params = {                                              // set the parameters
		            "definedParamsinedParams" => "123456789abcdefg"
		    };
	
		    var options = {                                             // set the options
		         :method => Communications.HTTP_REQUEST_METHOD_GET,      // set HTTP method
		         //:headers => {                                           // set headers
		         //        "Content-Type" => Communications.REQUEST_CONTENT_TYPE_URL_ENCODED},
		                                                                 // set response type
		         :responseType => Communications.HTTP_RESPONSE_CONTENT_TYPE_JSON,
		    };
		
		    //var responseCallback = method(:callback);                  // set responseCallback to
		                                                                 // onReceive() method
		    // Make the Communications.makeWebRequest() call
		    Communications.makeWebRequest(url, params, options, callback);
	    }
	//}
}