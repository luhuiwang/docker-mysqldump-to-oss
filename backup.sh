#!/bin/bash

set -e
set -o pipefail

if [ "${PREFIX}" = "**None**" ]; then
  echo "You need to set the PREFIX environment variable." 
  exit 1
fi

if [ -z "${OSS_ENTRYPOINT}" ]; then
  echo "You need to set the OSS_ENTRYPOINT environment variable." 
  exit 1
fi

if [ -z "${OSS_ACCESSKEY_ID}" ]; then
  echo "You need to set the OSS_ACCESSKEY_ID environment variable." 
  exit 1
fi

if [ -z "${OSS_ACCESSKEY_SECRET}" ]; then
  echo "You need to set the OSS_ACCESSKEY_SECRET environment variable." 
  exit 1
fi

if [ -z "${OSS_BUCKET}" ]; then
  echo "You need to set the OSS_BUCKET environment variable." 
  exit 1
fi

if [ -z "${MYSQL_ENV_MYSQL_DATABASE}" ]; then
  echo "You need to set the MYSQL_ENV_MYSQL_DATABASE environment variable." 
  exit 1
fi

if [ -z "${MYSQL_ENV_MYSQL_USER}" ]; then
  echo "You need to set the MYSQL_ENV_MYSQL_USER environment variable." 
  exit 1
fi

if [ -z "${MYSQL_ENV_MYSQL_PASSWORD}" ]; then
  echo "You need to set the MYSQL_ENV_MYSQL_PASSWORD environment variable." 
  exit 1
fi

if [ -z "${MYSQL_PORT_3306_TCP_ADDR}" ]; then
  echo "You need to set the MYSQL_PORT_3306_TCP_ADDR environment variable or link to a container named MYSQL." 
  exit 1
fi

if [ -z "${MYSQL_PORT_3306_TCP_PORT}" ]; then
  echo "You need to set the MYSQL_PORT_3306_TCP_PORT environment variable or link to a container named MYSQL." 
  exit 1
fi

if [ -z "${DATE_FORMAT}" ]; then
  DATE_FORMAT="%Y-%m-%d"
fi

MYSQL_HOST_OPTS="-h $MYSQL_PORT_3306_TCP_ADDR --port $MYSQL_PORT_3306_TCP_PORT -u $MYSQL_ENV_MYSQL_USER -p$MYSQL_ENV_MYSQL_PASSWORD"

echo "Starting dump of ${MYSQLDUMP_DATABASE} database(s) from ${MYSQL_PORT_3306_TCP_ADDR}..." 

FILENAME=$PREFIX-$(date +"$DATE_FORMAT").sql

mysqldump $MYSQL_HOST_OPTS $MYSQLDUMP_OPTIONS $MYSQL_ENV_MYSQL_DATABASE > /tmp/$FILENAME

gzip /tmp/$FILENAME

/ossutil64 config -e $OSS_ENTRYPOINT -i $OSS_ACCESSKEY_ID -k $OSS_ACCESSKEY_SECRET  -L CH -c ossutil64.conf
/ossutil64 -c ossutil64.conf cp -f /tmp/$FILENAME.gz oss://$OSS_BUCKET

/bin/rm -f /tmp/$FILENAME.gz

echo "Done!" 

exit 0

