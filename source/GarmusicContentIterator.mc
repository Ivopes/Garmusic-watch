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
       
        profile.playbackControls = [
            PLAYBACK_CONTROL_NEXT,
            PLAYBACK_CONTROL_PREVIOUS
        ];

        return profile;
    }

    // Get the next media content object.
    function next() {
    	if (mSongIndex + 1 >= mPlaylist.size()) {
    		 System.println("next End");
    		return null;
    	}
    	 System.println("next");
    	mSongIndex++;
    	
    	// Get Id of song
    	var songResId = mPlaylist[mSongIndex];
    	// Get Song
    	var song = Media.getCachedContentObj(new Media.ContentRef(songResId, Media.CONTENT_TYPE_AUDIO));
    
    	return song;
    }

    // Get the next media content object without incrementing the iterator.
    function peekNext() {
     	if (mSongIndex + 1 >= mPlaylist.size()) {
    	 System.println("next peek End");
    		return null;
    	}
    	 System.println("next peek");
    	// Get Id of song
    	var songResId = mPlaylist[mSongIndex+1];
    	// Get Song
    	var song = Media.getCachedContentObj(new Media.ContentRef(songResId, Media.CONTENT_TYPE_AUDIO));
    
    	return song;
    }

    // Get the previous media content object without decrementing the iterator.
    function peekPrevious() {
    	if (mSongIndex  <= 0) {
    	 System.println("prev peek End");
    		return null;
    	}
    	 System.println("prev peek");
    	// Get Id of song
    	var songResId = mPlaylist[mSongIndex-1];
    	// Get Song
    	var song = Media.getCachedContentObj(new Media.ContentRef(songResId, Media.CONTENT_TYPE_AUDIO));
    
    	return song;
    }

    // Get the previous media content object.
    function previous() {
    
    	if (mSongIndex  <= 0) {
    	 System.println("prev End");
    		return null;
    	}
    	 System.println("prev");
    	mSongIndex--;
    	// Get Id of song
    	var songResId = mPlaylist[mSongIndex];
    	// Get Song
    	var song = Media.getCachedContentObj(new Media.ContentRef(songResId, Media.CONTENT_TYPE_AUDIO));
    
    	return song;
    }

    // Determine if playback is currently set to shuffle.
    function shuffling() {
    	System.println("shufle");
     	return mShuffling;
        //return false;
    }
    
    // Gets the songs to play. If no playlist is available then all the songs in the
    // system are played.
    function initializePlaylist() {
        var tempPlaylist = storage.getValue(keys.PLAYLIST_TO_PLAY);

        // Get pl to play
        //var playlistToPlay = storage.getValue(keys.PLAYLIST_TO_PLAY);
        
        var playlistToPlay = storage.getValue(keys.PLAYLISTS_JSON)[4];
        
        mPlaylist = [];
        // If null then get all songs
        if (playlistToPlay == null) {
        	var availableSongs = Media.getContentRefIter({:contentType => Media.CONTENT_TYPE_AUDIO});
        	
            if (availableSongs != null) {
            	System.println("Nnei prazdne");
                var song = availableSongs.next();
                while (song != null) {
                    mPlaylist.add(song.getId());
                    song = availableSongs.next();
                }
            } else {
            	System.println("je prazdne");
            }
        } else {
        	var songResIds = storage.getValue(keys.SONG_RES_ID);
        
        	var songIds = playlistToPlay["songsIds"];
        	for (var i = 0; i < songIds.size(); i++) {
        		mPlaylist.add(songResIds[songIds[i]]);
        	}
        }
        
        System.println("aaa");
    }
}
