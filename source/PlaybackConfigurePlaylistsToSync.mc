using Toybox.WatchUi;
using Toybox.Application.Storage as storage;
using StorageKeys as keys;
using Toybox.Media;

class PlaybackConfigurePlaylistsToSync extends WatchUi.Menu2InputDelegate {



    function initialize() {
        Menu2InputDelegate.initialize();
       
    }

    function onSelect(item) {
        
        var name = item.getId();
        
        var playlists = storage.getValue(keys.PLAYLISTS_JSON);
        
        var settings = storage.getValue(keys.PLAYLIST_SYNC_SETTINGS);

		for (var i = 0; i < playlists.size(); i++) {
			if (playlists[i]["name"].equals(name)) {
				settings[playlists[i]["id"]] = item.isEnabled();
				break;
			}
		}
		
		storage.setValue(keys.PLAYLIST_SYNC_SETTINGS, settings);
    }
}
