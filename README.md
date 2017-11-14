MaxMind GeoIP DB Updater
========================

A simple shell script to update MaxMind GeoIP Databse(mmdb file). Only depends on curl, md5sum and awk.

Usage
-----

Edit the destination path then:

    ./maxmind-geoip-updater.sh && nginx -s reload
