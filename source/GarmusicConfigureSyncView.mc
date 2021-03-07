using Toybox.WatchUi;
using Toybox.Media;
using MenuIds as ids;
using Toybox.Application.Storage as storage;
using StorageKeys as keys;

// This is the View that is used to configure the songs
// to sync. New pages may be pushed as needed to complete
// the configuration.
class GarmusicConfigureSyncView extends WatchUi.View {

    function initialize() {
        View.initialize();
    }

    // Load your resources here
    function onLayout(dc) {
        setLayout(Rez.Layouts.ConfigureSyncLayout(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() {
    	var menu = new WatchUi.Menu2({:title=>"Account"});

		if (storage.getValue(keys.OAUTH_TOKEN) == null) {
			menu.addItem(
					new MenuItem(
						"Login",
						null,
						ids.LOGIN,
						{}
					)
			);
		}

		

		menu.addItem(
				new MenuItem(
					"Logout",
					null,
					ids.LOGOUT,
					{}
				)
		);

	
		// Create a new Menu2InputDelegate
		var delegate = new GarmusicConfigureSyncDelegate(); // a WatchUi.Menu2InputDelegate

		// Push the Menu2 View set up in the initializer
		WatchUi.pushView(menu, delegate, WatchUi.SLIDE_IMMEDIATE);
		return false;
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
