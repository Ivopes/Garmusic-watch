using Toybox.WatchUi;
using Toybox.Application.Storage as storage;
using StorageKeys as keys;
using Toybox.Media;

class PlaybackConfigurePlayerDelegate extends WatchUi.Menu2InputDelegate {

	// DIct of settings
	var sett;

    function initialize() {
        Menu2InputDelegate.initialize();
        
        sett = getSettings();
    }

    function onSelect(item) {
        switch (item.getId().toString()) {
        	case "prev": {        		
        		sett[Media.PLAYBACK_CONTROL_PREVIOUS] = item.isChecked();	
        		break;
        	}
        	case "next": { 		
        		sett[Media.PLAYBACK_CONTROL_NEXT] = item.isChecked();	
        		break;
        	}
        	case "skipF": {
        		sett[Media.PLAYBACK_CONTROL_SKIP_FORWARD] = item.isChecked();   		
        		break;
        	}
        	case "skipB": {
        		sett[Media.PLAYBACK_CONTROL_SKIP_BACKWARD] = item.isChecked();		
        		break;
        	}
        }
        
    }
    
    function getSettings() {
    	var settings = storage.getValue(keys.SETTINGS);
    	
    	return settings;
    }
    
    function onDone() {
    	storage.setValue(keys.SETTINGS, sett);
    	
    	popView(WatchUi.SLIDE_IMMEDIATE);
    }
}
