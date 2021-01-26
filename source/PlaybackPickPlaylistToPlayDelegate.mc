using Toybox.WatchUi;
using Toybox.Application.Storage as storage;
using StorageKeys as keys;
using Toybox.Media;

class PlaybackPickPlaylistToPlayDelegate extends WatchUi.Menu2InputDelegate {

	// Playlists
	private var mPlaylists;

    function initialize() {
        Menu2InputDelegate.initialize();
        
        mPlaylists = storage.getValue(keys.PLAYLISTS_JSON);
        
        if (mPlaylists == null) {
        	mPlaylists = [];
        }
    }

    function onSelect(item) {
        for (var i = 0; i < mPlaylists.size(); i++) {
        	if (mPlaylists[i]["name"].equals(item.getId())) {
		        storage.setValue(keys.PLAYLIST_TO_PLAY_ID, mPlaylists[i]["id"]);
		        Media.startPlayback(null);
		        return;
        	}
        }
        
        storage.deleteValue(keys.PLAYLIST_TO_PLAY_ID);
        Media.startPlayback(null);
    }
}
