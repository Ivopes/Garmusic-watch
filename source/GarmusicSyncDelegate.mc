using Toybox.Communications;
using Toybox.Media;
using Toybox.Application.Storage as storage;
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
    	if (storage.getValue(keys.OAUTH_TOKEN) == null) {
    		Media.notifySyncComplete("Please log in first");
    		return;
    	}
    	System.println("start sync");
		getLists(method(:getListsCallback));   
    }
    // Called by the system to determine if the app needs to be synced.
    function isSyncNeeded() {
        return true;
    }

    // Get one song to play by API id
    function getSong(callback, id) {
    
    	var url = APIConstants.getApiUrl() + "/song/file/" + id;   
		
	    var params = {};
	    
	    var token = storage.getValue(keys.OAUTH_TOKEN);
	    
		var headers = {
			"Authorization" => "Bearer " + token
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
    	var id = mSongsDownList[0];
    	System.println("syncuju: " + id);
    	
        getSong(method(:saveSongDataCallback), id);
    }
    // Get list of song and playlists
	function getLists(callback) {
    
    	var url = APIConstants.getApiUrl() + "/watch";  	
		//System.println(url);
	    var params = {};
	    
	    var token = storage.getValue(keys.OAUTH_TOKEN);
	    
		var headers = {
			"Authorization" => "Bearer " + token
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
    		System.println("Cant get list");
    		System.println(responseType);
    		Media.notifySyncComplete("Cant get list");
    		return;
    	}
    	
    	System.println(data);
    	System.println(data["songs"]);
    	System.println(data["playlists"]);
    	mSongToSync = 0;
    	mSongDelList = getSongsToDel(data["songs"]);
    	
    	var songsToDown = getSongsToDownFromPlaylists(data["playlists"]);
 
    	mSongsDownList = getNotDownloadedSongs(songsToDown);
    	
    	mSongToSync = mSongsDownList.size();
    			
    	storage.setValue(keys.PLAYLISTS_JSON, data["playlists"]);
    	storage.setValue(keys.SONGS_JSON, data["songs"]);
    	
    	if (mSongDelList.size() > 0) {
    		//System.println("del s");
    		deleteSongs();
    	}
    	
    	if (mSongDelList.size() > 0 && mSongToSync == 0) {
			Media.notifySyncComplete(null);
			return;
    	}
    	
    	if (mSongDelList.size() == 0 && mSongsDownList.size() == 0) {
    		Media.notifySyncComplete(null);
			return;
    	}
    	
    	if (mSongsDownList.size() > 0) {
    		//System.println("down s");
    		syncNextSong();
    	} 	
    }
	// Get songs to delete
	function getSongsToDel(songsData) {
    	var songs = storage.getValue(keys.SONG_RES_ID);
		if (songs == null) {
			return [];
		}
		var songsToDel = [];
		
		for (var i = 0; i < songs.size(); i++) {
    			var inArray = false;
    			var keys = songs.keys();
    			for (var j = 0; j < songsData.size(); j++) {
    				if (keys[i] == songsData[j]["id"]) {
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
	function getNotDownloadedSongs(songsIds) {
    	var songs = storage.getValue(keys.SONG_RES_ID);
    	if (songs == null) {
			return songsIds;
		}
		var songsToAdd = [];
    	for (var i = 0; i < songsIds.size(); i++) {
    			var inArray = false;
    			var keys = songs.keys();    			
    			for (var j = 0; j < songs.size(); j++) {
    				if (keys[j] == songsIds[i]) {
    					inArray = true;
    					break;
    				}
    			}
    			if (!inArray) {
    				songsToAdd.add(songsIds[i]);
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
			var songId = mSongDelList[i]["id"];
			
			Media.deleteCachedItem(songResId[songId]);
			songResId.remove(songId);			
		}
		mSongDelList = [];
	}
	// Handles song download callback
	function saveSongDataCallback(responseType, data, context) {
		if (responseType != 200) {
			System.println("Cant down song");
    		Media.notifySyncComplete("Cant down song");
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
    // When sync is cancelled
    function onStopSync() {
    	//storage.deleteValue(keys.SONGS_JSON);
    	//storage.deleteValue(keys.PLAYLISTS_JSON);
    	//storage.deleteValue(keys.SONG_RES_ID);
    	System.println(""); 
    	System.println("STOP SYNC !!!!!!!!!!!"); 		
    	System.println(""); 
    	
    	Communications.cancelAllRequests();
        Media.notifySyncComplete("Sync has been calcelled");
    }
    
    function getSongsToDownFromPlaylists(playlistsData) {   	
    	var songsIds = [];
    	
    	for (var i = 0; i < playlistsData.size(); i++) {
    		if (!playlistsData[i]["sync"]) {
    			continue;
    		}
    	
    		for (var j = 0; j < playlistsData[i]["songsIds"].size(); j++) {
    			var inArray = false;
    			for (var k = 0; k < songsIds.size(); k++) {
    				if (playlistsData[i]["songsIds"][j] == songsIds[k]) {
    					inArray = true;
    					break;
    				}
    			}
    			if (!inArray) {
    				songsIds.add(playlistsData[i]["songsIds"][j]);
    			}
    		}
    	}
    	
    	return songsIds;
    }
}
