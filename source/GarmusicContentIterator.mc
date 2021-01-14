using Toybox.Media;
using Toybox.Application.Storage as storage;

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
    
    	if (mSongIndex < (mPlaylist.size() - 1)) {
            ++mSongIndex;
            var obj = Media.getCachedContentObj(new Media.ContentRef(mPlaylist[mSongIndex], Media.CONTENT_TYPE_AUDIO));
            return obj;
        }

        return null;
        var obj = Media.getCachedContentObj(new Media.ContentRef(-2030043124, Media.CONTENT_TYPE_AUDIO));
            return obj;
    }

    // Get the current media content playback profile
    function getPlaybackProfile() {
        var profile = new Media.PlaybackProfile();
       
        profile.playbackControls = [
            PLAYBACK_CONTROL_NEXT,
            //PLAYBACK_CONTROL_PLAYBACK,
            PLAYBACK_CONTROL_PREVIOUS,
            //PLAYBACK_CONTROL_SKIP_BACKWARD,
            //PLAYBACK_CONTROL_SKIP_FORWARD
        ];

        return profile;
    }

    // Get the next media content object.
    function next() {
    	if (mSongIndex < (mPlaylist.size() - 1)) {
            ++mSongIndex;
            //var obj = Media.getCachedContentObj(new Media.ContentRef(mPlaylist[mSongIndex], Media.CONTENT_TYPE_AUDIO));
            var obj = Media.getCachedContentObj(new Media.ContentRef(-2030043135, Media.CONTENT_TYPE_AUDIO));
            return obj;
        }
    
        return null;
    }

    // Get the next media content object without incrementing the iterator.
    function peekNext() {
     	var nextIndex = mSongIndex + 1;
        /*if (nextIndex < mPlaylist.size()) {
            var obj = Media.getCachedContentObj(new Media.ContentRef(mPlaylist[nextIndex], Media.CONTENT_TYPE_AUDIO));
            return obj;
        }*/

        return null;
        //return null;
    }

    // Get the previous media content object without decrementing the iterator.
    function peekPrevious() {
    	var previousIndex = mSongIndex - 1;
        if (previousIndex >= 0) {
            var obj = Media.getCachedContentObj(new Media.ContentRef(mPlaylist[previousIndex], Media.CONTENT_TYPE_AUDIO));
            return obj;
        }
    
        return null;
    }

    // Get the previous media content object.
    function previous() {
    	if (mSongIndex > 0) {
            --mSongIndex;
            var obj = Media.getCachedContentObj(new Media.ContentRef(mPlaylist[mSongIndex], Media.CONTENT_TYPE_AUDIO));
            return obj;
        }
    
        return null;
    }

    // Determine if playback is currently set to shuffle.
    function shuffling() {
     	return mShuffling;
        //return false;
    }
    
    // Gets the songs to play. If no playlist is available then all the songs in the
    // system are played.
    function initializePlaylist() {
        var tempPlaylist = storage.getValue("playlists");
        
        if (tempPlaylist == null) {
            var availableSongs = Media.getContentRefIter({:contentType => Media.CONTENT_TYPE_AUDIO});

            mPlaylist = [];
            if (availableSongs != null) {
                var song = availableSongs.next();
                while (song != null) {
                    mPlaylist.add(song.getId());
                    song = availableSongs.next();
                }
            }
        } else {
            mPlaylist = new [tempPlaylist.size()];
            for (var idx = 0; idx < mPlaylist.size(); ++idx) {
                mPlaylist[idx] = tempPlaylist[idx];
            }
        }
    }

}
