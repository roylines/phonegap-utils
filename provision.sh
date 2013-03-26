#!/usr/bin/bash

# example bin/provision.sh newapp com.domain
set -e

APP=$1
DOMAIN=$2
PWD="`pwd`"
USER="`whoami`"
JQUERY_VERSION="1.9.1"
JQUERY_MOBILE_VERSION="1.3.0"

DIR=$PWD/$APP

# I need to run this as sudo for some reason
rm -r $DIR
CREATE='sudo /opt/phonegap/lib/android/bin/create'

$($CREATE $DIR $DOMAIN.$APP $APP)
sudo chgrp -R users $DIR
sudo chown -R $USER $DIR

cd $DIR
sed -i 's/android:minSdkVersion="7"/android:minSdkVersion="10"/g' AndroidManifest.xml

# css
cd $DIR
cd assets/www/css
rm index.css
wget http://code.jquery.com/mobile/$JQUERY_MOBILE_VERSION/jquery.mobile-$JQUERY_MOBILE_VERSION.min.css

# js
cd $DIR
cd assets/www/js
wget http://code.jquery.com/jquery-$JQUERY_VERSION.min.js
wget http://code.jquery.com/mobile/$JQUERY_MOBILE_VERSION/jquery.mobile-$JQUERY_MOBILE_VERSION.min.js

# ant release