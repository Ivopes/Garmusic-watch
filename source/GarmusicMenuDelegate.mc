using Toybox.WatchUi;
using Toybox.System as sys;
using Toybox.Application.Storage;
using SongController;
using AuthController;


class GarmusicMenuDelegate extends WatchUi.MenuInputDelegate {

    function initialize() {
        MenuInputDelegate.initialize();
    }

    function onMenuItem(item) {
        if (item == :item_login) {
            AuthController.login(method(:authCallback));
        } else if (item == :item_1) {
            sys.println("download json songs");
            SongController.getAllSongs(method(:songsCallback));
        } else if (item == :item_2) {
            sys.println("download file song");
            SongController.getSong(method(:songCallback));
        }
    }
    //json callback
    function songsCallback(responseCode, data) {
    	if (responseCode != 200) {
    		return;
    	}
    
    	var songs = new [data.size()];
    	/*for (var i = 0; i < data.size(); i++) {
    		var song = new Song(data[i]["id"], data[i]["name"]);
    		
    		songs[i] = song ;
    	}   */ 	
    }
    //file callback
    function songCallback(responseCode, data) {
    	if (responseCode != 200) {
    		return;
    	}
    
    	var song = data;
    }
    
    function authCallback(message) {
    
    if (message.data != null) {
        //var code = message.data[OAUTH_CODE];
        //var error = message.data[OAUTH_ERROR];
    } else {
        // return an error
    }
    	/*sys.println("\nBylo ulozeno:\n");
    	sys.println(Storage.getValue("jwt"));
		sys.println("Request Done");
    	sys.println("Data: \n");
    	sys.println(data.data["value"]);
    	Storage.setValue("jwt", data.data["value"]);
    	sys.println("\nted jsem ulozil:\n");
    	sys.println(Storage.getValue("jwt"));*/
    }

	

}