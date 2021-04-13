using Toybox.Media;
using Toybox.Application.Storage as storage;
using StorageKeys as keys;

class GarmusicContentIterator extends Media.ContentIterator {

    // The index of the current song in mPlaylist
    private var mSongIndex;
    // The refIds of the songs to play
    private var mPlaylist;
    // Whether or not shuffling is enabled
    private var mShuffling;

    function initialize() {
        ContentIterator.initialize();
        
        mSongIndex = 0;
        
        initializePlaylist();
    }

    // Determine if the the current track can be skipped.
    function canSkip() {
        return false;
    }

    // Get the current media content object.
    function get() {
    	if (mSongIndex >= mPlaylist.size() || mSongIndex < 0) {
    		return null;
    	}
    	// Get Id of song
    	var songResId = mPlaylist[mSongIndex];
    	// Get Song
    	var song = Media.getCachedContentObj(new Media.ContentRef(songResId, Media.CONTENT_TYPE_AUDIO));
    
    	return song;
    }
	
    // Get the current media content playback profile
    function getPlaybackProfile() {
        var profile = new Media.PlaybackProfile();
       
		var settings = storage.getValue(keys.SETTINGS);
		
		if (settings == null) {
			settings = getDefaultSettings();
		}
		
       	var keys;
       	var sett = [];
       	
       	keys = settings.keys();
       	for (var i = 0; i < settings.size(); i++) {
       		if (settings[keys[i]]) {
       			sett.add(keys[i]);
       		}
       	}
       
        profile.playbackControls = sett;

        profile.playbackControls = sett;

        return profile;
    }

    // Get the next media content object.
    function next() {
    	if (mSongIndex + 1 >= mPlaylist.size()) {
    		mSongIndex = -1;
    		//return null;
    	}
    	mSongIndex++;
    	
    	// Get Id of song
    	var songResId = mPlaylist[mSongIndex];
    	// Get Song
    	var song = Media.getCachedContentObj(new Media.ContentRef(songResId, Media.CONTENT_TYPE_AUDIO));
    
    	return song;
    }

    // Get the next media content object without incrementing the iterator.
    function peekNext() {
    	if (mPlaylist.size() == 0) {
    		return null;
    	}
    
    	var temp = mSongIndex;
     	if (temp + 1 >= mPlaylist.size()) {
     		temp = -1;
    		//return null;
    	}
    	// Get Id of song
    	var songResId = mPlaylist[temp+1];
    	// Get Song
    	var song = Media.getCachedContentObj(new Media.ContentRef(songResId, Media.CONTENT_TYPE_AUDIO));
    
    	return song;
    }

    // Get the previous media content object without decrementing the iterator.
    function peekPrevious() {
    	if (mPlaylist.size() == 0) {
    		return null;
    	}
    
    	var temp = mSongIndex;
    	if (mSongIndex  <= 0) {
    		temp = 1;
    		//return null;
    	}
    	// Get Id of song

    	var songResId = mPlaylist[temp-1];
    	// Get Song
    	var song = Media.getCachedContentObj(new Media.ContentRef(songResId, Media.CONTENT_TYPE_AUDIO));
    
    	return song;
    }

    // Get the previous media content object.
    function previous() {
    	if (mSongIndex  <= 0) {
    		mSongIndex = 1;
    		//return null;
    	}
    	mSongIndex--;
    	// Get Id of song
    	var songResId = mPlaylist[mSongIndex];
    	// Get Song
    	var song = Media.getCachedContentObj(new Media.ContentRef(songResId, Media.CONTENT_TYPE_AUDIO));
    
    	return song;
    }

    // Determine if playback is currently set to shuffle.
    function shuffling() {
     	return mShuffling;
        //return false;
    }
    
    // Gets the songs to play. If no playlist is available then all the songs in the
    // system are played.
    function initializePlaylist() {
        // Get pl to play
        var playlistToPlayId = storage.getValue(keys.PLAYLIST_TO_PLAY_ID);
        
        var playlistToPlay = null;
        
        if (playlistToPlayId != null) {
        	//playlistToPlay = storage.getValue(keys.PLAYLISTS_JSON)[playlistToPlayId];
        	var playlists = storage.getValue(keys.PLAYLISTS_JSON);
        	for (var i = 0; i < playlists.size(); i++) {
        		if (playlists[i]["id"] == playlistToPlayId) {
        			playlistToPlay = playlists[i];
        			break;
        		}
        	}
        }

        mPlaylist = [];
        // If null then get all songs
        if (playlistToPlay == null) {
        	var availableSongs = Media.getContentRefIter({:contentType => Media.CONTENT_TYPE_AUDIO});
        	
            if (availableSongs != null) {
                var song = availableSongs.next();
                while (song != null) {
                    mPlaylist.add(song.getId());
                    song = availableSongs.next();
                }
            } else {
            }
        } else {
        	var songResIds = storage.getValue(keys.SONG_RES_ID);
        
        	if (songResIds != null) {
	        	var songIds = playlistToPlay["songsIds"];
	        	for (var i = 0; i < songIds.size(); i++) {
	        		mPlaylist.add(songResIds[songIds[i]]);
	        	}
        	}
        }
    }
    
    function getDefaultSettings() {
    	var settings = {};
		settings[Media.PLAYBACK_CONTROL_NEXT] = true;
   		settings[Media.PLAYBACK_CONTROL_PREVIOUS] = true;
   		//settings[Media.PLAYBACK_CONTROL_SHUFFLE] = false;
   		settings[Media.PLAYBACK_CONTROL_SKIP_FORWARD] = false;
   		settings[Media.PLAYBACK_CONTROL_SKIP_BACKWARD] = false;
   		//settings[Media.PLAYBACK_CONTROL_REPEAT] = false;
   		//settings[Media.PLAYBACK_CONTROL_RATING] = false;
   		
   		storage.setValue(keys.SETTINGS, settings);
   		
   		return settings;
    }
}
