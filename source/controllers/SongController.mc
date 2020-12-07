using Toybox.System;
using Toybox.Communications;
using ConfigModule;
using Toybox.Media;

module SongController {

	var token = "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1aWQiOiIxIiwiZXhwIjoxNjA2MzM0Mzk5LCJpc3MiOiJodHRwczovL2xvY2FsaG9zdDo0NDMwMyJ9.iwROAnIS6xQJckcxBH5GLpCp8RX-JDBUSVAO1AMUS84";
	
    function getAllSongs(callback) {
    	var url = ConfigModule.APIConstants.api_dev + "/song";  
		System.println(url);
	    var params = {};
	    
		var headers = {
			"Authorization" => token
		};
		
	    var options = {
	    	:headers => headers,
	    	:method => Communications.HTTP_REQUEST_METHOD_GET
	    };
		
 
		Communications.makeWebRequest(url, {}, options, callback);
    }
    
    function getSong(callback) {
    
    	var url = ConfigModule.APIConstants.api_dev + "/song/llfile/27";  
    	//var url = ConfigModule.APIConstants.api_prod + "/song/file/27";  
    	
    	
		System.println(url);
		
	    var params = {};
	    
		var headers = {
			//"Authorization" => token
			//"Content-Type" => "asd"
			};
		
	    var options = {
	    	:headers => headers,
	    	:method => Communications.HTTP_REQUEST_METHOD_GET,
	    	:responseType => Communications.HTTP_RESPONSE_CONTENT_TYPE_AUDIO,
	    	:mediaEncoding => Media.ENCODING_MP3
	    };
		
		Communications.makeWebRequest(url, {}, options, callback);
    }
}