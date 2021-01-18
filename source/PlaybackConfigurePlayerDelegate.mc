using Toybox.WatchUi;
using Toybox.Application.Storage as storage;
using StorageKeys as keys;
using Toybox.Media;

class PlaybackConfigurePlayerDelegate extends WatchUi.Menu2InputDelegate {

    function initialize() {
        Menu2InputDelegate.initialize();
        
        
    }

    function onSelect(item) {
        switch (item.getId().toString()) {
        	case "shuffle": {
        		var sett = getSettings();
        		
        		sett[Media.PLAYBACK_CONTROL_SHUFFLE] = item.isEnabled();
        		
        		storage.setValue(keys.SETTINGS, sett);

        		break;
        	}
        	case "prev": {
        		var sett = getSettings();
        		
        		sett[Media.PLAYBACK_CONTROL_PREVIOUS] = item.isEnabled();
        		
        		storage.setValue(keys.SETTINGS, sett);
        		
        		break;
        	}
        	case "next": {
        		var sett = getSettings();
        		
        		sett[Media.PLAYBACK_CONTROL_NEXT] = item.isEnabled();
        		
        		storage.setValue(keys.SETTINGS, sett);
        		
        		break;
        	}
        	case "skipF": {
        		var sett = getSettings();
        		
        		sett[Media.PLAYBACK_CONTROL_SKIP_FORWARD] = item.isEnabled();
        		
        		storage.setValue(keys.SETTINGS, sett);
        		
        		break;
        	}
        	case "skipB": {
        		var sett = getSettings();
        		
        		sett[Media.PLAYBACK_CONTROL_SKIP_BACKWARD] = item.isEnabled();
        		
        		storage.setValue(keys.SETTINGS, sett);
        		
        		break;
        	}
        	case "rep": {
        		var sett = getSettings();
        		
        		sett[Media.PLAYBACK_CONTROL_REPEAT] = item.isEnabled();
        		
        		storage.setValue(keys.SETTINGS, sett);
        		
        		break;
        	}
        	case "rat": {
        		var sett = getSettings();
        		
        		sett[Media.PLAYBACK_CONTROL_RATING] = item.isEnabled();
        		
        		storage.setValue(keys.SETTINGS, sett);
        		
        		break;
        	}
        }
        
    }
    
    function getSettings() {
    	var settings = storage.getValue(keys.SETTINGS);
    	
    	return settings;
    }
}
