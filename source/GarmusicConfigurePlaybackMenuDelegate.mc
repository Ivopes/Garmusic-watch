using Toybox.WatchUi;
using Toybox.Application.Storage as storage;
using StorageKeys as keys;
using Toybox.Media;

class GarmusicConfigurePlaybackMenuDelegate extends WatchUi.Menu2InputDelegate {

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
        
        System.println(item.getId());
        
        for (var i = 0; i < mPlaylists.size(); i++) {
        	if (mPlaylists[i]["name"].equals(item.getId())) {
		        System.println(mPlaylists[i]["name"]);
		        storage.setValue(keys.PLAYLIST_TO_PLAY_ID, i);
		        Media.startPlayback(null);
		        return;
        	}
        }
        
        storage.deleteValue(keys.PLAYLIST_TO_PLAY_ID);
        Media.startPlayback(null);
    }
}
