#!/usr/bin/bash

# example bin/provision.sh newapp com.domain
set -e

APP=$1
DOMAIN=$2
PWD="`pwd`"
USER="`whoami`"
ANGULARJS_VERSION="1.0.5"
JQUERY_VERSION="1.9.1"
JQUERY_MOBILE_VERSION="1.3.0"

DIR=$PWD/$APP

# I need to run this as sudo for some reason
rm -r $DIR
CREATE='sudo /opt/phonegap/lib/android/bin/create'

$($CREATE $DIR $DOMAIN.$APP $APP)
sudo chgrp -R users $DIR
sudo chown -R $USER $DIR

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

cd $DIR
sed -i 's/android:minSdkVersion="7"/android:minSdkVersion="10"/g' AndroidManifest.xml

# backup www
cd $DIR
cd assets
# cp -r www www-orig

# html
cd $DIR
cd assets/www
cp -r $SCRIPT_DIR/templates/assets/www/* .
sed -i "s/APP/$APP/g" index.html
sed -i "s/APP/$APP/g" js/index.js

sed -i "s/ANGULAR/angular-$ANGULARJS_VERSION.min/g" index.html
sed -i "s/JQUERY.MOBILE/jquery.mobile-$JQUERY_MOBILE_VERSION.min/g" index.html
sed -i "s/JQUERY/jquery-$JQUERY_VERSION.min/g" index.html

# css
cd $DIR
cd assets/www/css
rm index.css
# wget http://code.jquery.com/mobile/$JQUERY_MOBILE_VERSION/jquery.mobile-$JQUERY_MOBILE_VERSION.min.css

# js
cd $DIR
cd assets/www/js
wget http://code.angularjs.org/$ANGULARJS_VERSION/angular.min.js
mv angular.min.js angular-$ANGULARJS_VERSION.min.js
wget http://code.jquery.com/jquery-$JQUERY_VERSION.min.js
# wget http://code.jquery.com/mobile/$JQUERY_MOBILE_VERSION/jquery.mobile-$JQUERY_MOBILE_VERSION.min.js

#img
cd $DIR
rm res/*/ic_*
cd assets/www/img
rm *.png

#build
cd $DIR
cp $SCRIPT_DIR/templates/custom_rules.xml .
# ant release