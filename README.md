# Garmusic watch app
bachelor's thesis

## Prerequisites
* [Eclipse IDE](https://www.eclipse.org/downloads/)
* [Connect IQ SDK and Eclipse plug-in](https://developer.garmin.com/connect-iq/connect-iq-basics/getting-started/)

# How To setup
Guide on how to setup the app to run locally in simulator.  

## Get the run
1. Clone the repo 
```
git clone https://github.com/Ivopes/Garmusic-watch.git
```
2. Open project in the Eclipse IDE
3. Replace URLs in source/constants/APIConstats.mc with your web app URLs
4. Set JWT obtained from browser after login and paste in into GarmusicConfigureSyncDelegate.mc
```
// Uncomment next line if tested on simulator to simulate login
// storage.setValue(keys.OAUTH_TOKEN, "<YOUR JWT>");
```
5. Run the app throught the simulator
