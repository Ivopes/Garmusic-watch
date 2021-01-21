using Toybox.WatchUi;
using Toybox.Application.Storage as storage;
using StorageKeys as keys;
using Toybox.Media;

class PlaybackConfigurePlaylistsToSyncDelegate extends WatchUi.Menu2InputDelegate {

	// Was there a change
	var changed;

    function initialize() {
        Menu2InputDelegate.initialize();
       
       	var playlists = storage.getValue(keys.PLAYLISTS_JSON);
       	
       	changed = new[playlists.size()];
       	
       	for (var i = 0; i< changed.size(); i++) {
       		changed[i] = false;
       	}
    
    }

    function onSelect(item) {
        var name = item.getId();
        
        var playlists = storage.getValue(keys.PLAYLISTS_JSON);

		for (var i = 0; i < playlists.size(); i++) {
			if (playlists[i]["name"].equals(name)) {
			
				playlists[i]["sync"] = item.isChecked();
				
				changed[i] = !changed[i];
				
				break;
			}
		}
		
		storage.setValue(keys.PLAYLISTS_JSON, playlists);
    }
    
    function onDone() {
    	if (isChaged()) {   	
    		sendSyncData(method(:sendSyncDataCallback));
    	}
    	popView(WatchUi.SLIDE_IMMEDIATE);
    }
    
    function sendSyncData(callback) {
    	var playlists = storage.getValue(keys.PLAYLISTS_JSON);
    	
    	if (playlists == null || playlists.size() == 0) {
    		return;
    	}
    	
		// Add sync settings to playlists array dict
    	/*var settings = storage.getValue(keys.PLAYLIST_SYNC_SETTINGS);
    	
		var keys = settings.keys();
		
    	for (var i = 0; i < playlists.size(); i++) {
    		for (var j = 0; j < keys.size(); j++) {
    			if (playlists[i]["id"] == keys[j]) {
    				playlists[i].put("sync", settings[keys[j]]);
    				break;
    			}
    		}
    	}   */ 	

    	// Request itself
    	var url = APIConstants.API_DEV + "/watch";   
    		
	    var params = {
	    	"playlists" => playlists
	    };
	    
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
    
    function isChaged() {
    	for (var i = 0; i< changed.size(); i++) {
       		if (changed[i]) {
       			return true;
       		}
       	}
    	return false;
    }
}
