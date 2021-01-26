using Toybox.WatchUi;
using Toybox.Application.Storage as storage;
using StorageKeys as keys;
using Toybox.Media;
using MenuIds as ids;

class GarmusicConfigurePlaybackMenuDelegate extends WatchUi.Menu2InputDelegate {

	// Playlists
	private var mPlaylists;

    function initialize() {
        Menu2InputDelegate.initialize();
        
        // Get all playlists
        var playlists = storage.getValue(keys.PLAYLISTS_JSON);     
        
        if (playlists == null) {
        	playlists = [];
        }
        
        mPlaylists = playlists;
    }

    function onSelect(item) { 
        switch (item.getId()) {
        	case ids.CONFIGURE_PLAYER: {
        		pushConfPlayer();
        		break;
        	}
        	case ids.PLAYLISTS_TO_SYNC: {
        		pushToPlSyncConf();
        		break;
        	}
        	case ids.PLAYLISTS_TO_PLAY: {
        		pushToPlay();
        		break;
        	}
        }
    }
    // Pushes view for picking a playlist to play
    function pushToPlay() {
    	var menu = new WatchUi.Menu2({:title=>"Playlists"});

		menu.addItem(
				new MenuItem(
					"Play all",
					null,
					null,
					{}
				)
		);
		for (var i = 0; i < mPlaylists.size(); i++) {

			menu.addItem(
				new MenuItem(
					mPlaylists[i]["name"],
					null,
					mPlaylists[i]["name"],
					{}
				)
			);
		}
		// Create a new Menu2InputDelegate
		var delegate = new PlaybackPickPlaylistToPlayDelegate(); // a WatchUi.Menu2InputDelegate

		// Push the Menu2 View set up in the initializer
		WatchUi.pushView(menu, delegate, WatchUi.SLIDE_IMMEDIATE);
    }
    // Pushes view for configurationg player
    function pushConfPlayer() {
		var delegate = new PlaybackConfigurePlayerDelegate();

		var menu = new WatchUi.CheckboxMenu({:title=>"Player configuration"});

		var settings = storage.getValue(keys.SETTINGS);
		
		if (settings == null) {
			settings = getDefaultSettings();
		}
		
		menu.addItem(new CheckboxMenuItem("Shuffle", null, "shuffle", settings[Media.PLAYBACK_CONTROL_SHUFFLE], {}));
		menu.addItem(new CheckboxMenuItem("Previous", null, "prev", settings[Media.PLAYBACK_CONTROL_PREVIOUS], {}));
		menu.addItem(new CheckboxMenuItem("Next", null, "next", settings[Media.PLAYBACK_CONTROL_NEXT], {}));
		menu.addItem(new CheckboxMenuItem("Skip forward", null, "skipF", settings[Media.PLAYBACK_CONTROL_SKIP_FORWARD], {}));
		menu.addItem(new CheckboxMenuItem("Skip Backward", null, "skipB", settings[Media.PLAYBACK_CONTROL_SKIP_BACKWARD], {}));
		menu.addItem(new CheckboxMenuItem("Repeat", null, "rep", settings[Media.PLAYBACK_CONTROL_REPEAT], {}));
		menu.addItem(new CheckboxMenuItem("Rating", null, "rat", settings[Media.PLAYBACK_CONTROL_RATING], {}));
		
		WatchUi.pushView(menu, delegate, WatchUi.SLIDE_IMMEDIATE);
    }
    // Get default settings for player
    function getDefaultSettings() {
    	var settings = {};
		settings[Media.PLAYBACK_CONTROL_NEXT] = true;
   		settings[Media.PLAYBACK_CONTROL_PREVIOUS] = true;
   		settings[Media.PLAYBACK_CONTROL_SHUFFLE] = false;
   		settings[Media.PLAYBACK_CONTROL_SKIP_FORWARD] = false;
   		settings[Media.PLAYBACK_CONTROL_SKIP_BACKWARD] = false;
   		settings[Media.PLAYBACK_CONTROL_REPEAT] = false;
   		settings[Media.PLAYBACK_CONTROL_RATING] = false;
   		
   		storage.setValue(keys.SETTINGS, settings);
   		
   		return settings;
    }
    
    function pushToPlSyncConf() {
    	var menu = new WatchUi.CheckboxMenu({:title=>"Playlist to sync"});
    	
		var playlists = storage.getValue(keys.PLAYLISTS_JSON);
		
		mPlaylists = playlists;
		
		for (var i = 0; i < mPlaylists.size(); i++) {
			menu.addItem(
				new CheckboxMenuItem(
					mPlaylists[i]["name"],
					null,
					mPlaylists[i]["name"],
					mPlaylists[i]["sync"],
					{}
				)
			);
		}
		// Create a new Menu2InputDelegate
		var delegate = new PlaybackConfigurePlaylistsToSyncDelegate(); // a WatchUi.Menu2InputDelegate

		// Push the Menu2 View set up in the initializer
		WatchUi.pushView(menu, delegate, WatchUi.SLIDE_IMMEDIATE);
    }
}
