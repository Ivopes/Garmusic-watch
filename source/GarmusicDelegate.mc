using Toybox.WatchUi;

class GarmusicDelegate extends WatchUi.BehaviorDelegate {

    function initialize() {
        BehaviorDelegate.initialize();
    }

    function onMenu() {
        WatchUi.pushView(new Rez.Menus.MainMenu(), new GarmusicMenuDelegate(), WatchUi.SLIDE_UP);
        return true;
    }

}