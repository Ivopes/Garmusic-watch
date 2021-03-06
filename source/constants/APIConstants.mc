module APIConstants {
	
	var API_DEV = "https://localhost:44303/api";
	var API_PROD = "https://garmusic.azurewebsites.net/api";
	var DEV = "https://localhost:44303";
	var PROD = "https://garmusic.azurewebsites.net";
	
	(:debug) 
	function getApiUrl() {
	return API_DEV;
	}
	
	(:release) 
	function getApiUrl() {
	return API_PROD;
	}
	(:debug) 
	function getUrl() {
	return DEV;
	}
	(:release) 
	function getUrl() {
	return PROD;
	}
}
