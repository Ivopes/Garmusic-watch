using Toybox.WatchUi;
using Toybox.Application.Storage as storage;
using StorageKeys as keys;
using Toybox.Media;

class PlaybackConfigurePlaylistsToSyncDelegate extends WatchUi.Menu2InputDelegate {

	// Was there a change
	var changed;
	
	var playlists;

    function initialize() {
        Menu2InputDelegate.initialize();
       
       	playlists = storage.getValue(keys.PLAYLISTS_JSON);
       	
       	 if (playlists == null) {
        	playlists = [];
        }
       	
       	changed = new[playlists.size()];
       	
       	for (var i = 0; i< changed.size(); i++) {
       		changed[i] = false;
       	}
    }

    function onSelect(item) {
        var name = item.getId();

		for (var i = 0; i < playlists.size(); i++) {
			if (playlists[i]["name"].equals(name)) {
			
				playlists[i]["sync"] = item.isChecked();
				
				changed[i] = !changed[i];
				
				break;
			}
		}

    }
    
    function onDone() {
    	if (isChaged()) {   	
    		sendSyncData(method(:sendSyncDataCallback));
    	}
    	popView(WatchUi.SLIDE_IMMEDIATE);
    }
    
    function sendSyncData(callback) {
      	
    	if (playlists == null || playlists.size() == 0) {
    		return;
    	}

    	// Request itself
    	var url = APIConstants.getApiUrl() + "/watch";   
    		
	    var params = {
	    	"playlists" => playlists
	    };
	    
	    var token = storage.getValue(keys.OAUTH_TOKEN);
	    
		var headers = {
			"Authorization" => "Bearer " + token,
			"Content-Type" => Communications.REQUEST_CONTENT_TYPE_JSON
			};
		
	    var options = {
	    	:headers => headers,
	    	:method => Communications.HTTP_REQUEST_METHOD_PUT
	    };

        Communications.makeWebRequest(url, params, options, callback);
    }
    
    function sendSyncDataCallback(responseType, data) {
    	if (responseType == 200) {
    		storage.setValue(keys.PLAYLISTS_JSON, playlists);
    	}
    	else {
    		System.println(responseType);
    	} 
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
