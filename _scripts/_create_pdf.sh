#!/bin/sh
echo "PDF generation started"

#
# This script will generate PDF from html files and write them to the _site/pdf
#
# Require:
# - weasyprint installed (see _setup/start.sh)

if [ -z "$WRKDIR" ]
then
    echo Environment WRKDIR is not set, setting it to current working directory
    WRKDIR=`pwd`
    export WRKDIR
fi

#html source
DIR=$WRKDIR/documentation-generator/_site

#output pdf folder
DIR2=$WRKDIR/documentation-generator/_site/pdf

LOCAL_WEBSERVER_URL='http://localhost:8000'

set -x

#get all files and remove / and .html from filename
FILENAME=`find $DIR -type f -name *.html | awk -F $DIR '{print $2}' |  cut -d "/" -f 2 | cut -d . -f 1`

mkdir -p $DIR2 || true

( cd $DIR && python -m SimpleHTTPServer ) &

# do not create PDF for tags or TODO printable-reference
for i in $FILENAME; do
    if [ $i != "tags" ] && [ $i != "printable-reference" ]
    then
        echo '\n' $i '\n'
        weasyprint $LOCAL_WEBSERVER_URL/$i.html $DIR2/$i.pdf || true
    fi
done

kill %1

echo "PDF generation finished"
