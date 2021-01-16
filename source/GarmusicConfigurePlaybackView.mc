using Toybox.WatchUi;
using Toybox.Application.Storage as storage;
using StorageKeys as keys;

class GarmusicConfigurePlaybackView extends WatchUi.View {

	// Playlist names to show
	private var mPlaylists;


    function initialize() {
        View.initialize();
        
        // Get all playlists
        var playlists = storage.getValue(keys.PLAYLISTS_JSON);     
        
        if (playlists == null) {
        	playlists = [];
        }
           
        mPlaylists = [];  
        
        // Get names of playlists
        for (var i = 0; i < playlists.size(); i++) {
        	mPlaylists.add(playlists[i]["name"]);
        }
           
    }

    // Load your resources here
    function onLayout(dc) {
        setLayout(Rez.Layouts.ConfigurePlaybackLayout(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() {
    	var menu = new WatchUi.Menu2({:title=>"Playlists"});

		for (var i = 0; i < mPlaylists.size(); i++) {
			menu.addItem(
				new MenuItem(
					mPlaylists[i],
					null,
					mPlaylists[i],
					{}
				)
			);
		}
		// Create a new Menu2InputDelegate
		var delegate = new GarmusicConfigurePlaybackDelegate(); // a WatchUi.Menu2InputDelegate

		// Push the Menu2 View set up in the initializer
		WatchUi.pushView(menu, delegate, WatchUi.SLIDE_IMMEDIATE);
		return true;
    }

    // Update the view
    function onUpdate(dc) {
        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
    }

}
