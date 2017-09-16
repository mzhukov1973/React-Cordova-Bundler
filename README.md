# React-Cordova-Bundler
**A simple bash script to bundle together vanilla template apps created by `create-react-app xxx` and `cordova create xxx`, as well as already existing apps of both kinds.**

#### Version: 0.0.1

## Bugs: :warning:
Report issues on the [React-Cordova-Bundler issue tracker].(https://github.com/mzhukov1973/React-Cordova-Bundler/issues)

## Description: :notebook:
A simple bash script to bundle together vanilla template apps created by `create-react-app` and `cordova create` as well as already existing apps of both kinds. 

Bundling is completely transparent to React app. It is a full-blown unejected `create-react-app` app, so it can be developed, debugged, upgraded via npm, run via its in-built server (via `npm start`) etc as normal, and when time comes to combine it with Cordova and debug/test/run it on a device (or an emulator), one launches `makeBundle-react.sh`, which is placed by `makeBundle-init.sh` in the root folder of React app, which builds the production version of the React app, does all the required magic to correctly combine it with the Cordova one, ensuring no filenames collision between the two, and builds and/or deploys the resultant Cordova app.

Should one want to, say, add or remove plugin to Cordova app or make any change to it outside its `www` directory (contents of the `www` directory is mostly dynamic and gets overwritten with each build by the React app (though with several notable exceptions - see docs below), so there's no point in editing most things in it, since WWW side of things is dealt with in the React app anyway), one may do it in the normal way, ignoring that the app is bundled with the React app.

Semantically, bundling takes place above the level of Cordova platforms, so one may add-remove them at will, nothing depends on them in the bundle.

However at the moment only Android platform is properly supported to conveniently build Cordova part of things (credentials management etc), since it was a priority for us in our other projects.

More will be added as soon as we iron out the most egregious wrinkles, though one can always use user-provided build script for Cordova to build for any of the platforms available for Cordova even now.

For details of the apps' bundling, as well as for different usage procedures required to either generate and bundle two apps from scratch, or to bundle the apps with one or both of them pre-existing, consult the documentation.

## Usage: :memo:
### The general usage pattern is:
1. Init the bundle.
2. Develop, debug, upgrade, test, deploy and otherwise manipulate the apps, comprising the bundle almost as if they were standalone.

#### There are two main ways to initialise the bundle:
- Generating both apps from scratch.
- Bundling together apps where one or both of them already exist.

##### Generating both apps from scratch:
*Protocol is as follows:*
1. Copy `makeBundle-init.sh` to the directory you wish to contain both apps (apps are not required to be in one directory, but when generating them from scratch this is the default behaviour).
2. Edit it with your favorite text editor, setting a few of the required options in the user-editable section at the top of the script file (minimally you must provide just the base name for the app, the two generated apps shall be called `<base-app-name>-react` and `<base-app-name>-cordova` respectively).
3. Run it.
4. Two folders appear, containing the two apps, now bundled together and ready for hacking.

##### Bundling together apps where one or both of them already exist:
*Protocol is as follows:*
1. Copy `makeBundle-init.sh` to the directory you want it run from (it doesn't matter which directory this is if both apps already exist, if one of them does not exist yet, then it will be created in the directory you run `makeBundle-init.sh` from).
2. Edit it with your favorite text editor, setting the required options in the user-editable section at the top of the script file (minimally you must provide the base name for the app and path(s) to the existing app(s)).
3. Edit your existing app(s) according to the rules (see the details below). The changes required are minimal and practically non-invasive - none at all might be needed even if the original structure of either app was not modified too heavily before.

#### After bundle is successfully initialised, one may begin working with it:
- **React app:**
  - Upgrade create-react-app/npm/node module(s).
  - Run/debug the app on a test server via `npm start`.
  - Add resources to the app (fonts,images,CSS/JS frameworks,etc).
  - Adjust apps' parameters (service workers' parameters, favicon and similar topics, etc).
- **Cordova app:**
  - Add/remove a plugin.
  - Add/remove a build platform.
  - Upgrade Cordova/app/platform(s)/plugins.
  - Build/debug/test/run/deploy to an emulator or physical device.

#### To use a Cordova-provided feature in React app one must:
- Wrap attempt to access the feature in question in an `if`, checking to see if `window.cordova` object exists. If it does - it means we are running on a Cordova platform and its features are available to us (as opposed to, say, running React app standalone - on an in-built server with `npm start`).
- Build and launch the full React-Cordova bundle combo.
- Debug/Test the resulting app.

## Architecture: :triangular_ruler:
*(What goes where.)*

To combine the two apps we essentially do the following: 
- Generate a full production build of React app.
- Use it instead of original contents of Cordovas' app `/www` directory, by copying it there while making some trivial adjustments to it to avoid filename collisions and unify resource storage logic, as well as injecting it with Cordova-specific code snippets to make full Cordova resources (plugins etc.) available to the React app.

To this end, we

## ToDo: :calendar:
- [x] ~~Options to set both app base name, cordova android build credentials, relevant folder names etc,~~ with **configurable storage options on a per-option basis** (to provide for, say, storing credential-related secrets in environment variable, while keeping the rest of the options in-file).
- [x] ~~Options storage variant: in a section of the script file (a clearly marked out and commented section at the top of `makeBundle-init.sh` script).~~
- [ ] Options storage variant: in environment variables (useful to keep cordova build credentials at hand, but out of commits).
- [ ] Options storage variant: in an external file (useful to keep cordova build credentials at hand, but out of commits).
- [ ] Options storage variant: ask during script execution (the last fallback option).
- [ ] :question: *General replacement placeholder format (with a default fallback).*
- [ ] :question: *npm installer that is cordova/react aware.*
- [ ] Simple, user-adaptable syntax (i.e. a system for markers for sed to use and resources, assosiated with these markers, **user comments should be allowed for!**).
- [x] ~~Replacement resources should be stored inside scripts' bodies.~~
- [x] ~~Optionally some resources could be stored in a separate file (referenced in scripts' bodies).~~ Must make it universal.
- [x] ~~User-defined build script for Cordova (optional).~~
- [x] ~~Auto-init everything, including vanilla apps creation with `create-react-app` and `cordova create` prior to bundling them together for development.~~
- [ ] Auto-add Android platform when creating vanilla template app for Cordova, since we are Android-centered anyway.
- [ ] Documentation.
- [ ] Make `makeBundle-react.sh` source contained within `makeBundle-init.sh` script body.
