#!/bin/bash

TMP=/tmp/GeoLite2
DEST=/etc/GeoLite2

CITY_MD5_URL="http://geolite.maxmind.com/download/geoip/database/GeoLite2-City.tar.gz.md5"
COUNTRY_MD5_URL="http://geolite.maxmind.com/download/geoip/database/GeoLite2-Country.tar.gz.md5"
CITY_URL="http://geolite.maxmind.com/download/geoip/database/GeoLite2-City.tar.gz"
COUNTRY_URL="http://geolite.maxmind.com/download/geoip/database/GeoLite2-Country.tar.gz"

CITY_MD5="GeoLite2-City.tar.gz.md5"
COUNTRY_MD5="GeoLite2-Country.tar.gz.md5"
CITY="GeoLite2-City.tar.gz"
COUNTRY="GeoLite2-Country.tar.gz"

CITY_DB="GeoLite2-City.mmdb"
COUNTRY_DB="GeoLite2-Country.mmdb"

OUT=1

echo `date`

mkdir -p $TMP
mkdir -p $DEST

if [ -e $TMP/$CITY_MD5 ]; then
  rm $TMP/$CITY_MD5
fi

if [ -e $TMP/$COUNTRY_MD5 ]; then
  rm $TMP/$COUNTRY_MD5
fi

curl -s $CITY_MD5_URL -o $TMP/$CITY_MD5
curl -s $COUNTRY_MD5_URL -o $TMP/$COUNTRY_MD5


if [ ! -e $DEST/$CITY_DB ] || [ ! -e $DEST/$CITY_MD5 ] || [ "$(diff $TMP/$CITY_MD5 $DEST/$CITY_MD5)" != "" ]; then
  echo "City DB need update"

  if [ -e $TMP/$CITY ]; then
    rm $TMP/$CITY
  fi
  curl -s $CITY_URL -o $TMP/$CITY

  md5sum $TMP/$CITY | awk '{ printf $1 }' > $TMP/CITY_MD5

  if [ "$(diff $TMP/CITY_MD5 $TMP/$CITY_MD5)" == "" ]; then
    tar -xf $TMP/$CITY --no-same-owner --strip 1 -C $TMP
    mv $DEST/$CITY_DB $DEST/$CITY_DB.old
    mv $TMP/$CITY_DB $DEST/$CITY_DB
    mv $TMP/$CITY_MD5 $DEST/$CITY_MD5
    OUT=0
    echo "City DB update complete"
  else
    echo "New City DB MD5 not match, abort update"
  fi

  rm $TMP/CITY_MD5
else
  echo "City DB not need update"
fi


if [ ! -e $DEST/$COUNTRY_DB ] || [ ! -e $DEST/$COUNTRY_MD5 ] || [ "$(diff $TMP/$COUNTRY_MD5 $DEST/$COUNTRY_MD5)" != "" ]; then
  echo "Country DB need update"

  if [ -e $TMP/$COUNTRY ]; then
    rm $TMP/$COUNTRY
  fi
  curl -s $COUNTRY_URL -o $TMP/$COUNTRY

  md5sum $TMP/$COUNTRY | awk '{ printf $1 }' > $TMP/COUNTRY_MD5

  if [ "$(diff $TMP/COUNTRY_MD5 $TMP/$COUNTRY_MD5)" == "" ]; then
    tar -xf $TMP/$COUNTRY --no-same-owner --strip 1 -C $TMP
    mv $DEST/$COUNTRY_DB $DEST/$COUNTRY_DB.old
    mv $TMP/$COUNTRY_DB $DEST/$COUNTRY_DB
    mv $TMP/$COUNTRY_MD5 $DEST/$COUNTRY_MD5
    OUT=0
    echo "Country DB update complete"
  else
    echo "New Country DB MD5 not match, abort update"
  fi

  rm $TMP/COUNTRY_MD5
else
  echo "Country DB not need update"
fi

exit $OUT
