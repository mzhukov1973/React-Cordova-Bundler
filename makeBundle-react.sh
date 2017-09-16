#!/bin/bash
#===========================================================================#
#  Copyright 2017 Maxim Zhukov                                              #
#                                                                           #
#  Licensed under the Apache License, Version 2.0 (the "License");          #
#  you may not use this file except in compliance with the License.         #
#  You may obtain a copy of the License at                                  #
#                                                                           #
#      http://www.apache.org/licenses/LICENSE-2.0                           #
#                                                                           #
#  Unless required by applicable law or agreed to in writing, software      #
#  distributed under the License is distributed on an "AS IS" BASIS,        #
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. #
#  See the License for the specific language governing permissions and      #
#  limitations under the License.                                           #
#===========================================================================#
VERSION=
#------Options-------------------------------------------------------------------------------------------------------------------------------------

BASE_APP_NAME=                                  #As is - base name of the app, cordova & react apps' folders names are formed based on this variable.
CORDOVA_BASE_REL="../$BASE_APP_NAME-cordova"    #Cordova base dir. Relative path from the root of React Apps' base dir (where this script is located).
REACT_BASE_REL="."                              #React base dir. Since this is Reacts' copy of the script it is  ".".
CORDOVA_BASE=`readlink -f $CORDOVA_BASE_REL`    #Calculated absolute path of Cordova apps' base directory.
REACT_BASE=`readlink -f $REACT_BASE_REL`        #Calculated absolute path of React apps' base directory.
CORDOVA_RUN=                                    #Script to build and run Cordova (from the root of Cordova app directory). If not set or empty, then use builtin defaults.
CORDOVA_RUN_EN=                                 #Script to build and run Cordova (from the root of Cordova app directory). If not set or empty, then use builtin defaults.
CORDOVA_RUN_EX=                                 #Script to build and run Cordova (from the root of Cordova app directory). If not set or empty, then use builtin defaults.
CORDOVA_KEYSTORE=                               #Cordova Android build credentials.
CORDOVA_KEYSTORE_EN=                            #Cordova Android build credentials.
CORDOVA_KEYSTORE_EX=                            #Cordova Android build credentials.
CORDOVA_KEYSTORE_PASSWORD=                      #Cordova Android build credentials.
CORDOVA_KEYSTORE_PASSWORD_EN=                   #Cordova Android build credentials.
CORDOVA_KEYSTORE_PASSWORD_EX=                   #Cordova Android build credentials.
CORDOVA_KEY=                                    #Cordova Android build credentials.
CORDOVA_KEY_EN=                                 #Cordova Android build credentials.
CORDOVA_KEY_EX=                                 #Cordova Android build credentials.
CORDOVA_KEY_PASSWORD=                           #Cordova Android build credentials.
CORDOVA_KEY_PASSWORD_EN=                        #Cordova Android build credentials.
CORDOVA_KEY_PASSWORD_EX=                        #Cordova Android build credentials.
IAM=                                            #Which version of the script this one is.
#IAM_EN=                                        #Which version of the script this one is.
#IAM_EX=                                        #Which version of the script this one is.
#--------------------------------------------------------------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------------------------------------------------------------



#------Functions-----------------------------------------------------------------------------------------------------------------------------------
escape_for_sed () {
 #Auto-escape user option strings to make them usable in sed:
 return printf "%q" $1;
}

get_cordova_run_from_ex () {
}
get_cordova_run_from_en () {
}

ask_for_cordova_keystore () {
 if [ 0 -ne `read -p 'CORDOVA_KEYSTORE is not set. Please, provide path to the keystore: ' REPLY_RES` ]; then return ask_for_cordova_keystore; else return escape_for_sed $REPLY_RES; fi
}
get_cordova_keystore_from_ex () {
}
get_cordova_keystore_from_en () {
}

ask_for_cordova_keystore_password () {
 if [ 0 -ne `read -p 'CORDOVA_KEYSTORE_PASSWORD is not set. Please, provide the password to the keystore: ' REPLY_RES` ]; then return ask_for_cordova_keystore_password; else return escape_for_sed $REPLY_RES; fi
}
get_cordova_keystore_password_from_ex () {
}
get_cordova_keystore_password_from_en () {
}

ask_for_cordova_key () {
 if [ 0 -ne `read -p 'CORDOVA_KEY is not set. Please, provide key alias: ' REPLY_RES` ]; then return ask_for_cordova_key; else return escape_for_sed $REPLY_RES; fi
}
get_cordova_key_from_ex () {
}
get_cordova_key_from_en () {
}

ask_for_cordova_key_password () {
 if [ 0 -ne `read -p 'CORDOVA_KEY_PASSWORD is not set. Please, provide the password to the key: ' REPLY_RES` ]; then return ask_for_cordova_key_password; else return escape_for_sed $REPLY_RES; fi
}
get_cordova_key_password_from_ex () {
}
get_cordova_key_password_from_en () {
}

update_copied_asset-manifest () {
 sed -i 's/css\/main[\.a-zA-Z0-9]*css/css\/react_main\.css/g'           "$CORDOVA_BASE/www/asset-manifest.json";
 sed -i 's/css\/main[\.a-zA-Z0-9]*css\.map/css\/react_main\.css\.map/g' "$CORDOVA_BASE/www/asset-manifest.json";
 sed -i 's/js\/main[\.a-zA-Z0-9]*js/js\/react_main\.js/g'               "$CORDOVA_BASE/www/asset-manifest.json";
 sed -i 's/js\/main[\.a-zA-Z0-9]*js\.map/js\/react_main\.js.\map/g'     "$CORDOVA_BASE/www/asset-manifest.json";
 sed -i 's/media\/logo[\.a-zA-Z0-9]*svg/media\/react_logo\.svg/g'       "$CORDOVA_BASE/www/asset-manifest.json";
}
update_copied_manifest () {
 sed -i 's/favicon.ico/react_favicon.ico/g' "$CORDOVA_BASE/www/manifest.json";
}
update_copied_index-html () {
#insert in the head, replacing viewport etc:
sed -i "s/<meta name=\"viewport\" [^>]*>/<meta http-equiv='Content-Security-Policy' content='default-src \'self\' data: gap: https:\/\/ssl.gstatic.com \'unsafe-eval\'; style-src \'self\' \'unsafe-inline\'; media-src \*; img-src \'self\' data: content:;'><meta name='format-detection' content='telephone=no'><meta name='msapplication-tap-highlight' content='no'><meta name='viewport' content='user-scalable=no, initial-scale=1, maximum-scale=1, minimum-scale=1, width=device-width'><link rel='stylesheet' type='text\/css' href='static\/css\/cordova-index.css'>/g" "$CORDOVA_BASE/www/index.html";
#insert before '</body>':
sed -i "s/<\/body>/<script type='text\/javascript' src='cordova\.js'><\/script><script type='text\/javascript' src='static\/js\/cordova-index\.js'><\/script><\/body>/g" "$CORDOVA_BASE/www/index.html";
#change [css/js]index.[css/js] to static/[css/js]cordova-index.[css/js]:
sed -i "s/css\/index\.css/static\/css\/cordova-index\.css/g" "$CORDOVA_BASE/www/index.html";
sed -i "s/js\/index\.js/static\/js\/cordova-index\.js/g" "$CORDOVA_BASE/www/index.html";
sed -i "s/\.\/static/static/g" "$CORDOVA_BASE/www/index.html";
sed -i "s/\/static/static/g" "$CORDOVA_BASE/www/index.html";
}
rct2cor_root_www () {
 rm -f "$CORDOVA_BASE/www/asset-manifest.json" "$CORDOVA_BASE/www/manifest.json" "$CORDOVA_BASE"/www/react_*;
 cd "$REACT_BASE/build";
 for f in *.*;
 do
  if [ "$f" == "asset-manifest.json" ]; then cp "$REACT_BASE/build/$f" "$CORDOVA_BASE/www/$f"; continue; fi
  if [ "$f" == "manifest.json" ];       then cp "$REACT_BASE/build/$f" "$CORDOVA_BASE/www/$f"; continue; fi
  if [ "$f" == "index.html" ];          then cp "$REACT_BASE/build/$f" "$CORDOVA_BASE/www/$f"; continue; fi
  cp "$REACT_BASE/build/$f" "$CORDOVA_BASE/www/react_$f";
 done;
 cd "$REACT_BASE";
}



update_for_copied_media () {
  #Sample really - copying the default logo.svg from ./src directory of a vanilla create-react-app app:
  sed -i 's/logo[\.a-zA-Z0-9]*svg/react_logo\.svg/g' "$CORDOVA_BASE/www/static/css/react_main.css" "$CORDOVA_BASE/www/static/css/react_main.css.map" "$CORDOVA_BASE/www/static/js/react_main.js" "$CORDOVA_BASE/www/static/js/react_main.js.map" "$CORDOVA_BASE/www/index.html";
  sed -i 's/logo_svg/react_logo_svg/g'               "$CORDOVA_BASE/www/static/js/react_main.js.map";
}
rct2cor_media () {
 rm -f "$CORDOVA_BASE"/www/static/media/react_*;
 cd "$REACT_BASE/build/static/media";
 for f in *.*;
 do
  if [[ "$f" =~ logo[\.a-zA-Z0-9]*svg ]]; then cp "$REACT_BASE/build/static/media/$f" "$CORDOVA_BASE/www/static/media/react_logo.svg"; continue; fi
  cp "$REACT_BASE/build/static/media/$f" "$CORDOVA_BASE/www/static/media/react_$f";
 done;
 cd "$REACT_BASE";
}



update_for_copied_css () {
 sed -i 's/main[\.a-zA-Z0-9]*css/react_main\.css/g' "$CORDOVA_BASE/www/index.html";
}
rct2cor_css () {
 rm -f "$CORDOVA_BASE"/www/static/css/react_*;
 cp "$REACT_BASE"/build/static/css/main.*.css "$CORDOVA_BASE/www/static/css/react_main.css";
 cp "$REACT_BASE"/build/static/css/main.*.css.map "$CORDOVA_BASE/www/static/css/react_main.css.map";
 cd "$REACT_BASE/build/static/css";
 for f in *.*;
 do
  if [[ "$f" =~ main[\.a-zA-Z0-9]*css ]] || [[ "$f" =~ main[\.a-zA-Z0-9]*css\.map ]]; then continue; fi
  cp "$REACT_BASE/build/static/css/$f" "$CORDOVA_BASE/www/static/css/react_$f";
 done;
 cd "$REACT_BASE";
}



update_for_copied_js () {
 sed -i 's/service-worker\.js/react_service-worker\.js/g' "$CORDOVA_BASE/www/static/js/react_main.js";
 sed -i 's/main[\.a-zA-Z0-9]*js/react_main\.js/g' "$CORDOVA_BASE/www/index.html";
}
rct2cor_js () {
 rm -f "$CORDOVA_BASE"/www/static/js/react_*;
 cp "$REACT_BASE"/build/static/js/main.*.js "$CORDOVA_BASE/www/static/js/react_main.js";
 cp "$REACT_BASE"/build/static/js/main.*.js.map "$CORDOVA_BASE/www/static/js/react_main.js.map";
 cd "$REACT_BASE/build/static/js";
 for f in *.*;
 do
  if [[ "$f" =~ main[\.a-zA-Z0-9]*js ]] || [[ "$f" =~ main[\.a-zA-Z0-9]*js\.map ]]; then continue; fi
  cp "$REACT_BASE/build/static/js/$f" "$CORDOVA_BASE/www/static.js/react_$f";
 done;
 cd "$REACT_BASE";
}

#--------------------------------------------------------------------------------------------------------------------------------------------------



#------Script itself-------------------------------------------------------------------------------------------------------------------------------
#Get user options by whichever way available:
if [ ! -z $CORDOVA_RUN ]; then if [ ! -z $CORDOVA_RUN_EN ]; then if [ ! -z $CORDOVA_RUN_EX ]; then continue; else CORDOVA_RUN=`get_cordova_run_from_ex`; fi else CORDOVA_RUN=`get_cordova_run_from_en`; fi fi
if [ ! -z $CORDOVA_KEYSTORE ]; then if [ ! -z $CORDOVA_KEYSTORE_EN ]; then if [ ! -z $CORDOVA_KEYSTORE_EX ]; then CORDOVA_KEYSTORE=`ask_for_cordova_keystore`; else CORDOVA_KEYSTORE=`get_cordova_keystore_from_ex`; fi else CORDOVA_KEYSTORE=`get_cordova_keystore_from_en`; fi fi
if [ ! -z $CORDOVA_KEYSTORE_PASSWORD ]; then if [ ! -z $CORDOVA_KEYSTORE_PASSWORD_EN ]; then if [ ! -z $CORDOVA_KEYSTORE_PASSWORD_EX ]; then CORDOVA_KEYSTORE_PASSWORD=`ask_for_cordova_keystore_password`; else CORDOVA_KEYSTORE_PASSWORD=`get_cordova_keystore_password_from_ex`; fi else CORDOVA_KEYSTORE_PASSWORD=`get_cordova_keystore_password_from_en`; fi fi
if [ ! -z $CORDOVA_KEY ]; then if [ ! -z $CORDOVA_KEYE_EN ]; then if [ ! -z $CORDOVA_KEY_EX ]; then CORDOVA_KEY=`ask_for_cordova_key`; else CORDOVA_KEY=`get_cordova_key_from_ex`; fi else CORDOVA_KEY=`get_cordova_key_from_en`; fi fi
if [ ! -z $CORDOVA_KEY_PASSWORD ]; then if [ ! -z $CORDOVA_KEY_PASSWORD_EN ]; then if [ ! -z $CORDOVA_KEY_PASSWORD_EX ]; then CORDOVA_KEY_PASSWORD=`ask_for_cordova_key_password`; else CORDOVA_KEY_PASSWORD=`get_cordova_key_password_from_ex`; fi else CORDOVA_KEY_PASSWORD=`get_cordova_key_password_from_en`; fi fi

#Build standalone React app (i.e. 'npm run build'):
npm run build

#Copy stuff, renaming some files to avoid name collisions as well as updating content to reflect changed paths and filenames:
# copy[+rename]:
rct2cor_css;
rct2cor_js;
rct2cor_media;
rct2cor_root_www;
# update content:
update_for_copied_css;
update_for_copied_js;
update_for_copied_media;
update_copied_asset-manifest;
update_copied_manifest;
update_copied_index-html;

#Build Cordova app (optional - either call user-supplied build script here or use one of the pre-made ones):
cd "$CORDOVA_BASE"
if [ -z "$CORDOVA_RUN" ];
then
 cordova build android --debug --device -- --keystore="$CORDOVA_KEYSTORE" --storePassword="$CORDOVA_KEYSTORE_PASSWORD" --alias="$CORDOVA_KEY" --password="$CORDOVA_KEY_PASSWORD"
else
 "./$CORDOVA_RUN"
fi
cd "$REACT_BASE"

#--------------------------------------------------------------------------------------------------------------------------------------------------
