#!/bin/sh

# Run this script within the directory where the generated packages reside, eg. "$BUILDROOT/bin/*/packages/seafile"

../../../../scripts/ipkg-make-index.sh . > Packages
gzip -c Packages > Packages.gz
scp * root@192.168.0.1:/mnt/packages/seafile
