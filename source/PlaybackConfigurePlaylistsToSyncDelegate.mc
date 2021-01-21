using Toybox.WatchUi;
using Toybox.Application.Storage as storage;
using StorageKeys as keys;
using Toybox.Media;

class PlaybackConfigurePlaylistsToSyncDelegate extends WatchUi.Menu2InputDelegate {



    function initialize() {
        Menu2InputDelegate.initialize();
       
    }

    function onSelect(item) {
        
        var name = item.getId();
        
        var playlists = storage.getValue(keys.PLAYLISTS_JSON);
        
        var settings = storage.getValue(keys.PLAYLIST_SYNC_SETTINGS);

		for (var i = 0; i < playlists.size(); i++) {
			if (playlists[i]["name"].equals(name)) {
				settings[playlists[i]["id"]] = item.isChecked();
				break;
			}
		}
		
		storage.setValue(keys.PLAYLIST_SYNC_SETTINGS, settings);
		
		
    }
    
    function onDone() {
    	
    	sendSyncData(method(:sendSyncDataCallback));
    	popView(WatchUi.SLIDE_IMMEDIATE);
    }
    
    function sendSyncData(callback) {
    	var playlists = storage.getValue(keys.PLAYLISTS_JSON);
    	
    	if (playlists == null || playlists.size() == 0) {
    		return;
    	}
    	
    	var url = APIConstants.API_DEV + "/playlist";   
    		
	    var params = playlists;
	    
		var headers = {
			//"Authorization" => token
			"Content-Type" => Communications.REQUEST_CONTENT_TYPE_JSON
			};
		
	    var options = {
	    	:headers => headers,
	    	:method => Communications.HTTP_REQUEST_METHOD_PUT
	    };
	    
		System.println(params);
		//var delegate = new RequestHandler(callback, context);
        //delegate.makeWebRequest(url, params, options);
        Communications.makeWebRequest(url, params, options, callback);
    }
    
    function sendSyncDataCallback(resposeType, data) {
    	System.println(resposeType);
    }
}
