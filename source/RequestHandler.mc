using Toybox.Communications;

// Delegate injects a context argument into web request response callback
class RequestHandler
{
    hidden var mCallback; // function always takes 3 arguments
    hidden var mParams;  // custom params for callback method

    function initialize(callback, params) {
        mCallback = callback;
        mParams = params;
    }

    // Perform the request using the previously configured callback
    function makeWebRequest(url, params, options) {
        Communications.makeWebRequest(url, params, options, method(:onWebResponse));
    }

    // Forward the response data and the previously configured context
    function onWebResponse(code, data) {
    	if (mParams != null) {
        	mCallback.invoke(code, data, mParams);
    	}
    	else {
    		mCallback.invoke(code, data);
    	}
    }
}