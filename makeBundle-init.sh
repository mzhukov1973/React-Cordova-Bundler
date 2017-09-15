#!/bin/bash
#Install (place a copy of bundle-build script in either directory, alter reacts' index.js, delete unneeded js, css & img folders from cordova, while keeping cordova logo from www/img/logo.png in www/static/media/cordova-logo.png

#------Options-------------------------------------------------------------------------------------------------------------------------------------
#+++++N.B.!: Should add simpler abs/rel paths input options here, autodetect.++++++
BASE_APP_NAME="asd"
CORDOVA_BASE_REL="./$BASE_APP_NAME-cordova" #Cordova base dir. Relative path from the root of React Apps' base dir (where this script is located).
REACT_BASE_REL="./$BASE_APP_NAME-react"     #React base dir. Since this is Reacts' copy of the script it is  ".".
CORDOVA_RUN=''                              #N.B.: Must auto-escape these strings for use in sed (later)
CORDOVA_KEYSTORE=''                         #N.B.: Must auto-escape these strings for use in sed (later)
CORDOVA_KEYSTORE_PASSWORD=''                #N.B.: Must auto-escape these strings for use in sed (later)
CORDOVA_KEY=''                              #N.B.: Must auto-escape these strings for use in sed (later)
CORDOVA_KEY_PASSWORD=''                     #N.B.: Must auto-escape these strings for use in sed (later)
#--------------------------------------------------------------------------------------------------------------------------------------------------
VERSION='0.0.1'
if [ -f "./init_$BASE_APP_NAME_done" ]; then echo "Init has already been run for $BASE_APP_NAME in this directory, exiting..."; exit 1; fi
#Create both apps if directories are not present:
if [ ! -d "$CORDOVA_BASE_REL" ]; then cordova create "$BASE_APP_NAME-cordova"; fi
if [ ! -d "$REACT_BASE_REL" ]; then create-react-app "$BASE_APP_NAME-react"; fi
CORDOVA_BASE=`readlink -f $CORDOVA_BASE_REL` #Calculated absolute path of Cordova apps' base directory.
REACT_BASE=`readlink -f $REACT_BASE_REL`     #Calculated absolute path of React apps' base directory.
#--------------------------------------------------------------------------------------------------------------------------------------------------


#Update src/index.js in React to make it able to both launch with Cordova (for production builds) and as a standalone purely React app (for React coding and debugging):
sed -i 's/^ReactDOM.render/\/\*Wrapped by makeBundle-init\.sh:\*\/\nconst startIt = () => \n{\n ReactDOM.render/g' "$REACT_BASE/src/index.js";
sed -i 's/registerServiceWorker();/ registerServiceWorker();\n};\n\n\/\*Added by makeBundle-init\.sh:\*\/\nif (window\.cordova) {\n document\.addEventListener("deviceready",startIt,false);\n} \nelse {\n startIt();\n}\n/g' "$REACT_BASE/src/index.js";

#Create react-like folder structure in Cordovas' www folder, keeping logo from former www/img/logo.png as www/static/media/cordova-logo.png:
mkdir -p "$CORDOVA_BASE/www/static/css" "$CORDOVA_BASE/www/static/js" "$CORDOVA_BASE/www/static/media"
cp "$CORDOVA_BASE/www/img/logo.png" "$CORDOVA_BASE/www/static/media/cordova_logo.png"
cp "$CORDOVA_BASE/www/css/index.css" "$CORDOVA_BASE/www/static/css/cordova_index.css"
sed -i 's/img\/logo\.png/media\/cordova_logo\.png/g' "$CORDOVA_BASE/www/static/css/cordova_index.css"
#Create new www/index.js for Cordova:
echo $'var appC =\n{\n initialize:    function(){document.addEventListener(\'deviceready\', this.onDeviceReady.bind(this),false);},\n\n onDeviceReady: function() {this.receivedEvent(\'deviceready\');},\n\n receivedEvent: function(id) {console.log(\'Received Event: \' + id);}\n};\n\nappC.initialize();\n' > "$CORDOVA_BASE/www/static/js/cordova_index.js"
rm -rf "$CORDOVA_BASE/www/css" "$CORDOVA_BASE/www/js" "$CORDOVA_BASE/www/img" "$CORDOVA_BASE/www/index.html"

#Put the build script into React directory and fill it with parameters:
cp ./makeBundle-react.sh "$REACT_BASE/makeBundle-react.sh"
sed -i "s/VERSION=/VERSION='$VERSION'/g" "$REACT_BASE/makeBundle-react.sh"
sed -i "s/IAM=/IAM='React'/g" "$REACT_BASE/makeBundle-react.sh"
sed -i "s/BASE_APP_NAME=/BASE_APP_NAME=\"$BASE_APP_NAME\"/g" "$REACT_BASE/makeBundle-react.sh"
if [ ! -z $CORDOVA_RUN ];               then sed -i "s/CORDOVA_RUN=/CORDOVA_RUN=\"$CORDOVA_RUN\"/g"                                           "$REACT_BASE/makeBundle-react.sh"; else sed -i "s/CORDOVA_RUN=/#CORDOVA_RUN=/g"                             "$REACT_BASE/makeBundle-react.sh"; fi
if [ ! -z $CORDOVA_KEYSTORE ];          then sed -i "s/CORDOVA_KEYSTORE=/CORDOVA_KEYSTORE=\"$CORDOVA_KEYSTORE\"/g"                            "$REACT_BASE/makeBundle-react.sh"; else sed -i "s/CORDOVA_KEYSTORE=/#CORDOVA_KEYSTORE=/g"                   "$REACT_BASE/makeBundle-react.sh"; fi
if [ ! -z $CORDOVA_KEYSTORE_PASSWORD ]; then sed -i "s/CORDOVA_KEYSTORE_PASSWORD=/CORDOVA_KEYSTORE_PASSWORD=\"$CORDOVA_KEYSTORE_PASSWORD\"/g" "$REACT_BASE/makeBundle-react.sh"; else sed -i "s/CORDOVA_KEYSTORE_PASSWORD=/#CORDOVA_KEYSTORE_PASSWORD=/g" "$REACT_BASE/makeBundle-react.sh"; fi
if [ ! -z $CORDOVA_KEY ];               then sed -i "s/CORDOVA_KEY=/CORDOVA_KEY=\"$CORDOVA_KEY\"/g"                                           "$REACT_BASE/makeBundle-react.sh"; else sed -i "s/CORDOVA_KEY=/#CORDOVA_KEY=/g"                             "$REACT_BASE/makeBundle-react.sh"; fi
if [ ! -z $CORDOVA_KEY_PASSWORD ];      then sed -i "s/CORDOVA_KEY_PASSWORD=/CORDOVA_KEY_PASSWORD=\"$CORDOVA_KEY_PASSWORD\"/g"                "$REACT_BASE/makeBundle-react.sh"; else sed -i "s/CORDOVA_KEY_PASSWORD=/#CORDOVA_KEY_PASSWORD=/g"           "$REACT_BASE/makeBundle-react.sh"; fi

#Mark init as having already run for these folders:
touch ./init_"$BASE_APP_NAME"_done

