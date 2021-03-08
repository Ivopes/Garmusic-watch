using Toybox.Media;

// This class handles events from the system's media
// player. getContentIterator() returns an iterator
// that iterates over the songs configured to play.
class GarmusicContentDelegate extends Media.ContentDelegate {

    // Iterator for playing songs
    private var mIterator;
    // Enum value to strings for song events
    private var mSongEvents = ["Start", "Skip Next", "Skip Previous", "Playback Notify", "Complete", "Stop", "Pause", "Resume"];


    function initialize() {
        ContentDelegate.initialize();
        resetContentIterator();
    }

    // Returns an iterator that is used by the system to play songs.
    // A custom iterator can be created that extends Media.ContentIterator
    // to return only songs chosen in the sync configuration mode.
    function getContentIterator() {
       	return mIterator;
    }

    // Returns the iterator to play songs
    function resetContentIterator() {
        mIterator = new GarmusicContentIterator();

        return mIterator;
    }
    // Respond to a user ad click
    function onAdAction(adContext) {
    }

    // Respond to a thumbs-up action
    function onThumbsUp(contentRefId) {
    }

    // Respond to a thumbs-down action
    function onThumbsDown(contentRefId) {
    }

    // Respond to a command to turn shuffle on or off
    function onShuffle() {
    	
    }

	function onRepeat() {
    	
    }

    // Handles a notification from the system that an event has
    // been triggered for the given song
    function onSong(contentRefId, songEvent, playbackPosition) {
		
    }
}
