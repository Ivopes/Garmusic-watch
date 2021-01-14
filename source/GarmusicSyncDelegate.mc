using Toybox.Communications;
using Toybox.Media;
using Toybox.Application.Storage as storage;
using SongController;
using APIConstants;
using StorageKeys as keys;

class GarmusicSyncDelegate extends Media.SyncDelegate {

	// The list of playlists to be downloaded
    private var mPlaylistsDownList;
    // The list of songs to be downloaded
    private var mSongsDownList;
    // The list of songs to delete
    private var mSongDelList;
    // The list of playlists to delete
    private var mPlaylistsDelList;
    
    private var mSongToSync;

    function initialize() {
        SyncDelegate.initialize();  
    }

    // Called when the system starts a sync of the app.
    // The app should begin to download songs chosen in the configure
    // sync view .
    function onStartSync() {
    	
		getLists(method(:getListsCallback));   
    }
    // Called by the system to determine if the app needs to be synced.
    function isSyncNeeded() {
        return true;
    }

    // Called when the user chooses to cancel an active sync.
    function onStopSync() {
        Communications.cancelAllRequests();
        Media.notifySyncComplete(null);
    }
    // Get one song to play by API id
    function getSong(callback, id) {
    
    	var url = APIConstants.API_DEV + "/song/file/" + id;   
		
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
	    
	   	var context = {
			"id" => id
	    };
	   
		var delegate = new RequestHandler(callback, context);
        delegate.makeWebRequest(url, params, options);
		//Communications.makeWebRequest(url, {}, options, callback);
    }    
    // Downloads the next song to be synced
    function syncNextSong() {
    	if (mSongsDownList.size() == 0) {
    		System.println("Konec sync");
    		Media.notifySyncComplete(null);
    		return;
    	}
    	var id = mSongsDownList[0]["id"];
    	System.println("syncuju: " + id);
    	
        getSong(method(:saveSongDataCallback), id);
    }
    // Get list of playlists from API
    function getPlaylists(callback) {
    
    	var url = API_DEV + "/playlist/watch";  	
		
	    var params = {};
	    
		var headers = {
			//"Authorization" => token
			//"Content-Type" => "asd"
			};
		
	    var options = {
	    	:headers => headers,
	    	:method => Communications.HTTP_REQUEST_METHOD_GET,
	    	:responseType => Communications.HTTP_RESPONSE_CONTENT_TYPE_JSON
	    };
	   
	   	var context = null;
	   	
	   	var delegate = new RequestHandler(callback, context);
        delegate.makeWebRequest(url, params, options);
    }
	function getLists(callback) {
    
    	var url = APIConstants.API_DEV + "/watch";  	
		System.println(url);
	    var params = {};
	    
		var headers = {
			//"Authorization" => token
			//"Content-Type" => "asd"
			};
		
	    var options = {
	    	:headers => headers,
	    	:method => Communications.HTTP_REQUEST_METHOD_GET,
	    	:responseType => Communications.HTTP_RESPONSE_CONTENT_TYPE_JSON
	    };
	   
	   	var context = null;
	   	
	   	//var delegate = new RequestHandler(callback, context);
        //delegate.makeWebRequest(url, params, options);
        Communications.makeWebRequest(url, params, options, callback);
    }
    
    function getListsCallback(responseType, data) {
    	if(responseType != 200) {
    		return;
    	}
    	mSongToSync = 0;
    	mSongDelList = getSongsToDel(data["songs"]);
    	
    	mSongsDownList = getSongsToDown(data["songs"]);
    	
    	mSongToSync = mSongsDownList.size();
    	
    	System.println("ahoj");
    	if (mSongDelList.size() > 0) {
    		System.println("del s");
    		deleteSongs();
    	}
    	if (mSongsDownList.size() > 0) {
    		System.println("down s");
    		syncNextSong();
    	}
    	if (mSongDelList.size() > 0 || mSongToSync > 0) {
    		System.println("sync");
    		storage.setValue(keys.SONGS_JSON, data["songs"]);
    		storage.setValue(keys.PLAYLISTS_JSON, data["playlists"]);
    	} 
    	else {
    		Media.notifySyncComplete(null);
			return;
    	}   	
    	
    	if (mSongDelList.size() > 0 && mSongToSync == 0) {
			Media.notifySyncComplete(null);
			return;
    	}
    }
	// Get songs to delete
	function getSongsToDel(songsData) {
		var songs = storage.getValue(keys.SONGS_JSON);
		if (songs == null) {
			return [];
		}
		var songsToDel = [];
		
		for (var i = 0; i < songs.size(); i++) {
    			var inArray = false;
    			for (var j = 0; j < songsData.size(); j++) {
    				if (songs[i]["id"] == songsData[j]["id"]) {
    					inArray = true;
    					break;
    				}
    			}
    			if (!inArray) {
    				songsToDel.add(songs[i]);
    			}
    	}
    	return songsToDel;
	}
	// Get songs to download
	function getSongsToDown(songsData) {
		var songs = storage.getValue(keys.SONGS_JSON);
		if (songs == null) {
			return songsData;
		}
		var songsToAdd = [];
		
		for (var i = 0; i < songsData.size(); i++) {
    			var inArray = false;
    			for (var j = 0; j < songs.size(); j++) {
    				if (songs[j]["id"] == songsData[i]["id"]) {
    					inArray = true;
    					break;
    				}
    			}
    			if (!inArray) {
    				songsToAdd.add(songsData[i]);
    			}
    	}
    	return songsToAdd;
	}
	// Deletes songs from storage
	function deleteSongs() {
		var songResId = storage.getValue(keys.SONG_RES_ID);

		//System.println(songResId);
		if (songResId == null || songResId.size() == 0) {
			return;
		} 
		for(var i = 0; i < mSongDelList.size(); i++) {
			//System.println(mSongDelList[i]["id"]);
			
			// Deletes media by resID
			//Media.deleteCachedItem(songResId[i]["id"]);
			//songResId.remove(mSongDelList[i]["id"]);			
		}
	}
	// Handles song download callback
	function saveSongDataCallback(responseType, data, context) {
		if (responseType != 200) {
			return;
		}
		
		var songResId = storage.getValue(keys.SONG_RES_ID);
		if (songResId == null) {
			songResId = {};
		}
		
		songResId[context["id"]] = data.getId();
		
		mSongsDownList.remove(mSongsDownList[0]);
		
		storage.setValue(keys.SONG_RES_ID, songResId);
		onSongSynced();
		syncNextSong();			
	}
	// Update the system with the current sync progress
    function onSongSynced() {
        
        var synced = mSongToSync - mSongsDownList.size();
        
        var progress =  synced / mSongToSync.toFloat();
        progress = (progress * 100).toNumber();

        Media.notifySyncProgress(progress);
    }
}
